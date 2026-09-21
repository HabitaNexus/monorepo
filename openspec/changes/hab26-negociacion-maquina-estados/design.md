# Design

## Context

Backend greenfield: no existe `apps/backend/`. Primer módulo de dominio (HAB-26). Stack decidido en explore: Nest + Prisma + PostgreSQL + TypeScript 7 (build SWC, `tsc --noEmit`), pg-cron como trigger de expiración, Postgres dev en Podman (`podman play kube`). Ver proposal.md (Why) y specs (negotiation-engine, rental-flow) para motivación y comportamiento.

## Goals / Non-Goals

**Goals:**

- Dominio puro hexagonal testeable sin servidor ni DB.
- Expiración 72h que opera sin intervención del usuario.
- Migraciones Prisma con guardarraíles desde el día 1 (datos legales/financieros aguas abajo).

**Non-Goals:**

- UI Flutter (HAB-27, change separado).
- Calculadora de costos (HAB-28), aviso legal (HAB-29), validación de rangos (HAB-30): solo slots de integración.
- Auth/autorización (se asume actor identificado en el contexto del caso de uso; diseño de auth, fuera).

## Decisions

- **Nest (build SWC, types con tsgo):** andamiaje (módulos, DI, ValidationPipe, Schedule) para un equipo de un agente; SWC evita que el emit dependa del compilador nativo. Alternativa descartada: Fastify (menos peso, pero más código propio).
- **Prisma + PostgreSQL:** guardarraíles de migración (shadow DB, drift detection, `migrate dev/deploy`) para datos contractuales; Client aislado en `infrastructure/`. Alternativa descartada: Drizzle (más control SQL, menos red de seguridad).
- **TypeScript 7 desde el día 1:** sin costo de migración; aliases relativos (sin `baseUrl`); WebCrypto en vez de `node:crypto`+Buffer (roce tsgo con TypedArrays); sin dependencias de la compiler API (llega en 7.1).
- **pg-cron como trigger tonto:** cron inserta/dispara → Nest ejecuta la transición con la máquina de dominio → mismo audit que las acciones de usuario. La transición nunca vive en SQL. Alternativa descartada: función SQL dueña del cambio de estado (bifurca autoridad y audit).
- **Términos como JSON validado contra catálogo:** los 34 términos viajan como documento versionado, no 34 columnas; el catálogo legal puede crecer sin migrar. Los slots HAB-28/29/30 leen el mismo documento.
- **Cierre a 5 rondas como `EXPIRADA`:** cambio mínimo consistente con el SOP; a confirmar con @lapc506 al cerrar (Slack). Alternativa: `CERRADA_SIN_ACUERDO` (mejor auditoría, más scope).
- **Clock inyectable + idempotencia por UUID de intento:** expiraciones deterministas en tests; reintentos desde mobile no duplican rondas.

## Risks / Trade-offs

- [Nest + tsgo sin verificar] → Mitigación: primer `tsc --noEmit` + build SWC como criterio de aceptación del scaffold; plugin Swagger (compiler API) pineado a classic si lo exige.
- [pg-cron condiciona el proveedor Postgres] → Mitigación: Supabase/RDS lo soportan; si prod fuese Neon, rediseñar trigger (ver explore).
- [Sin auth, el "actor" del audit es provisional] → Mitigación: actor como string opaco en el dominio; wiring de auth posterior sin tocar la máquina.
- [Mono-module inicial] → Mitigación: estructura `negotiation/` (domain/application/infrastructure) lista para extraer a servicio.

## Migration Plan

1. Scaffold `apps/backend/` (Nest CLI, Prisma init, primera migración: extensiones + tablas `negotiations`, `rounds`, `transition_audits`).
2. `migrate deploy` en cada entorno; rollback = `migrate resolve` + down-script versionado (tablas nuevas, sin datos que preservar en esta fase).

## Open Questions

- Ninguna que cambie specs o tasks. Confirmación pendiente con @lapc506 (cierre a 5 rondas) anotada como notificación de cierre, no como bloqueo.
