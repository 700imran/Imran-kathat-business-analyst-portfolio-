# language: en
@DAA-105 @DAA-E1 @must
Feature: Save when the file is auto-selected
  Scenario: Latest-file mode
    Given run_task("clean") is called without a file path
    When the latest file is picked automatically
    Then the live output file is named after the picked file and is saved
