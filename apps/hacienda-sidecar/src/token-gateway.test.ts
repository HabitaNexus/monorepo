import assert from "node:assert/strict";
import { describe, it } from "node:test";
import type { AuthClient } from "./client.js";
import { TokenGateway } from "./token-gateway.js";

describe("TokenGateway", () => {
  it("returns the SDK token on a later fetch without a caller-supplied token", async () => {
    const tokens = ["token-a", "token-b"];
    let authenticateCalls = 0;
    const client: AuthClient = {
      authenticate: async () => {
        authenticateCalls += 1;
      },
      getAccessToken: async () => {
        const next = tokens.shift();
        if (!next) {
          throw new Error("no token");
        }
        return next;
      },
    };
    const gateway = new TokenGateway(client);

    assert.equal(await gateway.getAccessToken(), "token-a");
    assert.equal(await gateway.getAccessToken(), "token-b");
    assert.equal(authenticateCalls, 0);
    assert.equal(gateway.getAccessToken.length, 0);
  });

  it("authenticates once when refresh fails and still takes no caller token", async () => {
    let authenticateCalls = 0;
    let fetchCalls = 0;
    const client: AuthClient = {
      authenticate: async () => {
        authenticateCalls += 1;
      },
      getAccessToken: async () => {
        fetchCalls += 1;
        if (fetchCalls === 1) {
          throw new Error("refresh failed");
        }
        return "token-after-auth";
      },
    };
    const gateway = new TokenGateway(client);

    assert.equal(await gateway.getAccessToken(), "token-after-auth");
    assert.equal(authenticateCalls, 1);
    assert.equal(gateway.getAccessToken.length, 0);
  });
});
