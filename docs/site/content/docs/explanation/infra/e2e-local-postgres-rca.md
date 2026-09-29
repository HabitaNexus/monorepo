# RCA: Postgres E2E-LOCAL en minikube (imagen `supabase/postgres`)

Fecha: 2026-09-29 · Overlay: `k8s/overlays/e2e-local` · Gate de PR #44.

La imagen `supabase/postgres:15.8.1.060` se eligió porque la migración
`0001_negotiation_engine` exige `pg_cron` + `pg_net` (`CREATE EXTENSION`).
Levantarla en Kubernetes expuso 4 incompatibilidades encadenadas, cada una
con error distinto. Se documentan para no re-descubrirlas.

## 1. `POSTGRES_USER` custom rompe el init (peer auth)

**Síntoma:** `FATAL: Peer authentication failed for user "habitanexus"`,
`Connection matched pg_hba.conf line 83: local all all peer map=supabase_map`.

**Causa:** el `pg_ident.conf` de la imagen (`supabase_map`) solo mapea los OS
users `postgres/root/ubuntu → postgres`. El entrypoint corre
`psql --username $POSTGRES_USER` como OS user `postgres`; con
`POSTGRES_USER=habitanexus` el mapa no tiene entrada `postgres → habitanexus`.

**Fix:** `POSTGRES_USER=postgres` (DB de app sigue siendo la que pida
`POSTGRES_DB`). Ver comentario en `postgres.yaml`.

## 2. `POSTGRES_PORT=tcp://…` rompe `migrate.sh` → `enableServiceLinks: false`

**Síntoma:** `psql: error: invalid integer value "tcp://10.100.26.119:5432"
for connection option "port"`.

**Causa:** Kubernetes inyecta por defecto variables legacy estilo Docker-links
en cada Pod: por el Service `postgres`, todo Pod recibe
`POSTGRES_PORT=tcp://<cluster-ip>:5432` (más `POSTGRES_SERVICE_HOST`, etc.).
El `migrate.sh` de supabase hace `PGPORT="${POSTGRES_PORT:-5432}"` esperando
un número de puerto, y psql rechaza el valor `tcp://…`.

**Fix (estándar):** `enableServiceLinks: false` en el `podSpec` — campo
estable de Kubernetes que desactiva esa inyección legacy. La app no la usa
(resuelve `postgres` por DNS del Service). Ver comentario en `postgres.yaml`.

## 3. `migrate.sh` exige el rol `supabase_admin` pre-existente

**Síntoma:** `FATAL: password authentication failed for user "supabase_admin"`,
`Role "supabase_admin" does not exist` (pg_hba línea 82, `scram-sha-256`).

**Causa:** el primer `psql` de `migrate.sh` conecta `-U supabase_admin`, rol
que en el flujo AMI de supabase ya existe pero en el flujo Docker/k8s solo
nacería en `init-scripts/`… que corre *después*, dentro del propio
`migrate.sh`. Interbloqueo en cluster fresco.

**Fix (solo E2E):** `init-00roles.sql` (vía ConfigMap `pg-init-roles`)
pre-siembra `supabase_admin SUPERUSER LOGIN`. Corre antes que `migrate.sh`
por orden alfabético del runner (`00* < migrate.sh`). Password = mismo
`POSTGRES_PASSWORD` del overlay. **Nunca fuera de E2E.**

## 4. `pg_cron` solo admite `CREATE EXTENSION` en la DB `postgres`

**Síntoma:** `ERROR: can only create extension in database postgres`
(`cron.database_name`), al migrar contra la DB `habitanexus`.

**Causa:** el worker pg_cron lee los jobs de la DB configurada en
`cron.database_name` (`postgres` en esta imagen). La propia migración lo
anticipa: *"pg_cron corre en la DB `postgres`; ajustar si el backend usa otra"*.

**Fix:** el overlay usa `POSTGRES_DB=postgres` y `DATABASE_URL=…/postgres`.
El job `hab26-negotiation-expiry-sweep` (cada 5 min) dispara a
`current_setting('habitanexus.backend_url', true)` = NULL en E2E: falla en
silencio dentro de la DB, sin afectar el smoke.
