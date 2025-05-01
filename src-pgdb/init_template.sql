-- init_template.sql

-- Create roles with specific permissions
CREATE ROLE readonly;
GRANT CONNECT ON DATABASE ${POSTGRES_DB} TO readonly;
GRANT USAGE ON SCHEMA public TO readonly;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO readonly;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO readonly;

CREATE ROLE readwrite;
GRANT CONNECT ON DATABASE ${POSTGRES_DB} TO readwrite;
GRANT USAGE ON SCHEMA public TO readwrite;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO readwrite;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO readwrite;


-- Create users and assign roles
-- ## Create Application user
CREATE USER ${PGDB_USER1} WITH PASSWORD '${PGDB_USER1_PASSWORD}' SUPERUSER CREATEDB CREATEROLE LOGIN;
GRANT readwrite TO ${PGDB_USER1};
ALTER ROLE ${PGDB_USER1} SET client_encoding TO 'utf8';
ALTER ROLE ${PGDB_USER1} SET default_transaction_isolation TO 'read committed';
ALTER ROLE ${PGDB_USER1} SET timezone TO 'UTC';

-- ## Create reader user
CREATE USER ${PGDB_USER2} WITH PASSWORD '${PGDB_USER2_PASSWORD}';
GRANT readonly TO ${PGDB_USER2};
ALTER ROLE ${PGDB_USER2} SET client_encoding TO 'utf8';
ALTER ROLE ${PGDB_USER2} SET default_transaction_isolation TO 'read committed';
ALTER ROLE ${PGDB_USER2} SET timezone TO 'UTC';