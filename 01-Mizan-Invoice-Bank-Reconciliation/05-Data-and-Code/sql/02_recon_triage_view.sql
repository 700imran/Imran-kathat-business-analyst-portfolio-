-- v1.1 (2024-12-18): grace period counted in working days after system-integration-test defect DEF-009 / change request CR-002.
-- Read-only view; every consumer (insert job, dashboard, tests) reads the same logic.

CREATE OR REPLACE VIEW v_recon_triage AS
WITH
params AS (
    SELECT 0.05::numeric        AS vat_rate,             -- GCC VAT (UAE)
           0.50::numeric        AS variance_tolerance,   -- AED
           3                    AS settlement_grace_days,-- WORKING days (Mon-Fri), see CR-002 / DEF-009
           'Asia/Dubai'::text   AS local_tz
),

-- Gateway sales only; refunds/chargebacks are reconciled by a separate job
gw AS (
    SELECT s.*,
           (s.settlement_utc AT TIME ZONE 'UTC')::date AS settlement_date_utc
    FROM raw_gateway_settlements s
    WHERE s.settlement_type = 'SALE'
),

-- The legacy ERP can re-issue an invoice without voiding the old one.
-- Keep the latest non-void invoice per gateway transaction.
ledger_ranked AS (
    SELECT i.*,
           ROW_NUMBER() OVER (
               PARTITION BY i.gateway_code, i.gateway_txn_ref
               ORDER BY i.issued_at DESC, i.invoice_id DESC
           ) AS rn
    FROM internal_ledger_invoices i
    WHERE i.payment_status <> 'VOID'
      AND i.gateway_txn_ref IS NOT NULL
),
ledger AS (
    SELECT * FROM ledger_ranked WHERE rn = 1
),

-- FULL OUTER JOIN exposes orphans on both sides
joined AS (
    SELECT g.settlement_id,
           l.invoice_id,
           COALESCE(g.gateway_code, l.gateway_code)       AS gateway_code,
           COALESCE(g.transaction_ref, l.gateway_txn_ref) AS transaction_ref,
           COALESCE(g.payment_rail, l.payment_rail)       AS payment_rail,
           g.batch_id,
           l.gross_amount          AS ledger_gross,
           l.vat_amount_aed,
           l.payment_status,
           l.posting_date_gst,
           g.gross_amount          AS gw_gross,
           g.gateway_fee,
           g.fee_vat_amount,
           g.net_amount            AS gw_net,
           g.settlement_date_gst,
           g.settlement_date_utc
    FROM gw g
    FULL OUTER JOIN ledger l
           ON l.gateway_code    = g.gateway_code
          AND l.gateway_txn_ref = g.transaction_ref
),

-- Price each transaction against the fee schedule live on its settlement day
priced AS (
    SELECT j.*,
           pr.vat_rate, pr.variance_tolerance, pr.settlement_grace_days, pr.local_tz,
           ROUND(COALESCE(j.ledger_gross, j.gw_gross) * COALESCE(fs.pct_rate, 0)
                 + COALESCE(fs.fixed_fee_aed, 0), 2)        AS exp_fee
    FROM joined j
    CROSS JOIN params pr
    LEFT JOIN gateway_fee_schedule fs
           ON fs.gateway_code = j.gateway_code
          AND fs.payment_rail = j.payment_rail
          AND COALESCE(j.settlement_date_gst, j.posting_date_gst) >= fs.effective_from
          AND (fs.effective_to IS NULL
               OR COALESCE(j.settlement_date_gst, j.posting_date_gst) <= fs.effective_to)
),

calc AS (
    SELECT p.*,
           ROUND(p.exp_fee * p.vat_rate, 2)                               AS exp_fee_vat,
           -- expected bank credit = invoice gross - contracted fee - VAT on that fee
           p.ledger_gross - p.exp_fee - ROUND(p.exp_fee * p.vat_rate, 2)  AS exp_net,
           (p.gateway_fee + p.fee_vat_amount)
             - (p.exp_fee + ROUND(p.exp_fee * p.vat_rate, 2))             AS fee_variance,
           -- ledger booked on the UTC date while Dubai was already on the next day
           (p.posting_date_gst = p.settlement_date_utc
            AND p.settlement_date_utc <> p.settlement_date_gst)           AS tz_explained,
           w.working_days_elapsed
    FROM priced p
    LEFT JOIN LATERAL (
        SELECT COUNT(*)::int AS working_days_elapsed
        FROM generate_series(p.posting_date_gst + 1, (now() AT TIME ZONE p.local_tz)::date, interval '1 day') AS g(d)
        WHERE EXTRACT(ISODOW FROM g.d) < 6          -- Monday-Friday; UAE weekend is Sat/Sun
    ) w ON TRUE
),

variance AS (
    SELECT c.*,
           c.gw_net - c.exp_net AS net_variance,
           SUM(c.gw_net - c.exp_net) OVER (PARTITION BY c.batch_id) AS batch_net_variance
    FROM calc c
),

triaged AS (
    SELECT v.*,
           CASE
               -- booked as paid, nothing settled, grace period over
               WHEN v.gw_net IS NULL
                    AND v.payment_status IN ('PAID','PARTIALLY_PAID')
                    AND v.working_days_elapsed >= v.settlement_grace_days
                    THEN 'ORPHANED_LEDGER_RECORD'
               WHEN v.gw_net IS NULL
                    THEN NULL            -- still inside settlement window or never paid: not an exception
               WHEN v.invoice_id IS NULL
                    THEN 'ORPHANED_GATEWAY_RECORD'
               -- money is right, only the calendar day differs because of UTC vs GST
               WHEN ABS(v.net_variance) <= v.variance_tolerance AND v.tz_explained
                    THEN 'TIMING_MISMATCH_TIMEZONE'
               WHEN ABS(v.fee_variance) > v.variance_tolerance
                    THEN 'FEE_VARIANCE_BREACH'
               WHEN ABS(v.net_variance) <= v.variance_tolerance
                    THEN 'MATCHED'
               ELSE 'UNCLASSIFIED_VARIANCE'
           END AS triage_tag
    FROM variance v
)
SELECT * FROM triaged;
