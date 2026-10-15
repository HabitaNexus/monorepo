# Hacienda authentication sidecar (HAB-45)

Node.js 22+ service using the published `@dojocoding/hacienda-sdk@0.4.1`.
The upstream [issue #37](https://github.com/DojoCodingLabs/hacienda-cr/issues/37)
was fixed in [PR #39](https://github.com/DojoCodingLabs/hacienda-cr/pull/39).

## Credentials

Copy `.env.example` to `.env` locally and supply the full IDP username and password
outside git. Preserve every hyphen and the environment domain:

```dotenv
HACIENDA_ENVIRONMENT=sandbox
HACIENDA_IDP_USERNAME='cpf-01-0000-0000@stag.comprobanteselectronicos.go.cr'
HACIENDA_PASSWORD=''
```

The username above is only a placeholder. The sidecar passes
`HACIENDA_IDP_USERNAME` as SDK `credentials.username`. It does not derive a
taxpayer ID from it or pad its digits. Authentication needs no `.p12` certificate.

When no username variable exists, the legacy `HACIENDA_ID_TYPE` and
`HACIENDA_ID_NUMBER` pair remains available. An explicitly empty or invalid
username fails closed. In full-username mode the legacy ID fields are not used;
future invoice emitter identification remains a separate concern.

## Local verification

From this directory:

```sh
npm ci
npm test
npm run build
# SDK authentication against Hacienda; prints no token or password:
node --env-file=.env dist/smoke.js
# Start the actual gRPC service using the same configuration:
node --env-file=.env dist/index.js
```

With the service running, use a gRPC client to call
`habitanexus.hacienda.auth.v1.HaciendaAuth/GetAuthStatus` with an empty request.
For example, if `grpcurl` is available, run in another terminal:

```sh
grpcurl -plaintext -import-path proto -proto hacienda_auth.proto -d '{}' \
  127.0.0.1:50051 habitanexus.hacienda.auth.v1.HaciendaAuth/GetAuthStatus
```

Require `authenticated: true` and `environment: sandbox`. This invokes the real
sidecar/SDK path. The root `make dev-hacienda-idp-handshake` target is a separate
direct-HTTP IDP diagnostic; its historical CSV does not prove gRPC authentication.
Automated gRPC regressions use the real installed SDK with intercepted IDP HTTP
responses, including refresh, re-authentication and credential rejection.

## Kubernetes

Populate the `hacienda-credentials` Secret outside git with
`HACIENDA_IDP_USERNAME` and `HACIENDA_PASSWORD`. Omit the legacy ID keys when using
the issued username. The example Secret contains blank placeholders only.
Dev and staging remain in sandbox. The service is internal (`ClusterIP:50051`).

After deploying, verify ArgoCD sync/health and repeat the gRPC status call through
a local port-forward. Live authentication and cluster evidence remain separate
from passing local tests.
