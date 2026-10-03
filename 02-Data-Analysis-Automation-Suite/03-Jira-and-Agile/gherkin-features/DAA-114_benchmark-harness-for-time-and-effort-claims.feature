# language: en
@DAA-114 @DAA-E5 @should
Feature: Benchmark
  Scenario: Measure runtime
    Given a dataset of 50,000 rows
    When the clean task runs 5 times
    Then the median runtime is recorded in the benchmark report

  Scenario: Manual baseline
    Given the same task performed in a spreadsheet by an analyst
    Then the time taken is recorded alongside the automated run
