create table raw_transactions (
	time_step int, 
	transaction_type varchar(20), 
	amount numeric(18,2), 
	name_orig varchar(20), 
	old_balance_orig numeric(18,2), 
	new_balance_orig numeric(18,2), 
	name_dest varchar(20), 
	old_balance_dest numeric(18,2), 
	new_balance_dest numeric(18,2), 
	is_fraud smallint, 
	is_flagged_fraud smallint
);

drop table raw_transactions ;
create table raw_transactions (
	time_step int, 
	transaction_type varchar(20), 
	amount numeric(18,2), 
	name_orig varchar(20), 
	old_balance_orig numeric(18,2), 
	new_balance_orig numeric(18,2), 
	name_dest varchar(20), 
	old_balance_dest numeric(18,2), 
	new_balance_dest numeric(18,2), 
	is_fraud smallint, 
	is_flagged_fraud smallint
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

DROP TABLE IF EXISTS raw_transactions;

CREATE TABLE raw_transactions (
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
