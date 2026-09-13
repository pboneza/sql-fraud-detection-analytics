# Environment Verification

## Purpose

This document records the verified local environment for the SQL Fraud Detection Analytics project. It confirms that the required services and tools are available before transaction data is ingested into PostgreSQL.

## Environment summary

| Component | Verified configuration |
|---|---|
| Operating system | Windows, AMD64 architecture |
| Windows Subsystem for Linux | WSL 2.7.14.0 |
| Docker Desktop | 4.90.0 |
| Docker Engine | 29.7.2 |
| Docker Compose | 5.5.1 |
| DBeaver Community | 26.2.0.202608301738 |
| PostgreSQL | 17.11, 64-bit |

## Architecture

PostgreSQL runs inside a Docker container rather than as a separate Windows installation. This approach provides a consistent PostgreSQL version, isolates database dependencies from the host operating system, and makes the environment easier to reproduce on another computer.

The database files are stored in a named Docker volume, allowing the data to persist when the container is stopped or recreated without removing the volume.

## Connection configuration

| Setting | Value |
|---|---|
| Host | `localhost` |
| Port | `5432` |
| Database | `fraud_analytics` |
| Username | `fraud_admin` |
| Docker Compose service | `postgres` |

The database password is stored only in the local `.env` file and is not documented in the repository.

## Verification results

The PostgreSQL container was started through Docker Compose and reported a healthy status. The connection was tested successfully from both the containerised `psql` client and DBeaver.

The following query was used to verify the active database, database role, and PostgreSQL version:

```sql
SELECT
    current_database(),
    current_user,
    version();
```

The query returned:

- database: `fraud_analytics`;
- user: `fraud_admin`; and
- PostgreSQL version: 17.11, 64-bit.

## Operational commands

Start the PostgreSQL service:

```powershell
docker compose up -d
```

Check the service status:

```powershell
docker compose ps
```

Open an interactive PostgreSQL session:

```powershell
docker compose exec postgres psql -U fraud_admin -d fraud_analytics
```

Stop the service while preserving the container:

```powershell
docker compose stop
```

Restart the stopped service:

```powershell
docker compose start
```

Remove the container while preserving the database volume:

```powershell
docker compose down
```

## Security controls

Database configuration values are read from the local `.env` file. The repository's `.gitignore` excludes this file from version control, while `.env.example` documents the required variable names without exposing the active password.

Passwords and other credentials must not be included in SQL scripts, screenshots, documentation, commits, or issue discussions.

## Status

The local PostgreSQL environment is operational and ready for raw transaction-data ingestion.
