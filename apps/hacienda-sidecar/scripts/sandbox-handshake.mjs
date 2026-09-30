#!/usr/bin/env node
/**
 * Hacienda IDP handshake (sandbox by default).
 *
 * Reads apps/hacienda-sidecar/.env (or the process environment).
 * Does not print the password or the access token.
 *
 * Passwords that contain "@" break `curl --data-urlencode` (curl treats "@"
 * as "read this file"). This script sends application/x-www-form-urlencoded
 * via URLSearchParams instead.
 */

import { existsSync, readFileSync } from "node:fs";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";

const APP_DIR = resolve(dirname(fileURLToPath(import.meta.url)), "..");
const ENV_FILE = resolve(APP_DIR, ".env");

const ENDPOINTS = {
  sandbox: {
    tokenUrl:
      "https://idp.comprobanteselectronicos.go.cr/auth/realms/rut-stag/protocol/openid-connect/token",
    clientId: "api-stag",
  },
  production: {
    tokenUrl:
      "https://idp.comprobanteselectronicos.go.cr/auth/realms/rut/protocol/openid-connect/token",
    clientId: "api-prod",
  },
};

loadDotEnv(ENV_FILE);

const environment = process.env.HACIENDA_ENVIRONMENT || "sandbox";
const username = process.env.HACIENDA_IDP_USERNAME?.trim();
const password = process.env.HACIENDA_PASSWORD ?? "";
const endpoint = ENDPOINTS[environment];

if (!endpoint) {
  fail(`HACIENDA_ENVIRONMENT must be sandbox or production (got ${environment})`);
}
if (!username) {
  fail(
    "HACIENDA_IDP_USERNAME is required (full IDP user, e.g. cpf-01-0000-0000@stag.comprobanteselectronicos.go.cr). Put it in apps/hacienda-sidecar/.env",
  );
}
if (!password) {
  fail("HACIENDA_PASSWORD is required. Put it in apps/hacienda-sidecar/.env (single-quoted).");
}

const body = new URLSearchParams({
  grant_type: "password",
  client_id: endpoint.clientId,
  username,
  password,
});

const response = await fetch(endpoint.tokenUrl, {
  method: "POST",
  headers: { "Content-Type": "application/x-www-form-urlencoded" },
  body,
});

const text = await response.text();
let payload;
try {
  payload = JSON.parse(text);
} catch {
  payload = null;
}

if (!response.ok || !payload?.access_token) {
  const reason = payload?.error_description || payload?.error || `HTTP ${response.status}`;
  console.error("handshake_failed");
  console.error(reason);
  process.exit(1);
}

console.log("handshake_ok");
console.log(`environment=${environment}`);
console.log(`token_type=${payload.token_type ?? "unknown"}`);
console.log(`expires_in=${payload.expires_in ?? "unknown"}`);
console.log(`access_token_length=${payload.access_token.length}`);

function fail(message) {
  console.error("handshake_failed");
  console.error(message);
  process.exit(1);
}

function loadDotEnv(path) {
  if (!existsSync(path)) return;
  const text = readFileSync(path, "utf8");
  for (const raw of text.split("\n")) {
    const line = raw.trim();
    if (!line || line.startsWith("#")) continue;
    const eq = line.indexOf("=");
    if (eq < 1) continue;
    const key = line.slice(0, eq).trim();
    let value = line.slice(eq + 1).trim();
    if (
      (value.startsWith("'") && value.endsWith("'")) ||
      (value.startsWith('"') && value.endsWith('"'))
    ) {
      value = value.slice(1, -1);
    }
    if (process.env[key] === undefined || process.env[key] === "") {
      process.env[key] = value;
    }
  }
}
