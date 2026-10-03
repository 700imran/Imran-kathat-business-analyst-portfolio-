# language: en
@MAS-107 @MAS-E4 @should
Feature: ERP journal posting
  Scenario: Approved report posts once
    Given report "ER-2041" is approved
    When posting runs
    Then one journal with reference "ER-2041" exists in the ERP

  Scenario: Retry is idempotent
    Given the first post timed out after the ERP committed it
    When the retry uses the same idempotency key
    Then the ERP returns the existing journal

  Scenario: Rate limit during a 300-journal run
    Given the ERP returns HTTP 429 on journal 120
    When the service backs off and resumes
    Then journals 120 to 300 are posted and 1 to 119 are not posted again

  Scenario: Unmapped expense category
    Given category "Training" has no ledger account
    Then the journal is held with reason "ACCOUNT_UNMAPPED" and Finance is notified
