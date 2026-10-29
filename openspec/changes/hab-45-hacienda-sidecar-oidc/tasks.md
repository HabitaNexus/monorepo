# Tasks

## 1. Sidecar package

- [x] 1.1 Create `apps/hacienda-sidecar` as a Node.js 22 TypeScript package that depends on `@dojocoding/hacienda-sdk@0.4.1` and does not depend on `@dojocoding/hacienda-cr`. Verify with `npm ls @dojocoding/hacienda-sdk` showing 0.4.1 and `npm ls @dojocoding/hacienda-cr` reporting it is not installed.
- [x] 1.2 Verify the Node 22 image build with the SDK 0.4.1 lockfile. The current assurance CI successfully ran Docker build: https://github.com/HabitaNexus/monorepo/actions/runs/38688481223. Publication and deployment are separate checks.

## 2. Credentials and environment

- [x] 2.1 Load `HACIENDA_ENVIRONMENT`, `HACIENDA_IDP_USERNAME`, and `HACIENDA_PASSWORD` at startup (legacy ID type/number only when the username is absent), and refuse to listen when the password is missing. Verify with a unit test that an unset password fails closed and that no credential literal appears in the package source.
- [x] 2.2 Pass `sandbox` or `production` through to `HaciendaClient` and reject any other value. Verify with unit tests that sandbox configuration does not select the production environment, and the reverse.

## 3. Token lifecycle

- [x] 3.1 Obtain and renew the access token only through the SDK (`authenticate` / `getAccessToken`), so a caller never supplies a replacement token. Verify with a unit test that a second fetch inside the renewal window returns a new token while the caller passes no token.
- [x] 3.2 When refresh fails, authenticate again with the injected password. Verify with a unit test that a failed refresh triggers one new authentication and still does not accept a caller-supplied token.

## 4. gRPC surface

- [x] 4.1 Serve auth status and a valid access token on port 50051, plus `grpc.health.v1.Health`. Response messages must not include the password, id number, or refresh token. Verify with an in-process client test that a rejected credential reports failure and returns no access token.
- [x] 4.2 On a successful SDK authentication, report success and a non-empty access token. Verify with an in-process client test using a fake SDK client.

## 5. Kubernetes

- [x] 5.1 Add a `hacienda-sidecar` Deployment and ClusterIP Service (port 50051, no Ingress) under `k8s/base/backend/`, with `secretKeyRef` for the full IDP username and password, plus optional legacy ID keys. Set `HACIENDA_ENVIRONMENT=sandbox` on the dev and staging overlays. Verify with `kubectl kustomize k8s/overlays/dev` and `kubectl kustomize k8s/overlays/staging`: both render the sidecar, `sandbox`, and the secret refs, and neither renders an Ingress for port 50051.
- [x] 5.2 Add an example Secret manifest that lists the credential keys with empty values only. Verify the file contains no password value and that `make dev-fallback-secret` is unchanged.

## 6. Sandbox handshake

- [x] 6.1 Add a smoke script that exits non-zero when the credential variables are unset, prints neither a password nor a token, and writes `reports/idp-handshake.csv` without those secrets. Verify with `src/handshake-report.test.ts`.
- [x] 6.2 Run `make dev-hacienda-idp-handshake` against Hacienda sandbox once `HACIENDA_IDP_USERNAME` and `HACIENDA_PASSWORD` are supplied out of band for realm `rut-stag`. The command printed `handshake_ok` with `access_token_length=1510`, `expires_in=300`, and `token_type=Bearer`. The CSV is `docs/qa/rounds/hacienda-oidc-2026-10-01/idp-handshake-sandbox.csv` and contains neither the password nor the token.

## 7. Issued IDP username support (upstream #37)

