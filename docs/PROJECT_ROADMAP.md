# Project Roadmap

## Project outcome

The final system will use PostgreSQL to ingest and clean financial transaction data, model the business domain, calculate behavioural and time-series measures, identify anomalous activity, generate explainable fraud alerts, and supply analytical outputs to Power BI. An advanced extension will simulate transaction events for near-real-time monitoring.

## Milestone sequence

### 1. Environment, raw data, and SQL foundations

Set up a reproducible development environment, understand the raw dataset, create a raw-data layer, load records safely, profile the data, and establish baseline transaction measures.

### 2. Data cleaning and quality assurance

Identify and handle missing values, duplicates, inconsistent categories, invalid dates, incorrect amounts, referential problems, and other data-quality defects. Preserve raw data and create reproducible cleaning logic.

### 3. Relational data modelling

Transform the initial flat data into a documented relational design for customers, accounts, merchants, transactions, and fraud-related entities. Apply keys, constraints, and relationships.

### 4. Intermediate analytical SQL

Use joins, subqueries, common table expressions, conditional aggregation, and window functions to analyse behaviour across customers, accounts, merchants, and transaction types.

### 5. Time-series analytics

Measure hourly, daily, weekly, and monthly activity; calculate period-over-period change, rolling measures, volatility, peaks, and changes in behavioural patterns.

### 6. Fraud and anomaly detection

Create explainable fraud indicators for unusual amounts, transaction velocity, unfamiliar locations, new merchants, repeated threshold-adjacent amounts, and other suspicious behaviour. Combine indicators into a documented risk score.

### 7. Performance optimisation

Assess queries with `EXPLAIN (ANALYZE, BUFFERS)`, design appropriate indexes, compare performance, introduce views or materialized views, and evaluate partitioning where justified.

### 8. Real-time data extension

Replay historical transactions using Python and an event-streaming platform. Apply streaming SQL or incremental processing to produce near-real-time fraud alerts.

### 9. Power BI dashboard

Connect Power BI to curated PostgreSQL outputs and build executive, transaction-monitoring, and fraud-investigation report pages.

### 10. Documentation and project presentation

Complete the README, architecture and ER diagrams, data dictionary, fraud methodology, performance evidence, dashboard screenshots, findings, limitations, and technical presentation.

## Engineering principles

- Keep the raw data unchanged.
- Store secrets outside version control.
- Make all transformations reproducible.
- Use descriptive names and consistent SQL formatting.
- State assumptions and business rules explicitly.
- Validate important transformations.
- Explain performance decisions with evidence.
- Commit work in small, meaningful stages.
