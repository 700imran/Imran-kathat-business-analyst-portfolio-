# language: en
@MAS-111 @MAS-E2 @must
Feature: Retention and archive
  Scenario: Document retained for statutory period
    Given a tax invoice attached on 10 March 2025
    Then deletion is blocked until 31 December 2032 (7 years after the period end)

  Scenario: Legal hold
    When Internal Audit sets a legal hold
    Then the document cannot be deleted even after the period

  Scenario: Storage location
    Then the object is stored in the UAE region bucket
