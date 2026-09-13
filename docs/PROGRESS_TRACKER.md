# Progress Tracker

Last updated: 2026-09-13

## Current position

- Current milestone: **1 — Environment, raw data, and SQL foundations**
- Current phase: **Raw-data selection and inspection**
- Overall status: **In progress**

## Milestone status

| Milestone | Status | Evidence |
|---|---|---|
| 1. Environment, raw data, and SQL foundations | In progress | PostgreSQL environment verified; raw-data work pending |
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
- Verified Docker Compose 5.5.1 and WSL 2.7.14.0.
- Started and verified PostgreSQL 17.11 in Docker.
- Verified database access through `psql` and DBeaver Community.
- Merged the environment-verification record through Pull Request #2.
- Completed and closed the environment-setup issue.

## Immediate next actions

- Evaluate suitable financial transaction datasets.
- Select a dataset with appropriate usage and redistribution conditions.
- Document the source, purpose, structure, and limitations.
- Download the original files without modifying them.
- Record file names, sizes, row counts, columns, and apparent data types.
- Define the initial data-quality checks.
- Design the raw PostgreSQL staging table.

## Evidence to capture during Milestone 1

- Dataset source and licence or usage conditions.
- Raw file names, sizes, record counts, and columns.
- Initial data-quality observations.
- PostgreSQL ingestion and validation results.
- SQL scripts and baseline analytical results.
- Milestone findings and implementation decisions.

## Decisions

| Date | Decision | Reason |
|---|---|---|
| 2026-09-13 | PostgreSQL is the primary database | Supports standards-based SQL and advanced analytical and engineering features |
| 2026-09-13 | Work is delivered through defined implementation milestones | Provides traceable scope, validation, and project progression |
| 2026-09-13 | Raw data will not be modified directly | Preserves traceability and reproducibility |
| 2026-09-13 | PostgreSQL runs in Docker | Creates a portable and reproducible development environment |
