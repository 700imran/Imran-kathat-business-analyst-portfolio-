# language: en
@MAS-105 @MAS-E2 @must
Feature: TRN validation and VAT recoverability
  Scenario: Valid UAE tax invoice
    Given a supplier invoice of AED 1,050.00 with a 15-digit TRN and VAT AED 50.00
    Then input_vat_recoverable is AED 50.00

  Scenario: Missing TRN on a UAE supplier invoice
    Given an invoice of AED 840.00 from a UAE supplier has no TRN
    Then input_vat_recoverable is AED 0.00 and the line is tagged NON_RECOVERABLE_VAT_NO_TRN

  Scenario: Simplified invoice limit
    Given a simplified tax invoice for AED 10,000.00 is attached
    Then it is accepted
    And a simplified invoice for AED 10,000.01 is flagged "FULL_TAX_INVOICE_REQUIRED"

  Scenario: Non-recoverable category
    Given the category is "Client entertainment"
    Then input VAT is recorded as non-recoverable regardless of TRN

  Scenario: Foreign supplier
    Given a EUR invoice from a German supplier
    Then VAT is recorded as AED 0.00 recoverable