- [x] 7.1 Upgrade the published SDK and lockfile to 0.4.1 (upstream fix #39).
- [x] 7.2 Pass `HACIENDA_IDP_USERNAME` unchanged to `HaciendaClient`, without requiring a padded or reconstructed ID; preserve the legacy ID fallback only when the username is absent. Inject the username from `hacienda-credentials` and redact it from startup errors.
- [x] 7.3 Verify real installed SDK login, refresh, and re-authentication through in-process gRPC in sandbox and production, with intercepted IDP HTTP responses. Verify rejected credentials expose no token. Evidence: `docs/qa/rounds/hacienda-sdk-041-2026-10-14/round.md`.
- [x] 7.4 Run the sidecar gRPC path against the real sandbox using the installed SDK 0.4.1. `GetAuthStatus` returned authenticated/sandbox, `GetAccessToken` returned a non-empty token, and `Health.Check` returned `SERVING`. Evidence: `docs/qa/rounds/hacienda-sdk-041-2026-10-14/live-grpc-sandbox.json`. The historical direct-IDP CSV remains separate.
- [x] 7.6 Verify automatic renewal through the real local gRPC sidecar after waiting for the SDK renewal window. A second token differed and its expiry was extended; health stayed `SERVING`. Evidence: the `renewal` section of `live-grpc-sandbox.json`. Ten-hour re-authentication remains covered by simulation, not a live wait.
- [ ] 7.5 Capture the deployed sidecar's ArgoCD sync/health status and confirm the new Secret key is configured.

## 8. Ready-to-review assurance

- [x] 8.1 Correct diagnostic success detection; HTTP 200 with invalid metadata fails. Verify the three invalid-metadata regressions in `handshake-report.test.ts`.
- [x] 8.2 Implement health-watch transitions and deterministic stream cleanup on shutdown. Verify `updates health watchers and closes their streams on shutdown`.
- [x] 8.3 Restrict TCP 50051 ingress to same-namespace backend pods with NetworkPolicy and exclude `.env*` from the Docker context. Manifest assertions and dev/staging render pass; enforcement by a deployed CNI remains pending 7.5.
- [x] 8.4 Add pinned TypeScript lint/format/typecheck gates, runtime dependency audit and Docker image build to CI. Local gates and 30 tests pass; the expanded CI including Docker passed at bfbd328337179e6a02e72d0b97c6cc29722afcb2. Final-head status is verified again before remote review.
- [x] 8.5 Triage the unpatched high node-forge signature-verification advisory as HAB-95, owned by David Achoy; it is outside the current auth-only path. Critical findings in npm runtime audit: 0.
- [x] 8.7 Generate and validate `apps/hacienda-sidecar/e2e/test-suite.json` from the testing pillar output, covering all 10 OpenSpec scenarios. Keep the existing node:test runner; stage-only manual verification remains a QA handoff. Do not execute the stage E2E runner in this workflow.
- [ ] 8.6 Obtain the configured remote review verdict and complete the human handoff without merging or marking HAB-45 Done.

## QA traceability (four layers)

SSOT: `docs/process/qa-traceability.md`

| Capa | Artifacto |
| --- | --- |
| 1 — AC normativos | `specs/tribu-cr-adapter/spec.md` (este cambio) y Acceptance Criteria de HAB-45 |
| 2 — QA manual de stage | No hay SOP de dominio. El chequeo manual del sidecar es `GetAuthStatus` por gRPC contra sandbox (local 7.4 passed; deployed 7.5 pending); `make dev-hacienda-idp-handshake` es un diagnóstico HTTP independiente. Secret fuera de git. Stage sigue en sandbox hasta que exista overlay de producción. |
| 3 — Automatizada | `apps/hacienda-sidecar` `npm test` (JUnit en `reports/junit.xml`). CI: `.github/workflows/hacienda-sidecar.yml` |
| 4 — Ronda HITL | Historical direct-IDP evidence: `docs/qa/rounds/hacienda-oidc-2026-10-01/round.md`; SDK upgrade: `docs/qa/rounds/hacienda-sdk-041-2026-10-14/round.md` |

### Mapeo scenario → verificación

| Scenario de OpenSpec | Test automatizado | Manual (SOP / Kiwi) | Caso HITL ID | Storybook (solo UI) |
| --- | --- | --- | --- | --- |
| Unrelated pod requests a token | `HAB-45 acceptance criteria` → NetworkPolicy selectors and port; dev/staging kustomize rendering | Verify allowed/denied pod connections with an enforcing CNI before deploying real credentials | HACIENDA-08 | — |
| Authentication health changes | `hacienda auth grpc` → `updates health watchers and closes their streams on shutdown` | — | HACIENDA-09 | — |
| Invalid successful HTTP response | `handshake report` → three invalid token metadata HTTP 200 cases | — | HACIENDA-10 | — |
| Issued IDP username | `hacienda auth grpc` → `preserves the issued sandbox username through gRPC login, refresh and re-authentication` and production equivalent (installed SDK, HTTP intercepted); configuration tests reject invalid explicit usernames | Full username in `hacienda-credentials`; live local gRPC sandbox check passed 7.4; deployed verification pending 7.5 | HACIENDA-07 | — |
| Successful sandbox handshake | `handshake report` → `writes a secret-free CSV when the token endpoint accepts the password` (fixture local). Historical direct-IDP handshake: `idp-handshake-sandbox.csv`; live local sidecar gRPC passed 7.4; deployed verification pending 7.5 | `make dev-hacienda-idp-handshake` | HACIENDA-01 | — |
| Rejected credentials | `hacienda auth grpc` → `reports failure and omits secrets when credentials are rejected` | — | HACIENDA-02 | — |
| Token near expiry | `TokenGateway` → `returns the SDK token on a later fetch without a caller-supplied token` y `authenticates once when refresh fails and still takes no caller token`, plus the installed-SDK gRPC login/refresh/re-authentication regressions and live automatic renewal evidence in `live-grpc-sandbox.json`. La ventana de 30 s vive en `TokenManager` de `@dojocoding/hacienda-sdk` | — | HACIENDA-03 | — |
| Missing password | `boot` → `does not listen when the password is missing`; `loadCredentials` → `fails closed when the password is missing`; `handshake report` → `records credentials_not_configured and does not call the identity provider` | script sin `.env` | HACIENDA-04 | — |
| Sandbox configuration | `createHaciendaClient` → `sends sandbox authentication to the rut-stag identity provider`; `HAB-45 acceptance criteria` → overlay sandbox | `kubectl kustomize k8s/overlays/dev` | HACIENDA-05 | — |
| Production configuration | `createHaciendaClient` → `sends production authentication to the rut identity provider` | No hay overlay de producción en este PR | HACIENDA-06 | — |

### Acceptance Criteria de HAB-45

| Criterio | Verificación en `npm test` | Resultado que falta fuera de CI |
| --- | --- | --- |
| `apps/hacienda-sidecar/` consume el paquete publicado, sin fork | `depends on the published SDK and does not fork hacienda-cr` (`@dojocoding/hacienda-sdk@0.4.1`; `@dojocoding/hacienda-cr` no existe en npm) | — |
| OIDC contra Hacienda, sandbox parametrizable a producción | tests de `createHaciendaClient` and installed-SDK gRPC regressions | Live local sidecar gRPC passed 7.4; deployed verification pending 7.5; historical CSV only verifies the direct HTTP script |
| El token se renueva al expirar | tests de `TokenGateway` and installed-SDK gRPC regressions; real local automatic renewal passed 7.6 | `live-grpc-sandbox.json` renewal evidence; deployed verification pending 7.5 |
| Secretos por Secret de k8s, no hardcodeados | `injects taxpayer secrets from the Kubernetes secret...` y `package source` → `does not embed a credential literal` | Secret real creado fuera de banda |
| Manifiestos kustomize desplegables por ArgoCD | el mismo test de secretos (base, overlays dev/staging, Applications `backend-dev` y `backend-staging`) | `kubectl kustomize` en la ronda |
| Smoke de handshake sandbox exitoso | el CSV del fixture prueba el reporte | `idp-handshake-sandbox.csv`: HTTP 200, `access_token_length_1510` |

### Handoff

- [x] Casos manuales: `make dev-hacienda-idp-handshake` (no hay SOP aparte)
- [x] Ronda HITL con `round.md` y esta tabla
- [x] CSV de sandbox real adjunto al PR (`idp-handshake-sandbox.csv`)
