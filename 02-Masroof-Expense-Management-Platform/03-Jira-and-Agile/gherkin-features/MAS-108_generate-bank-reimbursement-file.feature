# language: en
@MAS-108 @MAS-E4 @should
Feature: Reimbursement file
  Scenario: File contains only approved, released lines
    Given 40 approved lines of which 2 are HELD_FX_REVIEW
    When the monthly payment file is generated
    Then it contains 38 payments and a control total equal to their sum

  Scenario: Invalid IBAN
    Given an employee IBAN fails the UAE 23-character check
    Then that payment is excluded and listed in the exception report

  Scenario: File regeneration
    When the file is regenerated for the same run
    Then the same payments appear with the same control total
