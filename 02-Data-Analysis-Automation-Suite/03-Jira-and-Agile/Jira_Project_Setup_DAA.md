# Jira Project Setup - DAA (Data Analysis Automation)

Scrum project with a single backlog; nothing is scheduled into sprints yet because this is a personal project with one contributor.

| Setting | Value |
|---|---|
| Key | DAA |
| Components | Input, Cleaning, Analysis, KPI, Forecast, Output, Config, Docs, Testing |
| Estimation | Fibonacci story points |
| Workflow | To Do > In Progress > In Review > Done |

| Filter | JQL |
|---|---|
| Fix first | `project = DAA AND priority in (Highest, High) AND statusCategory != Done ORDER BY Rank` |
| By finding | `project = DAA AND labels = bug` |
| Test and evidence work | `project = DAA AND component = Testing` |

## Backlog (61 story points, all To Do)

| Rank | Key | Epic | Story | SP | MoSCoW | Priority |
|---|---|---|---|---|---|---|
| 1 | DAA-101 | DAA-E1 | Provide run_forecast and build the income statement | 13 | Must | Highest |
| 2 | DAA-102 | DAA-E1 | Remove import-time side effects | 2 | Must | Highest |
| 3 | DAA-103 | DAA-E1 | Fix the kpi task call and missing-data valuation flag | 3 | Must | High |
| 4 | DAA-104 | DAA-E1 | Add missing pandas import in default_folder | 2 | Must | High |
| 5 | DAA-105 | DAA-E1 | Support auto-selected files in save_output | 2 | Must | High |
| 6 | DAA-106 | DAA-E2 | Central configuration for input and output folders | 3 | Must | High |
| 7 | DAA-107 | DAA-E2 | requirements.txt and setup guide | 2 | Must | Medium |
| 8 | DAA-108 | DAA-E3 | Configurable missing-value policy with a fill report | 5 | Should | Medium |
| 9 | DAA-109 | DAA-E3 | Welch t-test option and effect size | 3 | Should | Medium |
| 10 | DAA-110 | DAA-E3 | Clear output for the relation task | 3 | Should | Low |
| 11 | DAA-111 | DAA-E4 | Correct working-capital change and NPV definition | 5 | Should | High |
| 12 | DAA-112 | DAA-E4 | Three-statement integrity checks | 8 | Should | Medium |
| 13 | DAA-113 | DAA-E5 | Automated tests for cleaning and analysis | 5 | Should | Medium |
| 14 | DAA-114 | DAA-E5 | Benchmark harness for time and effort claims | 5 | Should | Medium |

Import: Settings > System > External System Import > CSV with `jira_import_DAA.csv`. Each story's Gherkin is in its description and in `gherkin-features/`.
