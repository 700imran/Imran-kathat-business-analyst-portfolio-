-- Fixture-based test for v_recon_triage. Run in a scratch schema.
-- Rail CARD_VISA contract: 2.40% + AED 1.00; VAT on fee 5%.

INSERT INTO gateway_fee_schedule (gateway_code, payment_rail, pct_rate, fixed_fee_aed, effective_from)
VALUES ('GW-TEST','CARD_VISA',0.02400,1.00,'2024-01-01');

INSERT INTO raw_gateway_settlements
 (gateway_code,batch_id,transaction_ref,settlement_type,payment_rail,gross_amount,gateway_fee,fee_vat_amount,net_amount,settlement_utc,source_file_hash)
VALUES
 ('GW-TEST','B-FIX','FX-001','SALE','CARD_VISA',1000.00,25.00,1.25,973.75,'2024-12-10 08:00+00',repeat('a',64)),   -- exact
 ('GW-TEST','B-FIX','FX-002','SALE','CARD_VISA',1000.00,25.29,1.26,973.45,'2024-12-10 08:00+00',repeat('a',64)),   -- within tolerance (-0.30)
 ('GW-TEST','B-FIX','FX-003','SALE','CARD_VISA',1000.00,30.00,1.50,968.50,'2024-12-10 08:00+00',repeat('a',64)),   -- 2.90% charged
 ('GW-TEST','B-FIX','FX-004','SALE','CARD_VISA',1000.00,25.00,1.25,973.75,'2024-12-10 21:40+00',repeat('a',64)),   -- 01:40 GST next day
 ('GW-TEST','B-FIX','FX-005','SALE','CARD_VISA',1000.00,25.00,1.25,973.75,'2024-12-10 08:00+00',repeat('a',64));   -- no ledger row

INSERT INTO internal_ledger_invoices
 (invoice_number,gateway_code,gateway_txn_ref,payment_rail,gross_amount,vat_amount_aed,payment_status,issued_at,posting_date_gst)
VALUES
 ('FX-INV-001','GW-TEST','FX-001','CARD_VISA',1000.00,47.62,'PAID','2024-12-09 09:00+04','2024-12-10'),
 ('FX-INV-002','GW-TEST','FX-002','CARD_VISA',1000.00,47.62,'PAID','2024-12-09 09:00+04','2024-12-10'),
 ('FX-INV-003','GW-TEST','FX-003','CARD_VISA',1000.00,47.62,'PAID','2024-12-09 09:00+04','2024-12-10'),
 ('FX-INV-004','GW-TEST','FX-004','CARD_VISA',1000.00,47.62,'PAID','2024-12-09 09:00+04','2024-12-10'),   -- ERP stamped the UTC date
 ('FX-INV-006','GW-TEST','FX-006','CARD_VISA',1000.00,47.62,'PAID', now() - interval '14 days', current_date - 14);  -- paid, never settled

-- Assertion: every fixture row must land on its expected tag. Zero rows returned = pass.
WITH expected(ref, tag) AS (VALUES
    ('FX-001','MATCHED'), ('FX-002','MATCHED'), ('FX-003','FEE_VARIANCE_BREACH'),
    ('FX-004','TIMING_MISMATCH_TIMEZONE'), ('FX-005','ORPHANED_GATEWAY_RECORD'), ('FX-006','ORPHANED_LEDGER_RECORD'))
SELECT e.ref, e.tag AS expected_tag, t.triage_tag AS actual_tag
FROM expected e
LEFT JOIN v_recon_triage t ON t.transaction_ref = e.ref AND t.gateway_code = 'GW-TEST'
WHERE t.triage_tag IS DISTINCT FROM e.tag;
