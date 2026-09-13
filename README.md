# SQL Fraud Detection Analytics

An end-to-end PostgreSQL project for financial transaction analytics, time-series analysis, anomaly detection, fraud detection, and database engineering.

## Business problem

Financial institutions process large volumes of transactions and need reliable ways to understand customer behaviour, monitor activity over time, identify suspicious patterns, and prioritise transactions for investigation.

This project develops a transaction-monitoring system progressively, beginning with raw-data ingestion and validation before advancing to behavioural baselines, fraud-risk rules, query optimisation, streaming data, and Power BI reporting.

## Objectives

- Build a clean and well-documented PostgreSQL analytics database.
- Establish reproducible ingestion, transformation, and validation processes.
- Analyse customer, account, merchant, and transaction behaviour.
- Detect suspicious transactions using explainable SQL rules.
- Evaluate query performance and apply database optimisation techniques.
- Extend the batch system towards near-real-time transaction monitoring.
- Present operational and fraud insights through Power BI.
- Maintain professional technical documentation and a traceable Git history.

## Technology

- PostgreSQL
- SQL
- Git and GitHub
- Docker
- Python
- Power BI
- Kafka-compatible event streaming

## Project milestones

| Milestone | Focus | Status |
|---|---|---|
| 1 | Environment, raw data, and SQL foundations | In progress |
| 2 | Data cleaning and quality assurance | Not started |
| 3 | Relational data modelling | Not started |
| 4 | Intermediate analytical SQL | Not started |
| 5 | Time-series analytics | Not started |
| 6 | Fraud and anomaly detection | Not started |
| 7 | Performance optimisation | Not started |
| 8 | Real-time data extension | Not started |
| 9 | Power BI dashboard | Not started |
| 10 | Documentation and project presentation | Not started |

## Repository structure

```text
data/                         Data documentation and approved samples
docs/                         Roadmap, progress, design, and methodology
sql/01_database_setup/        Milestone 1 SQL work
sql/02_data_ingestion/        Raw-data loading
sql/03_data_cleaning/         Cleaning and quality controls
sql/04_exploratory_analysis/  Foundational business analysis
sql/05_relational_modelling/  Normalised relational model
sql/06_intermediate_analysis/ CTEs, subqueries, and window functions
sql/07_time_series/           Time-based transaction analysis
sql/08_fraud_detection/       Anomaly rules and risk scoring
sql/09_performance/           Indexing and query optimisation
sql/10_streaming/             Streaming SQL extension
python/                       Transaction-stream simulation
dashboards/powerbi/           Power BI deliverables
tests/                        Data and SQL validation
```

Folders will be added progressively as the implementation advances, keeping the repository history aligned with the system's development.

## Development approach

Each milestone defines:

1. The business requirement and expected outcome.
2. The technical scope.
3. Implementation tasks and deliverables.
4. Validation and acceptance criteria.
5. Documentation requirements.
6. An optional advanced extension where appropriate.

## Current work

See the [environment setup guide](docs/ENVIRONMENT_SETUP.md), [Milestone 1 specification](sql/01_database_setup/README.md), and [progress tracker](docs/PROGRESS_TRACKER.md).
