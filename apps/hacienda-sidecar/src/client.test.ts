import assert from "node:assert/strict";
import { describe, it } from "node:test";
import { createHaciendaClient } from "./client.js";
import type { SidecarConfig } from "./config.js";

const base: SidecarConfig = {
  environment: "sandbox",
  idType: "02",
  idNumber: "3101234567",
  password: "fixture-password",
};

describe("createHaciendaClient", () => {
  it("selects sandbox and not production", () => {
    const client = createHaciendaClient(base);
    assert.equal(client.environment, "sandbox");
    assert.notEqual(client.environment, "production");
  });

  it("selects production and not sandbox", () => {
    const client = createHaciendaClient({ ...base, environment: "production" });
    assert.equal(client.environment, "production");
    assert.notEqual(client.environment, "sandbox");
  });
});
