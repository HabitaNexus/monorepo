import assert from "node:assert/strict";
import { describe, it } from "node:test";
import type { AuthClient } from "./client.js";
import { boot } from "./boot.js";
import { DEFAULT_GRPC_PORT, type SidecarConfig } from "./config.js";

const password = "from-the-environment";

describe("boot", () => {
  it("does not listen when the password is missing", async () => {
    let listened = false;
    await assert.rejects(
      () =>
        boot(
          {
            HACIENDA_ENVIRONMENT: "sandbox",
            HACIENDA_ID_TYPE: "02",
            HACIENDA_ID_NUMBER: "3101234567",
          },
          {
            createClient: () => {
              throw new Error("client should not be created");
            },
            listen: async () => {
              listened = true;
              throw new Error("listen should not be called");
            },
          },
        ),
      /HACIENDA_PASSWORD is required/,
    );
    assert.equal(listened, false);
  });

  it("listens on port 50051 after credentials load", async () => {
    const seen: Array<{ environment: SidecarConfig["environment"]; port: number }> = [];
    await boot(validEnv("sandbox"), {
      createClient: fakeClient,
      listen: async (options) => {
        seen.push({ environment: options.environment, port: options.port });
        return { port: options.port, shutdown: async () => undefined };
      },
    });
    assert.deepEqual(seen, [{ environment: "sandbox", port: DEFAULT_GRPC_PORT }]);
    assert.equal(DEFAULT_GRPC_PORT, 50051);
  });
});

function validEnv(environment: string): NodeJS.ProcessEnv {
  return {
    HACIENDA_ENVIRONMENT: environment,
    HACIENDA_ID_TYPE: "02",
    HACIENDA_ID_NUMBER: "3101234567",
    HACIENDA_PASSWORD: password,
  };
}

function fakeClient(): AuthClient {
  return {
    authenticate: async () => undefined,
    getAccessToken: async () => "token",
  };
}
