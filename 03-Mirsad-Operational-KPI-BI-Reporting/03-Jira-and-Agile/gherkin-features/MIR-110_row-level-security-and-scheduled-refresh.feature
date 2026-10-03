# language: en
@MIR-110 @MIR-E4 @must
Feature: Security and refresh
  Scenario: Team lead sees own team only
    Given user "arjun.nair" is mapped to team PAY-OPS
    Then every visual shows only PAY-OPS rows

  Scenario: Executives see all teams
    Given user is in the Executive role
    Then all teams are visible

  Scenario: Scheduled refresh
    Then the dataset refreshes at 06:30 GST on working days

  Scenario: Refresh failure
    When a refresh fails twice
    Then an alert is sent to the BI owner
