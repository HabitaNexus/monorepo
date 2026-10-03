#!/usr/bin/env node
/**
 * Hacienda IDP handshake (sandbox by default).
 *
 * Reads apps/hacienda-sidecar/.env (or the process environment).
 * Prints neither the password nor the access token.
 *
 * Writes reports/idp-handshake.csv with the same columns as
 * newman-reporter-csv, except the optional body column. That column would
 * store the access token (--reporter-csv-includeBody). This file never
 * writes it. If the password, the username, or the access token would land
 * in the CSV, the script exits before creating the file.
 *
 * Passwords that contain "@" break `curl --data-urlencode` (curl treats "@"
 * as "read this file"). This script sends application/x-www-form-urlencoded
 * via URLSearchParams instead.
 */

import { existsSync, mkdirSync, readFileSync, writeFileSync } from "node:fs";
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

const CSV_HEADERS = [
  "iteration",
  "collectionName",
  "requestName",
  "method",
  "url",
  "status",
  "code",
  "responseTime",
  "responseSize",
  "executed",
  "failed",
  "skipped",
  "totalAssertions",
  "passedCount",
  "failedCount",
  "skippedCount",
];

if (process.env.HACIENDA_HANDSHAKE_SKIP_DOTENV !== "1") {
  loadDotEnv(ENV_FILE);
}

const environment = process.env.HACIENDA_ENVIRONMENT || "sandbox";
const username = process.env.HACIENDA_IDP_USERNAME?.trim() ?? "";
const password = process.env.HACIENDA_PASSWORD ?? "";
const endpoint = ENDPOINTS[environment];
const reportPath = process.env.HACIENDA_HANDSHAKE_REPORT
  ? resolve(process.env.HACIENDA_HANDSHAKE_REPORT)
  : resolve(APP_DIR, "reports/idp-handshake.csv");

if (!endpoint) {
  finishFailure({
    failed: ["environment_not_sandbox_or_production"],
    reason: "HACIENDA_ENVIRONMENT must be sandbox or production",
  });
}

const tokenUrl = resolveTokenUrl(endpoint.tokenUrl);

if (!username) {
  finishFailure({
    url: tokenUrl,
    failed: ["credentials_not_configured"],
    reason:
      "HACIENDA_IDP_USERNAME is required (full IDP user, e.g. cpf-01-0000-0000@stag.comprobanteselectronicos.go.cr). Put it in apps/hacienda-sidecar/.env",
  });
}
if (!password) {
  finishFailure({
    url: tokenUrl,
    failed: ["credentials_not_configured"],
    reason: "HACIENDA_PASSWORD is required. Put it in apps/hacienda-sidecar/.env (single-quoted).",
  });
}

const body = new URLSearchParams({
  grant_type: "password",
  client_id: endpoint.clientId,
  username,
  password,
});

const started = Date.now();
const response = await fetch(tokenUrl, {
  method: "POST",
  headers: { "Content-Type": "application/x-www-form-urlencoded" },
  body,
});
const responseTime = Date.now() - started;
const text = await response.text();
let payload;
try {
  payload = JSON.parse(text);
} catch {
  payload = null;
}

const accessToken = typeof payload?.access_token === "string" ? payload.access_token : "";
const secrets = [password, username, accessToken];
const checks = handshakeChecks(response, payload, secrets);

if (!response.ok || !payload?.access_token) {
  writeReport({
    url: tokenUrl,
    status: safeStatus(response.statusText, secrets),
    code: String(response.status),
    responseTime: String(responseTime),
    responseSize: String(Buffer.byteLength(text)),
    executed: checks.executed,
    failed: checks.failed.length > 0 ? checks.failed : ["handshake_rejected"],
  }, secrets);
  console.error("handshake_failed");
  console.error(publicFailureReason(payload, response.status, secrets));
  console.error(`report=${reportPath}`);
  process.exit(1);
}

writeReport({
  url: tokenUrl,
  status: safeStatus(response.statusText, secrets),
  code: String(response.status),
  responseTime: String(responseTime),
  responseSize: String(Buffer.byteLength(text)),
  executed: checks.executed,
  failed: checks.failed,
}, secrets);

const printedTokenType = safeLabel(typeof payload.token_type === "string" ? payload.token_type : "", secrets);
console.log("handshake_ok");
console.log(`environment=${environment}`);
console.log(`token_type=${printedTokenType || "unknown"}`);
console.log(`expires_in=${typeof payload.expires_in === "number" ? payload.expires_in : "unknown"}`);
console.log(`access_token_length=${accessToken.length}`);
console.log(`report=${reportPath}`);

