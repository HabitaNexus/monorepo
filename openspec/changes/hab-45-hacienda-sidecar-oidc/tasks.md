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

- [x] 6.1 Add a smoke script that exits non-zero when the credential variables are unset and prints neither a password nor a token. Verify by running the script with those variables unset.
- [ ] 6.2 Run the same script against Hacienda sandbox once `HACIENDA_ID_TYPE`, `HACIENDA_ID_NUMBER`, and `HACIENDA_PASSWORD` are supplied out of band for realm `rut-stag`. Verify a successful handshake status. This task stays blocked until those values exist; do not invent them.
