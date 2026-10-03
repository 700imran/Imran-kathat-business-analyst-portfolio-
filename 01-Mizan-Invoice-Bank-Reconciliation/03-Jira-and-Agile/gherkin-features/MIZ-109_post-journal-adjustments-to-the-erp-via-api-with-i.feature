# language: en
@MIZ-109 @MIZ-E4 @must
Feature: ERP journal posting
  Scenario: Approved adjustment is posted once
    Given an approved adjustment with exception_id 8841
    When the posting service runs
    Then one journal is created in the ERP with reference "EXC-8841"
    And the journal_id is stored on the exception

  Scenario: Retry after timeout does not double-post
    Given the first post for "EXC-8841" timed out after the ERP committed it
    When the service retries with the same idempotency key
    Then the ERP returns the existing journal
    And only one journal exists

  Scenario: Rate limit response
    Given the ERP returns HTTP 429 on the 38th journal of a 120-journal run
    When the service backs off and resumes
    Then journals 38 to 120 are posted
    And journals 1 to 37 are not posted again

  Scenario: Closed accounting period
    Given the ERP period for the posting date is locked
    When the service posts the journal
    Then the adjustment is held with reason "PERIOD_LOCKED"
    And the Finance Controller is notified
