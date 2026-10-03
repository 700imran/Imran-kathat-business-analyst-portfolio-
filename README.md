# Imran Kathat - Business Analyst Portfolio

Two projects, each in its own folder with requirements documents, process diagrams, a Jira backlog with Gherkin, Confluence pages and a tracking workbook.

| # | Project | Type | What it shows |
|---|---|---|---|
| 1 | [Mizan: invoice and bank reconciliation](01-Mizan-Invoice-Bank-Reconciliation/) | Simulated (fictional client, synthetic data) | Requirements, BPMN As-Is/To-Be, business rules, SQL reconciliation, change control, UAT |
| 2 | [Data Analysis Automation Suite](02-Data-Analysis-Automation-Suite/) | Real code (my repository), documented and reviewed afterwards | Python automation, reverse-engineered requirements, review findings with evidence, verification, improvement backlog |

Each project folder has a `README.md` with the approach, diagrams, results and what I would do differently.

## Where each skill is shown

| Skill | Evidence in this repository |
|---|---|
| Requirements elicitation, BRD authoring | Mizan: Requirements_Gathering_Report, BRD_Excerpts. Data Analysis Suite: Requirements_and_Scope (reverse-engineered from code) |
| User stories with Gherkin acceptance criteria | `03-Jira-and-Agile/gherkin-features/` in both projects (11 + 14 feature files) |
| Business rules definition | Mizan BRD rules catalogue; Data Analysis Suite rules extracted from code (BRL-01 to BRL-14) |
| As-Is / To-Be process mapping (BPMN 2.0) | Mizan As-Is and To-Be BPMN (draw.io, SVG, PNG, Mermaid) |
| Gap analysis | Mizan BRD section 8; Data Analysis Suite Review Findings and Gap Analysis |
| Change control | Mizan Change Log (four change requests) |
| UAT management, defect triage | Mizan UAT and defects sheets, UAT plan; Data Analysis Suite Verification Log |
| Backlog prioritisation (MoSCoW), Jira | Both projects: backlog sheets, Jira import CSVs, Jira setup guides |
| RACI, RAID log | Mizan governance workbook (RACI, RAID); Data Analysis Suite RAID sheet |
| SQL data validation and reconciliation | Mizan `05-Data-and-Code/sql/` (schema, triage view, fixtures, validations) |
| Python (Pandas) data cleaning and automation | Data Analysis Suite: the source repository, system documentation, review and verification script |
| Business KPI tracking, Excel modelling | Mizan KPI workbook and HTML dashboard (formula-driven) |
| Confluence documentation | Confluence pages in both projects |

## Not covered here

No Power BI (.pbix) report and no project charter or business case are included in this repository.

## Conventions

Project 1 uses AED, 5% VAT, UTC storage with Gulf Standard Time (UTC+4) reporting, and a Monday to Friday working week. Its people and companies are fictional and its figures are modelled. Project 2 is based on real code; figures in it come from running that code on synthetic test data, and benefit claims in the original notes are listed as unmeasured.
