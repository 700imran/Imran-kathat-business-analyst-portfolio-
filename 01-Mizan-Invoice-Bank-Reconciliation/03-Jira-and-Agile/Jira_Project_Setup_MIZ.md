# Jira Project Setup - MIZ (Mizan Reconciliation)

> Simulated portfolio project. Client, people and data are fictional.

| Setting | Value |
|---|---|
| Project key / type | MIZ, company-managed Scrum |
| Issue types | Epic, Story, Task, Sub-task, Bug |
| Components | Ingestion, Matching, Exceptions, Approvals, ERP Integration, Reporting |
| Estimation | Story points (Fibonacci 1, 2, 3, 5, 8, 13) |
| Sprint length | 2 weeks (Monday to Friday; UAE weekend Saturday-Sunday) |

## Workflow

`Backlog -> Ready (meets DoR) -> In Progress -> In Review -> In Test -> UAT -> Done`
Blocked is a flag, not a status. Transition rules: In Progress to In Review requires a linked PR; UAT to Done requires Product Owner as approver.

## Custom fields

Business rule IDs (BRL-xx), Requirement ID (BR/FR/NFR), MoSCoW, UAT case ID, Severity (S1-S4).

## Boards and filters

| Item | JQL |
|---|---|
| Sprint board | `project = MIZ AND sprint in openSprints()` |
| Must-have remaining | `project = MIZ AND "MoSCoW" = Must AND statusCategory != Done` |
| Open defects by severity | `project = MIZ AND issuetype = Bug AND statusCategory != Done ORDER BY Severity` |
| Stories without Gherkin | `project = MIZ AND issuetype = Story AND description !~ "Scenario"` |
| UAT failures | `project = MIZ AND labels = uat-fail` |

## Dashboard gadgets

Sprint burndown, velocity chart, created vs resolved, defects by severity (pie), epic progress, filter results for Must-have remaining.

## Automation rules

1. When a Bug is created with Severity S1, set priority Highest and notify the Engineering Lead and Product Owner.
2. When all sub-tasks of a story are Done, transition the story to In Review.
3. When a story moves to Done, comment the sprint and add label `released-v1.0` if it is in the release version.

## Backlog and sprint plan

| Rank | Key | Epic | Story | SP | MoSCoW | Sprint |
|---|---|---|---|---|---|---|
| 1 | MIZ-101 | MIZ-E1 | Webhook receiver with signature verification and idempotency | 5 | Must | MIZ Sprint 1 |
| 2 | MIZ-102 | MIZ-E1 | Scheduled polling fallback for missed batches | 5 | Should | MIZ Sprint 1 |
| 3 | MIZ-103 | MIZ-E2 | Match gateway settlements to ledger invoices within tolerance | 8 | Must | MIZ Sprint 2 |
| 4 | MIZ-104 | MIZ-E2 | Price settlements against fee schedule including VAT on fee | 8 | Must | MIZ Sprint 2 |
| 5 | MIZ-105 | MIZ-E2 | Classify UTC vs GST timing differences | 5 | Must | MIZ Sprint 3 |
| 6 | MIZ-106 | MIZ-E3 | Detect orphaned records in both directions | 5 | Must | MIZ Sprint 3 |
| 7 | MIZ-107 | MIZ-E3 | Route exceptions to owners by decision table | 5 | Should | MIZ Sprint 3 |
| 8 | MIZ-108 | MIZ-E4 | In-tool approval with thresholds and SLA escalation | 8 | Must | MIZ Sprint 4 |
| 9 | MIZ-109 | MIZ-E4 | Post journal adjustments to the ERP via API with idempotency | 8 | Must | MIZ Sprint 4 |
| 10 | MIZ-110 | MIZ-E5 | Reconciliation KPI dashboard and exception tracker | 5 | Should | MIZ Sprint 5 |
| 11 | MIZ-111 | MIZ-E5 | Export reconciliation audit report for internal audit | 8 | Should | MIZ Sprint 5 |

Epic summary: MIZ-E1 Settlement Ingestion; MIZ-E2 Matching Engine & Tolerance Rules; MIZ-E3 Exception Management & Routing; MIZ-E4 Approval & Ledger Adjustment; MIZ-E5 Reconciliation Reporting & Audit. Total 70 story points over five sprints (average velocity 14).

## Import instructions

1. Jira > Settings > System > External System Import > CSV.
2. Upload `jira_import_MIZ.csv`; map Issue Id to Issue Id, Parent to Parent, Story point estimate to Story point estimate, Sprint to Sprint.
3. Epics are imported first (rows are ordered epic, then stories, then sub-tasks).
4. Gherkin acceptance criteria are in the description; the same scenarios are in `gherkin-features/*.feature`.
