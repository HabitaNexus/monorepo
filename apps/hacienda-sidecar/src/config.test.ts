import assert from "node:assert/strict";
import { readdir, readFile } from "node:fs/promises";
import path from "node:path";
import { describe, it } from "node:test";
import { fileURLToPath } from "node:url";
import { CredentialConfigError, loadCredentials } from "./config.js";

const packageRoot = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..");

describe("loadCredentials", () => {
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
  /(?:password|HACIENDA_PASSWORD|HACIENDA_ID_NUMBER)\s*[:=]\s*["'][^"']+["']/;

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
