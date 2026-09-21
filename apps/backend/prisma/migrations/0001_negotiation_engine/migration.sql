-- HAB-26: motor de estados de negociación.
-- Extensiones: pg_cron (trigger tonto de expiración) + pg_net (HTTP a Nest).
-- La transición NUNCA vive en SQL: cron dispara, el dominio en Nest ejecuta.

CREATE EXTENSION IF NOT EXISTS pg_cron;
CREATE EXTENSION IF NOT EXISTS pg_net;

CREATE TABLE negotiations (
  id UUID PRIMARY KEY,
  listing_id UUID NOT NULL,
  tenant_id TEXT NOT NULL,
  owner_id TEXT NOT NULL,
  status TEXT NOT NULL CHECK (status IN (
    'PROPUESTA_ENVIADA', 'CONTRAPROPUESTA', 'ACUERDO_ALCANZADO',
    'PENDIENTE_FIRMA', 'RECHAZADA', 'EXPIRADA'
  )),
  round INTEGER NOT NULL CHECK (round >= 1 AND round <= 5),
  deadline TIMESTAMPTZ(6) NOT NULL,
  terms JSONB NOT NULL,
  summary JSONB,
  tenant_confirmed BOOLEAN NOT NULL DEFAULT FALSE,
  owner_confirmed BOOLEAN NOT NULL DEFAULT FALSE,
  close_reason TEXT,
  created_at TIMESTAMPTZ(6) NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ(6) NOT NULL DEFAULT now()
);

CREATE INDEX negotiations_status_deadline_idx ON negotiations (status, deadline);

CREATE TABLE transition_audits (
  id UUID PRIMARY KEY,
  negotiation_id UUID NOT NULL REFERENCES negotiations (id) ON DELETE RESTRICT,
  actor TEXT NOT NULL,
  at TIMESTAMPTZ(6) NOT NULL,
  "from" TEXT NOT NULL,
  "to" TEXT NOT NULL,
  round INTEGER NOT NULL,
  attempt_id UUID NOT NULL UNIQUE
);

CREATE INDEX transition_audits_negotiation_idx ON transition_audits (negotiation_id);

-- Trigger tonto: cada 5 minutos invoca el barrido en Nest, que ejecuta la
-- transición con la máquina de dominio y escribe el audit. La URL y el
-- secreto se inyectan en deploy (ver apps/backend/docs/EXPIRY.md).
-- Nota: pg_cron corre en la DB `postgres`; ajustar si el backend usa otra.
SELECT cron.schedule(
  'hab26-negotiation-expiry-sweep',
  '*/5 * * * *',
  $$
  SELECT net.http_post(
    url := current_setting('habitanexus.backend_url', true) || '/negotiations/expire-rounds',
    headers := jsonb_build_object(
      'Content-Type', 'application/json',
      'X-Cron-Secret', current_setting('habitanexus.cron_secret', true)
    ),
    body := '{}'::jsonb
  );
  $$
);
