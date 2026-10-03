# language: en
@MIZ-107 @MIZ-E3 @should
Feature: Exception routing
  Scenario Outline: Route by anomaly flag
    Given an exception with flag "<flag>"
    When routing runs
    Then the owner queue is "<owner>"

    Examples:
      | flag                     | owner                 |
      | TIMING_MISMATCH_TIMEZONE | finance-ops-recon     |
      | FEE_VARIANCE_BREACH      | payments-partnerships |
      | ORPHANED_LEDGER_RECORD   | revenue-accounting    |
      | ORPHANED_GATEWAY_RECORD  | finance-ops-recon     |
      | UNCLASSIFIED_VARIANCE    | recon-lead            |

  Scenario: Re-running the job does not duplicate exceptions
    Given an OPEN exception exists for settlement 5521 and flag FEE_VARIANCE_BREACH
    When the reconciliation job runs again
    Then no new exception row is created
