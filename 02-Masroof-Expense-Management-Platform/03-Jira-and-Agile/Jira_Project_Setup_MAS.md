# Jira Project Setup - MAS (Masroof)

> Simulated portfolio project. Client, people and data are fictional.

| Setting | Value |
|---|---|
| Key / type | MAS, company-managed Scrum |
| Issue types | Epic, Story, Task, Sub-task, Bug |
| Components | Approvals, Capture, Tax, Currency, ERP Integration, Audit, Card Feed, Mobile |
| Estimation | Fibonacci story points |
| Sprint | 2 weeks, Monday-Friday; Ramadan capacity factor 0.8 in Sprints 2-3 |

**Workflow:** Backlog > Ready > In Progress > In Review > In Test > UAT > Done (Blocked as flag). Done requires Product Owner approval for Must stories.

**Fields:** MoSCoW, Requirement ID, Business rule IDs, Severity S1-S4, UAT case.

| Filter | JQL |
|---|---|
| Release 1 scope | `project = MAS AND "MoSCoW" in (Must, Should)` |
| Stories without Gherkin | `project = MAS AND issuetype = Story AND description !~ "Scenario" AND "MoSCoW" in (Must, Should)` |
| Open defects | `project = MAS AND issuetype = Bug AND statusCategory != Done` |
| Change-request stories | `project = MAS AND labels = change-request` |

**Dashboards:** burndown, velocity, created vs resolved, defects by severity, epic progress, risk filter from RAID labels.

**Automation:** S1 bug notifies Eng Lead and PO; stories auto-move to In Review when all sub-tasks Done; label `release-1.0` on Done.

## Backlog

| Key | Epic | Story | SP | MoSCoW | Sprint |
|---|---|---|---|---|---|
| MAS-101 | MAS-E1 | Multi-tier approval for expense lines above AED 1,000 | 8 | Must | MAS Sprint 2 |
| MAS-102 | MAS-E3 | Foreign-currency expenses with FX tolerance and tax-document enforcement | 8 | Should | MAS Sprint 3 |
| MAS-103 | MAS-E1 | Approval policy configuration for administrators | 5 | Must | MAS Sprint 1 |
| MAS-104 | MAS-E2 | Receipt upload with OCR extraction | 8 | Must | MAS Sprint 1 |
| MAS-105 | MAS-E2 | TRN validation and VAT recoverability | 5 | Must | MAS Sprint 2 |
| MAS-106 | MAS-E3 | FX rate service with staleness guard | 5 | Should | MAS Sprint 3 |
| MAS-107 | MAS-E4 | Post approved expenses to the ERP as journals | 8 | Should | MAS Sprint 5 |
| MAS-108 | MAS-E4 | Generate bank reimbursement file | 5 | Should | MAS Sprint 4 |
| MAS-109 | MAS-E2 | Tamper-evident audit log | 8 | Must | MAS Sprint 4 |
| MAS-110 | MAS-E1 | Approval delegation for leave and absence | 3 | Must | MAS Sprint 2 |
| MAS-111 | MAS-E2 | Retention and e-archive of tax documents | 3 | Must | MAS Sprint 1 |
| MAS-112 | MAS-E1 | Approval notifications and reminders | 3 | Should | MAS Sprint 3 |
| MAS-113 | MAS-E5 | Match corporate card transactions to expense claims | 13 | Could | Backlog |
| MAS-114 | MAS-E6 | GPS mileage tracking and Salik toll import | 8 | Won't | Backlog |

Epics: MAS-E1 Policy-Driven Approval Workflow (Must); MAS-E2 Tax-Document Capture, Validation and Audit (Must); MAS-E3 Multi-Currency Conversion (Should); MAS-E4 ERP Posting and Reimbursement (Should); MAS-E5 Corporate Card Feed Auto-Matching (Could); MAS-E6 GPS Mileage and Toll Import (Won't).

## Import

Jira > Settings > System > External System Import > CSV. Upload `jira_import_MAS.csv`; map Issue Id, Parent, Story point estimate, Sprint. Gherkin criteria are in descriptions and in `gherkin-features/`.
