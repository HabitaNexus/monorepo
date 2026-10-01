# Tasks

## 1. Sidecar package

- [x] 1.1 Create `apps/hacienda-sidecar` as a Node.js 22 TypeScript package that depends on `@dojocoding/hacienda-sdk@0.3.0` and does not depend on `@dojocoding/hacienda-cr`. Verify with `npm ls @dojocoding/hacienda-sdk` showing 0.3.0 and `npm ls @dojocoding/hacienda-cr` reporting it is not installed.
- [x] 1.2 Add a Dockerfile based on Node 22 that installs from the lockfile and starts the gRPC process. Verify with a successful image build from `apps/hacienda-sidecar`.

## 2. Credentials and environment

- [x] 2.1 Load `HACIENDA_ENVIRONMENT`, `HACIENDA_ID_TYPE`, `HACIENDA_ID_NUMBER`, and `HACIENDA_PASSWORD` at startup, and refuse to listen when the password is missing. Verify with a unit test that an unset password fails closed and that no credential literal appears in the package source.
- [x] 2.2 Pass `sandbox` or `production` through to `HaciendaClient` and reject any other value. Verify with unit tests that sandbox configuration does not select the production environment, and the reverse.

## 3. Token lifecycle

- [x] 3.1 Obtain and renew the access token only through the SDK (`authenticate` / `getAccessToken`), so a caller never supplies a replacement token. Verify with a unit test that a second fetch inside the renewal window returns a new token while the caller passes no token.
- [x] 3.2 When refresh fails, authenticate again with the injected password. Verify with a unit test that a failed refresh triggers one new authentication and still does not accept a caller-supplied token.

## 4. gRPC surface

- [x] 4.1 Serve auth status and a valid access token on port 50051, plus `grpc.health.v1.Health`. Response messages must not include the password, id number, or refresh token. Verify with an in-process client test that a rejected credential reports failure and returns no access token.
- [x] 4.2 On a successful SDK authentication, report success and a non-empty access token. Verify with an in-process client test using a fake SDK client.

## 5. Kubernetes

- [x] 5.1 Add a `hacienda-sidecar` Deployment and ClusterIP Service (port 50051, no Ingress) under `k8s/base/backend/`, with `secretKeyRef` for the three credential keys. Set `HACIENDA_ENVIRONMENT=sandbox` on the dev and staging overlays. Verify with `kubectl kustomize k8s/overlays/dev` and `kubectl kustomize k8s/overlays/staging`: both render the sidecar, `sandbox`, and the secret refs, and neither renders an Ingress for port 50051.
- [x] 5.2 Add an example Secret manifest that lists the credential keys with empty values only. Verify the file contains no password value and that `make dev-fallback-secret` is unchanged.

## 6. Sandbox handshake

- [x] 6.1 Add a smoke script that exits non-zero when the credential variables are unset, prints neither a password nor a token, and writes `reports/idp-handshake.csv` without those secrets. Verify with `src/handshake-report.test.ts`.
- [ ] 6.2 Run `make dev-hacienda-idp-handshake` against Hacienda sandbox once `HACIENDA_IDP_USERNAME` and `HACIENDA_PASSWORD` are supplied out of band for realm `rut-stag`. The command must print `handshake_ok` and the CSV must include `access_token_length_*` without the password or the token. Attach that CSV to the PR. This task stays blocked until those values exist; do not invent them.

## QA traceability (four layers)

SSOT: `docs/process/qa-traceability.md`

| Capa | Artifacto |
| --- | --- |
| 1 — AC normativos | `specs/tribu-cr-adapter/spec.md` (este cambio) y Acceptance Criteria de HAB-45 |
| 2 — QA manual de stage | No hay SOP de dominio. El chequeo manual es `make dev-hacienda-idp-handshake` contra sandbox, con el Secret fuera de git. Stage sigue en sandbox hasta que exista overlay de producción. |
| 3 — Automatizada | `apps/hacienda-sidecar` `npm test` (JUnit en `reports/junit.xml`). CI: `.github/workflows/hacienda-sidecar.yml` |
| 4 — Ronda HITL | `docs/qa/rounds/hacienda-oidc-2026-10-01/round.md` |

### Mapeo scenario → verificación

| Scenario de OpenSpec | Test automatizado | Manual (SOP / Kiwi) | Caso HITL ID | Storybook (solo UI) |
| --- | --- | --- | --- | --- |
| Successful sandbox handshake | `handshake report` → `writes a secret-free CSV when the token endpoint accepts the password` (fixture local). El handshake real contra `rut-stag` queda en 6.2 | `make dev-hacienda-idp-handshake` | HACIENDA-01 | — |
| Rejected credentials | `hacienda auth grpc` → `reports failure and omits secrets when credentials are rejected` | — | HACIENDA-02 | — |
| Token near expiry | `TokenGateway` → `returns the SDK token on a later fetch without a caller-supplied token` y `authenticates once when refresh fails and still takes no caller token`. La ventana de 30 s vive en `TokenManager` de `@dojocoding/hacienda-sdk` | — | HACIENDA-03 | — |
| Missing password | `boot` → `does not listen when the password is missing`; `loadCredentials` → `fails closed when the password is missing`; `handshake report` → `records credentials_not_configured and does not call the identity provider` | script sin `.env` | HACIENDA-04 | — |
| Sandbox configuration | `createHaciendaClient` → `sends sandbox authentication to the rut-stag identity provider`; `HAB-45 acceptance criteria` → overlay sandbox | `kubectl kustomize k8s/overlays/dev` | HACIENDA-05 | — |
| Production configuration | `createHaciendaClient` → `sends production authentication to the rut identity provider` | No hay overlay de producción en este PR | HACIENDA-06 | — |

### Acceptance Criteria de HAB-45

| Criterio | Verificación en `npm test` | Resultado que falta fuera de CI |
| --- | --- | --- |
| `apps/hacienda-sidecar/` consume el paquete publicado, sin fork | `depends on the published SDK and does not fork hacienda-cr` (`@dojocoding/hacienda-sdk@0.3.0`; `@dojocoding/hacienda-cr` no existe en npm) | — |
| OIDC contra Hacienda, sandbox parametrizable a producción | tests de `createHaciendaClient` (realm `rut-stag` / `rut`) | CSV del handshake sandbox (tarea 6.2) |
| El token se renueva al expirar | tests de `TokenGateway`; la ventana de 30 s es del SDK | — |
| Secretos por Secret de k8s, no hardcodeados | `injects taxpayer secrets from the Kubernetes secret...` y `package source` → `does not embed a credential literal` | Secret real creado fuera de banda |
| Manifiestos kustomize desplegables por ArgoCD | el mismo test de secretos (base, overlays dev/staging, Applications `backend-dev` y `backend-staging`) | `kubectl kustomize` en la ronda |
| Smoke de handshake sandbox exitoso | el CSV del fixture prueba el reporte; no llama a Hacienda | tarea 6.2 |

### Handoff

- [x] Casos manuales: `make dev-hacienda-idp-handshake` (no hay SOP aparte)
- [x] Ronda HITL con `round.md` y esta tabla
- [ ] CSV de sandbox real adjunto al PR (tarea 6.2, bloqueada sin credenciales)
