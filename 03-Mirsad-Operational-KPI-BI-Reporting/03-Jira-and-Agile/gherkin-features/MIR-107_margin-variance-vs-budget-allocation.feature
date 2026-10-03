# language: en
@MIR-107 @MIR-E3 @must
Feature: Margin variance vs budget
  Scenario: Month view
    Given actual margin AED 22,000 and budget AED 20,000 for a team in April
    Then margin variance % is 10.0%

  Scenario: Day view is guarded
    When the visual is at day granularity
    Then the measure returns blank

  Scenario: Zero budget
    Given budget is 0
    Then the measure returns blank, not an error
