import assert from "node:assert/strict";
import * as grpc from "@grpc/grpc-js";
import * as protoLoader from "@grpc/proto-loader";
import path from "node:path";
import { after, describe, it } from "node:test";
import { fileURLToPath } from "node:url";
import type { AuthClient } from "./client.js";
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

describe("hacienda auth grpc", () => {
  it("reports failure and omits secrets when credentials are rejected", async () => {
    const started = await startWith(
      failingClient(`rejected ${password} ${idNumber} ${refreshToken}`),
    );
    const auth = clientAt(AuthCtor, started.port);
    const health = clientAt(HealthCtor, started.port);

    const status = await unary<{ authenticated: boolean; environment: string }>(auth, "GetAuthStatus", {});
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
