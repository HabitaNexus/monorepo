# Tasks

## 1. Scaffold `apps/backend/`

- [x] Inicializar Nest (SWC) + TypeScript 7 (`typescript@7`, build SWC, `tsc --noEmit` en CI sin flags de heap).
- [x] Criterio: `tsc --noEmit` en verde (valida compat Nest+tsgo) y `nest build` genera `dist/`.
- [x] Prisma init + primera migración (`extensions pg_cron/pg_net`, tablas `negotiations`, `rounds`, `transition_audits`). Nota: `rounds` quedó como columna `round` + `deadline` en `negotiations` con historial por ronda en `transition_audits` (sin tabla propia; decisión en reporte final).

## 2. Dominio `negotiation/` puro

- [x] `states.ts`: union discriminada de 6 estados + tipos de eventos (user actions + `RoundExpired`, `MaxRoundsReached`).
- [x] `machine.ts`: función pura `transition(state, event)`; inválidas → error estructurado `InvalidNegotiationTransition` (código, from, event).
- [x] `clock.ts`: port de tiempo inyectable (producción = reloj real, tests = reloj fijo).
- [x] Criterio: cero imports de `@nestjs/*`, `prisma`, `express`/`fastify` en `domain/` (verificar con grep).

## 3. Application + infrastructure

- [x] Casos de uso: `propose`, `counterPropose`, `accept`, `reject`, `confirmSummary`, `expireRound` — todos contra `NegotiationRepository` (port).
- [x] Adapter Prisma de `NegotiationRepository` + `NegotiationModule` (controller delgado, ValidationPipe, DTOs en `infrastructure/http`, sin decoradores en dominio).
- [x] Expiración: job pg-cron como trigger → caso de uso `expireRound` ejecuta la transición y escribe audit.
- [x] Idempotencia: UUID de intento por ronda, deduplicado en adapter.
- [x] Criterio: `npm test` en verde; expiración cubierta con clock fijo.

## 4. Verificación y cierre

- [x] `openspec validate --strict` del change en verde.
- [ ] Confirmar con @lapc506 (Slack): cierre a 5 rondas como `EXPIRADA`.
- [ ] Siguiente: `/opsx-apply hab26-negociacion-maquina-estados` + `/opsx-sync`/`archive` al terminar.
