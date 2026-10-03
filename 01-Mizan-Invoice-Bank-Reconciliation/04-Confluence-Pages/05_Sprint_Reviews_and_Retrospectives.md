# Sprint Reviews and Retrospectives

> Simulated portfolio project. Client, people and data are fictional.

| Sprint | Dates | Committed SP | Completed SP | Focus |
|---|---|---|---|---|
| Sprint 0 - Discovery | 2024-10-07 to 2024-10-18 | 0 | 0 | Elicitation, baseline, BRD v0.1 |
| MIZ Sprint 1 | 2024-10-21 to 2024-11-01 | 10 | 10 | Webhook and polling ingestion |
| MIZ Sprint 2 | 2024-11-04 to 2024-11-15 | 16 | 16 | Matching and fee pricing |
| MIZ Sprint 3 | 2024-11-18 to 2024-11-29 | 15 | 15 | Timing, orphans, routing |
| MIZ Sprint 4 | 2024-12-02 to 2024-12-13 | 16 | 16 | Approvals and ERP posting (National Day 2-3 Dec) |
| MIZ Sprint 5 | 2024-12-16 to 2024-12-27 | 13 | 13 | Dashboard, audit export, hardening |

## Retrospective highlights

| Sprint | Went well | To improve | Action |
|---|---|---|---|
| 2 | Fixture-based tests caught the re-issued invoice defect early | Fee schedule data arrived late | BA chases contract data one sprint ahead |
| 3 | Timing rule explained 55% of old breaks | Stories sized too large | Split anything above 8 points |
| 4 | Idempotency design avoided double posting | National Day reduced capacity | Capacity planning includes public holidays |
| 5 | UAT cases prepared from Gherkin | SLA timer bug found only in UAT (DEF-013) | Add working-hours timer test to SIT |
