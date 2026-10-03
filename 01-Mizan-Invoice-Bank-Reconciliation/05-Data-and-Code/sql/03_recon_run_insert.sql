-- Scheduled job (every batch + 06:00 GST sweep). Idempotent via dedupe_key.

INSERT INTO recon_exceptions_audit
       (settlement_id, invoice_id, batch_id, anomaly_flag, variance_amount,
        batch_net_variance_aed, resolution_owner, dedupe_key)
SELECT t.settlement_id,
       t.invoice_id,
       t.batch_id,
       t.triage_tag::anomaly_flag_t,
       CASE t.triage_tag
            WHEN 'ORPHANED_GATEWAY_RECORD' THEN t.gw_net
            WHEN 'ORPHANED_LEDGER_RECORD'  THEN -COALESCE(t.exp_net, t.ledger_gross)
            ELSE t.net_variance
       END,
       t.batch_net_variance,
       CASE t.triage_tag
            WHEN 'TIMING_MISMATCH_TIMEZONE'  THEN 'finance-ops-recon'
            WHEN 'FEE_VARIANCE_BREACH'       THEN 'payments-partnerships'
            WHEN 'ORPHANED_LEDGER_RECORD'    THEN 'revenue-accounting'
            WHEN 'ORPHANED_GATEWAY_RECORD'   THEN 'finance-ops-recon'
            ELSE 'recon-lead'
       END,
       md5(concat_ws('|', t.settlement_id, t.invoice_id, t.triage_tag))
FROM v_recon_triage t
WHERE t.triage_tag IS NOT NULL
  AND t.triage_tag <> 'MATCHED'
ON CONFLICT (dedupe_key) DO NOTHING
RETURNING exception_id, anomaly_flag, variance_amount, resolution_owner;
