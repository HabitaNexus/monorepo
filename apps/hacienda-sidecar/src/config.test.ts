import assert from "node:assert/strict";
import { readdir, readFile } from "node:fs/promises";
import path from "node:path";
import { describe, it } from "node:test";
import { fileURLToPath } from "node:url";
import { CredentialConfigError, loadCredentials, sanitizeStartupError } from "./config.js";

const packageRoot = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..");

describe("loadCredentials", () => {
  it("preserves the issued username without requiring or reconstructing a taxpayer ID", () => {
    const username = "cpf-01-1234-5678@stag.comprobanteselectronicos.go.cr";
    const config = loadCredentials({
      HACIENDA_ENVIRONMENT: "sandbox",
      HACIENDA_IDP_USERNAME: username,
      HACIENDA_PASSWORD: "fixture-password",
      HACIENDA_ID_TYPE: "",
      HACIENDA_ID_NUMBER: "12345678",
    });
    assert.deepEqual(config, { environment: "sandbox", username, password: "fixture-password" });
  });

  it("rejects blank or whitespace-bearing explicit usernames instead of using legacy IDs", () => {
    for (const username of ["", " ", " user@stag.comprobanteselectronicos.go.cr", "user\nname"]) {
      assert.throws(
        () =>
          loadCredentials({
            HACIENDA_ENVIRONMENT: "sandbox",
            HACIENDA_IDP_USERNAME: username,
            HACIENDA_PASSWORD: "fixture-password",
            HACIENDA_ID_TYPE: "02",
            HACIENDA_ID_NUMBER: "3101234567",
          }),
        /HACIENDA_IDP_USERNAME/,
      );
    }
  });

  it("redacts the full username and password in startup errors", () => {
    const env = {
      HACIENDA_IDP_USERNAME: "cpf-01-1234-5678@stag.comprobanteselectronicos.go.cr",
      HACIENDA_PASSWORD: "fixture-password",
    };
    assert.equal(
      sanitizeStartupError(`${env.HACIENDA_IDP_USERNAME} ${env.HACIENDA_PASSWORD}`, env),
      "[redacted] [redacted]",
    );
  });

  it("reads the four Hacienda variables", () => {
    const config = loadCredentials({
      HACIENDA_ENVIRONMENT: "sandbox",
      HACIENDA_ID_TYPE: "02",
      HACIENDA_ID_NUMBER: "3101234567",
      HACIENDA_PASSWORD: "from-the-environment",
    });
    assert.equal(config.environment, "sandbox");
    assert.equal(config.idType, "02");
    assert.equal(config.idNumber, "3101234567");
    assert.equal(config.password, "from-the-environment");
  });

  it("fails closed when the password is missing", () => {
    assert.throws(
      () =>
        loadCredentials({
          HACIENDA_ENVIRONMENT: "sandbox",
          HACIENDA_ID_TYPE: "02",
          HACIENDA_ID_NUMBER: "3101234567",
        }),
      (error: unknown) => {
        assert.ok(error instanceof CredentialConfigError);
        assert.match(error.message, /HACIENDA_PASSWORD is required/);
        return true;
      },
    );
  });

  it("rejects an environment other than sandbox or production", () => {
    assert.throws(
      () =>
        loadCredentials({
          HACIENDA_ENVIRONMENT: "staging",
          HACIENDA_ID_TYPE: "02",
          HACIENDA_ID_NUMBER: "3101234567",
          HACIENDA_PASSWORD: "from-the-environment",
        }),
      /HACIENDA_ENVIRONMENT must be sandbox or production/,
    );
  });
});

describe("package source", () => {
  it("does not embed a credential literal", async () => {
    const offenders: string[] = [];
    for (const file of await sourceFiles(path.join(packageRoot, "src"))) {
      const text = await readFile(file, "utf8");
      if (CREDENTIAL_LITERAL.test(text)) {
        offenders.push(path.relative(packageRoot, file));
      }
    }
    assert.deepEqual(offenders, []);
  });
});

const CREDENTIAL_LITERAL =
  /(?:password|HACIENDA_PASSWORD|HACIENDA_ID_NUMBER|HACIENDA_IDP_USERNAME)\s*[:=]\s*["'][^"']+["']/;

async function sourceFiles(directory: string): Promise<string[]> {
  const entries = await readdir(directory, { withFileTypes: true });
  const files: string[] = [];
  for (const entry of entries) {
    const fullPath = path.join(directory, entry.name);
    if (entry.isDirectory()) {
      files.push(...(await sourceFiles(fullPath)));
      continue;
    }
    if (entry.name.endsWith(".ts") && !entry.name.endsWith(".test.ts")) {
      files.push(fullPath);
    }
  }
  return files;
}
