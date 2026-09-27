# Design

## Context

See proposal.md for why this change exists. On `develop`, `openspec/specs/tribu-cr-adapter/spec.md` names a "hacienda-cr gRPC sidecar" and does not name an npm package. `apps/hacienda-sidecar/` does not exist. `apps/backend/` does not exist either. `k8s/base/backend/` is a single HTTP Deployment (`backend`, port 3000, image `ghcr.io/habitanexus/monorepo/backend:latest`) plus a ClusterIP Service and an Ingress. ArgoCD `backend-dev` syncs `k8s/overlays/dev` from `develop`. `make dev-fallback-secret` creates a placeholder secret (`placeholder=true`) and does not carry Hacienda credentials.

The published toolkit is `@dojocoding/hacienda-sdk` 0.3.0 from [DojoCodingLabs/hacienda-cr](https://github.com/DojoCodingLabs/hacienda-cr) (`packages/sdk`). `@dojocoding/hacienda-cr` is not an npm package (registry 404). The SDK is a TypeScript client (auth, XML, XAdES, HTTP), not a gRPC server. Aduanext's `hacienda-sidecar` is the topology reference: a TypeScript process speaking gRPC, in that repo on loopback port 50051. This repo does not contain aduanext's `libs/proto/hacienda.proto`.

Hacienda authentication in the SDK is OAuth2 ROPC, not a confidential-client client secret. `TokenManager` caches the access token (~5 minutes), refreshes about 30 seconds before expiry, and keeps a refresh token for about 10 hours. `getAccessToken()` performs that refresh. Environment endpoints and public client ids are built in:

| Environment | IDP realm | Client ID |
| --- | --- | --- |
| sandbox | `rut-stag` | `api-stag` |
| production | `rut` | `api-prod` |

The constructor takes `environment` plus `credentials.idType`, `credentials.idNumber`, and `credentials.password`. Node.js 22+ is required.

## Goals / Non-Goals

**Goals:**

- A gRPC sidecar we own, depending on `@dojocoding/hacienda-sdk` as an npm package.
- Sandbox and production selected by configuration, with token renewal delegated to the SDK.
- Taxpayer secrets only from the Kubernetes secret store.
- A smoke check that reports success or a credential failure without printing the password.

**Non-Goals:**

- Forking hacienda-cr, or copying its auth, XML, or signing code.
- Declaration RCI (HAB-46), factura electrónica (HAB-47), `TribuTaxReporter`, XAdES, `.p12`, or ATENA.
- Changing the existing rental, tax, invoice, compliance, or `TaxReportingPort` requirements.
- Same-pod loopback beside a tax-reporting container. That container does not exist on this branch.

## Decisions

### 1. Depend on `@dojocoding/hacienda-sdk`, never `@dojocoding/hacienda-cr`

Pin `apps/hacienda-sidecar` to `@dojocoding/hacienda-sdk` (0.3.0 at the time of this design). The GitHub repository stays the upstream source of truth; we do not vendor or fork it.

Alternative considered: treat `@dojocoding/hacienda-cr` as the package name, as the Linear issue and the `main` copy of the living spec do. Rejected because that name 404s on the npm registry. The `develop` living spec does not name a package, so this design is the place that records the real one.

### 2. Wrap the SDK in our sidecar; do not reimplement ROPC

The process constructs `HaciendaClient` with environment and credentials from the environment, then serves gRPC. Token expiry and refresh stay inside `TokenManager` / `getAccessToken()`. After the refresh token itself expires, the sidecar calls `authenticate()` again with the same injected password. Callers never send a password or a replacement token.

The HAB-45 gRPC surface is only authentication status plus "return a currently valid access token". Use standard `grpc.health.v1.Health` for process health, and a small proto for auth status (authenticated or failed, no secret fields in the response). ClusterIP only. Do not publish an Ingress for this port.

Alternative considered: a confidential OIDC client with our own client id and client secret. Rejected because Hacienda's IDP client ids are public and already selected by `getEnvironmentConfig()`. The secret is the taxpayer password.

Alternative considered: shell out to `@dojocoding/hacienda-cli`. Rejected because the sidecar needs an in-process token cache, not a login prompt.

### 3. Own Deployment in the existing backend kustomize base

Add `hacienda-sidecar` Deployment and ClusterIP Service (gRPC port 50051) under `k8s/base/backend/`, included by the current kustomization. Leave the placeholder `backend` container as it is. Dev and staging overlays set `HACIENDA_ENVIRONMENT=sandbox`. There is no production overlay in the repo; the binary still accepts `production`, and a later overlay can set it.

Same-pod `127.0.0.1:50051` beside the tax service remains the aduanext end state. It waits until that container exists. Until then, in-cluster callers use the ClusterIP Service.

Alternative considered: a second container on the current `backend` Deployment. Rejected because that image is a stub and would couple the OIDC smoke path to an app this change does not own.

### 4. Secrets are a Kubernetes Secret, not git and not the placeholder

Env vars, all required at startup:

- `HACIENDA_ENVIRONMENT` — `sandbox` or `production` (non-secret, from the overlay ConfigMap)
- `HACIENDA_ID_TYPE` — `01`, `02`, `03`, or `04`
- `HACIENDA_ID_NUMBER`
- `HACIENDA_PASSWORD`

Mount them from a dedicated Secret (for example `hacienda-credentials`) via `secretKeyRef`. If the password is missing, the process exits before it listens; it does not use a default. Do not extend `make dev-fallback-secret` with real values, and do not commit a Secret manifest that contains them. An example manifest may list the keys with empty placeholders. Infisical is the intended injector when that operator is wired; this repo does not wire it today, so creating the Secret out of band is the supported path.

### 5. Smoke test is local and refuses to run without credentials

A script in `apps/hacienda-sidecar` starts the client against the configured environment and prints only success or a sanitized failure (no password, no token). If the three credential variables are unset, it exits non-zero with that reason. It is not a default CI job: CI does not have a `rut-stag` taxpayer.

## Risks / Trade-offs

- [Sandbox taxpayer is not in the repo or in Linear] → Manifests and the process can land without it. The live handshake stays blocked until someone supplies `idType`, `idNumber`, and the `rut-stag` password out of band. Record the result when they do; do not invent credentials.
- [Access token lifetime is about five minutes] → Callers must use the sidecar (or `getAccessToken()`) per operation rather than cache a token themselves. The sidecar is the only cache.
- [Refresh token lasts about ten hours, then ROPC runs again with the stored password] → The password stays in the Secret for the life of the process. That is the IDP model. Restrict the Secret to this Deployment's service account.
- [Single sidecar is the auth path for later B2G calls] → One replica is enough for HAB-45. Readiness must fail when authentication is down so a later caller does not get a pod that cannot mint a token.
- [SDK 0.3.0 is a direct dependency] → Renovate or a manual bump picks up upstream OIDC and signing fixes. A fork would freeze those fixes here.

## Migration Plan

1. Add `apps/hacienda-sidecar` (package, Dockerfile, Node 22, gRPC server, smoke script). No Flutter changes.
2. Add the Deployment, Service, and credential key references under `k8s/base/backend/`. Set sandbox on the dev and staging overlays.
3. Apply on a cluster only after the Secret exists. Rollback is removing those manifests; there is no schema and no stored token to migrate.
4. Run the smoke script with the sandbox Secret. If the Secret is absent, the script fails closed and the rest of the change can still be reviewed.

## Open Questions

None. The missing sandbox password does not change the spec, the package, or the task breakdown. It only gates the live handshake.
