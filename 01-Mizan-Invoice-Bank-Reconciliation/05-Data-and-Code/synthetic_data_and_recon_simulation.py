import numpy as np, pandas as pd
from datetime import datetime, timedelta
from common import working_hours
rng = np.random.default_rng(20241201)
N = 26000
RAILS = {"CARD_VISA": (0.0240, 1.00, .46), "CARD_MC": (0.0250, 1.00, .30), "APPLE_PAY": (0.0260, 1.00, .12), "AANI": (0.0050, 0.50, .07), "UAE_DDS": (0.0060, 0.00, .05)}
rail_names = list(RAILS); rail_p = [RAILS[r][2] for r in rail_names]
days = pd.date_range("2024-12-01", "2024-12-31")
tx_day = rng.choice(len(days), N)
amount = np.round(np.clip(rng.lognormal(5.6, 0.9, N), 25, 15000), 2)
rail = rng.choice(rail_names, N, p=rail_p)
gw_rows, led_rows = [], []
for i in range(N):
    ref = f"TX{2400000 + i}"
    d = days[tx_day[i]]
    lag = rng.choice([1, 2], p=[.7, .3])
    st_utc = d + timedelta(days=int(lag), hours=float(rng.uniform(0.3, 23.8)))
    while (st_utc + timedelta(hours=4)).weekday() >= 5: st_utc += timedelta(days=1)
    pct, fx, _ = RAILS[rail[i]]; g = amount[i]
    fee = round(g * pct + fx, 2); fvat = round(fee * 0.05, 2)
    kind = rng.random()
    breach = kind < 0.006
    if breach: fee = round(g * (pct + 0.005) + fx, 2); fvat = round(fee * 0.05, 2)
    gw = dict(transaction_ref=ref, batch_id=f"B-{st_utc:%Y%m%d}", payment_rail=rail[i], gross_amount=g, gateway_fee=fee, fee_vat_amount=fvat,
              net_amount=round(g - fee - fvat, 2), settlement_utc=st_utc)
    gst_date = (st_utc + timedelta(hours=4)).normalize(); utc_date = st_utc.normalize()
    led_post = utc_date if rng.random() < 0.09 else gst_date
    led = dict(invoice_number=f"INV-{3100000 + i}", gateway_txn_ref=ref, payment_rail=rail[i], gross_amount=g, vat_amount_aed=round(g / 1.05 * 0.05, 2),
               payment_status="PAID", posting_date_gst=led_post)
    r2 = rng.random()
    if r2 < 0.0025: led = None           # orphaned gateway record
    elif 0.0025 <= r2 < 0.0045: gw = None  # orphaned ledger record
    elif 0.0045 <= r2 < 0.0055: gw["net_amount"] = round(gw["net_amount"] - rng.choice([3.0, 7.5, 12.0, 45.0]), 2)  # unexplained short-pay
    if gw: gw_rows.append(gw)
    if led: led_rows.append(led)
gw = pd.DataFrame(gw_rows); led = pd.DataFrame(led_rows)

# ---- reconcile (mirrors 05-Data-and-Code/sql/02_reconciliation_run.sql) ----
TOL = 0.50
m = gw.merge(led, left_on="transaction_ref", right_on="gateway_txn_ref", how="outer", suffixes=("_g", "_l"), indicator=True)
m["rail"] = m["payment_rail_g"].fillna(m["payment_rail_l"])
sched = {k: (v[0], v[1]) for k, v in RAILS.items()}
def exp_net(row):
    p, f = sched[row["rail"]]; g = row["gross_amount_l"]
    fee = round(g * p + f, 2); fv = round(fee * 0.05, 2); return fee, fv, round(g - fee - fv, 2)
