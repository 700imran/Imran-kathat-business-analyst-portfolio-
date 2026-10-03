-- Mizan reconciliation schema (PostgreSQL 15). Run once.
-- UTC storage, GST (Asia/Dubai) reporting; VAT 5%; AED.

-- ---------------------------------------------------------------
-- Enumerations
-- ---------------------------------------------------------------
CREATE TYPE payment_status_t AS ENUM ('PENDING','PAID','PARTIALLY_PAID','REFUNDED','VOID');
CREATE TYPE anomaly_flag_t   AS ENUM (
    'TIMING_MISMATCH_TIMEZONE',
    'FEE_VARIANCE_BREACH',
    'ORPHANED_LEDGER_RECORD',
    'ORPHANED_GATEWAY_RECORD',
    'UNCLASSIFIED_VARIANCE'
);
CREATE TYPE exception_status_t AS ENUM ('OPEN','IN_REVIEW','RESOLVED','WRITTEN_OFF');

-- ---------------------------------------------------------------
-- Contracted gateway pricing, versioned by effective date.
-- Interchange/scheme fees change; the recon must price each
-- transaction against the schedule that was live on settlement day.
-- ---------------------------------------------------------------
CREATE TABLE gateway_fee_schedule (
    fee_schedule_id  INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    gateway_code     VARCHAR(20)  NOT NULL,
    payment_rail     VARCHAR(20)  NOT NULL,   -- CARD_VISA, CARD_MC, APPLE_PAY, AANI, UAE_DDS, MADA, KNET, BENEFIT
    pct_rate         NUMERIC(6,5) NOT NULL CHECK (pct_rate >= 0 AND pct_rate < 0.10),
    fixed_fee_aed    NUMERIC(8,2) NOT NULL DEFAULT 0 CHECK (fixed_fee_aed >= 0),
    effective_from   DATE         NOT NULL,
    effective_to     DATE,                    -- NULL = open-ended
    CONSTRAINT uq_fee_schedule UNIQUE (gateway_code, payment_rail, effective_from),
    CONSTRAINT chk_fee_window  CHECK (effective_to IS NULL OR effective_to >= effective_from)
);

-- ---------------------------------------------------------------
-- a) Gateway side: one row per settled transaction event
-- ---------------------------------------------------------------
CREATE TABLE raw_gateway_settlements (
    settlement_id      BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    gateway_code       VARCHAR(20)   NOT NULL,
    batch_id           VARCHAR(40)   NOT NULL,
    transaction_ref    VARCHAR(64)   NOT NULL,
    merchant_order_ref VARCHAR(64),
    settlement_type    VARCHAR(12)   NOT NULL
                       CHECK (settlement_type IN ('SALE','REFUND','CHARGEBACK')),
    payment_rail       VARCHAR(20)   NOT NULL,
    gross_amount       NUMERIC(14,2) NOT NULL,                  -- what the customer paid, VAT-inclusive
    gateway_fee        NUMERIC(12,2) NOT NULL CHECK (gateway_fee >= 0),
    fee_vat_amount     NUMERIC(12,2) NOT NULL DEFAULT 0,        -- 5% VAT the gateway charges on its own fee
    net_amount         NUMERIC(14,2) NOT NULL,                  -- amount credited to the bank account
    currency_code      CHAR(3)       NOT NULL DEFAULT 'AED',
    settlement_utc     TIMESTAMPTZ   NOT NULL,                  -- gateways report in UTC
    settlement_date_gst DATE GENERATED ALWAYS AS
                       ((settlement_utc AT TIME ZONE 'Asia/Dubai')::date) STORED,
    source_file_hash   CHAR(64)      NOT NULL,                  -- SHA-256 of the delivered settlement file
    ingested_at        TIMESTAMPTZ   NOT NULL DEFAULT now(),
    CONSTRAINT uq_gateway_event UNIQUE (gateway_code, transaction_ref, settlement_type),
    CONSTRAINT chk_sale_net CHECK (
        settlement_type <> 'SALE'
        OR ABS(net_amount - (gross_amount - gateway_fee - fee_vat_amount)) <= 0.01
    )
);
CREATE INDEX ix_gw_batch    ON raw_gateway_settlements (batch_id);
CREATE INDEX ix_gw_gst_date ON raw_gateway_settlements (settlement_date_gst);

