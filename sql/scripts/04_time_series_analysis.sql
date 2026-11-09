-- ============================================================
-- TIME-SERIES FRAUD ANALYSIS
-- ============================================================
--
-- Objective:
-- Analyse how transaction activity and fraud behaviour change
-- across time_step.
--
-- Key questions:
-- 1. How does transaction volume change over time?
-- 2. How does fraud frequency change over time?
-- 3. Which time periods show unusually high fraud activity?
-- 4. Are there sudden increases or recurring temporal patterns?
-- ============================================================

select time_step,
count(*) as transaction_count,
coalesce (count(*) filter(where is_fraud = 1), 0) as fraud_count,
round(count(*) filter(where is_fraud = 1) * 100.0 / nullif(count(*), 0), 4) as fraud_rate_pct,
sum(amount) as total_amount, 
sum(amount) filter( where is_fraud = 1) as fraud_amount
from raw_transactions
group by time_step
order by time_step;

-- ============================================================
-- Analysis: Transaction and fraud activity by time step
--
-- Business question:
-- How do transaction volume, fraud frequency, fraud rate,
-- transaction value, and fraudulent value change over time?
--
-- Purpose:
-- Establish the baseline temporal pattern of transaction and
-- fraud activity before applying trend and anomaly analysis.
-- ============================================================

with time_step_summary as 
(select time_step,
count(*) as transaction_count,
count(*) filter(where is_fraud = 1) as fraud_count,
round(count(*) filter(where is_fraud = 1) * 100.0 / nullif(count(*), 0), 4) as fraud_rate_pct,
sum(amount) as total_amount, 
coalesce(sum(amount) filter(where is_fraud = 1), 0) as fraud_amount
from raw_transactions
group by time_step)
select time_step,
transaction_count,
fraud_count,
fraud_rate_pct,  
fraud_amount
from time_step_summary
order by fraud_count desc
limit 10;

-- Finding:
-- The periods with the highest absolute fraud counts do not
-- necessarily have the highest fraud rates.
--
-- Time step 212 recorded the highest fraud count (40 cases)
-- across 34,047 transactions, corresponding to a fraud rate
-- of only 0.1175%.
--
-- In contrast, several low-volume time steps recorded fraud
-- rates of 100%, where every transaction in the period was
-- labelled as fraudulent.
--
-- This shows that fraud count and fraud rate capture different
-- dimensions of temporal fraud activity.


with time_step_summary as 
(select time_step,
count(*) as transaction_count,
count(*) filter(where is_fraud = 1) as fraud_count,
round(count(*) filter(where is_fraud = 1) * 100.0 / nullif(count(*), 0), 4) as fraud_rate_pct,
sum(amount) as total_amount, 
coalesce(sum(amount) filter(where is_fraud = 1), 0) as fraud_amount
from raw_transactions
group by time_step)
select time_step,
transaction_count,
fraud_count,
fraud_rate_pct,  
fraud_amount
from time_step_summary
order by fraud_rate_pct desc, fraud_count desc
limit 10;

-- Finding:
-- The highest fraud-rate time steps are dominated by low-volume
-- periods in which every recorded transaction is fraudulent.
--
-- Several time steps have a 100% fraud rate but contain only
-- approximately 20–30 transactions.
--
-- This shows that fraud rate should be interpreted together with
-- transaction volume. High fraud concentration does not necessarily
-- imply high absolute fraud volume.

with fraud_check as (select time_step,
count(*) as transaction_count,
count(*) filter(where is_fraud= 1) as fraud_count
from raw_transactions
group by time_step),
rolling_metrics as (
select time_step,
transaction_count,
fraud_count,
sum(transaction_count) over (
order by time_step
rows between 6 preceding and current row) as rolling_7_transaction_count,
sum(fraud_count) over (
order by time_step
rows between 6 preceding and current row) as rolling_7_fraud_count
from fraud_check)
select time_step,
transaction_count,
fraud_count,
round(rolling_7_fraud_count * 100.0 / nullif(rolling_7_transaction_count, 0),4) as rolling_7_fraud_rate_pct
from rolling_metrics
order by time_step;

