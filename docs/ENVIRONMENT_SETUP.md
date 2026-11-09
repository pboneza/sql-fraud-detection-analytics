## Environment Setup

To ensure reproducibility, this project runs PostgreSQL locally with Docker Compose. A named Docker volume preserves the database between runs.

**Prerequisites for Windows** include Git, PowerShell, and Docker Desktop configured to use WSL 2. It is optional to use DBeaver or pgAdmin.

### Start PostgreSQL

Open Docker Desktop on your local computer, and in PowerShell run:

```powershell
git clone https://github.com/pboneza/sql-fraud-detection-analytics.git
Set-Location sql-fraud-detection-analytics
Copy-Item .env.example .env
```

Set a local value for `POSTGRES_PASSWORD` in `.env`. Keep `.env` out of Git.

```powershell
docker compose up -d
docker compose ps
```

Once the PostgreSQL service is healthy, verify the connection:

```powershell
docker compose exec postgres psql -U fraud_admin -d fraud_analytics -c "SELECT current_database(), current_user;"
```

If you changed `POSTGRES_USER` or `POSTGRES_DB` in `.env`, use those values in the verification command.

### Connect a SQL client

| Setting | Value |
|---|---|
| Host | `localhost` |
| Port | `POSTGRES_PORT` from `.env` |
| Database | `POSTGRES_DB` from `.env` |
| Username | `POSTGRES_USER` from `.env` |
| Password | `POSTGRES_PASSWORD` from `.env` |

### Stop PostgreSQL

Run `docker compose down` to stop and remove the container while preserving the database volume. Run `docker compose up -d` to start it again. Adding `-v` to `docker compose down` deletes the volume and its data.
