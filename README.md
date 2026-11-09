# SQL Fraud Detection Analytics

An end-to-end PostgreSQL project for financial transaction analytics, time-series analysis, anomaly detection, fraud detection, and database engineering.

## Project Overview

Financial institutions process large volumes of transactions and need reliable ways to understand customer behaviour, monitor activity over time, identify suspicious patterns, and prioritise transactions for investigation.

This project uses PostgreSQL to build a transaction-monitoring workflow, starting with raw-data ingestion and validation and then extending to behavioural baselines, fraud-risk rules, query optimisation, streaming data, and Power BI reporting.

## Dataset

The project uses [PaySim, a synthetic transaction dataset available on Kaggle](https://www.kaggle.com/datasets/ealaxi/paysim1). The dataset includes fraud labels that can be used to evaluate how well monitoring rules flag simulated fraudulent transactions.

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


## Repository structure

```text
data/                         Data documentation and approved samples
docs/                         Environment setup and verification
sql/01_database_setup/        Initial SQL work
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