-- Finding:
-- A 7-time-step rolling fraud rate was calculated to smooth
-- short-term fluctuations in individual time steps.
--
-- The first six observations use incomplete rolling windows,
-- while time step 7 onward uses the full current-plus-six-
-- preceding-period window.
--
-- The rolling metric will be used to identify sustained changes
-- in fraud activity rather than isolated single-period spikes.

with fraud_check as (select time_step,
count(*) as transaction_count,
count(*) filter(where is_fraud= 1) as fraud_count
from raw_transactions
group by time_step),
rolling_metrics as (
select time_step,
transaction_count,
fraud_count,
sum(transaction_count) over (
order by time_step
rows between 6 preceding and current row) as rolling_7_transaction_count,
sum(fraud_count) over (
order by time_step
rows between 6 preceding and current row) as rolling_7_fraud_count
from fraud_check),
rolling_rates as (
select time_step,
transaction_count,
fraud_count,
rolling_7_transaction_count,
rolling_7_fraud_count,
rolling_7_fraud_count * 100.0 / nullif(rolling_7_transaction_count, 0) as rolling_7_fraud_rate_pct
from rolling_metrics),
rate_changes as (
select time_step,
rolling_7_fraud_rate_pct,
lag(rolling_7_fraud_rate_pct) over (order by time_step) as previous_rolling_rate,
rolling_7_fraud_rate_pct - lag(rolling_7_fraud_rate_pct) over (order by time_step) as change_pct_points
from rolling_rates)
select time_step,
round(rolling_7_fraud_rate_pct, 4) as rolling_7_fraud_rate_pct,
round(previous_rolling_rate, 4),
round(change_pct_points, 4)
from rate_changes
order by time_step;

-- Analysis: Change in rolling fraud rate

-- Business question: When did the rolling fraud rate change,
-- and how many transactions were behind that change?
WITH step_summary AS (
    SELECT
        time_step,
        COUNT(*) AS transaction_count,
        COUNT(*) FILTER (WHERE is_fraud = 1) AS fraud_count
    FROM public.raw_transactions
    GROUP BY time_step
),
step_bounds AS (
    SELECT MIN(time_step) AS first_step, MAX(time_step) AS last_step
    FROM step_summary
),
complete_steps AS (
    SELECT
        steps.time_step,
        COALESCE(s.transaction_count, 0) AS transaction_count,
        COALESCE(s.fraud_count, 0) AS fraud_count
    FROM step_bounds AS b
    CROSS JOIN LATERAL
        generate_series(b.first_step, b.last_step) AS steps(time_step)
    LEFT JOIN step_summary AS s USING (time_step)
),
rolling_counts AS (
    SELECT
        time_step,
        transaction_count,
        fraud_count,
        COUNT(*) OVER recent_steps AS steps_in_window,
        SUM(transaction_count) OVER recent_steps AS rolling_transaction_count,
        SUM(fraud_count) OVER recent_steps AS rolling_fraud_count
    FROM complete_steps
    WINDOW recent_steps AS (
        ORDER BY time_step
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    )
),
rolling_rates AS (
    SELECT
        *,
        CASE WHEN steps_in_window = 7 THEN
            100.0 * rolling_fraud_count / NULLIF(rolling_transaction_count, 0)
        END AS rolling_fraud_rate_pct
    FROM rolling_counts
)
SELECT
    time_step,
    transaction_count,
    fraud_count,
    rolling_transaction_count,
    rolling_fraud_count,
    ROUND(rolling_fraud_rate_pct, 4) AS rolling_7_fraud_rate_pct,
    ROUND(
        rolling_fraud_rate_pct
        - LAG(rolling_fraud_rate_pct) OVER (ORDER BY time_step),
        4
    ) AS change_pct_points
FROM rolling_rates
ORDER BY time_step;