-- ---------------------------------------------------------------
-- b) Ledger side: invoices as booked in the internal ledger
-- ---------------------------------------------------------------
CREATE TABLE internal_ledger_invoices (
    invoice_id        BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    invoice_number    VARCHAR(30)   NOT NULL UNIQUE,
    customer_trn      CHAR(15)      CHECK (customer_trn ~ '^[0-9]{15}$'),  -- UAE TRN is 15 digits; NULL for B2C
    gateway_code      VARCHAR(20),
    gateway_txn_ref   VARCHAR(64),                                         -- soft reference: orphans must be representable
    merchant_order_ref VARCHAR(64),
    payment_rail      VARCHAR(20),
    gross_amount      NUMERIC(14,2) NOT NULL CHECK (gross_amount > 0),     -- VAT-inclusive
    vat_amount_aed    NUMERIC(14,2) NOT NULL,
    net_of_vat_amount NUMERIC(14,2) GENERATED ALWAYS AS (gross_amount - vat_amount_aed) STORED,
    payment_status    payment_status_t NOT NULL DEFAULT 'PENDING',
    issued_at         TIMESTAMPTZ   NOT NULL,
    posting_date_gst  DATE          NOT NULL,   -- GL posting date; the legacy ERP stamps this from the server clock (UTC) for some entities
    created_at        TIMESTAMPTZ   NOT NULL DEFAULT now(),
    CONSTRAINT chk_vat_5pct CHECK (ABS(vat_amount_aed - ROUND(gross_amount / 1.05 * 0.05, 2)) <= 0.01)
);
CREATE INDEX ix_ledger_txn  ON internal_ledger_invoices (gateway_code, gateway_txn_ref);
CREATE INDEX ix_ledger_post ON internal_ledger_invoices (posting_date_gst);

-- ---------------------------------------------------------------
-- c) Exception register: append-only audit of every recon break
-- ---------------------------------------------------------------
CREATE TABLE recon_exceptions_audit (
    exception_id           BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    settlement_id          BIGINT REFERENCES raw_gateway_settlements (settlement_id) ON DELETE RESTRICT,
    invoice_id             BIGINT REFERENCES internal_ledger_invoices (invoice_id)   ON DELETE RESTRICT,
    batch_id               VARCHAR(40),
    anomaly_flag           anomaly_flag_t NOT NULL,
    variance_amount        NUMERIC(14,2)  NOT NULL,           -- signed: gateway net minus expected net
    batch_net_variance_aed NUMERIC(14,2),
    resolution_owner       VARCHAR(40)    NOT NULL,
    status                 exception_status_t NOT NULL DEFAULT 'OPEN',
    dedupe_key             CHAR(32)       NOT NULL UNIQUE,    -- md5(settlement_id|invoice_id|flag): makes the job re-runnable
    detected_at            TIMESTAMPTZ    NOT NULL DEFAULT now(),
    resolved_at            TIMESTAMPTZ,
    resolution_note        TEXT,
    CONSTRAINT chk_has_side   CHECK (settlement_id IS NOT NULL OR invoice_id IS NOT NULL),
    CONSTRAINT chk_resolved   CHECK (status NOT IN ('RESOLVED','WRITTEN_OFF') OR resolved_at IS NOT NULL)
);
CREATE INDEX ix_exc_open ON recon_exceptions_audit (status, resolution_owner) WHERE status IN ('OPEN','IN_REVIEW');

-- Audit rows are never deleted; only status/resolution columns change.
REVOKE DELETE ON recon_exceptions_audit FROM PUBLIC;
