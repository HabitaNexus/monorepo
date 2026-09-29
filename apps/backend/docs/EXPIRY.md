# Expiración 72h — pg-cron como trigger tonto (HAB-26)

La transición a `EXPIRADA` **nunca vive en SQL**. El flujo es:

1. `pg-cron` (job `hab26-negotiation-expiry-sweep`, cada 5 min) hace
   `POST {BACKEND_PUBLIC_URL}/negotiations/expire-rounds` vía `pg_net`,
   con header `X-Cron-Secret: {CRON_SECRET}`.
2. Nest ejecuta `expireRoundsSweep`: lista rondas abiertas vencidas y aplica
   `ROUND_EXPIRED` con la máquina de dominio + audit `system:pg-cron`.
3. Rondas no vencidas o estados terminales se omiten sin audit (idempotente).

## Deploy

```sql
ALTER SYSTEM SET habitanexus.backend_url = 'https://api.habitanexus.example';
ALTER SYSTEM SET habitanexus.cron_secret = '<CRON_SECRET del entorno>';
SELECT pg_reload_conf();
```

`CRON_SECRET` debe coincidir con la env del backend. Sin `CRON_SECRET`
configurado, el endpoint responde 401 siempre.

## Nota de entorno

Esta migración está **autorizada pero no aplicada**: el entorno de esta
rama no dispone de Podman (`podman play kube` sin runtime) ni de Postgres
dev, por lo que `prisma migrate dev/deploy` queda pendiente del primer
entorno con DB (ver `docs/postgres-dev.yaml`). Validado con
`prisma validate`; el SQL sigue el dialecto Postgres 15+ (pg_cron/pg_net
disponibles en Supabase y RDS).
