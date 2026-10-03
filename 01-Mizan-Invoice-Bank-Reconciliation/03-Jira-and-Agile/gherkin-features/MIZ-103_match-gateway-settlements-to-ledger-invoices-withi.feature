# language: en
@MIZ-103 @MIZ-E2 @must
Feature: Match settlements to ledger invoices
  Background:
    Given the variance tolerance is AED 0.50

  Scenario: Exact match
    Given gateway row "TX-9001" has net AED 2,036.65 and expected net is AED 2,036.65
    When reconciliation runs
    Then "TX-9001" is tagged MATCHED and creates no exception

  Scenario: Difference within tolerance
    Given the expected net is AED 1,000.00 and the gateway net is AED 999.70
    When reconciliation runs
    Then the row is tagged MATCHED

  Scenario: Difference beyond tolerance
    Given the expected net is AED 1,000.00 and the gateway net is AED 998.90
    When reconciliation runs
    Then an exception is created with variance_amount -1.10

  Scenario: Re-issued invoice uses the latest version
    Given transaction "TX-9002" has two non-void invoices issued on 4 Nov and 6 Nov
    When reconciliation runs
    Then only the 6 Nov invoice is compared with the gateway row

  Scenario: Voided invoice is ignored
    Given the only invoice for "TX-9003" has status VOID
    When reconciliation runs
    Then the gateway row for "TX-9003" is treated as an orphaned gateway record
