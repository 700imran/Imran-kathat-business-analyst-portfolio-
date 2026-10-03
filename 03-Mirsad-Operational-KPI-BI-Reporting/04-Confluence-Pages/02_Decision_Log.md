# Decision Log

> Simulated portfolio project. Client, people and data are fictional.

| ID | Date | Decision | Options | Rationale | By |
|---|---|---|---|---|---|
| DL-01 | 2025-06-11 | Python pipeline for cleaning | Power Query only; Python | Testable, reusable, quarantine output; fits export schedule | BI Lead |
| DL-02 | 2025-06-18 | Median, not average, for clearance velocity | Average | Long-tail tickets distort the average | Head Fin Ops |
| DL-03 | 2025-06-25 | Raw hours in fact; weekend removal in measure | Precompute working hours | Calendar rule changes need no reload | BI Lead, BA |
| DL-04 | 2025-07-14 | Budget guarded at month grain | Allocate budget to days | Daily allocation would be invented data | Head Fin Ops |
| DL-05 | 2025-07-24 | Holidays are non-working for rate measures | Weekends only | CR-003 | Head Fin Ops |
