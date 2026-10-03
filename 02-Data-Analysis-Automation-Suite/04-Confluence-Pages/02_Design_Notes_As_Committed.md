# Design Notes (as committed)

These are observations from the code, not recorded decisions.

| Observation | Where | Effect |
|---|---|---|
| One runner, task chosen by a text argument | task_runner.py | Simple to call; every task shares load and clean steps |
| Cleaning is generic and applied to every dataset | primary_clean_utils.py | Consistent inputs; one rule (zero-fill) affects all statistics |
| Fixed 'live' output file plus optional archive | output_utils.py | Dashboards read a stable name; history is opt-in |
| safe_get() tries several statement labels | financial_metrics_utils.py, forecast_utils.py | Tolerates label differences between companies |
| Statements split into separate modules | cashflow_utils.py, balance_sheet_utils.py | Clean separation; not yet connected by an orchestrator |
| Console prompts for columns and tickers | analysis_target_entry.py, task_runner.py | Easy interactive use; not suitable for scheduled runs |
