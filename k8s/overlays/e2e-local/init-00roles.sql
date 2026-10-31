-- E2E-LOCAL solamente: pre-siembra el rol supabase_admin que el
-- migrate.sh de la imagen supabase/postgres exige pre-existente en su
-- primer psql (-U supabase_admin). Corre antes que migrate.sh por orden
-- alfabético (00* < migrate.sh). Password = POSTGRES_PASSWORD del overlay.
-- Nunca usar fuera de E2E.
CREATE ROLE supabase_admin SUPERUSER LOGIN PASSWORD 'habitanexus';
