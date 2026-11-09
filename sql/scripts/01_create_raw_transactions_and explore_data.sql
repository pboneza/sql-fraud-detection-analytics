-- Create table matching the raw data format and data types
CREATE TABLE IF NOT EXISTS public.raw_transactions (
    time_step INT,
    transaction_type VARCHAR(20),
    amount NUMERIC(18,2),
    name_orig VARCHAR(20),
    old_balance_orig NUMERIC(18,2),
    new_balance_orig NUMERIC(18,2),
    name_dest VARCHAR(20),
    old_balance_dest NUMERIC(18,2),
    new_balance_dest NUMERIC(18,2),
    is_fraud SMALLINT,
    is_flagged_fraud SMALLINT
);

SELECT
    column_name,
    data_type,
    character_maximum_length,
    numeric_precision,
    numeric_scale
FROM information_schema.columns
WHERE table_name = 'raw_transactions'
ORDER BY ordinal_position;

SELECT
    ordinal_position,
    column_name,
    data_type,
    character_maximum_length,
    numeric_precision,
    numeric_scale
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name = 'raw_transactions'
ORDER BY ordinal_position;

-- Initial profiling inspections
SELECT
    COUNT(*) AS loaded_rows,
    MIN(time_step) AS first_time_step,
    MAX(time_step) AS last_time_step,
    COUNT(*) FILTER (
        WHERE time_step IS NULL
           OR NULLIF(BTRIM(transaction_type), '') IS NULL
           OR amount IS NULL
           OR NULLIF(BTRIM(name_orig), '') IS NULL
           OR NULLIF(BTRIM(name_dest), '') IS NULL
    ) AS rows_with_missing_key_fields,
    COUNT(*) FILTER (WHERE amount < 0) AS negative_amount_rows,
    COUNT(*) FILTER (
        WHERE is_fraud IS NULL OR is_fraud NOT IN (0, 1)
    ) AS invalid_fraud_label_rows,
    COUNT(*) FILTER (
        WHERE is_flagged_fraud IS NULL OR is_flagged_fraud NOT IN (0, 1)
    ) AS invalid_system_flag_rows
FROM public.raw_transactions;

-- inspect the imported table by checking columns
select count(*)
from raw_transactions;

select * from raw_transactions limit 10;

select distinct transaction_type from raw_transactions;

-- overall fraud rate
select count(*) as fraud_count,
is_fraud
from raw_transactions group by is_fraud;

select count(*) as transaction_count, transaction_type
from raw_transactions 
group by transaction_type;

-- fraud distribution by transaction type
select transaction_type,
fraud_count, 
total_count, 
round(fraud_count * 100.0 / total_count, 2) as fraudulent_percentage
from 
(select transaction_type, 
count(*) filter(where is_fraud = 1) as fraud_count,
count(*) as total_count
from raw_transactions
group by transaction_type) as counts
order by fraudulent_percentage desc;

-- fraud rate summary statistics
select is_fraud,
count(*) as transaction_count,
round(avg(amount),2) as avg_amount,
round(min(amount),2) as min_amount,
round(max(amount),2) as max_amount
from raw_transactions 
group by is_fraud
order by is_fraud;

SELECT
    column_name,
    data_type
FROM information_schema.columns
WHERE table_name = 'raw_transactions'
ORDER BY ordinal_position;

SELECT
    COUNT(*) AS transaction_count,
    COUNT(*) FILTER (WHERE is_fraud = 1) AS fraud_count,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE is_fraud = 1)
        / NULLIF(COUNT(*), 0),
        4
    ) AS fraud_rate_pct
FROM public.raw_transactions;