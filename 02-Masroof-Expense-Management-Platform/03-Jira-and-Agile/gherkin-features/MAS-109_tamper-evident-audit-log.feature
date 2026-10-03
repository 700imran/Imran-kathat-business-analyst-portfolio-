# language: en
@MAS-109 @MAS-E2 @must
Feature: Tamper-evident audit log
  Scenario: Events are chained
    When two approval events are recorded in sequence
    Then the second record stores the SHA-256 hash of the first in prev_hash

  Scenario: Tampering is detected
    Given a record was edited directly in the database
    When the nightly verification job runs
    Then it raises a P1 alert naming the first broken record

  Scenario: Application cannot update or delete
    When the application role attempts UPDATE or DELETE on the audit table
    Then the database rejects the statement

  Scenario: Daily chain head exported
    When the day closes at 00:00 GST
    Then the chain head hash is written to object storage with a 7-year lock
