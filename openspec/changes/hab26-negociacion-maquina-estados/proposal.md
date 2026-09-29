# Proposal

## Why

La Fase 4 del flujo de arrendamiento (negociación estructurada) no puede operar sobre el proceso informal actual: sin una máquina de estados con autoridad en el servidor, las reglas legales y operativas (timeout 72h, máximo 5 rondas, auditabilidad) quedarían a merced del cliente. Este change implementa ese motor (HAB-26) como primer módulo de dominio del backend greenfield.

## What Changes

- Nuevo `apps/backend/` (Nest + Prisma + TypeScript 7): scaffold con arquitectura hexagonal.
- Entidad `Negotiation` con estados `PROPUESTA_ENVIADA`, `CONTRAPROPUESTA`, `ACUERDO_ALCANZADO`, `PENDIENTE_FIRMA`, `RECHAZADA`, `EXPIRADA` como discriminated union; solo transiciones válidas del SOP, error estructurado en inválidas.
- Timeout 72h por ronda vía pg-cron como trigger + transición ejecutada por el dominio (clock inyectable para tests).
- Cierre forzado a 5 rondas como `EXPIRADA` (a confirmar con @lapc506 al cerrar).
- Confirmación bilateral del resumen de términos antes de `PENDIENTE_FIRMA`.
- Audit trail append-only (quién, cuándo, de→a, ronda).
- Tests unitarios de dominio sin servidor ni DB.

## Capabilities

### New Capabilities

- `negotiation-engine`: motor de estados de negociación previa a la firma — estados, transiciones, timeout por ronda, límite de rondas y audit trail.

### Modified Capabilities

- `rental-flow`: la entidad `Negotiation` pasa de máquina resumida (`PROPUESTA -> CONTRAPROPUESTA -> ACUERDO -> PENDIENTE_FIRMA`) a 6 estados con `RECHAZADA`/`EXPIRADA`, timeout 72h, máximo 5 rondas y auditabilidad.

## Impact

- Nuevo directorio `apps/backend/` (Nest 11, Prisma 7, TS 7 con build SWC + `tsc --noEmit`).
- Nueva DB Postgres (dev local vía Podman; migraciones Prisma).
- Frontera con Fase 5: `PENDIENTE_FIRMA` alimenta HAB-31/HAB-32. Sin cambios en mobile en este change.