function finishFailure({ url = "", failed, reason }) {
  writeReport({
    url,
    status: "",
    code: "",
    responseTime: "",
    responseSize: "",
    executed: [],
    failed,
  }, [password, username]);
  console.error("handshake_failed");
  console.error(reason);
  console.error(`report=${reportPath}`);
  process.exit(1);
}

function resolveTokenUrl(defaultUrl) {
  const override = process.env.HACIENDA_TOKEN_URL?.trim();
  if (!override) {
    return defaultUrl;
  }
  let parsed;
  try {
    parsed = new URL(override);
  } catch {
    finishFailure({
      failed: ["token_url_invalid"],
      reason: "HACIENDA_TOKEN_URL must be an http URL on loopback",
    });
  }
  if (parsed.hostname !== "127.0.0.1" && parsed.hostname !== "localhost") {
    finishFailure({
      failed: ["token_url_not_loopback"],
      reason: "HACIENDA_TOKEN_URL may only point at loopback",
    });
  }
  return parsed.toString();
}

function handshakeChecks(response, payload, secrets) {
  const checks = [];
  checks.push({ name: response.ok ? "status_2xx" : `http_${response.status}`, ok: response.ok });
  if (payload && typeof payload === "object") {
    const tokenType = safeLabel(typeof payload.token_type === "string" ? payload.token_type : "", secrets);
    const expiresIn = typeof payload.expires_in === "number" ? payload.expires_in : 0;
    const accessToken = typeof payload.access_token === "string" ? payload.access_token : "";
    checks.push({ name: tokenType ? `token_type_${tokenType}` : "token_type_missing", ok: tokenType.length > 0 });
    checks.push({ name: expiresIn > 0 ? `expires_in_${expiresIn}` : "expires_in_missing", ok: expiresIn > 0 });
    checks.push({
      name: accessToken ? `access_token_length_${accessToken.length}` : "access_token_missing",
      ok: accessToken.length > 0,
    });
  } else {
    checks.push({ name: "response_not_json", ok: false });
  }
  return {
    executed: checks.filter((check) => check.ok).map((check) => check.name),
    failed: checks.filter((check) => !check.ok).map((check) => check.name),
  };
}

function publicFailureReason(payload, status, secrets) {
  const code = typeof payload?.error === "string" && /^[A-Za-z0-9_]+$/.test(payload.error) ? payload.error : "";
  const description = typeof payload?.error_description === "string" ? payload.error_description : "";
  const candidate = description || code || `HTTP ${status}`;
  if (secrets.some((secret) => secret && candidate.includes(secret))) {
    return code || `HTTP ${status}`;
  }
  return candidate;
}

function safeLabel(value, secrets) {
  if (!value) {
    return "";
  }
  const charsetOk = /^[A-Za-z0-9._-]{1,32}$/.test(value);
  const leaks = secrets.some((secret) => secret && (value === secret || value.includes(secret)));
  if (!charsetOk || leaks) {
    return "redacted";
  }
  return value;
}

function safeStatus(statusText, secrets) {
  const cleaned = statusText.replace(/[\r\n]/g, " ").trim();
  if (secrets.some((secret) => secret && cleaned.includes(secret))) {
    return "";
  }
  return cleaned;
}

function writeReport(row, secrets) {
  const record = {
    iteration: "1",
    collectionName: "hacienda-idp-handshake",
    requestName: "ROPC token",
    method: "POST",
    url: row.url,
    status: row.status,
    code: row.code,
    responseTime: row.responseTime,
    responseSize: row.responseSize,
    executed: row.executed.join(","),
    failed: row.failed.join(","),
    skipped: "",
    totalAssertions: String(row.executed.length + row.failed.length),
    passedCount: String(row.executed.length),
    failedCount: String(row.failed.length),
    skippedCount: "0",
  };
  const csv = `${CSV_HEADERS.join(",")}\n${CSV_HEADERS.map((header) => csvEscape(record[header])).join(",")}\n`;
  if (reportContainsSecret(csv, secrets)) {
    console.error("handshake_failed");
    console.error("refusing to write a report that contains a secret");
    process.exit(1);
  }
  mkdirSync(dirname(reportPath), { recursive: true });
  writeFileSync(reportPath, csv);
}

function reportContainsSecret(csv, secrets) {
  if (/eyJ[A-Za-z0-9_-]{8,}/.test(csv)) {
    return true;
  }
  return secrets.some((secret) => secret && csv.includes(secret));
}

function csvEscape(value) {
  const text = String(value ?? "");
  if (/[",\n\r]/.test(text)) {
    return `"${text.replaceAll('"', '""')}"`;
  }
  return text;
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
