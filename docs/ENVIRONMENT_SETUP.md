# Environment Setup

## Architecture

PostgreSQL runs inside Docker rather than as a separate local installation. The database data is stored in a named Docker volume and persists when the container is stopped.

## Prerequisites

- Git
- Docker Desktop
- A terminal
- Optional graphical database client: DBeaver, pgAdmin, or another PostgreSQL-compatible client

On Apple Silicon, install the Apple-chip version of Docker Desktop.

## 1. Clone the repository

```bash
git clone https://github.com/pboneza/sql-fraud-detection-analytics.git
cd sql-fraud-detection-analytics
git switch -c milestone-1-foundations
```

## 2. Create the local environment file

```bash
cp .env.example .env
```

Open `.env` and replace the example password with a local password. The real `.env` file is excluded from Git and must not be committed.

## 3. Start PostgreSQL

Confirm that Docker Desktop is open and its engine is running. Then execute:

```bash
docker compose up -d
```

Check the service:

```bash
docker compose ps
```

The PostgreSQL service should eventually report a healthy status.

## 4. Verify the database

```bash
docker compose exec postgres \
  psql -U fraud_admin -d fraud_analytics \
  -c "SELECT version();"
```

If `POSTGRES_USER` or `POSTGRES_DB` was changed in `.env`, use the new values in this command.

## 5. Open an interactive SQL session

```bash
docker compose exec postgres \
  psql -U fraud_admin -d fraud_analytics
```

Inside `psql`, run:

```sql
SELECT current_database(), current_user;
SELECT version();
```

Exit with:

```text
\q
```

## Database-client connection

Use these values in a PostgreSQL-compatible client:

| Setting | Value |
|---|---|
| Host | `localhost` |
| Port | Value of `POSTGRES_PORT` |
| Database | Value of `POSTGRES_DB` |
| Username | Value of `POSTGRES_USER` |
| Password | Value of `POSTGRES_PASSWORD` |

## Stop and restart the service

Stop the containers while preserving the database:

```bash
docker compose stop
```

Start them again:

```bash
docker compose start
```

Alternatively, remove the containers while preserving the named volume:

```bash
docker compose down
```

`docker compose down -v` deletes the database volume and its stored data. Do not use it unless permanent local data deletion is intended.

## Environment verification record

Record the following after setup:

- operating system and architecture;
- Docker Desktop version;
- Docker Engine version from `docker version`;
- Docker Compose version from `docker compose version`;
- PostgreSQL version returned by `SELECT version();`;
- database client and version, if applicable; and
- any setup problem and its resolution.
