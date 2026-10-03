# Known Issues

Full detail in the Review Findings document.

| ID | Severity | Summary | Backlog |
|---|---|---|---|
| F-01 | High | run_forecast is imported by task_runner.py and documented in README, forecast.md and two notebooks, but is not defined in the committed forecast_utils.py. | DAA-101 |
| F-02 | High | latest_data_utils.py calls get_latest_data() at module level (the notebook example was left in the file), so importing it, and therefore task_runner, reads the input folder and raises FileNotFoundError when the folder is empty or missing.. | DAA-102 |
| F-03 | High | task_runner calls valuation_kpis(df, predictors, target, ticker) but the function is defined as valuation_kpis(ticker_symbol, gov_bond_yield=0.07). | DAA-103 |
| F-04 | Medium | default_folder.py uses pd.read_excel / pd.read_csv without importing pandas.. | DAA-104 |
| F-05 | Medium | save_output builds the file name from os.path.basename(filepath); when the runner auto-selects the latest file, filepath is None and every task fails at the save step.. | DAA-105 |
| F-06 | Medium | Input and output folders are hard-coded to C:\Users\Dell\... | DAA-106 |
| F-07 | Medium | clean_dataframe replaces every missing numeric value with 0. | DAA-108 |
| F-08 | Medium | financial_forecast subtracts revenue x working-capital % each year as the working-capital change (a level, not a year-on-year change) and sets NPV to 10% of final-year FCF (a placeholder constant). | DAA-111 |
| F-09 | Low | compare_groups uses Student's t-test (equal variance). | DAA-109 |
| F-10 | Low | The relation task uses only the first predictor and writes the single correlation value into every row of the output.. | DAA-110 |
| F-11 | Low | The valuation flag returns Overvalued whenever earnings yield is missing, and compares against a 7% bond yield default regardless of the ticker's market.. | DAA-103 |
| F-12 | Low | No requirements file, no tests, no setup steps in README, and the entry-point notebooks contain no recorded outputs for most tasks.. | DAA-107, DAA-113 |
| F-13 | Info | README and module notes state 70-80% faster workflows, 10-15 analyst hours saved a week, 20% faster and 10-12% more accurate valuations, 30-40% better reliability. | DAA-114 |
