# Decision Log

> Simulated portfolio project. Client, people and data are fictional.

| ID | Date | Decision | Options | Rationale | Decided by |
|---|---|---|---|---|---|
| DL-01 | 2025-02-07 | Build core, license OCR | Buy Concur; buy Expensify; build | VAT/TRN rules, residency, ERP latency; see business case | CFO |
| DL-02 | 2025-02-12 | Approval tiers evaluated per line, not per report | Per report | Stops a high-value line hiding in a large report; aggregation rule for split claims | Controller |
| DL-03 | 2025-02-14 | Async OCR with manual fallback | Synchronous OCR | Mobile networks and peak load; claim never blocked | Eng Lead |
| DL-04 | 2025-02-18 | Hash-chained audit table plus WORM export | Third-party immutable ledger | Cost, residency, simplicity | IT Director, Audit |
| DL-05 | 2025-03-14 | Second tier raised to AED 5,000 | Keep 3,000 | Sample showed 3,000 created queue noise (CR-003) | Controller |
| DL-06 | 2025-03-12 | Per-diem deferred to release 2 | Add now (+13 SP) | Protects go-live (CR-002) | CFO, Controller |
| DL-07 | 2025-05-14 | Bank file fixed-width format | CSV | Bank requirement (CR-005) | Controller |
