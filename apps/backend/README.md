# @habitanexus/backend

Backend HabitaNexus (Nest + Prisma + PostgreSQL + TypeScript 7).
Primer módulo de dominio: **HAB-26 motor de estados de negociación**.

## Requisitos

- Node >= 22 (`~/tools/node/bin`), npm global en `~/.npm-global/bin`
- Postgres dev: `podman play kube apps/backend/docs/postgres-dev.yaml`

## Comandos

```bash
cd apps/backend
npm install
cp .env.example .env        # ajustar DATABASE_URL / CRON_SECRET
npm run prisma:generate
npm run prisma:validate
npx prisma migrate dev      # requiere DB (pendiente: sin Podman en esta rama)
npm run typecheck           # tsc --noEmit (TypeScript 7)
npm test
npm run build               # nest build (SWC) → dist/
npm start
```

## Estructura

```
src/
  main.ts / app.module.ts
  prisma/prisma.service.ts
  negotiation/
    domain/           # puro: states, events, machine, clock, terms, errors
    application/      # casos de uso + port NegotiationRepository
    infrastructure/
      http/           # controller delgado + DTOs (ValidationPipe)
      persistence/    # adapter Prisma + doble en memoria (tests)
prisma/
  schema.prisma       # negotiations, transition_audits
  migrations/0001_negotiation_engine/
docs/
  EXPIRY.md           # trigger pg-cron → POST /negotiations/expire-rounds
  postgres-dev.yaml   # manifiesto Podman (supabase/postgres)
```

## Reglas

- `domain/`: cero imports de `@nestjs/*`, prisma o HTTP (verificar con grep).
- IDs e idempotencia: UUID v7 vía WebCrypto (`crypto.randomUUID`).
- Sin `baseUrl`/paths en tsconfig: imports relativos.
