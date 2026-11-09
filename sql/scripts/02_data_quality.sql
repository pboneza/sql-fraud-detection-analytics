-- Analysis: Transaction count
-- Business question: How many transactions are available for analysis?
-- Purpose: To establish the size of raw dataset before performing cleaning and fraud analysis
-- Finding: The raw_transactions table contains 6,362,620 transactions.

select count(*) as transaction_count
from raw_transactions;

--Next up, check missing values
-- Question to answer: Are important transaction fields missing values?
-- Columns to check: transaction identifieer, amount, transaction_tpe and is_fraud
-- Answer: No missing / NULL values were recorded

select count(*) filter(where amount is null) as missing_amount,
count(*) filter(where transaction_type is null) as missing_transaction_type,
count(*) filter(where is_fraud is null) as missing_fraud_label
from raw_transactions;

-- Next up, check for financial validity of transactions
-- Question: Are transaction amounts financially valid?
-- Solution: 16 records have zero amount. No negative amount recorded.

select min(amount) as min_amount
from raw_transactions;

select min(amount) as min_amount,
count(*) filter(where amount = 0) as zero_amount_count,
count(*) filter(where amount < 0) as negative_amount_count
from raw_transactions;

-- Let's investigate the 16 zero amount records further.

select * 
from raw_transactions
where amount = 0;

select transaction_type,
is_fraud,
count(*) as zero_amount_count
from raw_transactions
where amount = 0
group by transaction_type, is_fraud
order by zero_amount_count desc;

-- Finding:
-- The dataset contains 16 zero-value transactions.
-- All 16 are CASH_OUT transactions and are labelled as fraudulent.
-- No zero-value non-fraudulent transactions were identified.
--
-- This suggests that zero transaction amounts may represent a
-- fraud-related pattern in this dataset rather than random
-- missing or invalid monetary data.

-- investigate usual large transaction so one has an idea of how an
-- unusually large transaction could look like

select avg(amount) as avg_amount,
percentile_cont(0.5) within group (order by amount) as median_amount,
percentile_cont(0.95) within group (order by amount) as p95_amount,
percentile_cont(0.99) within group(order by amount) as p99_amount,
max(amount) as max_amount
from raw_transactions;

-- Finding:
-- Transaction amounts are strongly right-skewed.
-- The median transaction amount is approximately 74,871.94,
-- while the average is approximately 179,861.90.
--
-- 95% of transactions are at or below approximately 518,634.20,
-- and 99% are at or below approximately 1,615,979.47.
--
-- The maximum transaction amount is approximately 92.45 million,
-- which is far above the 99th percentile and indicates the presence
-- of extremely large transactions requiring further investigation.

with amount_threshold as 
(select percentile_cont(0.99) within group (order by amount) as threshold 
from raw_transactions), 
fraud_enquiry as (select 
count(*) as high_value_transactions,
count(*) filter(where is_fraud = 1) as high_value_fraudulent_transactions
from raw_transactions
where amount > (select threshold from amount_threshold))
select high_value_transactions,
high_value_fraudulent_transactions,
round(high_value_fraudulent_transactions * 100.0 / nullif (high_value_transactions,0), 2) as fraud_rate
from fraud_enquiry;

-- Finding:
-- Transactions above the 99th percentile have a fraud rate of 3.09%,
-- compared with an overall fraud rate of approximately 0.13%.
--
-- The fraud rate among extreme high-value transactions is therefore
-- approximately 24 times higher than the overall transaction baseline.
--
-- This indicates that unusually large transaction amounts are strongly
-- associated with elevated fraud risk in this dataset.

with amount_threshold as 
(select percentile_cont(0.99) within group (order by amount) as threshold
from raw_transactions),
overall_fraud_count as 
(select count(*) as transaction_count,
count (*) filter (where is_fraud = 1) as fraudulent_transactions 
from raw_transactions),
fraud_enquiry as 
(select count (*) as high_value_transactions,
count(*) filter(where is_fraud = 1) as high_value_fraudulent_transactions
from raw_transactions 
where amount > (select threshold from amount_threshold)),
overall_fraud_rate as 
(select fraudulent_transactions * 100.0 / nullif(transaction_count, 0) as overall_fraud_rate
from overall_fraud_count),
high_value_fraud as
(select high_value_fraudulent_transactions * 100.0 / nullif(high_value_transactions,0) as high_value_fraud_rate
from fraud_enquiry)
select ofr.overall_fraud_rate as overall_fraud_rate,
hvf.high_value_fraud_rate as high_value_fraud_rate,
round(hvf.high_value_fraud_rate / nullif(ofr.overall_fraud_rate, 0), 2) as risk_multiple
from overall_fraud_rate ofr
cross join high_value_fraud hvf;

-- Finding:
-- The overall fraud rate is approximately 0.1291%.
-- For transactions above the 99th percentile of transaction amount,
-- the fraud rate increases to approximately 3.0946%.
--
-- High-value transactions therefore exhibit approximately 23.97 times
-- the fraud rate observed across the full transaction population.
--
-- Although transactions above the 99th percentile represent roughly
-- 1% of all transactions, they contain approximately 24% of all
-- fraudulent transactions.
--
-- This indicates a strong association between extreme transaction
-- amounts and fraud risk in this dataset. Transaction amount may
-- therefore be useful as one component of a fraud-monitoring rule,
-- although it should not be treated as a standalone fraud indicator.

