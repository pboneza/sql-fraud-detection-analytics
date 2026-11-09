-- 03 | High-value transaction anomaly detection
--
-- Business question
-- Can an unusually high transaction amount help prioritise fraud investigations?
--
-- Method
-- Use the first 70% of the observed time-step span to estimate the 99th
-- percentile (P99). Flag transactions strictly above that threshold in the
-- remaining period. The split is by time step, so the row proportions may differ.
-- Compare the amount rule with the dataset's existing flag on the same later rows.
-- is_fraud supplies the evaluation labels and is only used to measure results.
--
-- Record after running
-- Note the cutoff step, threshold, evaluation-period fraud rate, alert counts,
-- precision and recall for each rule. Compare fraud captured and review workload.
-- This is a retrospective test on synthetic data. Keep the later period held
-- out if reporting these results as an evaluation of the preset P99 rule.

WITH time_bounds AS (
    SELECT
        MIN(time_step) AS first_step,
        MAX(time_step) AS last_step
    FROM public.raw_transactions
),
time_split AS (
    SELECT
        first_step + FLOOR(0.70 * (last_step - first_step + 1))::integer - 1
            AS last_calibration_step
    FROM time_bounds
),
calibration AS (
    SELECT
        split.last_calibration_step,
        PERCENTILE_CONT(0.99) WITHIN GROUP (ORDER BY tx.amount) AS p99_amount
    FROM time_split AS split
    JOIN public.raw_transactions AS tx
        ON tx.time_step <= split.last_calibration_step
    GROUP BY split.last_calibration_step
),
rule_counts AS (
    SELECT
        cal.last_calibration_step,
        cal.p99_amount,
        rule.rule_name,
        MIN(tx.time_step) AS first_evaluation_step,
        MAX(tx.time_step) AS last_evaluation_step,
        COUNT(*) AS evaluated_transactions,
        COUNT(*) FILTER (WHERE tx.is_fraud = 1) AS labelled_fraud,
        COUNT(*) FILTER (WHERE rule.alerted) AS alerts,
        COUNT(*) FILTER (WHERE rule.alerted AND tx.is_fraud = 1) AS fraud_detected,
        COUNT(*) FILTER (WHERE rule.alerted AND tx.is_fraud = 0) AS false_alerts,
        COUNT(*) FILTER (WHERE NOT rule.alerted AND tx.is_fraud = 1) AS fraud_missed
    FROM calibration AS cal
    JOIN public.raw_transactions AS tx
        ON tx.time_step > cal.last_calibration_step
    CROSS JOIN LATERAL (
        VALUES
            ('high_value_p99', tx.amount > cal.p99_amount),
            ('existing_paysim_flag', tx.is_flagged_fraud = 1)
    ) AS rule(rule_name, alerted)
    WHERE cal.p99_amount IS NOT NULL
    GROUP BY cal.last_calibration_step, cal.p99_amount, rule.rule_name
)
SELECT
    rule_name,
    last_calibration_step,
    first_evaluation_step,
    last_evaluation_step,
    CASE WHEN rule_name = 'high_value_p99'
        THEN ROUND(p99_amount::numeric, 4)
    END AS amount_threshold,
    evaluated_transactions,
    labelled_fraud,
    alerts,
    fraud_detected,
    false_alerts,
    fraud_missed,
    ROUND(100.0 * labelled_fraud / NULLIF(evaluated_transactions, 0), 4)
        AS evaluation_fraud_rate_pct,
    ROUND(100.0 * alerts / NULLIF(evaluated_transactions, 0), 4)
        AS alert_rate_pct,
    ROUND(100.0 * fraud_detected / NULLIF(alerts, 0), 4) AS precision_pct,
    ROUND(100.0 * fraud_detected / NULLIF(labelled_fraud, 0), 4) AS recall_pct
FROM rule_counts
ORDER BY rule_name;
