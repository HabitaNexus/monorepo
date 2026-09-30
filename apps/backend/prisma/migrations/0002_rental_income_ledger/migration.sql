-- HAB-46: libro de renta de capital inmobiliario.
-- No altera negotiations ni transition_audits.
-- No guarda access tokens ni un payload de TRIBU-CR.

CREATE TABLE signed_rental_contracts (
  contract_id TEXT PRIMARY KEY,
  owner_id TEXT NOT NULL,
  signed_at TIMESTAMPTZ(6) NOT NULL
);

CREATE TABLE rental_income_payments (
  event_id TEXT PRIMARY KEY,
  contract_id TEXT NOT NULL,
  owner_id TEXT NOT NULL,
  gross_crc BIGINT NOT NULL CHECK (gross_crc >= 0),
  paid_at TIMESTAMPTZ(6) NOT NULL,
  period TEXT NOT NULL,
  included BOOLEAN NOT NULL
);

CREATE INDEX rental_income_payments_owner_id_period_idx
  ON rental_income_payments (owner_id, period);

CREATE TABLE rental_income_declarations (
  owner_id TEXT NOT NULL,
  period TEXT NOT NULL,
  gross_crc BIGINT NOT NULL CHECK (gross_crc >= 0),
  taxable_base_crc BIGINT NOT NULL CHECK (taxable_base_crc >= 0),
  income_tax_crc BIGINT NOT NULL CHECK (income_tax_crc >= 0),
  iva_crc BIGINT NOT NULL CHECK (iva_crc >= 0),
  status TEXT NOT NULL CHECK (status IN ('draft', 'pending_submission', 'submitted')),
  late BOOLEAN NOT NULL DEFAULT FALSE,
  notified BOOLEAN NOT NULL DEFAULT FALSE,
  PRIMARY KEY (owner_id, period)
);
