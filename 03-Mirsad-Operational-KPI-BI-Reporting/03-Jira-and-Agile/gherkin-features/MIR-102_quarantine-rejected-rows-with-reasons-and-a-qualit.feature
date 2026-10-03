# language: en
@MIR-102 @MIR-E1 @must
Feature: Quarantine
  Scenario: Missing transaction id
    Given a row with null txn_id
    Then it is written to quarantine_tickets.csv with reason MISSING_TXN_ID
    And it is excluded from the fact table

  Scenario: Resolved before opened
    Given resolved_at is earlier than opened_at
    Then the row is quarantined with reason NEGATIVE_TURNAROUND

  Scenario: Duplicate ticket
    Given ticket_ref "T-100045" appears twice
    Then the first row is kept and the second is quarantined as DUPLICATE_TICKET

  Scenario: Several defects on one row
    Given a row with a missing txn_id and a non-numeric amount
    Then quarantine_reason lists both reasons separated by "|"

  Scenario: Quality summary
    When the run completes
    Then the log shows clean count, quarantine count and a breakdown by reason
