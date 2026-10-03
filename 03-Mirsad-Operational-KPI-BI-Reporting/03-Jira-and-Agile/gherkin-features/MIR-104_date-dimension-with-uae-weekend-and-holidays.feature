# language: en
@MIR-104 @MIR-E2 @must
Feature: Date dimension
  Scenario: UAE weekend
    Then 2025-03-08 (Saturday) and 2025-03-09 (Sunday) have is_weekend true and is_working_day false

  Scenario: Public holiday
    Given 2025-03-31 is marked as a public holiday
    Then is_working_day is false

  Scenario: ISO week starts Monday
    Then 2025-03-03 has iso_week_num 10
