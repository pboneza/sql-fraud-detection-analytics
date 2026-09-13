# Progress Tracker

Last updated: 2026-09-13

## Current position

- Current milestone: **1 — Environment, raw data, and SQL foundations**
- Current phase: **Containerised PostgreSQL setup**
- Overall status: **In progress**

## Milestone status

| Milestone | Status | Evidence |
|---|---|---|
| 1. Environment, raw data, and SQL foundations | In progress | Windows container runtime verified |
| 2. Data cleaning and quality assurance | Not started | — |
| 3. Relational data modelling | Not started | — |
| 4. Intermediate analytical SQL | Not started | — |
| 5. Time-series analytics | Not started | — |
| 6. Fraud and anomaly detection | Not started | — |
| 7. Performance optimisation | Not started | — |
| 8. Real-time data extension | Not started | — |
| 9. Power BI dashboard | Not started | — |
| 10. Documentation and project presentation | Not started | — |

## Completed

- Created the public GitHub repository.
- Defined the system objectives and milestone roadmap.
- Established the initial repository structure.
- Added data-management and version-control guidance.
- Defined the Milestone 1 scope and acceptance criteria.
- Verified the Windows AMD64 development environment.
- Verified Docker Desktop 4.90.0 and Docker Engine 29.7.2.
- Verified Docker Compose 5.5.1.
- Verified WSL 2.7.14.0.

## Immediate next actions

- Clone the GitHub repository locally.
- Create the first milestone branch.
- Create the local `.env` file from `.env.example`.
- Start PostgreSQL through the project container configuration.
- Verify PostgreSQL access and record the version.
- Select a database client.
- Select and document the raw transaction dataset.
- Perform the first raw-data inspection without modifying the source.

## Evidence to capture during Milestone 1

- PostgreSQL version command and result.
- Successful database connection.
- Dataset source and licence or usage conditions.
- Raw file names, sizes, record counts, and columns.
- Initial data-quality observations.
- SQL scripts and validation results.
- Milestone findings and implementation decisions.

## Decisions

| Date | Decision | Reason |
|---|---|---|
| 2026-09-13 | PostgreSQL is the primary database | Supports standards-based SQL and advanced analytical and engineering features |
| 2026-09-13 | Work is delivered through defined implementation milestones | Provides traceable scope, validation, and project progression |
| 2026-09-13 | Raw data will not be modified directly | Preserves traceability and reproducibility |
| 2026-09-13 | PostgreSQL will run in Docker | Creates a portable and reproducible development environment |
