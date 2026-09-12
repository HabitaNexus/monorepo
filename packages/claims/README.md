# claims

Dominio de reclamos bidireccionales — máquina de estados del SOP §6.3
(`docs/site/content/docs/sops/flujo-arrendamiento.md`). Implementa
[HAB-39](https://linear.app/habitanexus/issue/HAB-39/reclamos-bidireccionales-maquina-de-estados).

## Decisión de arquitectura: dónde vive `Claim`

**Decisión:** package Dart puro `packages/claims`, sin dependencia de Flutter.

**Alternativas descartadas:**

- `apps/backend` — no existe (el issue lo anticipaba). Crear un backend
  entero para una máquina de estados pura habría sido sobredimensionado.
- `apps/mobile/lib/features/claims/` — acoplaría el dominio a Flutter e
  impediría reutilizarlo en el futuro backend o en jobs programados.

El package es importable desde la app móvil, el futuro backend y CLIs.
Cuando exista `apps/backend`, este package se usa tal cual como librería
de dominio.

## Máquina de estados

```text
CREADO ──► EN_REVISION ──► ACEPTADO ──► RESUELTO (con evidencia)
              │               ▲
              │ DISPUTADO ──► MEDIACION ──► RESUELTO
              │                                └────► ESCALADO
              └──► ESCALADO ──► CALIFICACION_NEGATIVA (automática)
                 (timeout 5 días / mediación fallida)
```

Reglas:

- 7 estados, incluidos `mediacion` y `calificacionNegativa` (el título del
  issue los omitía; el SOP los exige).
- Solo transiciones de la tabla son legales (`StateError` si no).
- Resolver exige evidencia fotográfica (`ArgumentError` si falta).
- Escalar exige actor de sistema.
- Timeout de 5 días: `applyTimeout` es puro (reloj inyectado) e idempotente,
  pensado para invocarse desde un scheduler.
- Código de seguimiento `RCL-XXXXXX` legible, sin caracteres ambiguos.
- Causas en catálogos cerrados por dirección (Cláusulas 13ª/14ª).

## Contrato para HAB-40 (UI)

Los enums serializan con nombres del SOP (`creado`, `enRevision`,
`aceptado`, `disputado`, `mediacion`, `escalado`, `resuelto`,
`calificacionNegativa`) y direcciones (`inquilinoAPropietario`,
`propietarioAInquilino`). Round-trip probado en
`test/claim_machine_test.dart`.

## Comandos

```bash
cd packages/claims
dart pub get
dart run build_runner build --delete-conflicting-outputs
dart test
dart analyze --fatal-infos
```
