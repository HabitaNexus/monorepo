import assert from "node:assert/strict";
import { Environment, getEnvironmentConfig } from "@dojocoding/hacienda-sdk";
import { describe, it } from "node:test";
import { createHaciendaClient, toClientOptions } from "./client.js";
import type { SidecarConfig } from "./config.js";

const base: SidecarConfig = {
  environment: "sandbox",
  idType: "02",
  idNumber: "3101234567",
  password: "fixture-password",
};

describe("createHaciendaClient", () => {
  it("sends sandbox authentication to the rut-stag identity provider", () => {
    const options = toClientOptions(base);
    const config = getEnvironmentConfig(options.environment);
    assert.equal(options.environment, Environment.Sandbox);
    assert.match(config.idpTokenUrl, /\/realms\/rut-stag\/protocol\/openid-connect\/token$/);
    assert.equal(config.clientId, "api-stag");
    assert.equal(createHaciendaClient(base).environment, "sandbox");
  });

  it("sends production authentication to the rut identity provider", () => {
    const production = { ...base, environment: "production" as const };
    const options = toClientOptions(production);
    const config = getEnvironmentConfig(options.environment);
    assert.equal(options.environment, Environment.Production);
    assert.match(config.idpTokenUrl, /\/realms\/rut\/protocol\/openid-connect\/token$/);
    assert.doesNotMatch(config.idpTokenUrl, /rut-stag/);
    assert.equal(config.clientId, "api-prod");
    assert.equal(createHaciendaClient(production).environment, "production");
  });
});
