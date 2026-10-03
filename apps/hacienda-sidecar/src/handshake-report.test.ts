import assert from "node:assert/strict";
import { spawn } from "node:child_process";
import { createServer, type IncomingMessage, type Server, type ServerResponse } from "node:http";
import { mkdtemp, readFile, rm } from "node:fs/promises";
import { tmpdir } from "node:os";
import path from "node:path";
import { describe, it } from "node:test";
import { fileURLToPath } from "node:url";

const scriptPath = path.resolve(
  path.dirname(fileURLToPath(import.meta.url)),
  "../scripts/sandbox-handshake.mjs",
);

// ---------------------------------------------------------------------------
// Fixtures — password and token must never appear in the CSV or the logs
// ---------------------------------------------------------------------------

const password = "p@ss,word\"do-not-leak";
const username = "cpf-01-0000-0000@stag.comprobanteselectronicos.go.cr";
const accessToken = "fixture-token-do-not-write";

// ---------------------------------------------------------------------------
// Cases — negative path, URL guard, and a local token endpoint
// ---------------------------------------------------------------------------

describe("handshake report", () => {
  it("records credentials_not_configured and does not call the identity provider", async () => {
    const directory = await mkdtemp(path.join(tmpdir(), "hacienda-handshake-"));
    const reportPath = path.join(directory, "idp-handshake.csv");
    try {
      const result = await runHandshake({ HACIENDA_HANDSHAKE_REPORT: reportPath });
      const csv = await readFile(reportPath, "utf8");
      assert.equal(result.code, 1);
      assert.match(result.stderr, /handshake_failed/);
      assert.match(csv, /credentials_not_configured/);
      assert.equal(csv.includes(password), false);
      assert.equal(result.stdout.includes("handshake_ok"), false);
    } finally {
      await rm(directory, { recursive: true, force: true });
    }
  });

  it("rejects a token URL that is not loopback", async () => {
    const directory = await mkdtemp(path.join(tmpdir(), "hacienda-handshake-"));
    const reportPath = path.join(directory, "idp-handshake.csv");
    try {
      const result = await runHandshake({
        HACIENDA_IDP_USERNAME: username,
        HACIENDA_PASSWORD: password,
        HACIENDA_TOKEN_URL: "https://example.com/token",
        HACIENDA_HANDSHAKE_REPORT: reportPath,
      });
      const csv = await readFile(reportPath, "utf8");
      assert.equal(result.code, 1);
      assert.match(result.stderr, /loopback/);
      assert.match(csv, /token_url_not_loopback/);
      assert.equal(csv.includes(password), false);
      assert.equal(csv.includes(username), false);
      assert.equal(csv.includes("example.com"), false);
    } finally {
      await rm(directory, { recursive: true, force: true });
    }
  });

  it("redacts a token type that repeats the password", async () => {
    const directory = await mkdtemp(path.join(tmpdir(), "hacienda-handshake-"));
    const reportPath = path.join(directory, "idp-handshake.csv");
    const server = await listen((_request, response) => {
      response.writeHead(200, { "Content-Type": "application/json" });
      response.end(JSON.stringify({
        access_token: accessToken,
        token_type: password,
        expires_in: 300,
      }));
    });
    try {
      const result = await runHandshake({
        HACIENDA_IDP_USERNAME: username,
        HACIENDA_PASSWORD: password,
        HACIENDA_TOKEN_URL: `http://127.0.0.1:${server.port}/token`,
        HACIENDA_HANDSHAKE_REPORT: reportPath,
      });
      const csv = await readFile(reportPath, "utf8");
      assert.equal(result.code, 0, result.stderr);
      assert.match(csv, /token_type_redacted/);
      assert.match(result.stdout, /token_type=redacted/);
      assert.equal(csv.includes(password), false);
      assert.equal(result.stdout.includes(password), false);
      assert.equal(result.stderr.includes(password), false);
      assert.equal(csv.includes(accessToken), false);
    } finally {
      await close(server.handle);
      await rm(directory, { recursive: true, force: true });
    }
  });

  it("writes a secret-free CSV when the token endpoint accepts the password", async () => {
    const directory = await mkdtemp(path.join(tmpdir(), "hacienda-handshake-"));
    const reportPath = path.join(directory, "idp-handshake.csv");
    const server = await listen((request, response) => {
      const chunks: Buffer[] = [];
      request.on("data", (chunk: Buffer) => chunks.push(chunk));
      request.on("end", () => {
        const form = Buffer.concat(chunks).toString("utf8");
        assert.equal(form.includes(encodeURIComponent(password)), true);
        response.writeHead(200, { "Content-Type": "application/json" });
        response.end(JSON.stringify({
          access_token: accessToken,
          token_type: "Bearer",
          expires_in: 300,
        }));
      });
    });
    try {
      const result = await runHandshake({
        HACIENDA_IDP_USERNAME: username,
        HACIENDA_PASSWORD: password,
        HACIENDA_TOKEN_URL: `http://127.0.0.1:${server.port}/token`,
        HACIENDA_HANDSHAKE_REPORT: reportPath,
      });
      const csv = await readFile(reportPath, "utf8");
      assert.equal(result.code, 0, result.stderr);
      assert.match(result.stdout, /handshake_ok/);
      assert.match(result.stdout, /access_token_length=26/);
      assert.match(csv, /collectionName,requestName/);
      assert.match(csv, /hacienda-idp-handshake,ROPC token,POST,/);
      assert.match(csv, /status_2xx,token_type_Bearer,expires_in_300,access_token_length_26/);
      assert.equal(csv.includes(password), false);
      assert.equal(csv.includes(username), false);
      assert.equal(csv.includes(accessToken), false);
      assert.equal(result.stdout.includes(accessToken), false);
      assert.equal(result.stderr.includes(accessToken), false);
      assert.equal(result.stdout.includes(password), false);
    } finally {
      await close(server.handle);
      await rm(directory, { recursive: true, force: true });
    }
  });
});

// ---------------------------------------------------------------------------
// Helpers — spawn the script and a loopback token endpoint
// ---------------------------------------------------------------------------

function runHandshake(env: Record<string, string>): Promise<{ code: number; stdout: string; stderr: string }> {
  return new Promise((resolve, reject) => {
    const child = spawn(process.execPath, [scriptPath], {
      env: {
        PATH: process.env.PATH,
        HOME: process.env.HOME,
        HACIENDA_HANDSHAKE_SKIP_DOTENV: "1",
        HACIENDA_ENVIRONMENT: "sandbox",
        ...env,
      },
    });
    let stdout = "";
    let stderr = "";
    child.stdout.setEncoding("utf8");
    child.stderr.setEncoding("utf8");
    child.stdout.on("data", (chunk: string) => {
      stdout += chunk;
    });
    child.stderr.on("data", (chunk: string) => {
      stderr += chunk;
    });
    child.on("error", reject);
    child.on("close", (code) => {
      resolve({ code: code ?? 1, stdout, stderr });
    });
  });
}

function listen(
  handler: (request: IncomingMessage, response: ServerResponse) => void,
): Promise<{ handle: Server; port: number }> {
  const handle = createServer(handler);
  return new Promise((resolve, reject) => {
    handle.once("error", reject);
    handle.listen(0, "127.0.0.1", () => {
      const address = handle.address();
      if (!address || typeof address === "string") {
        reject(new Error("missing port"));
        return;
      }
      resolve({ handle, port: address.port });
    });
  });
}

function close(handle: Server): Promise<void> {
  return new Promise((resolve, reject) => {
    handle.close((error) => {
      if (error) {
        reject(error);
        return;
      }
      resolve();
    });
  });
}
