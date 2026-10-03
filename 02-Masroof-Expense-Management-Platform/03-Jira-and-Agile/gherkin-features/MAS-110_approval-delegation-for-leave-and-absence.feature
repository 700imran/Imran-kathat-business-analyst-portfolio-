# language: en
@MAS-110 @MAS-E1 @must
Feature: Approval delegation
  Scenario: Approver on leave
    Given "Omar" is on approved leave and "Salim" is his delegate
    When a task is assigned to Omar
    Then it is assigned to Salim and the audit log records AUTO_DELEGATED

  Scenario: Delegate is also the requester
    Given Salim submitted the claim
    Then the task escalates to Omar's manager

  Scenario: No delegate configured
    Then the task stays with Omar and a reminder is sent to his manager after 2 working days
