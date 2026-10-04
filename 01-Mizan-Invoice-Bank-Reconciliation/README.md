# Fintech Invoice & Bank Reconciliation Workflow (Requirements, SQL, Data Validation)

> **Simulated portfolio project.** The company, people and data are fictional and results are modelled, not measured at a real client.

A Dubai marketplace settles about 26,000 card, wallet and instant-payment transactions a month through two gateways. Finance reconciled them by hand every morning: portal export, spreadsheet matching, email approval, manual journal. This project defines the requirements, business rules, process redesign and SQL validation logic to replace that.

## Deliverables

| Deliverable | File |
|---|---|
| Requirements gathering report | `01-Requirements/Mizan_Requirements_Gathering_Report.docx` |
| BRD excerpts (objectives, scope, requirements, business rules, gap analysis, RACI) | `01-Requirements/Mizan_BRD_Excerpts.docx` |
| As-Is and To-Be process workflows (BPMN 2.0) | `02-Process-and-Diagrams/` (`.drawio`, `.svg`, `.png`) |
| Prioritized sprint backlog and user stories with Gherkin acceptance criteria | `03-Jira-and-Agile/jira_import_MIZ.csv`, `gherkin-features/` (11 stories, 70 story points) |
| SQL: schema, reconciliation view (joins, CTEs, window functions), fixture tests, data-quality validations | `05-Data-and-Code/sql/` |
| Synthetic data and the script that generates and reconciles it | `05-Data-and-Code/` |
| RACI matrix, RAID log, change log, UAT cases, defect triage | `06-Governance-and-Tracking/Mizan_Governance_and_KPI_Workbook.xlsx` |
| KPI monitoring workbook and exception tracker (match rate, clearance velocity, daily resolution rate; formula-driven) | same workbook: `KPI Tracker`, `Exception Tracker`, `Daily Resolution` sheets |

## Diagrams

![As-Is process](02-Process-and-Diagrams/Mizan_BPMN_AsIs.png)

![To-Be process](02-Process-and-Diagrams/Mizan_BPMN_ToBe.png)

![Entity relationship diagram](02-Process-and-Diagrams/Mizan_ERD.png)

## Results (modelled)

- Handoffs per cycle: 4 to 0 (design outcome).
- Fee-dispute clearance in the simulated December run: 83.5 elapsed working hours (about 3.5 working days) against a 5.0-day baseline, a 30% reduction.
- Simulated December data set: 26,000 settlements, 97.4% matched, 680 exceptions flagged by timing, fee or orphan rules. The rules were run in Python (`05-Data-and-Code/synthetic_data_and_recon_simulation.py`) to mirror the SQL; the SQL itself has not been executed against a database in this repository.

## What went wrong or I would do differently

- The orphan grace period counted calendar days at first and raised weekend false positives (DEF-009). I should have asked what a working day means to the owners of orphaned records during discovery.
- The SLA timer bug (DEF-013) reached UAT because earlier tests did not cover working hours.
- Fee-dispute exceptions depend on the gateway, so their SLA is 120 working hours rather than a 24-hour target.

## Folder contents

- `01-Requirements/`
  - `Mizan_BRD_Excerpts.docx`
  - `Mizan_Requirements_Gathering_Report.docx`
- `02-Process-and-Diagrams/`
  - `Mizan_BPMN_AsIs.drawio`
  - `Mizan_BPMN_AsIs.svg`
  - `Mizan_BPMN_ToBe.drawio`
  - `Mizan_BPMN_ToBe.svg`
  - `Mizan_ERD.drawio`
  - `Mizan_ERD.svg`
- `03-Jira-and-Agile/`
  - `jira_import_MIZ.csv`
- `03-Jira-and-Agile/gherkin-features/` (12 files)
- `05-Data-and-Code/`
  - `common.py`
  - `synthetic_data_and_recon_simulation.py`
- `05-Data-and-Code/sample-data/` (4 files)
- `05-Data-and-Code/sql/`
  - `01_schema_ddl.sql`
  - `02_recon_triage_view.sql`
  - `03_recon_run_insert.sql`
  - `04_fixtures_and_assertions.sql`
  - `05_data_quality_validations.sql`
- `06-Governance-and-Tracking/`
  - `Mizan_Governance_and_KPI_Workbook.xlsx`

Jira: import `jira_import_MIZ.csv` (Settings > System > External System Import > CSV); Gherkin is in each description and in `gherkin-features/`. Diagrams: open `.drawio` in diagrams.net.
