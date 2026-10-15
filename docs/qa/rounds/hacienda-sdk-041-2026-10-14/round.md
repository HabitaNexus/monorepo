# HAB-45 — SDK 0.4.1 and issued IDP usernames

Date: 2026-10-14 (America/Costa_Rica).

## Upstream evidence

- [Issue #37](https://github.com/DojoCodingLabs/hacienda-cr/issues/37) is closed as completed.
- [PR #39](https://github.com/DojoCodingLabs/hacienda-cr/pull/39) is merged and adds `credentials.username` without changing hyphens or the environment domain.
- npm `latest` is 0.4.1. `npm ls @dojocoding/hacienda-sdk` confirms 0.4.1 installed here.

## Local verification

- `npm test`: 26 tests passed, zero failures; JUnit: `npm-test.junit.xml`.
- `npm run build`: passed on Node 22.22.2.
- `openspec validate hab-45-hacienda-sidecar-oidc --strict`: passed.
- `kubectl kustomize k8s/overlays/dev` and `k8s/overlays/staging`: passed; both render sandbox and the issued-username Secret reference. No cluster was changed.
- Docker image build not verified: the local Docker daemon is unavailable.

The new integration tests run configuration → boot → gRPC → TokenGateway → the
published HaciendaClient/TokenManager. Only the IDP HTTP transport is intercepted.
They assert the exact issued username in sandbox and production password grants,
refresh inside the 30-second renewal window, and re-authentication after the
refresh token expires. A separate SDK-backed 401 case verifies sanitized failure.
These are local transport simulations, not live Hacienda authentication.

## Traceability

| Case | Verification | State |
| --- | --- | --- |
| HACIENDA-07: Issued IDP username | `hacienda auth grpc` → `preserves the issued sandbox username through gRPC login, refresh and re-authentication`, plus production equivalent; invalid username configuration tests | Passed with intercepted IDP responses |
| HACIENDA-01: Successful sandbox handshake | Same installed-SDK gRPC regression; historical CSV is direct-IDP only | Live gRPC pending |
| HACIENDA-02: Rejected credentials | `reports a real SDK authentication rejection without exposing IDP details` | Passed with intercepted HTTP 401 |
| HACIENDA-03: Token near expiry | SDK-backed gRPC regression advances the clock into renewal and beyond refresh expiry | Passed with intercepted IDP responses |
| HACIENDA-04: Missing password | Existing configuration/boot tests plus missing-credentials script check | Passed |
| HACIENDA-05/06: Environment selection | Exact realm and public client asserted in SDK-backed gRPC requests | Passed with intercepted IDP responses |

## Remaining live checks

- [ ] Supply the full sandbox username and password outside git; authenticate through the actual gRPC service. See `apps/hacienda-sidecar/README.md`.
- [ ] Configure `HACIENDA_IDP_USERNAME` in the deployed Secret and capture ArgoCD sync/health evidence.
- [ ] Verify the updated container image builds and is available to the cluster.

No new live login, invoice submission, production call or Kubernetes deployment
was performed in this round. The upstream defect is fixed and locally covered;
HAB-45 is not marked fully validated by this report.
