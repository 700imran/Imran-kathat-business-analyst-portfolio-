# language: en
@DAA-102 @DAA-E1 @must
Feature: Import without side effects
  Scenario: Import on a machine without the input folder
    Given the input folder does not exist
    When I import task_runner
    Then no exception is raised and no file is read

  Scenario: Example code only runs as a script
    When I run latest_data_utils.py directly
    Then the example executes
