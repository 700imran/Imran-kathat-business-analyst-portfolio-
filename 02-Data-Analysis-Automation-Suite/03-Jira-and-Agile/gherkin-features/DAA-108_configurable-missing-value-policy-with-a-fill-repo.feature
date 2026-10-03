# language: en
@DAA-108 @DAA-E3 @should
Feature: Missing-value policy
  Scenario: Leave missing values
    Given policy "leave"
    Then numeric blanks stay blank and are excluded by the statistics functions

  Scenario: Fill with median and report
    Given policy "median"
    Then blanks are filled with the column median and a report lists column, count and value used

  Scenario: Flag column
    Given option "flag"
    Then a column <name>_was_missing records which rows were filled
