# Synthetic messy operational export for Mirsad, then cleaned with ops_hygiene.py (same script as Part 3 of the portfolio).
import numpy as np, pandas as pd, random
from datetime import datetime, timedelta
rng = np.random.default_rng(20250616); random.seed(7)
TEAMS = [("FIN-OPS","Finance Operations","Finance","Dubai","Reem Khan"),("PAY-OPS","Payments Operations","Finance","Dubai","Arjun Nair"),("CS-DXB","Customer Support Dubai","Customer Operations","Dubai","Salma Idris"),
         ("CS-AUH","Customer Support Abu Dhabi","Customer Operations","Abu Dhabi","Faisal Qadir"),("FUL-DXB","Fulfilment Dubai Hub","Fulfilment","Dubai","Mariam Youssef"),("FUL-RUH","Fulfilment Riyadh","Fulfilment","Riyadh","Omar Tamimi")]
W = {"FIN-OPS": (.8, 20, 22, 1.4), "PAY-OPS": (1.0, 26, 28, 1.6), "CS-DXB": (1.3, 16, 18, 2.0), "CS-AUH": (0.7, 15, 16, 1.5), "FUL-DXB": (1.6, 30, 34, 3.2), "FUL-RUH": (0.6, 38, 36, 3.0)}
# volume weight, median hours, sd hours, margin AED per ticket scale
start, end = datetime(2025, 3, 3), datetime(2025, 5, 30)
rows = []; tid = 100000
dates = [d for d in pd.date_range(start, end) if d.weekday() < 5 or rng.random() < 0.08]
fmt_cycle = ["%d/%m/%Y %H:%M", "%Y-%m-%d %H:%M:%S", "%d-%m-%Y %H:%M", "%d %b %Y %H:%M", "%d/%m/%Y %H:%M:%S"]
for d in dates:
    for t, (w, med, sd, ms) in W.items():
        n = rng.poisson(5.5 * w * (1.15 if d.weekday() == 0 else 1.0))
        for _ in range(n):
            tid += 1
            op = datetime(d.year, d.month, d.day, int(rng.integers(7, 19)), int(rng.integers(0, 60)))
            dur = max(0.4, rng.lognormal(np.log(med), 0.55))
            res = op + timedelta(hours=float(dur))
            exp = round(float(rng.lognormal(6.0, 0.8)), 2); noise = rng.normal(0, 0.02)
            if rng.random() < 0.07: noise = rng.choice([-1, 1]) * rng.uniform(0.05, 0.3)
            act = round(exp * (1 + noise), 2); margin = round(exp * ms / 100 * rng.uniform(0.6, 1.4), 2)
            status = "Resolved" if rng.random() < 0.93 else rng.choice(["Open", "In Progress", "Pending"])
            if status != "Resolved": res = None
            if op > datetime(2025, 5, 28): status, res = "Open", None
            f1, f2 = random.choice(fmt_cycle), random.choice(fmt_cycle)
            r = dict(ticket_ref=f"T-{tid}", txn_id=f"TXN{rng.integers(1000000, 9999999)}", team_code=t, status=status, opened_at=op.strftime(f1), resolved_at="" if res is None else res.strftime(f2),
                     expected_amount=f"AED {exp:,.2f}" if rng.random() < .3 else f"{exp:.2f}", actual_amount=f"{act:,.2f}" if rng.random() < .3 else f"{act:.2f}", margin_aed=f"{margin:.2f}")
            # mess
            m = rng.random()
            if m < 0.02: r["txn_id"] = random.choice(["", "N/A", "null"])
            elif m < 0.03: r["ticket_ref"] = ""
            elif m < 0.04 and res is not None: r["resolved_at"] = (op - timedelta(hours=2)).strftime(f2)
            elif m < 0.05: r["opened_at"] = "31/02/2025 10:00"
            elif m < 0.06: r["actual_amount"] = "tbc"
            elif m < 0.065: r["status"] = "Escalated??"
            r = {k: (f" {v} " if rng.random() < 0.05 and isinstance(v, str) and v else v) for k, v in r.items()}
            rows.append(r)
df = pd.DataFrame(rows)
dup = df.sample(14, random_state=1); df = pd.concat([df, dup], ignore_index=True).sample(frac=1, random_state=3).reset_index(drop=True)
df.columns = ["Ticket Ref", " Txn ID ", "Team Code", "Status", "Opened At", "Resolved At", "Expected Amount", "Actual Amount", "Margin AED"]
if __name__ == "__main__":
    import os
    out = "/home/claude/build/p3_raw"; os.makedirs(out, exist_ok=True)
    df.to_csv(f"{out}/raw_discrepancy_tickets_export.csv", index=False); print(len(df))
