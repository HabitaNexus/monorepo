# Proposal

## Why

HabitaNexus cannot report rental income to TRIBU-CR until it can obtain and renew a Hacienda access token. HAB-45 is the foundation for that cluster: deploy a gRPC sidecar that authenticates against Hacienda, so later declaration (HAB-46) and electronic invoice (HAB-47) work can call it.

## What Changes

- Add `apps/hacienda-sidecar/`, a Node/TypeScript gRPC sidecar that depends on `@dojocoding/hacienda-sdk` as an npm package. Do not fork [DojoCodingLabs/hacienda-cr](https://github.com/DojoCodingLabs/hacienda-cr).
- Authenticate with Hacienda OAuth2 ROPC (the SDK's `TokenManager`) and refresh the access token before it expires.
- Inject taxpayer credentials (`idType`, `idNumber`, password) through Kubernetes secrets. Public IDP client ids (`api-stag`, `api-prod`) stay inside the SDK.
- Parameterize `sandbox` versus `production` by environment. A smoke test proves a sandbox handshake.
- Add kustomize manifests under `k8s/base/backend/` and the existing overlays so ArgoCD can deploy the sidecar.
- Leave rental-income declaration, tax calculation, electronic invoicing, XAdES signing, ATENA, and `TribuTaxReporter` out of this change.

## Capabilities

### New Capabilities

- None.

### Modified Capabilities

- `tribu-cr-adapter`: add a requirement that the hacienda sidecar authenticates to Hacienda, renews the token, and reads credentials from injected secrets. Existing reporting, tax, invoice, compliance, and port requirements stay unchanged.

## Impact

- New app: `apps/hacienda-sidecar/` (Node.js 22+, gRPC). No Flutter or mobile changes.
- Dependency: `@dojocoding/hacienda-sdk` (published package; `@dojocoding/hacienda-cr` is the GitHub repo name and is not on npm).
- Kubernetes: extend `k8s/base/backend/` (today a single `backend` Deployment on port 3000) and overlays `dev` / `staging`. ArgoCD apps `backend-dev` and `backend-staging` already point at those overlays.
- Secrets: `make dev-fallback-secret` only creates a placeholder. A real sandbox handshake needs a `rut-stag` taxpayer id type, id number, and IDP password supplied outside the repo.
- Downstream: unblocks HAB-46 and HAB-47. Those issues are not implemented here.
