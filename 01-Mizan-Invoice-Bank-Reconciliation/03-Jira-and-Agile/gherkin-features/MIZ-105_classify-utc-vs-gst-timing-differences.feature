# language: en
@MIZ-105 @MIZ-E2 @must
Feature: UTC vs GST timing classification
  Scenario: Settlement crosses midnight in Dubai
    Given a settlement at 2024-11-30 21:40 UTC
    And the ledger posting date is 2024-11-30
    And amounts match within tolerance
    When reconciliation runs
    Then settlement_date_gst is 2024-12-01
    And the row is tagged TIMING_MISMATCH_TIMEZONE

  Scenario: Month-end cut-off
    Given a settlement at 2024-12-31 20:15 UTC
    When the December close report is generated
    Then the transaction is reported in January in GST
    And the timing exception explains the difference between the two period totals

  Scenario: Amount difference is never hidden by a timing tag
    Given the dates differ by timezone and the net variance is AED 12.00
    When reconciliation runs
    Then the row is not tagged TIMING_MISMATCH_TIMEZONE
    And it is tagged FEE_VARIANCE_BREACH or UNCLASSIFIED_VARIANCE by the next rule
