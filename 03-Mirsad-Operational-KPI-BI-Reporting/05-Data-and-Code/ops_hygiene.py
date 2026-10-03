#!/usr/bin/env python3
"""
ops_hygiene.py - cleans discrepancy-ticket exports for the BI star schema.

Usage:
    python ops_hygiene.py --input raw_tickets.csv --outdir ./out

Outputs:
    out/fact_discrepancy_resolution.csv   rows that passed all checks
    out/quarantine_tickets.csv            rows rejected, with quarantine_reason
"""
from __future__ import annotations

import argparse
import logging
from dataclasses import dataclass
from pathlib import Path

import numpy as np
import pandas as pd

log = logging.getLogger("ops_hygiene")

NULL_TOKENS = {"", "n/a", "na", "null", "none", "nil", "-", "--", "#n/a", "nan"}

# Day-first formats seen in the exports (UAE convention). Tried in order.
DATETIME_FORMATS = (
    "%d/%m/%Y %H:%M:%S",
    "%d/%m/%Y %H:%M",
    "%d-%m-%Y %H:%M",
    "%Y-%m-%d %H:%M:%S",
    "%Y-%m-%dT%H:%M:%S",
    "%d %b %Y %H:%M",
    "%d/%m/%Y",
    "%Y-%m-%d",
)

REQUIRED_COLUMNS = [
    "ticket_ref", "txn_id", "team_code", "status",
    "opened_at", "resolved_at", "expected_amount", "actual_amount",
]


@dataclass(frozen=True)
class Config:
    variance_outlier_pct: float = 50.0   # |variance %| above this is quarantined
    status_map: tuple = (
        ("OPEN", "OPEN"), ("IN PROGRESS", "IN_PROGRESS"), ("PENDING", "IN_PROGRESS"),
        ("RESOLVED", "RESOLVED"), ("CLOSED", "RESOLVED"), ("WRITTEN OFF", "WRITTEN_OFF"),
    )


# ---------------------------------------------------------------- load
def load_raw(path: Path) -> pd.DataFrame:
    df = pd.read_csv(
        path, dtype=str, keep_default_na=False,
        encoding="utf-8-sig", skipinitialspace=True,
    )
    df.columns = (
        df.columns.str.strip().str.lower().str.replace(r"\s+", "_", regex=True)
    )
    missing = [c for c in REQUIRED_COLUMNS if c not in df.columns]
    if missing:
        raise ValueError(f"Input is missing required columns: {missing}")
    if "margin_aed" not in df.columns:
        df["margin_aed"] = ""
    log.info("Loaded %d rows from %s", len(df), path)
    return df


# ---------------------------------------------------------------- clean
def normalise_text(df: pd.DataFrame) -> pd.DataFrame:
    """Collapse internal whitespace, trim ends, turn null-like tokens into NA."""
    out = df.copy()
    for col in out.columns:
        s = out[col].astype("string")
        s = s.str.replace(r"\s+", " ", regex=True).str.strip()
        out[col] = s.mask(s.str.lower().isin(NULL_TOKENS))
    return out


def parse_mixed_datetime(series: pd.Series) -> pd.Series:
    """Parse several datetime layouts in one column; unparseable values become NaT."""
    parsed = pd.Series(pd.NaT, index=series.index, dtype="datetime64[ns]")
    for fmt in DATETIME_FORMATS:
        todo = parsed.isna() & series.notna()
        if not todo.any():
            break
        parsed.loc[todo] = pd.to_datetime(series[todo], format=fmt, errors="coerce")
    return parsed


def parse_amount(series: pd.Series) -> pd.Series:
    """'AED 1,200.50' -> 1200.5 ; '(350.00)' -> -350.0 ; garbage -> NaN."""
    s = series.astype("string")
    s = s.str.replace(r"^\((.*)\)$", r"-\1", regex=True)
    s = s.str.replace(r"(?i)aed|[,\s]", "", regex=True)
    return pd.to_numeric(s, errors="coerce").astype("float64")


def cast_types(df: pd.DataFrame, cfg: Config) -> pd.DataFrame:
    out = df.copy()
    out["ticket_ref"] = out["ticket_ref"].str.upper()
    out["txn_id"] = out["txn_id"].str.upper()
    out["team_code"] = out["team_code"].str.upper()

    status_lookup = dict(cfg.status_map)
    out["status_key"] = out["status"].str.upper().map(status_lookup)

    out["opened_at_gst"] = parse_mixed_datetime(out["opened_at"])
    out["resolved_at_gst"] = parse_mixed_datetime(out["resolved_at"])

    for col in ("expected_amount", "actual_amount", "margin_aed"):
        out[col] = parse_amount(out[col])
    return out


