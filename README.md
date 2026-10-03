# Imran Kathat - Business Analyst Portfolio (three projects)

> **Simulated portfolio project.** The company, people, data and results are fictional and were built to show how I work as a business analyst. Dates, volumes and benefit figures are modelled, not measured at a real client.

Three self-contained projects, each with its own folder, requirements documents, process diagrams, Jira backlog with Gherkin, Confluence pages, SQL/Python/DAX where relevant, governance workbook and a dashboard.

| # | Project | Focus | Folder |
|---|---|---|---|
| 1 | Mizan: invoice and bank reconciliation | Requirements, BPMN, SQL reconciliation, UTC/GST and VAT-on-fee rules | `01-Mizan-Invoice-Bank-Reconciliation/` |
| 2 | Masroof: expense management platform | Agile governance, build vs buy, MoSCoW, UAE VAT, FX edge cases, change control | `02-Masroof-Expense-Management-Platform/` |
| 3 | Mirsad: operational KPI and BI reporting | Data hygiene, star schema, DAX, Power BI and Excel dashboards | `03-Mirsad-Operational-KPI-BI-Reporting/` |

Each project folder has a `README.md` with the problem, approach, diagrams, results and lessons.

## Where each skill on my resume is shown

| Resume skill | Evidence in this repository |
|---|---|
| Requirements elicitation, BRD / FRD / SRS authoring | Mizan: Requirements_Gathering_Report, BRD_Excerpts; Masroof: Requirements_Gathering_Report, BRD, SRS; Mirsad: Requirements_Gathering_Report, BRD |
| User stories with Gherkin acceptance criteria | `03-Jira-and-Agile/gherkin-features/` in each project (11 + 12 + 10 feature files) |
| Business rules definition | BRD business-rules sections; Confluence business-rules pages |
| As-Is / To-Be process mapping (BPMN 2.0) | Mizan AsIs and ToBe BPMN; Masroof approval BPMN; Mirsad AsIs vs ToBe reporting; draw.io, SVG, PNG and Mermaid |
| Gap analysis | Mizan BRD section 8; Mirsad BRD section 6 |
| Scope baseline and change control | Masroof Scope Statement and Change Control Procedure; Change Log sheets in each workbook |
| UAT management | UAT plan and sign-off documents; UAT sheets in the workbooks |
| MoSCoW backlog and sprint-ready epics | Backlog sheets, Jira import CSVs, Jira setup files |
| RACI, RAID log, risk register, defect triage | Governance workbooks in `06-Governance-and-Tracking/` |
| Project charter, business case with build vs buy | Masroof: Project_Charter, Business_Case_Build_vs_Buy |
| Personas, journey map, use cases, context diagrams | Masroof personas document, journey map, use-case and context diagrams |
| SQL data validation and reconciliation | Mizan `05-Data-and-Code/sql/` (schema, triage view, fixtures, validations) |
| Python (Pandas) data cleaning | Mirsad `05-Data-and-Code/ops_hygiene.py` |
| Power BI and Excel dashboards, KPI definitions, relational models | Mirsad: DAX file, theme, star schema, data dictionary, Power BI specification, Excel dashboard; HTML dashboards in each project |
| Executive reporting, sprint delivery metrics | Masroof Executive_Status_Report and dashboard; Sprint Metrics sheets |

## Conventions

AED for money, 5% VAT, timestamps stored in UTC and reported in Gulf Standard Time (UTC+4), UAE working week Monday to Friday. People and companies are fictional. Figures marked modelled or simulated come from the synthetic data in each project.
