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
| HACIENDA-01: Successful sandbox handshake | Real local sidecar on port 50051 → published SDK 0.4.1 → Hacienda sandbox, plus installed-SDK regression | Live gRPC passed; secret-free metadata in `live-grpc-sandbox.json` |
| HACIENDA-02: Rejected credentials | `reports a real SDK authentication rejection without exposing IDP details` | Passed with intercepted HTTP 401 |
| HACIENDA-03: Token near expiry | Live gRPC returned a different token with extended expiry after waiting for the real renewal window; SDK-backed clock regression separately covers refresh-token expiry | Live automatic renewal passed; ten-hour re-authentication remains simulated |
| HACIENDA-04: Missing password | Existing configuration/boot tests plus missing-credentials script check | Passed |
| HACIENDA-05/06: Environment selection | Exact realm and public client asserted in SDK-backed gRPC requests | Passed with intercepted IDP responses |

## Live sandbox verification

A local instance of the actual sidecar listened on port 50051 with the published
SDK 0.4.1 and made real HTTPS calls to Hacienda sandbox. No HTTP mocks, endpoint
overrides or artificial clock were used in this check.

- Initial check: `2026-10-15T05:30:06.686Z` (2026-10-14, 23:30 Costa Rica).
- `GetAuthStatus`: authenticated, environment sandbox.
- `GetAccessToken`: success and non-empty token (length 1510; value not recorded).
- `Health.Check`: `SERVING`.
- After waiting about 275 seconds for the real SDK renewal window, another
  `GetAccessToken` succeeded at `2026-10-15T05:34:41.320Z` (23:34 Costa Rica).
  The returned token differed from the original, its expiry was extended, and
  health remained `SERVING`.
- The process was shut down after verification. Credentials were loaded from the
  ignored local `.env`, restricted to the file owner; the local file was empty
  of credentials at the final check. No credentials, username,
  access token or refresh token are in the evidence file.

Evidence: `live-grpc-sandbox.json`. This proves initial authentication and automatic
token renewal through the local sidecar. It does not assert which IDP grant was
used internally for renewal, and does not demonstrate a ten-hour session or the
Kubernetes deployment.

## Remaining live checks

- [x] Authenticate through the actual gRPC service using sandbox credentials stored only in the ignored local `.env`. `GetAuthStatus` returned authenticated/sandbox, `GetAccessToken` returned a non-empty token, and `Health.Check` returned `SERVING`.
- [ ] Configure `HACIENDA_IDP_USERNAME` in the deployed Secret and capture ArgoCD sync/health evidence.
- [ ] Verify the updated container image builds and is available to the cluster.

A live sandbox login through the actual sidecar succeeded on 2026-10-14 (America/Costa_Rica). The service was shut down after verification. No invoice submission, production call or Kubernetes deployment was performed. HAB-45 still needs image and ArgoCD evidence.
