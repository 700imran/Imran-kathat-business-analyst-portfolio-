# language: en
@DAA-111 @DAA-E4 @should
Feature: Forecast formulas
  Scenario: Working-capital change
    Given working capital is 10% of revenue and revenue grows from 1,000,000 to 1,100,000
    Then the year-1 working-capital cash outflow is 10,000

  Scenario: Reference example
    Given the published reference inputs
    Then enterprise value matches the hand calculation within 0.01
