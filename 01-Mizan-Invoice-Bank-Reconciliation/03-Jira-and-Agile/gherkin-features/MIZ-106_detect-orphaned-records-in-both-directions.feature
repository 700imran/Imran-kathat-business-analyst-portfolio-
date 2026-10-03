# language: en
@MIZ-106 @MIZ-E3 @must
Feature: Orphan detection
  Background:
    Given the settlement grace period is 3 working days (Monday to Friday)

  Scenario: Gateway row without a ledger invoice
    Given gateway row "TX-9100" has no matching invoice
    When reconciliation runs
    Then it is tagged ORPHANED_GATEWAY_RECORD with owner "finance-ops-recon"

  Scenario: Paid invoice with no settlement after the grace period
    Given invoice "INV-7001" is PAID and posted on Monday
    And no settlement exists by Thursday close of business
    When reconciliation runs on Friday
    Then it is tagged ORPHANED_LEDGER_RECORD with owner "revenue-accounting"

  Scenario: Weekend does not count towards the grace period
    Given invoice "INV-7002" is PAID and posted on Thursday
    When reconciliation runs on Sunday
    Then no exception is raised
    And the invoice is still inside its grace window

  Scenario: Pending invoice is not an orphan
    Given invoice "INV-7003" has status PENDING and no settlement
    Then no exception is raised
