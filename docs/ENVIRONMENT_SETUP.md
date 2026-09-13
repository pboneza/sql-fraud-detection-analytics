# Environment Setup

## Architecture

PostgreSQL runs inside Docker rather than as a separate Windows installation. The database data is stored in a named Docker volume and persists when the container is stopped.

## Prerequisites

- Windows 10 or Windows 11
- Git for Windows
- Docker Desktop for Windows
- PowerShell
- Optional graphical database client: DBeaver, pgAdmin, or another PostgreSQL-compatible client

Docker Desktop should use its WSL 2 backend. If the installer asks whether to use WSL 2 instead of Hyper-V, select WSL 2.

## 1. Verify Docker Desktop

Open Docker Desktop and wait until the Docker engine is running. In PowerShell, execute:

```powershell
docker version
docker compose version
```

## 2. Clone the repository

```powershell
git clone https://github.com/pboneza/sql-fraud-detection-analytics.git
Set-Location sql-fraud-detection-analytics
git switch -c milestone-1-foundations
```

## 3. Create the local environment file

```powershell
Copy-Item .env.example .env
```

Open `.env` and replace the example password with a local password. The real `.env` file is excluded from Git and must not be committed.

## 4. Start PostgreSQL

```powershell
docker compose up -d
```

Check the service:

```powershell
docker compose ps
```

The PostgreSQL service should eventually report a healthy status.

## 5. Verify the database

```powershell
docker compose exec postgres psql -U fraud_admin -d fraud_analytics -c "SELECT version();"
```

If `POSTGRES_USER` or `POSTGRES_DB` was changed in `.env`, use the new values in this command.

## 6. Open an interactive SQL session

```powershell
docker compose exec postgres psql -U fraud_admin -d fraud_analytics
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

```powershell
docker compose stop
```

Start them again:

```powershell
docker compose start
```

Alternatively, remove the containers while preserving the named volume:

```powershell
docker compose down
```

`docker compose down -v` deletes the database volume and its stored data. Do not use it unless permanent local data deletion is intended.

## Environment verification record

Record the following after setup:

- Windows edition and version;
- system architecture;
- WSL version from `wsl --version`;
- Docker Desktop version;
- Docker Engine version from `docker version`;
- Docker Compose version from `docker compose version`;
- PostgreSQL version returned by `SELECT version();`;
- database client and version, if applicable; and
- any setup problem and its resolution.
