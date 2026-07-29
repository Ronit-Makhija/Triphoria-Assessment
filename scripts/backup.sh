#!/usr/bin/env bash

set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BACKUP_DIR="${BACKUP_DIR:-"$ROOT_DIR/backups"}"
TIMESTAMP="$(date -u +%Y%m%d_%H%M%S)"
BACKUP_FILE="$BACKUP_DIR/triphoria_$TIMESTAMP.dump"
TEMP_FILE="$BACKUP_FILE.tmp"

cd "$ROOT_DIR"

if ! command -v docker >/dev/null 2>&1; then
    echo "Error: Docker is required but was not found." >&2
    exit 1
fi

mkdir -p "$BACKUP_DIR"
docker compose up -d --wait postgres

cleanup() {
    rm -f "$TEMP_FILE"
}
trap cleanup EXIT

docker compose exec -T postgres sh -c \
    'exec pg_dump \
        --username="$POSTGRES_USER" \
        --dbname="$POSTGRES_DB" \
        --format=custom \
        --no-owner \
        --no-privileges' >"$TEMP_FILE"

mv "$TEMP_FILE" "$BACKUP_FILE"
trap - EXIT

echo "Backup created: $BACKUP_FILE"
