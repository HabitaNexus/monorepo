import assert from "node:assert/strict";
import * as grpc from "@grpc/grpc-js";
import * as protoLoader from "@grpc/proto-loader";
import { once } from "node:events";
import path from "node:path";
import { after, describe, it } from "node:test";
import { fileURLToPath } from "node:url";
import type { AuthClient } from "./client.js";
import { boot } from "./boot.js";
import { startServer, type StartedServer } from "./server.js";
import { TokenGateway } from "./token-gateway.js";

const password = "pw-do-not-leak";
const idNumber = "1099887766";
const refreshToken = "refresh-token-do-not-leak";
const protoRoot = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "../proto");

const packageDefinition = protoLoader.loadSync(
  [path.join(protoRoot, "hacienda_auth.proto"), path.join(protoRoot, "health.proto")],
  { keepCase: false, longs: String, enums: String, defaults: true, oneofs: true },
);
const loaded = grpc.loadPackageDefinition(packageDefinition) as Record<string, unknown>;
const AuthCtor = nested(loaded, ["habitanexus", "hacienda", "auth", "v1", "HaciendaAuth"]) as new (
  address: string,
  credentials: grpc.ChannelCredentials,
) => grpc.Client;
const HealthCtor = nested(loaded, ["grpc", "health", "v1", "Health"]) as new (
  address: string,
  credentials: grpc.ChannelCredentials,
) => grpc.Client;

const servers: StartedServer[] = [];

after(async () => {
  await Promise.all(servers.map((server) => server.shutdown()));
});

// ---------------------------------------------------------------------------
// Cases — gRPC contracts and the real SDK with an intercepted IDP transport
// ---------------------------------------------------------------------------

describe("hacienda auth grpc", () => {
  it(
    "updates health watchers and closes their streams on shutdown",
    { timeout: 5000 },
    async (t) => {
      let available = true;
      const started = await startWith({
        authenticate: async () => {
          if (!available) throw new Error("rejected");
        },
        getAccessToken: async () => {
          if (!available) throw new Error("rejected");
          return "fixture-access";
        },
      });
      const health = clientAt(HealthCtor, started.port);
      t.after(() => health.close());
      const stream = (
        health as unknown as {
          Watch: (request: object) => grpc.ClientReadableStream<{ status: string }>;
        }
      ).Watch({});
      t.after(() => stream.cancel());
      assert.equal((await once(stream, "data"))[0].status, "SERVING");
      available = false;
      assert.equal((await once(stream, "data"))[0].status, "NOT_SERVING");
      const ended = once(stream, "end");
      await started.shutdown();
      await ended;
    },
  );

  for (const [environment, username, realm, clientId] of [
    ["sandbox", "cpf-01-1234-5678@stag.comprobanteselectronicos.go.cr", "rut-stag", "api-stag"],
    ["production", "cpj-02-3101-234567@comprobanteselectronicos.go.cr", "rut", "api-prod"],
  ]) {
    it(`preserves the issued ${environment} username through gRPC login, refresh and re-authentication`, async (t) => {
      let now = Date.now();
      t.mock.method(Date, "now", () => now);
      const grants: string[] = [];
      t.mock.method(
        globalThis,
        "fetch",
        async (url: string | URL | Request, init?: RequestInit) => {
          assert.equal(
            String(url),
            `https://idp.comprobanteselectronicos.go.cr/auth/realms/${realm}/protocol/openid-connect/token`,
          );
          const form = new URLSearchParams(String(init?.body));
          assert.equal(form.get("client_id"), clientId);
          const grant = form.get("grant_type")!;
          grants.push(grant);
          if (grant === "password") {
            assert.equal(form.get("username"), username);
            assert.equal(form.get("password"), password);
          } else {
            assert.equal(grant, "refresh_token");
            assert.equal(form.get("refresh_token"), refreshToken);
          }
          return new Response(
            JSON.stringify({
              access_token: `sdk-access-${grants.length}`,
              refresh_token: refreshToken,
              expires_in: 300,
              refresh_expires_in: 36000,
              token_type: "Bearer",
            }),
            { status: 200 },
          );
        },
      );
      const started = await boot(
        {
          HACIENDA_ENVIRONMENT: environment,
          HACIENDA_IDP_USERNAME: username,
          HACIENDA_PASSWORD: password,
        },
        { listen: (options) => startServer({ ...options, port: 0 }) },
      );
      t.after(() => started.shutdown());
      const auth = clientAt(AuthCtor, started.port);
      t.after(() => auth.close());
      const getToken = () =>
        unary<{ success: boolean; accessToken: string }>(auth, "GetAccessToken", {});
      assert.deepEqual(await getToken(), { success: true, accessToken: "sdk-access-1", error: "" });
      // Enter the SDK's 30-second renewal window, then expire the refresh token.
      now += 271_000;
      assert.equal((await getToken()).accessToken, "sdk-access-2");
      now += 36_001_000;
      assert.equal((await getToken()).accessToken, "sdk-access-3");
      assert.deepEqual(grants, ["password", "refresh_token", "password"]);
      const status = await unary<{ authenticated: boolean; environment: string }>(
        auth,
        "GetAuthStatus",
        {},
      );
      assert.deepEqual(status, { authenticated: true, environment });
    });
  }

  it("reports a real SDK authentication rejection without exposing IDP details", async (t) => {
    t.mock.method(
      globalThis,
      "fetch",
      async () =>
        new Response(
          JSON.stringify({
            error: "invalid_grant",
            error_description: `${password} ${refreshToken}`,
          }),
          { status: 401 },
        ),
    );
    const started = await boot(
      {
        HACIENDA_ENVIRONMENT: "sandbox",
        HACIENDA_IDP_USERNAME: "cpf-01-1234-5678@stag.comprobanteselectronicos.go.cr",
        HACIENDA_PASSWORD: password,
      },
      { listen: (options) => startServer({ ...options, port: 0 }) },
    );
    t.after(() => started.shutdown());
    const auth = clientAt(AuthCtor, started.port);
    t.after(() => auth.close());
    const token = await unary<{ success: boolean; accessToken: string; error: string }>(
      auth,
      "GetAccessToken",
      {},
    );
    assert.deepEqual(token, { success: false, accessToken: "", error: "authentication_failed" });
    assert.equal(responseContainsSecret(token), false);
  });

  it("reports failure and omits secrets when credentials are rejected", async () => {
    const started = await startWith(
      failingClient(`rejected ${password} ${idNumber} ${refreshToken}`),
    );
    const auth = clientAt(AuthCtor, started.port);
    const health = clientAt(HealthCtor, started.port);

    const status = await unary<{ authenticated: boolean; environment: string }>(
      auth,
      "GetAuthStatus",
      {},
    );
    const token = await unary<{ success: boolean; accessToken: string; error: string }>(
      auth,
      "GetAccessToken",
      {},
    );
    const probe = await unary<{ status: string }>(health, "Check", {});

    assert.equal(status.authenticated, false);
    assert.equal(token.success, false);
    assert.equal(token.accessToken, "");
    assert.equal(token.error, "authentication_failed");
    assert.equal(probe.status, "NOT_SERVING");
    assert.equal(responseContainsSecret(status, token), false);
  });

  it("returns a non-empty access token when the SDK authenticates", async () => {
    const started = await startWith({
      authenticate: async () => undefined,
      getAccessToken: async () => "access-token-ok",
    });
    const auth = clientAt(AuthCtor, started.port);
    const token = await unary<{ success: boolean; accessToken: string; error: string }>(
      auth,
      "GetAccessToken",
      {},
    );
    assert.equal(token.success, true);
    assert.equal(token.accessToken, "access-token-ok");
    assert.equal(token.accessToken.length > 0, true);
  });
});

