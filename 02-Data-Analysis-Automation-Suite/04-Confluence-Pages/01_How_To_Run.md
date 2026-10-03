# How to Run

Prerequisites: Python 3.10 or later; packages pandas, numpy, scipy, statsmodels, scikit-learn, matplotlib, openpyxl, yfinance (a requirements file does not exist yet, DAA-107).

1. Clone the repository and open a terminal in its folder.
2. Edit the four hard-coded folder constants (DAA-106 will replace them) so that input and output folders exist on your machine.
3. Put a CSV or XLSX in the input folder.
4. In a notebook or script: `from task_runner import run_task` then `run_task("clean", "Stores.csv")`. Other tasks: scenario, relation, comparison, kpi, model.
5. The live output file appears in the output folder; answer 1 at the prompt to also keep a timestamped copy.

Known blockers on a clean checkout: see Known Issues (F-01 to F-05).
