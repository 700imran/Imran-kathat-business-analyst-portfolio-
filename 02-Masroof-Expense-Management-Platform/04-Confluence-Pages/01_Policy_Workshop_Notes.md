# Policy and Tax-Document Workshop

> Simulated portfolio project. Client, people and data are fictional.

| Field | Value |
|---|---|
| Date | 11 Feb 2025, 13:00-16:00 GST |
| Attendees | Reem Bakr, Joanna D'Souza, Hana Ibrahim, Tariq Mahmood, Vikram Shetty, Imran Kathat (facilitator) |
| Objective | Fix approval tiers, tax-document rules, audit and hosting needs |

## Discussion

- Policy states limits but one manager approves everything today. Tiers proposed at AED 1,000 / 3,000 / 25,000.
- Sample showed 9 of 40 receipts without TRN; VAT still claimed. Agreed: TRN validation and zero recoverable VAT when missing.
- Foreign claims converted at random rates; agreed rate rule: submission rate for thresholds, payout-date rate for reimbursement, 2% tolerance hold.
- Audit wants proof that history is unaltered; IT wants everything in a UAE region.

## Decisions

| # | Decision | Owner |
|---|---|---|
| 1 | Tiers 1,000 / 3,000 / 25,000 (later changed to 5,000 by CR-003) | Reem Bakr |
| 2 | Receipt mandatory above AED 250 | Reem Bakr |
| 3 | Hash-chained audit log, nightly verification | Hana Ibrahim, Tariq Mahmood |
| 4 | UAE-region hosting only | Tariq Mahmood |

## Actions

| Action | Owner | Due |
|---|---|---|
| Supply policy PDF and category list | Vikram Shetty | 12 Feb |
| Confirm retention periods with tax adviser | Reem Bakr | 13 Feb |
| Daily HR extract format | Aisha Farooq | 14 Feb |