async function startWith(client: AuthClient): Promise<StartedServer> {
  const started = await startServer({
    gateway: new TokenGateway(client),
    environment: "sandbox",
    port: 0,
  });
  servers.push(started);
  return started;
}

function failingClient(message: string): AuthClient {
  return {
    authenticate: async () => {
      throw new Error(message);
    },
    getAccessToken: async () => {
      throw new Error(message);
    },
  };
}

function clientAt(
  ctor: new (address: string, credentials: grpc.ChannelCredentials) => grpc.Client,
  port: number,
): grpc.Client {
  return new ctor(`127.0.0.1:${port}`, grpc.credentials.createInsecure());
}

function unary<T>(client: grpc.Client, method: string, request: object): Promise<T> {
  const call = client as unknown as Record<
    string,
    (input: object, callback: (error: grpc.ServiceError | null, response: T) => void) => void
  >;
  return new Promise((resolve, reject) => {
    const methodCall = call[method];
    if (!methodCall) {
      reject(new Error(`missing rpc ${method}`));
      return;
    }
    methodCall.call(client, request, (error, response) => {
      if (error) {
        reject(error);
        return;
      }
      resolve(response);
    });
  });
}

function responseContainsSecret(...responses: object[]): boolean {
  const encoded = JSON.stringify(responses);
  return encoded.includes(password) || encoded.includes(idNumber) || encoded.includes(refreshToken);
}

function nested(root: Record<string, unknown>, segments: string[]): unknown {
  let current: unknown = root;
  for (const segment of segments) {
    if (typeof current !== "object" || current === null || !(segment in current)) {
      throw new Error(`missing ${segment}`);
    }
    current = (current as Record<string, unknown>)[segment];
  }
  return current;
}
