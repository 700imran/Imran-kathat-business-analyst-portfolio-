"""Verification probes for data-analysis-automation-script (commit a04c40c).
Usage: python verify_core_functions.py <path-to-cloned-repo>
Runs the offline-testable functions on a seeded synthetic dataset and probes the known problem areas.
Live market-data functions (yfinance) are not exercised."""
import sys, inspect, subprocess
import numpy as np, pandas as pd
repo = sys.argv[1] if len(sys.argv) > 1 else "."
sys.path.insert(0, repo)
rng = np.random.default_rng(1); n = 60
df = pd.DataFrame({" Store ID ": range(1, n + 1), "Store Area ": rng.integers(900, 2200, n).astype(float), "Daily Customer Count": rng.integers(400, 1500, n).astype(float)})
df["Store_Sales"] = (df["Store Area "] * 20 + df["Daily Customer Count"] * 8 + rng.normal(0, 5000, n)).round(0)
df["Region"] = np.where(df.index % 2 == 0, " North", "South ")
df.loc[3, "Daily Customer Count"] = np.nan; df.loc[10, "Store_Sales"] = np.nan; df = pd.concat([df, df.iloc[[5, 6]]])
print("V-01 input rows:", len(df))
from primary_clean_utils import clean_dataframe
c = clean_dataframe(df.copy()); print("V-01 output rows:", len(c), "| columns:", list(c.columns), "| region values:", sorted(c.region.unique()))
print("V-02 zeros in store_sales after cleaning:", int((c.store_sales == 0).sum()), "| mean before (NaN skipped):", round(df.Store_Sales.mean()), "| mean after:", round(c.store_sales.mean()))
from analysis_utils import prepare_regression, check_correlation, compare_groups
m = prepare_regression(c.copy(), ["store_area", "daily_customer_count"], "store_sales"); print("V-03 R-squared:", round(m.rsquared, 3), "n:", int(m.nobs))
r, p = check_correlation(c.copy(), "store_area", "store_sales"); print("V-04 r:", round(r, 4), "p:", p)
t = compare_groups(c.copy(), "region", "store_sales", "North", "South"); print("V-05 t:", round(t.statistic, 3), "p:", round(t.pvalue, 3))
import forecast_utils
d, ev, npv = forecast_utils.financial_forecast(); print("V-06 EV:", ev, "NPV:", npv, "FCF year1:", round(d["Free Cash Flow"].iloc[0]))
r = subprocess.run([sys.executable, "-c", "import task_runner"], cwd=repo, capture_output=True, text=True); print("V-07 import task_runner:", "OK" if r.returncode == 0 else r.stderr.strip().splitlines()[-1])
print("V-08 run_forecast defined:", hasattr(forecast_utils, "run_forecast"))
import kpi_utils; print("V-09 valuation_kpis signature:", inspect.signature(kpi_utils.valuation_kpis))
import default_folder
try: default_folder.load_file("x.csv")
except Exception as e: print("V-10 load_file:", type(e).__name__, e)
import output_utils
try: output_utils.save_output(df, None, "clean")
except Exception as e: print("V-11 save_output(None):", type(e).__name__, e)
