-- Approval chain depth by line value (BRL-01). Boundaries inclusive on the lower tier.
CREATE OR REPLACE FUNCTION approval_tier(p_aed NUMERIC, p_date DATE) RETURNS INT LANGUAGE sql STABLE AS $$
  SELECT CASE WHEN p_aed <= pv.tier1 THEN 1 WHEN p_aed <= pv.tier2 THEN 2 WHEN p_aed <= pv.tier3 THEN 3 ELSE 4 END
  FROM policy_version pv WHERE pv.effective_from <= p_date ORDER BY pv.effective_from DESC LIMIT 1 $$;
-- 1 = line manager, 2 = + department head, 3 = + Finance Controller, 4 = + CFO
SELECT approval_tier(1000.00, current_date) AS t_1000, approval_tier(1000.01, current_date) AS t_1000_01;  -- expect 1, 2

-- Split-claim aggregation (BRL-02): same employee, merchant and date
SELECT r.employee_id, l.merchant, l.txn_date, SUM(l.submission_aed) AS combined_aed, COUNT(*) AS lines,
       approval_tier(SUM(l.submission_aed), l.txn_date) AS tier
FROM expense_line l JOIN expense_report r USING (report_id)
GROUP BY r.employee_id, l.merchant, l.txn_date HAVING COUNT(*) > 1;

-- FX hold list at payout (BRL-08/09/10): USD peg never held
SELECT line_id, currency, submission_aed, ROUND(amount * :payout_rate, 2) AS payout_aed,
       ROUND((amount * :payout_rate - submission_aed) / submission_aed * 100, 2) AS fx_variance_pct
FROM expense_line WHERE currency NOT IN ('AED','USD')
  AND ABS(amount * :payout_rate - submission_aed) / submission_aed > 0.02;
