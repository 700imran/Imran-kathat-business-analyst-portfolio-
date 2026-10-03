# language: en
@MIR-103 @MIR-E2 @must
Feature: Star schema integrity
  Scenario: Every fact row resolves to its dimensions
    When the load finishes
    Then no fact row has a team_key, status_key or opened_date_key without a matching dimension row

  Scenario: Resolved date is optional
    Given an open ticket
    Then resolved_date_key is null and the row is still loaded

  Scenario: Reload is repeatable
    When the load runs twice for the same file
    Then the fact table has the same row count
