# Triphoria DevOps Assessment

This repository contains reusable Terraform for an ALB, ECS Fargate, and
private PostgreSQL RDS architecture, plus a locally runnable PostgreSQL
database for migration, indexing, backup, and restore exercises.

## Local database

### Requirements

- Docker with Docker Compose v2

### Start PostgreSQL

```bash
docker compose up -d --wait
```

On the first startup of a fresh volume, PostgreSQL executes the files under
`database/migrations` in filename order:

1. `001_create_booking_tables.sql` creates the tables and constraints.
2. `002_add_query_indexes.sql` creates the query and event indexes.
3. `003_seed_bookings.sql` inserts deterministic sample data.

The seed contains 120 bookings across five organizations, five cities, and
four statuses. It also creates events for 80 bookings.

To stop the database while preserving its data:

```bash
docker compose stop
```

To remove the local database and rerun every initialization script:

```bash
docker compose down -v
docker compose up -d --wait
```

The `-v` option permanently deletes the local database volume.

### Verify the seed

```bash
docker compose exec postgres psql -U triphoria -d triphoria -c \
  "SELECT COUNT(*) AS bookings,
          COUNT(DISTINCT city) AS cities,
          COUNT(DISTINCT org_id) AS organizations,
          COUNT(DISTINCT status) AS statuses
   FROM hotel_bookings;"

docker compose exec postgres psql -U triphoria -d triphoria -c \
  "SELECT COUNT(*) AS events FROM booking_events;"
```

Expected results are 120 bookings, 5 cities, 5 organizations, 4 statuses,
and 80 events.

## Booking aggregation index

The assessment query filters by exact city and a recent timestamp range:

```sql
SELECT org_id, status, COUNT(*), SUM(amount)
FROM hotel_bookings
WHERE city = 'delhi'
  AND created_at >= NOW() - INTERVAL '30 days'
GROUP BY org_id, status;
```

The following covering B-tree index supports it:

```sql
CREATE INDEX hotel_bookings_city_created_at_covering_idx
    ON hotel_bookings (city, created_at DESC)
    INCLUDE (org_id, status, amount);
```

`city` is first because it uses equality filtering. `created_at` follows
because it uses a range filter. The grouping columns and `amount` are included
so PostgreSQL can potentially satisfy the query from the index without reading
every matching table row.

With only 120 seed rows, PostgreSQL may correctly prefer a sequential scan
because reading the tiny table is cheaper than traversing an index. The index
becomes useful as the table grows and the city/date predicate selects a small
portion of the bookings.

Inspect the execution plan with:

```bash
docker compose exec postgres psql -U triphoria -d triphoria -c \
  "EXPLAIN (ANALYZE, BUFFERS)
   SELECT org_id, status, COUNT(*), SUM(amount)
   FROM hotel_bookings
   WHERE city = 'delhi'
     AND created_at >= NOW() - INTERVAL '30 days'
   GROUP BY org_id, status;"
```

## Backup and restore

The scripts use PostgreSQL tools inside the Docker container, so `pg_dump`,
`pg_restore`, and `psql` do not need to be installed on the host.

Create a timestamped custom-format dump:

```bash
./scripts/backup.sh
```

Backups are written to `backups/triphoria_YYYYMMDD_HHMMSS.dump`. Dump files
are ignored by Git.

Restore the newest dump into a fresh `triphoria_restored` database:

```bash
./scripts/restore.sh
```

Restore a specific dump:

```bash
./scripts/restore.sh backups/triphoria_YYYYMMDD_HHMMSS.dump
```

The restore script recreates only the restore target. It does not modify the
source `triphoria` database. Override the target when needed:

```bash
RESTORE_DB=verification_db ./scripts/restore.sh
```

Verify that the restored database contains the expected data:

```bash
docker compose exec postgres psql -U triphoria -d triphoria_restored -c \
  "SELECT COUNT(*) AS bookings FROM hotel_bookings;"

docker compose exec postgres psql -U triphoria -d triphoria_restored -c \
  "SELECT COUNT(*) AS events FROM booking_events;"
```

The expected counts are 120 bookings and 80 events.

## Terraform

See [`infra/README.md`](infra/README.md) for environment structure, offline
validation, planning, and real AWS usage guidance.
