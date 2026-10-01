import assert from "node:assert/strict";
import { readFile } from "node:fs/promises";
import path from "node:path";
import { describe, it } from "node:test";
import { fileURLToPath } from "node:url";

// ---------------------------------------------------------------------------
// Paths — package manifest and the kustomize tree the sidecar ships in
// ---------------------------------------------------------------------------

const packageRoot = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..");
const repoRoot = path.resolve(packageRoot, "../..");

// ---------------------------------------------------------------------------
// Cases — HAB-45 criteria that npm test can decide without sandbox secrets
// ---------------------------------------------------------------------------

describe("HAB-45 acceptance criteria", () => {
  it("depends on the published SDK and does not fork hacienda-cr", async () => {
    const manifest = JSON.parse(await readFile(path.join(packageRoot, "package.json"), "utf8")) as {
      dependencies?: Record<string, string>;
      devDependencies?: Record<string, string>;
    };
    const lockfile = JSON.parse(await readFile(path.join(packageRoot, "package-lock.json"), "utf8")) as {
      packages?: Record<string, { resolved?: string }>;
    };
    const dependencies = { ...manifest.dependencies, ...manifest.devDependencies };
    assert.equal(dependencies["@dojocoding/hacienda-sdk"], "0.3.0");
    assert.equal(dependencies["@dojocoding/hacienda-cr"], undefined);
    const resolved = lockfile.packages?.["node_modules/@dojocoding/hacienda-sdk"]?.resolved ?? "";
    assert.match(resolved, /^https:\/\/registry\.npmjs\.org\/@dojocoding\/hacienda-sdk\/-\/hacienda-sdk-0\.3\.0\.tgz$/);
    assert.equal(lockfile.packages?.["node_modules/@dojocoding/hacienda-cr"], undefined);
    assert.equal(resolved.includes("github.com"), false);
  });

  it("injects taxpayer secrets from the Kubernetes secret and selects sandbox on dev and staging", async () => {
    const sidecar = await readFile(path.join(repoRoot, "k8s/base/backend/hacienda-sidecar.yaml"), "utf8");
    const example = await readFile(path.join(repoRoot, "k8s/base/backend/hacienda-credentials.example.yaml"), "utf8");
    const dev = await readFile(path.join(repoRoot, "k8s/overlays/dev/kustomization.yaml"), "utf8");
    const staging = await readFile(path.join(repoRoot, "k8s/overlays/staging/kustomization.yaml"), "utf8");
    const base = await readFile(path.join(repoRoot, "k8s/base/backend/kustomization.yaml"), "utf8");
    const devApp = await readFile(path.join(repoRoot, "k8s/argocd/applications/backend-dev.yaml"), "utf8");
    const stagingApp = await readFile(path.join(repoRoot, "k8s/argocd/applications/backend-staging.yaml"), "utf8");

    for (const key of ["HACIENDA_ID_TYPE", "HACIENDA_ID_NUMBER", "HACIENDA_PASSWORD"]) {
      assert.match(sidecar, new RegExp(`- name: ${key}\\n\\s+valueFrom:\\n\\s+secretKeyRef:\\n\\s+name: hacienda-credentials\\n\\s+key: ${key}`));
    }
    assert.match(sidecar, /containerPort: 50051/);
    assert.match(sidecar, /type: ClusterIP/);
    assert.doesNotMatch(sidecar, /kind:\s*Ingress/);
    assert.match(example, /HACIENDA_PASSWORD:\s*""/);
    assert.doesNotMatch(example, /HACIENDA_PASSWORD:\s*"[^"]+/);
    assert.match(base, /hacienda-sidecar\.yaml/);
    assert.match(dev, /HACIENDA_ENVIRONMENT=sandbox/);
    assert.match(staging, /HACIENDA_ENVIRONMENT=sandbox/);
    assert.match(devApp, /path: k8s\/overlays\/dev/);
    assert.match(stagingApp, /path: k8s\/overlays\/staging/);
  });
});