tags, var, ids = [], [], []
today = pd.Timestamp("2024-12-31")
for _, r in m.iterrows():
    if r["_merge"] == "left_only": tags.append("ORPHANED_GATEWAY_RECORD"); var.append(r["net_amount"]); continue
    fee, fv, en = exp_net(r)
    if r["_merge"] == "right_only":
        wd = np.busday_count(r["posting_date_gst"].date() + timedelta(days=1), (today + timedelta(days=1)).date(), weekmask="1111100")
        tags.append("ORPHANED_LEDGER_RECORD" if wd >= 3 else None); var.append(-en); continue
    nv = round(r["net_amount"] - en, 2); fvar = round((r["gateway_fee"] + r["fee_vat_amount"]) - (fee + fv), 2)
    st_utc = r["settlement_utc"]; sdu = st_utc.normalize(); sdg = (st_utc + timedelta(hours=4)).normalize()
    tz = (r["posting_date_gst"] == sdu) and (sdu != sdg)
    if abs(nv) <= TOL and tz: tags.append("TIMING_MISMATCH_TIMEZONE")
    elif abs(fvar) > TOL: tags.append("FEE_VARIANCE_BREACH")
    elif abs(nv) <= TOL: tags.append("MATCHED")
    else: tags.append("UNCLASSIFIED_VARIANCE")
    var.append(nv)
m["triage_tag"] = tags; m["variance_aed"] = var
m["settle_gst"] = (m["settlement_utc"] + pd.Timedelta(hours=4))
m["detected_date"] = m["settle_gst"].dt.normalize().fillna(m["posting_date_gst"]) + pd.Timedelta(hours=10)
exc = m[m["triage_tag"].notna() & (m["triage_tag"] != "MATCHED")].copy().reset_index(drop=True)
# exception lifecycle (simulated): resolution time depends on flag
base = {"TIMING_MISMATCH_TIMEZONE": (0.2, 0.1), "FEE_VARIANCE_BREACH": (80, 28), "ORPHANED_GATEWAY_RECORD": (30, 14), "ORPHANED_LEDGER_RECORD": (52, 20), "UNCLASSIFIED_VARIANCE": (36, 15)}
owner = {"TIMING_MISMATCH_TIMEZONE": "finance-ops-recon", "FEE_VARIANCE_BREACH": "payments-partnerships", "ORPHANED_GATEWAY_RECORD": "finance-ops-recon", "ORPHANED_LEDGER_RECORD": "revenue-accounting", "UNCLASSIFIED_VARIANCE": "recon-lead"}
res = []
for _, e in exc.iterrows():
    mu, sd = base[e["triage_tag"]]
    h = max(0.05, rng.normal(mu, sd))
    t = e["detected_date"]
    # advance by working elapsed hours skipping weekends
    rem = h
    while rem > 0:
        if t.weekday() >= 5: t = (t + pd.Timedelta(days=1)).normalize(); continue
        step = min(rem, (t.normalize() + pd.Timedelta(days=1) - t).total_seconds() / 3600)
        t += pd.Timedelta(hours=step); rem -= step
    res.append(t if t <= pd.Timestamp("2025-01-03 23:59") else pd.NaT)
exc["resolved_at_gst"] = res
exc["resolution_owner"] = exc["triage_tag"].map(owner)
exc["clearance_hours"] = [working_hours(a, b) for a, b in zip(exc["detected_date"], exc["resolved_at_gst"])]
exc["exception_id"] = [f"EXC-{8000 + i}" for i in range(len(exc))]
exc["txn_ref"] = exc["transaction_ref"].fillna(exc["gateway_txn_ref"])
exc["opened_date"] = exc["detected_date"].dt.normalize()
STATS = dict(total=len(m), matched=int((m["triage_tag"] == "MATCHED").sum()), exceptions=len(exc))
if __name__ == "__main__":
    print(STATS); print(exc["triage_tag"].value_counts())
    print("median clearance h:", exc["clearance_hours"].median(), " fee-breach median:", exc.loc[exc.triage_tag=="FEE_VARIANCE_BREACH","clearance_hours"].median())
    print("open:", exc["resolved_at_gst"].isna().sum(), "net variance sum", round(exc["variance_aed"].sum(),2))
