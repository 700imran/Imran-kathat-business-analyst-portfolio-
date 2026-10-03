# Jira Project Setup - MIR (Mirsad)

> Simulated portfolio project. Client, people and data are fictional.

| Setting | Value |
|---|---|
| Key / type | MIR, company-managed Scrum |
| Components | Data Engineering, Data Model, KPI, Reporting, Platform |
| Sprint | 2 weeks, Monday-Friday |
| Workflow | Backlog > Ready > In Progress > In Review > In Test > UAT > Done |

| Filter | JQL |
|---|---|
| Must remaining | `project = MIR AND "MoSCoW" = Must AND statusCategory != Done` |
| KPI stories | `project = MIR AND component = KPI` |
| Defects open | `project = MIR AND issuetype = Bug AND statusCategory != Done` |

Dashboards: burndown, velocity, defects by severity, epic progress.

## Backlog

| Key | Epic | Story | SP | MoSCoW | Sprint |
|---|---|---|---|---|---|
| MIR-101 | MIR-E1 | Python pipeline cleans messy ticket exports | 8 | Must | MIR Sprint 1 |
| MIR-102 | MIR-E1 | Quarantine rejected rows with reasons and a quality report | 5 | Must | MIR Sprint 1 |
| MIR-103 | MIR-E2 | Star schema and load | 8 | Must | MIR Sprint 2 |
| MIR-104 | MIR-E2 | Date dimension with UAE weekend and holidays | 3 | Must | MIR Sprint 1 |
| MIR-105 | MIR-E3 | Clearance velocity measure excluding weekends | 8 | Must | MIR Sprint 2 |
| MIR-106 | MIR-E3 | Daily resolution rate against incoming volume | 5 | Must | MIR Sprint 3 |
| MIR-107 | MIR-E3 | Margin variance vs budget allocation | 5 | Must | MIR Sprint 3 |
| MIR-108 | MIR-E4 | Executive Power BI dashboard | 8 | Must | MIR Sprint 4 |
| MIR-109 | MIR-E4 | Excel resource-utilization workbook | 5 | Should | MIR Sprint 3 |
| MIR-110 | MIR-E4 | Row-level security and scheduled refresh | 5 | Must | MIR Sprint 4 |

Import: Settings > System > External System Import > CSV with `jira_import_MIR.csv`.
