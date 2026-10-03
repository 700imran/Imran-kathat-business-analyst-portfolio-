# UAT Plan and Sign-off

> Simulated portfolio project. Client, people and data are fictional.

**Window:** 30 Dec 2024 to 10 Jan 2025 (outside the month-end close). **Environment:** UAT with December 2024 synthetic data and ERP sandbox.

## Entry criteria

- All Must stories Done in SIT; no open S1/S2 defects
- UAT data loaded and fixtures verified
- Testers briefed; Gherkin scenarios issued as scripts

## Exit and sign-off criteria

- 100% of Must test cases executed; at least 95% passed first time or retested to pass
- No open S1 or S2 defect; S3/S4 have a dated plan
- KPI dashboard totals agree with the Controller's manual December control totals
- Product Owner and Internal Audit sign off

## Results

| Case | Story | Scenario | Result | Date |
|---|---|---|---|---|
| UAT-01 | MIZ-101 | Signed batch ingested and row count matches declared rows | Pass | 2024-12-31 |
| UAT-02 | MIZ-101 | Invalid signature rejected; no rows written | Pass | 2024-12-31 |
| UAT-03 | MIZ-102 | Missed batch is back-filled within 15 minutes | Pass | 2025-01-02 |
| UAT-04 | MIZ-103 | Exact, within-tolerance and beyond-tolerance rows classified correctly | Pass | 2025-01-02 |
| UAT-05 | MIZ-104 | Gateway overcharge detected with fee variance AED 27.56 on test row | Pass | 2025-01-02 |
| UAT-06 | MIZ-105 | 30 Nov 21:40 UTC settlement tagged as timing mismatch | Pass | 2025-01-03 |
| UAT-07 | MIZ-106 | Weekend does not consume the orphan grace period | Pass | 2025-01-03 |
| UAT-08 | MIZ-107 | Each flag lands in the correct owner queue | Pass | 2025-01-06 |
| UAT-09 | MIZ-108 | Variance of AED 5,000.01 blocks posting until manager approval | Pass | 2025-01-06 |
| UAT-10 | MIZ-108 | SLA escalation fires after 4 working hours | Fail | 2025-01-06 |
| UAT-10R | MIZ-108 | Retest SLA escalation after fix DEF-013 | Pass | 2025-01-08 |
| UAT-11 | MIZ-109 | Retry after timeout does not double-post | Pass | 2025-01-07 |
| UAT-12 | MIZ-109 | Locked ERP period holds the adjustment with reason | Pass | 2025-01-07 |
| UAT-13 | MIZ-110 | KPI cards match controller's manual December control totals | Pass | 2025-01-08 |
| UAT-14 | MIZ-111 | Audit export for closed December period complete | Pass | 2025-01-09 |

14 first-run executions: 13 passed, 1 failed (SLA escalation, DEF-013). Retest passed on 8 Jan 2025.

## Sign-off

| Role | Name (fictional) | Decision | Date |
|---|---|---|---|
| Product Owner | Maryam Al Hosani | Accepted | 2025-01-10 |
| Finance Manager | Karthik Raman | Accepted | 2025-01-10 |
| Internal Audit | Hassan Raza | Accepted | 2025-01-10 |
