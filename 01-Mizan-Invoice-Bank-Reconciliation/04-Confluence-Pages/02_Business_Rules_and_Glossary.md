# Business Rules and Glossary

> Simulated portfolio project. Client, people and data are fictional.

## Glossary

| Term | Meaning |
|---|---|
| GST | Gulf Standard Time, UTC+4, no daylight saving |
| Gross | VAT-inclusive amount paid by the customer |
| Net (settlement) | Gross minus gateway fee minus VAT on the fee; the bank credit |
| Rail | Payment method family: CARD_VISA, CARD_MC, APPLE_PAY, AANI, UAE_DDS |
| Orphan (gateway) | Settlement row with no ledger invoice |
| Orphan (ledger) | Paid invoice with no settlement after the grace period |
| Clearance velocity | Median working hours from exception opened to resolved, weekends excluded |
| Daily resolution rate | Exceptions resolved on a day divided by exceptions opened that day, working days only |

## Business rules

| ID | Rule |
|---|---|
| BRL-01 | Expected bank credit = invoice gross - contracted fee - VAT on fee |
| BRL-02 | Contracted fee = gross x % + fixed fee, using the schedule effective on the GST settlement date |
| BRL-03 | VAT on fee = 5% of fee, rounded per row |
| BRL-05 | Match tolerance AED 0.50 on net variance |
| BRL-06 | Timing mismatch only when amounts match and dates differ by the UTC/GST boundary |
| BRL-07 | Orphan grace = 3 working days (Monday-Friday) |
| BRL-08 | Variance above AED 5,000.00 needs manager approval within 4 working hours |
| BRL-09 | Latest non-void invoice wins when an invoice is re-issued |
