# Decision Log

> Simulated portfolio project. Client, people and data are fictional.

| ID | Date | Decision | Options considered | Rationale | Decided by |
|---|---|---|---|---|---|
| DL-01 | 2024-10-17 | Use set-based SQL (CTE + window functions) for matching | Spreadsheet macro; ETL tool; SQL | Reproducible, testable with fixtures, runs in seconds on 26,000 rows | Controller, Eng Lead |
| DL-02 | 2024-10-22 | Webhook primary, polling fallback | Polling only; webhook only | Webhook gives speed; polling covers dropped events | Eng Lead |
| DL-03 | 2024-10-23 | Ledger-to-gateway link is a soft reference | FK to settlements | Orphans on either side must be insertable | BA, Data Eng |
| DL-04 | 2024-11-12 | Refunds and chargebacks deferred to 1.1 | Include now (+13 SP) | Protects go-live date; CR-001 | Controller |
| DL-05 | 2024-11-22 | Tolerance AED 0.50 | AED 1.00; AED 0.10 | Test data showed rounding noise below 0.30 | Finance Manager |
| DL-06 | 2024-12-18 | Grace period counted in working days | Calendar days | Weekend false positives; CR-002 | Controller |
