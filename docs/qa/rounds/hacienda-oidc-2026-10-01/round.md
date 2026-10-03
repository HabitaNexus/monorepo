# Ronda HITL — Hacienda OIDC sidecar (HAB-45)

Fecha: 2026-10-01. Rama: `davidachoy/hab-45-auth-oidc-via-hacienda-cr-sidecar-grpc`.

Esta ronda contrasta los Acceptance Criteria de HAB-45. El `.env` de sandbox no está en el repo. El 2026-10-03 se corrió el handshake vivo con credenciales suministradas fuera de banda y luego se borró el `.env`.

## Veredicto por criterio

| Criterio de HAB-45 | Veredicto | Evidencia |
| --- | --- | --- |
| Existe `apps/hacienda-sidecar/` y consume el paquete publicado, sin fork | Cumple | `npm ls @dojocoding/hacienda-sdk` → `0.3.0`. `npm ls @dojocoding/hacienda-cr` sale con código 1 (no está instalado). El lockfile resuelve el tarball de `registry.npmjs.org`. El nombre del issue dice `@dojocoding/hacienda-cr`; ese nombre responde 404 en npm. El paquete publicado es `@dojocoding/hacienda-sdk`. |
| El sidecar se autentica por OIDC y el ambiente elige sandbox o producción | Cumple | Los tests de `createHaciendaClient` fijan el realm `rut-stag` (`api-stag`) y el realm `rut` (`api-prod`). El handshake vivo contra `rut-stag` devolvió HTTP 200. |
| El token se renueva al expirar | Cumple en el límite del sidecar | `TokenGateway` vuelve a llamar al SDK sin token del caller, y si el refresh falla autentica de nuevo. La ventana de 30 s está en `TokenManager` de `@dojocoding/hacienda-sdk`, no reimplementada aquí. |
| Los secretos llegan por Secret de Kubernetes, no en el código | Cumple | `secretKeyRef` de `hacienda-credentials` para tipo, número y password. El ejemplo trae valores vacíos. El test de fuentes no encuentra un literal de password. Infisical no está cableado; el Secret se crea fuera de git. |
| Manifiestos en base y overlays, desplegables por ArgoCD | Cumple | `kubectl kustomize` de dev y staging renderizan el sidecar, `HACIENDA_ENVIRONMENT: sandbox`, el Secret y el Service `ClusterIP` `50051`. Ningún Ingress menciona el puerto 50051. `backend-dev` apunta a `k8s/overlays/dev` y `backend-staging` a `k8s/overlays/staging`. |
| Un smoke confirma el handshake OIDC contra sandbox | Cumple | `make dev-hacienda-idp-handshake` imprimió `handshake_ok`, `token_type=Bearer`, `expires_in=300`, `access_token_length=1510`. CSV: `idp-handshake-sandbox.csv`. |

## npm test

Comando: `npm test` en `apps/hacienda-sidecar`.

Resultado de esta corrida: 18 pruebas, 0 fallos. JUnit: `npm-test.junit.xml` en esta carpeta. El workflow `.github/workflows/hacienda-sidecar.yml` vuelve a correr lo mismo y sube el JUnit como artefacto del PR.

## Handshake sin credenciales

Comando: `HACIENDA_HANDSHAKE_SKIP_DOTENV=1 node apps/hacienda-sidecar/scripts/sandbox-handshake.mjs`

```text
handshake_failed
HACIENDA_IDP_USERNAME is required (full IDP user, e.g. cpf-01-0000-0000@stag.comprobanteselectronicos.go.cr). Put it in apps/hacienda-sidecar/.env
```

El proceso terminó con código 1. No hubo request al IDP. El CSV está en `idp-handshake-missing-credentials.csv`. La columna `failed` es `credentials_not_configured`. No hay password ni token.

## Handshake de sandbox

Comando: `make dev-hacienda-idp-handshake` el 2026-10-03, con el `.env` local. El archivo se borró después de la corrida.

```text
handshake_ok
environment=sandbox
token_type=Bearer
expires_in=300
access_token_length=1510
```

El proceso terminó con código 0. El CSV está en `idp-handshake-sandbox.csv`: HTTP 200, aserciones `status_2xx`, `token_type_Bearer`, `expires_in_300`, `access_token_length_1510`. No contiene el password, el usuario ni el token. `make dev-argocd-status` sigue sin salida en esta ronda.

## Kustomize

Detalle en `kustomize-check.txt`. `kubectl` v1.37.1 / Kustomize v5.8.1.

Dev y staging renderizan `HACIENDA_ENVIRONMENT: sandbox`, `secretKeyRef` hacia `hacienda-credentials`, y el Service `hacienda-sidecar` en `ClusterIP` puerto 50051. El Ingress que ya existía publica el Service `backend` en el puerto 80, no el sidecar.
