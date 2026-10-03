# language: en
@MIZ-108 @MIZ-E4 @must
Feature: Approval with thresholds and SLA
  Scenario: Variance at the threshold needs no manager approval
    Given an exception with variance AED 5,000.00
    When the analyst proposes an adjustment
    Then the adjustment goes straight to posting

  Scenario: Variance above AED 5,000 needs the Finance Manager
    Given an exception with variance AED 5,000.01
    When the analyst proposes an adjustment
    Then a task is created for the Finance Manager
    And posting is blocked until the task is approved

  Scenario: SLA escalation
    Given an approval task has been open for 4 working hours
    When the SLA timer fires
    Then the task is escalated to the Finance Controller
    And the audit log records "SLA_ESCALATED" with the UTC timestamp

  Scenario: Requester cannot approve their own adjustment
    Given Sana proposed the adjustment
    When Sana opens the approval task
    Then the approve action is disabled

  Scenario: Rejection returns to the analyst
    When the Finance Manager rejects with comment "Need gateway confirmation"
    Then the exception returns to status IN_REVIEW
    And the comment is stored and visible to the analyst