select column_name
from information_schema.columns 
where table_name = 'raw_transactions';

select time_step,
transaction_type,
amount, 
name_orig,
old_balance_orig,
new_balance_orig,
name_dest,
old_balance_dest,
new_balance_dest,
is_fraud,
is_flagged_fraud,
count(*)
from raw_transactions 
group by time_step,
transaction_type,
amount, 
name_orig,
old_balance_orig,
new_balance_orig,
name_dest,
old_balance_dest,
new_balance_dest,
is_fraud,
is_flagged_fraud
having count(*) > 1;

-- Analysis: Exact duplicate transaction check
--
-- Business question:
-- Does the raw transaction dataset contain exact duplicate records?
--
-- Method:
-- Transactions were grouped using all available attributes.
-- Groups occurring more than once were identified using HAVING.
--
-- Finding:
-- No exact duplicate transaction records were identified in
-- raw_transactions.
--
-- Note:
-- This confirms the absence of exact row duplicates. It does not
-- prove that there are no near-duplicate or repeated transactions
-- with small differences in their attributes.

select is_fraud,
is_flagged_fraud,
count(*) as transaction_count
from raw_transactions 
group by is_fraud, is_flagged_fraud
order by is_fraud desc, is_flagged_fraud desc;

-- Finding:
-- The fraud-flagging mechanism identified only 16 of the 8,213
-- fraudulent transactions in the dataset.
--
-- All 16 flagged transactions were genuinely fraudulent, meaning
-- no false-positive flags were observed.
--
-- However, 8,197 fraudulent transactions were not flagged.
-- This corresponds to a recall of approximately 0.19%, indicating
-- that the existing flagging mechanism captures only a very small
-- proportion of actual fraud.
--
-- The results demonstrate why fraud-detection performance should
-- not be evaluated using overall accuracy alone, particularly in
-- highly imbalanced datasets.

with confusion_matrix as 
(select count(*) filter(where is_fraud = 1 and is_flagged_fraud = 1) as true_positives,
count(*) filter(where is_fraud = 1 and is_flagged_fraud = 0) as false_negatives,
count(*) filter(where is_fraud = 0 and is_flagged_fraud = 1) as false_positives,
count(*) filter(where is_fraud = 0 and is_flagged_fraud = 0) as true_negatives
from raw_transactions),
eval_metrics as
(select true_positives * 1.0  / nullif(true_positives + false_positives, 0) as precision_ratio,
true_positives * 1.0 / nullif(true_positives + false_negatives, 0) as recall_ratio
from confusion_matrix)
select cm.true_positives,
cm.false_positives,
cm.false_negatives,
cm.true_negatives,
em.precision_ratio *100.0 as precision_pct,
em.recall_ratio * 100.0 as recall_pct,
em.precision_ratio * em.recall_ratio * 2.0 * 100.0 / nullif(em.precision_ratio + em.recall_ratio, 0) as f1_score
from confusion_matrix cm
cross join eval_metrics em;

-- Finding:
-- The existing fraud flag achieved 100% precision because all
-- 16 flagged transactions were actual fraud cases.
--
-- However, recall was only approximately 0.19%.
-- Of 8,213 fraudulent transactions, 8,197 were not flagged.
--
-- The mechanism is therefore highly conservative: it produces
-- no observed false positives but fails to detect approximately
-- 99.81% of fraudulent transactions.
--
-- This demonstrates why precision alone is insufficient when
-- evaluating fraud-detection systems.

select min(time_step) as min_time_step,
max(time_step) as max_time_step,
count (distinct time_step) as distinct_time_steps
from raw_transactions ;

select transaction_type,
count(*) as total_transactions,
count(*) filter (where old_balance_orig - amount = new_balance_orig) as exact_balance_matches,
count(*) filter (where old_balance_orig - amount <> new_balance_orig) as balance_mismatches,
count(*) filter (where old_balance_orig - amount <> new_balance_orig) * 100.0 / nullif (count(*), 0) as mismatch_pct
from raw_transactions
group by transaction_type;

-- Intermediate finding:
-- Applying a subtraction-based balance rule to all transaction
-- types produced an overall mismatch rate of approximately 80.56%.
--
-- The breakdown by transaction type showed that all CASH_IN
-- transactions failed this rule, indicating that the original
-- validation logic was inappropriate for incoming transactions.
--
-- Transaction-specific accounting logic is therefore required
-- before balance inconsistencies can be interpreted as anomalies.

with expected_balance as 
(select transaction_type,
new_balance_orig,
case when transaction_type = 'CASH_IN' 
then old_balance_orig + amount else old_balance_orig - amount end as expected_new_balance
from raw_transactions)
select transaction_type,
count(*) as total_transactions,
count(*) filter (where expected_new_balance = new_balance_orig) as exact_balance_matches,
count(*) filter (where expected_new_balance <> new_balance_orig) as balance_mismatches,
count(*) filter (where expected_new_balance <> new_balance_orig) * 100.0 / nullif (count(*), 0) as mismatch_pct
from expected_balance
group by transaction_type;

-- Data-quality observation:
-- Transaction-specific balance reconciliation revealed substantial
-- mismatches for several transaction types. Because PaySim is a
-- synthetic transaction dataset and the recorded balance behaviour
-- may reflect its generation process, these mismatches were documented
-- but not treated as invalid records or removed from the analysis.


