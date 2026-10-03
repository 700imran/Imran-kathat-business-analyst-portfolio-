# language: en
@MIR-106 @MIR-E3 @must
Feature: Daily resolution rate
  Scenario: Rate on a working day
    Given 20 tickets opened on Tuesday and 18 tickets resolved on Tuesday
    Then the daily resolution rate is 90%

  Scenario: Backlog burn-down above 100%
    Given 10 opened and 14 resolved on a day
    Then the rate is 140%

  Scenario: Weekend is blank
    When the filter is Saturday
    Then the measure returns blank
