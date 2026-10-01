# Ronda HITL — Hacienda OIDC sidecar (HAB-45)

Fecha: 2026-10-01. Rama: `davidachoy/hab-45-auth-oidc-via-hacienda-cr-sidecar-grpc`.

Esta ronda contrasta los Acceptance Criteria de HAB-45 con lo que se puede ejecutar sin el `.env` de sandbox. Ese archivo no está en el repo y no estaba en este entorno.

## Veredicto por criterio

| Criterio de HAB-45 | Veredicto | Evidencia |
| --- | --- | --- |
| Existe `apps/hacienda-sidecar/` y consume el paquete publicado, sin fork | Cumple | `npm ls @dojocoding/hacienda-sdk` → `0.3.0`. `npm ls @dojocoding/hacienda-cr` sale con código 1 (no está instalado). El lockfile resuelve el tarball de `registry.npmjs.org`. El nombre del issue dice `@dojocoding/hacienda-cr`; ese nombre responde 404 en npm. El paquete publicado es `@dojocoding/hacienda-sdk`. |
| El sidecar se autentica por OIDC y el ambiente elige sandbox o producción | Parcial | Los tests de `createHaciendaClient` fijan el realm `rut-stag` (`api-stag`) y el realm `rut` (`api-prod`). Falta el handshake vivo contra sandbox (tarea 6.2). |
| El token se renueva al expirar | Cumple en el límite del sidecar | `TokenGateway` vuelve a llamar al SDK sin token del caller, y si el refresh falla autentica de nuevo. La ventana de 30 s está en `TokenManager` de `@dojocoding/hacienda-sdk`, no reimplementada aquí. |
| Los secretos llegan por Secret de Kubernetes, no en el código | Cumple | `secretKeyRef` de `hacienda-credentials` para tipo, número y password. El ejemplo trae valores vacíos. El test de fuentes no encuentra un literal de password. Infisical no está cableado; el Secret se crea fuera de git. |
| Manifiestos en base y overlays, desplegables por ArgoCD | Cumple | `kubectl kustomize` de dev y staging renderizan el sidecar, `HACIENDA_ENVIRONMENT: sandbox`, el Secret y el Service `ClusterIP` `50051`. Ningún Ingress menciona el puerto 50051. `backend-dev` apunta a `k8s/overlays/dev` y `backend-staging` a `k8s/overlays/staging`. |
| Un smoke confirma el handshake OIDC contra sandbox | No corrido | No hay credenciales de `rut-stag` en este entorno. El camino sin credenciales sí se corrió y queda abajo. |

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

## Handshake de sandbox (pendiente)

Quien tenga `apps/hacienda-sidecar/.env` corre:

```bash
make dev-hacienda-idp-handshake
```

Tiene que imprimir `handshake_ok` y la longitud del token, y escribir `apps/hacienda-sidecar/reports/idp-handshake.csv`. Ese CSV usa las columnas de `newman-reporter-csv` (request, status, aserciones, conteos) y no la columna `body`. Esa columna sería el access token (`--reporter-csv-includeBody`). Si el password, el usuario o el token fueran a quedar en el archivo, el script no lo escribe.

Newman no es dependencia del sidecar. La imagen hace `npm ci`, y el runtime de Postman no entra en ese lockfile. El CSV es el artefacto auditable. Hay que adjuntar el CSV de una corrida real con usuario IDP; esta ronda no lo tiene.

## Kustomize

Detalle en `kustomize-check.txt`. `kubectl` v1.37.1 / Kustomize v5.8.1.

Dev y staging renderizan `HACIENDA_ENVIRONMENT: sandbox`, `secretKeyRef` hacia `hacienda-credentials`, y el Service `hacienda-sidecar` en `ClusterIP` puerto 50051. El Ingress que ya existía publica el Service `backend` en el puerto 80, no el sidecar.
