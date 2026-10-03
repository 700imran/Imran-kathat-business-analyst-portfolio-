-- Post-load validations. Each query returns zero rows when healthy. Wire into the nightly job; any row = alert.

-- V1 Ingestion completeness: gateway-declared row count vs rows loaded, per batch
-- (batch_control is filled from the webhook header)
SELECT b.batch_id, b.declared_rows, COUNT(s.*) AS loaded_rows
FROM batch_control b LEFT JOIN raw_gateway_settlements s USING (batch_id)
GROUP BY b.batch_id, b.declared_rows
HAVING COUNT(s.*) <> b.declared_rows;

-- V2 Net identity on SALE rows (belt and braces behind the table constraint)
SELECT settlement_id FROM raw_gateway_settlements
WHERE settlement_type = 'SALE' AND ABS(net_amount - (gross_amount - gateway_fee - fee_vat_amount)) > 0.01;

-- V3 Ledger VAT rule: 5/105 of gross
SELECT invoice_id FROM internal_ledger_invoices
WHERE ABS(vat_amount_aed - ROUND(gross_amount / 1.05 * 0.05, 2)) > 0.01;

-- V4 Triage completeness: every joined row is classified, pending or matched (no silent drops)
SELECT COUNT(*) AS unclassified_rows FROM v_recon_triage
WHERE triage_tag IS NULL AND payment_status IN ('PAID','PARTIALLY_PAID') AND working_days_elapsed >= settlement_grace_days
HAVING COUNT(*) > 0;

-- V5 Money parity: sum of gateway net equals sum of matched + exception gateway net (no row lost between layers)
SELECT 'PARITY_BREAK' AS check_name, g.total_net, t.triaged_net
FROM (SELECT SUM(net_amount) total_net FROM raw_gateway_settlements WHERE settlement_type='SALE') g,
     (SELECT SUM(gw_net) triaged_net FROM v_recon_triage) t
WHERE ABS(g.total_net - t.triaged_net) > 0.01;

-- V6 Exceptions without an owner
SELECT exception_id FROM recon_exceptions_audit WHERE resolution_owner IS NULL OR resolution_owner = '';

-- V7 Open exceptions older than SLA (4 working hours for >5,000; 3 working days otherwise)
SELECT exception_id, anomaly_flag, variance_amount, detected_at
FROM recon_exceptions_audit
WHERE status IN ('OPEN','IN_REVIEW')
  AND ((ABS(variance_amount) > 5000 AND detected_at < now() - interval '4 hours')
    OR (ABS(variance_amount) <= 5000 AND detected_at < now() - interval '3 days'));

-- V8 Idempotency: re-run must not create duplicates
SELECT dedupe_key, COUNT(*) FROM recon_exceptions_audit GROUP BY dedupe_key HAVING COUNT(*) > 1;
