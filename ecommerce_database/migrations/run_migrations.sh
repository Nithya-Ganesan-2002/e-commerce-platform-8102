#!/usr/bin/env bash
set -euo pipefail

# PUBLIC_INTERFACE
# This script applies database schema and seed data to the MySQL database.
# It uses environment variables if provided, otherwise falls back to startup.sh defaults.
# Required env vars (if overriding defaults):
#   MYSQL_USER, MYSQL_PASSWORD, MYSQL_DB, MYSQL_PORT, MYSQL_HOST
# Usage:
#   ./migrations/run_migrations.sh
#   MYSQL_DB=myapp MYSQL_USER=appuser MYSQL_PASSWORD=pass MYSQL_PORT=5000 MYSQL_HOST=127.0.0.1 ./migrations/run_migrations.sh

MYSQL_HOST="${MYSQL_HOST:-127.0.0.1}"
MYSQL_PORT="${MYSQL_PORT:-5000}"
MYSQL_USER="${MYSQL_USER:-appuser}"
MYSQL_PASSWORD="${MYSQL_PASSWORD:-dbuser123}"
MYSQL_DB="${MYSQL_DB:-myapp}"

echo "Applying migrations to MySQL:"
echo "  Host      : ${MYSQL_HOST}"
echo "  Port      : ${MYSQL_PORT}"
echo "  Database  : ${MYSQL_DB}"
echo "  User      : ${MYSQL_USER}"

# Ensure database exists (create if missing)
echo "Ensuring database exists..."
mysql -h "${MYSQL_HOST}" -P "${MYSQL_PORT}" -u root -p"${MYSQL_PASSWORD}" -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DB}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

# Apply schema
echo "Running schema.sql ..."
mysql -h "${MYSQL_HOST}" -P "${MYSQL_PORT}" -u "${MYSQL_USER}" -p"${MYSQL_PASSWORD}" "${MYSQL_DB}" < "$(dirname "$0")/../sql/schema.sql"

# Apply seed
echo "Running seed.sql ..."
mysql -h "${MYSQL_HOST}" -P "${MYSQL_PORT}" -u "${MYSQL_USER}" -p"${MYSQL_PASSWORD}" "${MYSQL_DB}" < "$(dirname "$0")/../sql/seed.sql"

echo "Migrations complete."
