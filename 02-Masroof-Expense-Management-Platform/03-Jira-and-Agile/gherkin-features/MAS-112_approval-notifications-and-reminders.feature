# language: en
@MAS-112 @MAS-E1 @should
Feature: Notifications and reminders
  Scenario: New task notification
    When a task is assigned
    Then the approver receives a notification within 1 minute

  Scenario: Reminder before SLA
    Given a task is open for 24 working hours
    Then a reminder is sent
    And a second reminder is sent at 48 working hours

  Scenario: Daily digest
    Given an approver has 5 pending tasks
    Then one digest is sent at 08:30 GST on working days
