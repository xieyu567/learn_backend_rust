#!/usr/bin/env bash
set -x
set -eo pipefail

if ! [ -x "$(command -v sqlx)" ]; then 
echo >&2 "Error: sqlx is not installed."
echo >&2 "Use:"
echo >&2 " cargo install sqlx-cli" 
echo >&2 "to install it."
exit 1 
fi

# Check if a custom user has been set, otherwise default to 'postgres'
DB_USER=${COCKROACH_USER:=xieyu} 
# Check if a custom password has been set, otherwise default to 'password'
DB_PASSWORD="${COCKROACH_PASSWORD:=HWtbMWBBI1YUiJHNLMZCeA}" 
# Check if a custom database name has been set, otherwise default to 'newsletter' 
DB_NAME="${COCKROACH_DB:=defaultdb}" 
# Check if a custom port has been set, otherwise default to '5432' 
DB_PORT="${COCKROACH_PORT:=26257}"
DB_HOST="${COCKROACH_HOST:=free-tier8.aws-ap-southeast-1.cockroachlabs.cloud}"

>&2 echo "CockroachDB is up and running on port ${DB_PORT} - running migrations now!"

export DATABASE_URL=postgresql://${DB_USER}:${DB_PASSWORD}@${DB_HOST}:${DB_PORT}/${DB_NAME}?sslmode=verify-full&options=--cluster%3Dplain-monkey-2765
sqlx database create 
sqlx migrate run

>&2 echo "CockroachDB has been migrated, ready to go!"