# Requirements Workshop - As-Is Process Mapping

> Simulated portfolio project. Client, people and data are fictional.

| Field | Value |
|---|---|
| Date / time | 15 Oct 2024, 10:00-12:00 GST |
| Facilitator / scribe | Imran Kathat |
| Attendees | Maryam Al Hosani, Karthik Raman, Sana Qureshi, Priya Menon, Omar Haddad, Daniel Okafor, Layla Siddiqui |
| Objective | Agree the As-Is process, list pain points, agree To-Be principles |

## Agenda

1. Walk the As-Is process end to end on the whiteboard (30 min)
2. Pain points and frequency (30 min)
3. Business rules: tolerance, VAT on fee, dates (30 min)
4. To-Be principles and scope boundary (30 min)

## Discussion and findings

- Analysts start at 09:00 GST and download portal files for both gateways and the bank. Four handoffs are manual: portal export, spreadsheet matching, email approval, manual journal.
- Spreadsheet matching uses exact VLOOKUP; any fee difference appears as a break, so most breaks are noise.
- Settlements after 20:00 UTC fall on the next day in GST; one ledger entity stamps UTC dates. Month-end totals never agree without manual explanation.
- Approvals happen by email reply; there is no record of who approved which variance.

## Decisions

| # | Decision | Owner |
|---|---|---|
| D1 | Tolerance starts at AED 1.00, to be reviewed after test data (later CR-003: AED 0.50) | Karthik Raman |
| D2 | Refunds and chargebacks out of 1.0 scope | Maryam Al Hosani |
| D3 | Variances above AED 5,000 need manager approval | Karthik Raman |

## Action items

| Action | Owner | Due |
|---|---|---|
| Supply three months of historical reconciliation sheets | Sana Qureshi | 16 Oct |
| Provide fee contracts per rail | Omar Haddad | 21 Oct |
| Confirm which ledger entity stamps UTC | Priya Menon | 16 Oct |
| Confirm ERP idempotency support | Daniel Okafor | 30 Oct |
