# Milestone 1 — Environment, Raw Data, and SQL Foundations

## Business requirement

Before transaction monitoring or fraud detection can be implemented, the project requires a reliable analytical environment and a documented understanding of the incoming data. Incorrect assumptions during ingestion can produce inaccurate measures and unreliable fraud indicators.

## Expected outcome

This milestone will deliver:

- a reproducible PostgreSQL environment;
- a documented raw dataset and source;
- a safe raw-ingestion table;
- repeatable data-loading scripts;
- validation of source and database record counts;
- an initial data-quality profile; and
- baseline transaction measures.

## Technical scope

- PostgreSQL databases, schemas, tables, rows, and columns;
- PostgreSQL data types;
- `CREATE DATABASE`, `CREATE SCHEMA`, and `CREATE TABLE`;
- `SELECT`, aliases, `DISTINCT`, `WHERE`, `ORDER BY`, and `LIMIT`;
- comparison and logical operators;
- `NULL`, `IS NULL`, `COALESCE`, and `NULLIF`;
- `CAST` and PostgreSQL type conversion;
- `CASE`;
- `COUNT`, `SUM`, `AVG`, `MIN`, and `MAX`;
- `GROUP BY` and `HAVING`;
- CSV import with `COPY` or `\copy`;
- SQL comments and consistent formatting.

## Part A — Environment setup

1. Clone the repository.
2. Install Docker Desktop.
3. Verify that Docker is running.
4. Create a feature branch named `milestone-1-foundations`.
5. Start the PostgreSQL service through the project container configuration.
6. Confirm database access with `SELECT version();`.
7. Select a database client.
8. Document software versions and setup commands so the environment can be reproduced.

## Part B — Raw-data inspection

Before implementing cleaning logic:

1. Record the dataset source and usage conditions.
2. Identify every source file.
3. Record file size, row count, column names, and apparent data types.
4. Review the dataset documentation.
5. Define at least ten initial data-quality checks.
6. Identify fields that may contain personal, sensitive, or labelled fraud information.
7. Do not edit the source files.

## Part C — Database and ingestion

Create SQL scripts that:

1. create the project database or document the external database-creation command;
2. create a `raw` schema;
3. create a raw staging table suitable for safe ingestion;
4. load the selected transaction file;
5. verify the imported row count;
6. compare source columns with database columns; and
7. perform basic checks without updating the raw records.

Suggested filenames:

```text
01_create_database.sql
02_create_raw_schema.sql
03_create_raw_transactions.sql
04_load_raw_transactions.sql
05_validate_ingestion.sql
```

## Part D — Baseline transaction analysis

Create SQL queries that answer:

1. How many transaction records were loaded?
2. What date range does the data cover?
3. What is the total transaction value?
4. What are the minimum, maximum, and average transaction amounts?
5. Which transaction types occur most frequently?
6. Which currencies and countries appear?
7. Which days have the highest transaction count and value?
8. How many important fields contain `NULL` or blank values?
9. Are any transaction identifiers duplicated?
10. Which accounts have the highest transaction value?
11. Which categories have an unusually high average amount?
12. How many labelled fraudulent and non-fraudulent transactions are present, if labels exist?

A negative amount, missing value, or duplicate must not be classified as an error until its business meaning has been investigated.

## Optional technical extension

Create a reusable profiling query that returns, for each selected categorical column:

- distinct value count;
- missing-value count;
- most frequent value; and
- frequency of the most frequent value.

Document any limitation in making this fully generic using ordinary PostgreSQL SQL.

## Validation and review

The milestone review will cover:

- environment reproducibility;
- ingestion correctness;
- source-to-database reconciliation;
- SQL correctness and readability;
- data-quality coverage;
- business interpretation;
- documentation; and
- Git history.

## Acceptance criteria

Milestone 1 is complete when:

- the environment can be reproduced from repository instructions;
- the raw dataset and its usage conditions are documented;
- ingestion scripts run successfully;
- validation results reconcile with the source;
- all baseline analysis requirements are implemented;
- SQL meets project conventions;
- the optional technical extension has been evaluated; and
- the progress tracker and main README are current.

## First checkpoint

Complete only **Part A — Environment setup** before proceeding to dataset selection and ingestion. Record the commands used and any errors encountered.
