-- Masroof core schema (PostgreSQL 15). Timestamps UTC; amounts AED unless stated.
CREATE TABLE employee (employee_id BIGINT PRIMARY KEY, manager_id BIGINT REFERENCES employee, department TEXT NOT NULL, office TEXT NOT NULL, iban VARCHAR(23) CHECK (iban ~ '^AE[0-9]{21}$'));
CREATE TABLE policy_version (policy_id INT PRIMARY KEY, effective_from DATE NOT NULL UNIQUE, tier1 NUMERIC(12,2), tier2 NUMERIC(12,2), tier3 NUMERIC(12,2), CHECK (tier1 < tier2 AND tier2 < tier3));
INSERT INTO policy_version VALUES (1,'2025-05-26',1000,5000,25000);
CREATE TABLE expense_report (report_id BIGINT PRIMARY KEY, employee_id BIGINT NOT NULL REFERENCES employee, status TEXT NOT NULL, submitted_at TIMESTAMPTZ);
CREATE TABLE expense_line (
  line_id BIGINT PRIMARY KEY, report_id BIGINT NOT NULL REFERENCES expense_report, merchant TEXT NOT NULL, txn_date DATE NOT NULL,
  amount NUMERIC(14,2) NOT NULL CHECK (amount > 0), currency CHAR(3) NOT NULL,
  submission_rate NUMERIC(12,6) NOT NULL, submission_aed NUMERIC(14,2) NOT NULL, payout_aed NUMERIC(14,2),
  fx_variance_pct NUMERIC(6,2), vat_amount NUMERIC(14,2) NOT NULL DEFAULT 0, input_vat_recoverable NUMERIC(14,2) NOT NULL DEFAULT 0, status TEXT NOT NULL);
CREATE TABLE audit_event (id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, seq BIGINT NOT NULL UNIQUE, event_type TEXT NOT NULL, payload JSONB NOT NULL, actor_id BIGINT, ts_utc TIMESTAMPTZ NOT NULL DEFAULT now(), prev_hash CHAR(64) NOT NULL, record_hash CHAR(64) NOT NULL);
REVOKE UPDATE, DELETE ON audit_event FROM PUBLIC;
