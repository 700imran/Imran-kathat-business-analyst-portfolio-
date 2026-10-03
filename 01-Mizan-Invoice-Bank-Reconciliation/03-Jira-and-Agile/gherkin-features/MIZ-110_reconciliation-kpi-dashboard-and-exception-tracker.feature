# language: en
@MIZ-110 @MIZ-E5 @should
Feature: Reconciliation KPI dashboard
  Scenario: Match rate is shown for the selected period
    Given 26,000 settlements were reconciled and 25,220 are MATCHED
    When the controller selects the month
    Then the match rate card shows 97.0%

  Scenario: Clearance velocity excludes weekends
    Given an exception opened Friday 16:00 GST and resolved Monday 10:00 GST
    Then its clearance time is 18.0 working hours

  Scenario: Daily resolution rate on a non-working day
    When the controller selects a Saturday
    Then the resolution rate card shows no value instead of 0%
