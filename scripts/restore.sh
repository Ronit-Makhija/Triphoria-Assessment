#!/usr/bin/env bash

set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BACKUP_DIR="${BACKUP_DIR:-"$ROOT_DIR/backups"}"
BACKUP_FILE="${1:-}"

cd "$ROOT_DIR"

if ! command -v docker >/dev/null 2>&1; then
    echo "Error: Docker is required but was not found." >&2
    exit 1
fi

if [[ -z "$BACKUP_FILE" ]]; then
    shopt -s nullglob
    BACKUP_FILES=("$BACKUP_DIR"/*.dump)
    shopt -u nullglob

    if (( ${#BACKUP_FILES[@]} == 0 )); then
        echo "Error: No backup files found in $BACKUP_DIR." >&2
        exit 1
    fi

    BACKUP_FILE="${BACKUP_FILES[0]}"
    for candidate in "${BACKUP_FILES[@]}"; do
        if [[ "$candidate" > "$BACKUP_FILE" ]]; then
            BACKUP_FILE="$candidate"
        fi
    done
fi

if [[ ! -f "$BACKUP_FILE" ]]; then
    echo "Error: Backup file not found: $BACKUP_FILE" >&2
    exit 1
fi

docker compose up -d --wait postgres

DB_USER="$(docker compose exec -T postgres sh -c \
    'printf "%s" "$POSTGRES_USER"' | tr -d '\r')"
SOURCE_DB="$(docker compose exec -T postgres sh -c \
    'printf "%s" "$POSTGRES_DB"' | tr -d '\r')"
RESTORE_DB="${RESTORE_DB:-"${SOURCE_DB}_restored"}"

if [[ ! "$RESTORE_DB" =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]]; then
    echo "Error: Invalid restore database name: $RESTORE_DB" >&2
    exit 1
fi

docker compose exec -T postgres psql \
    --username="$DB_USER" \
    --dbname=postgres \
    --set=ON_ERROR_STOP=1 \
    --command="SELECT pg_terminate_backend(pid)
               FROM pg_stat_activity
               WHERE datname = '$RESTORE_DB'
                 AND pid <> pg_backend_pid();" \
    --command="DROP DATABASE IF EXISTS \"$RESTORE_DB\";" \
    --command="CREATE DATABASE \"$RESTORE_DB\";"

docker compose exec -T postgres pg_restore \
    --username="$DB_USER" \
    --dbname="$RESTORE_DB" \
    --no-owner \
    --no-privileges \
    --exit-on-error <"$BACKUP_FILE"

echo "Backup restored from: $BACKUP_FILE"
echo "Restored database: $RESTORE_DB"
