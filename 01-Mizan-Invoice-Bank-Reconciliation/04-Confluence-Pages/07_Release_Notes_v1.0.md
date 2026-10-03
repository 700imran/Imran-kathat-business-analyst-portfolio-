# Release Notes - Mizan v1.0 (20 Jan 2025)

> Simulated portfolio project. Client, people and data are fictional.

## New

- Webhook ingestion with polling fallback (MIZ-101, MIZ-102)
- Matching with AED 0.50 tolerance, fee-schedule pricing, VAT on fee, UTC/GST classification (MIZ-103 to MIZ-105)
- Orphan detection, routing, approvals with SLA, ERP journal posting (MIZ-106 to MIZ-109)
- KPI dashboard, exception tracker, audit export (MIZ-110, MIZ-111)

## Changes after baseline

CR-002 working-day grace period; CR-003 tolerance AED 0.50; CR-004 AANI rail.

## Known limitations

Refunds and chargebacks are not reconciled (planned 1.1, CR-001). Multi-currency settlement not supported.

## Rollback

Disable the webhook subscription, resume manual process from the exception tracker; reconciliation SQL is read-only except for the idempotent exception insert.
