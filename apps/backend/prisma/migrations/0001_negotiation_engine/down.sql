-- Rollback de 0001_negotiation_engine (tablas nuevas, sin datos que preservar).
-- Uso: psql -f down.sql + `prisma migrate resolve --rolled-back 0001_negotiation_engine`.

SELECT cron.unschedule('hab26-negotiation-expiry-sweep');

DROP TABLE IF EXISTS transition_audits;
DROP TABLE IF EXISTS negotiations;