# ---------------------------------------------------------------- derive
def add_variance_columns(df: pd.DataFrame) -> pd.DataFrame:
    out = df.copy()
    out["variance_amount_aed"] = (out["actual_amount"] - out["expected_amount"]).round(2)
    denom = out["expected_amount"].abs().replace(0, np.nan)
    out["variance_pct"] = (out["variance_amount_aed"] / denom * 100).round(2)
    out["resolution_hours_raw"] = (
        (out["resolved_at_gst"] - out["opened_at_gst"]).dt.total_seconds() / 3600
    ).round(2)
    return out


# ---------------------------------------------------------------- validate
def flag_anomalies(df: pd.DataFrame, cfg: Config) -> pd.DataFrame:
    checks = pd.DataFrame(index=df.index)
    checks["MISSING_TXN_ID"] = df["txn_id"].isna()
    checks["MISSING_TICKET_REF"] = df["ticket_ref"].isna()
    checks["DUPLICATE_TICKET"] = df["ticket_ref"].notna() & df.duplicated("ticket_ref", keep="first")
    checks["UNPARSEABLE_OPENED_AT"] = df["opened_at_gst"].isna()
    checks["UNKNOWN_STATUS"] = df["status_key"].isna()
    checks["AMOUNT_NOT_NUMERIC"] = df["expected_amount"].isna() | df["actual_amount"].isna()
    checks["NEGATIVE_TURNAROUND"] = df["resolution_hours_raw"] < 0
    checks["VARIANCE_OUTLIER"] = df["variance_pct"].abs() > cfg.variance_outlier_pct

    out = df.copy()
    out["quarantine_reason"] = checks.apply(
        lambda row: "|".join(row.index[row.to_numpy()]), axis=1
    )
    return out


# ---------------------------------------------------------------- export
def build_fact(clean: pd.DataFrame) -> pd.DataFrame:
    fact = clean.copy()
    fact["opened_date_key"] = fact["opened_at_gst"].dt.strftime("%Y%m%d").astype("int64")
    resolved_key = fact["resolved_at_gst"].dt.strftime("%Y%m%d")
    fact["resolved_date_key"] = pd.to_numeric(resolved_key, errors="coerce").astype("Int64")
    fact = fact.rename(columns={
        "txn_id": "txn_id",
        "team_code": "team_code",
        "expected_amount": "expected_amount_aed",
        "actual_amount": "actual_amount_aed",
        "margin_aed": "net_margin_aed",
    })
    cols = [
        "ticket_ref", "txn_id", "opened_date_key", "resolved_date_key",
        "team_code", "status_key", "opened_at_gst", "resolved_at_gst",
        "expected_amount_aed", "actual_amount_aed", "variance_amount_aed",
        "variance_pct", "net_margin_aed", "resolution_hours_raw",
    ]
    return fact[cols].sort_values("opened_at_gst").reset_index(drop=True)


def run(input_path: Path, outdir: Path, cfg: Config) -> None:
    outdir.mkdir(parents=True, exist_ok=True)

    df = load_raw(input_path)
    df = normalise_text(df)
    df = cast_types(df, cfg)
    df = add_variance_columns(df)
    df = flag_anomalies(df, cfg)

    is_bad = df["quarantine_reason"] != ""
    quarantine = df.loc[is_bad]
    fact = build_fact(df.loc[~is_bad])

    fact.to_csv(outdir / "fact_discrepancy_resolution.csv", index=False)
    quarantine.to_csv(outdir / "quarantine_tickets.csv", index=False)

    log.info("Clean rows: %d | Quarantined: %d", len(fact), len(quarantine))
    if len(quarantine):
        log.info("Quarantine breakdown:\n%s",
                 quarantine["quarantine_reason"].str.split("|").explode().value_counts().to_string())


def main() -> None:
    parser = argparse.ArgumentParser(description="Clean discrepancy ticket exports.")
    parser.add_argument("--input", required=True, type=Path)
    parser.add_argument("--outdir", default=Path("./out"), type=Path)
    parser.add_argument("--outlier-pct", default=50.0, type=float)
    args = parser.parse_args()

    logging.basicConfig(level=logging.INFO, format="%(asctime)s %(levelname)s %(message)s")
    run(args.input, args.outdir, Config(variance_outlier_pct=args.outlier_pct))


if __name__ == "__main__":
    main()
