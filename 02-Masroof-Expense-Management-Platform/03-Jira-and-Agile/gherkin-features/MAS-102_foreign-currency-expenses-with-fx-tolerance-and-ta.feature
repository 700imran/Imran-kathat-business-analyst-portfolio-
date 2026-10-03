# language: en
@MAS-102 @MAS-E3 @should
Feature: Multi-currency conversion and tax-document enforcement

  Background:
    Given the FX tolerance is 2.0% and the stale-rate limit is 24 hours
    And timestamps are stored in UTC and displayed in GST (UTC+4)

  Scenario: EUR expense, rate moves within tolerance, paid at payout-date rate
    Given Ahmed submits EUR 400.00 at a stored rate of 4.0100 (AED 1,604.00)
    When the reimbursement run executes at a CBUAE rate of 4.0450
    Then the payout amount is AED 1,618.00
    And fx_variance_pct is 0.87

  Scenario: EUR expense, rate moves beyond tolerance, held for review
    Given Ahmed submitted EUR 400.00 at a stored rate of 4.0100 (AED 1,604.00)
    When the payout run executes at a CBUAE rate of 4.1200 (AED 1,648.00, +2.74%)
    Then the line status becomes "HELD_FX_REVIEW"
    And the line is excluded from the bank payment file

  Scenario: USD expense uses the peg and never triggers FX review
    Given Layla submits a line of USD 250.00 stored at 3.6725 (AED 918.13)
    When the payout run executes on any date
    Then the payout amount is AED 918.13 and fx_variance_pct is 0.00

  Scenario: Missing mandatory attachment blocks submission
    Given Layla creates a line of EUR 120.00 (AED 481.20) with no attachment
    When she selects "Submit report"
    Then submission fails with "Tax invoice or receipt required for lines above AED 250"

  Scenario: FX rate feed is stale at payout
    Given the latest CBUAE rate was fetched 31 hours before the payout run
    When the payout run starts
    Then foreign-currency lines are held with reason "FX_RATE_STALE"
    And AED lines are paid normally
