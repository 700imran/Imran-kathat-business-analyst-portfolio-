import numpy as np, pandas as pd
from datetime import datetime, timedelta

def working_hours(o, r):
    """Hours between two naive GST datetimes, with Saturday/Sunday time removed."""
    if pd.isna(o) or pd.isna(r): return np.nan
    tot = (r - o).total_seconds() / 3600
    d = o.normalize(); wk = 0.0
    while d <= r.normalize():
        if d.weekday() >= 5:
            s = max(d, o); e = min(d + timedelta(days=1), r)
            wk += max(0.0, (e - s).total_seconds() / 3600)
        d += timedelta(days=1)
    return round(tot - wk, 2)

def next_working_dt(dt, hours):
    """Add 'hours' of elapsed time but skip Sat/Sun (shift Fri/weekend landings to Monday)."""
    t = dt + timedelta(hours=hours)
    while t.weekday() >= 5: t += timedelta(days=1)
    return t
