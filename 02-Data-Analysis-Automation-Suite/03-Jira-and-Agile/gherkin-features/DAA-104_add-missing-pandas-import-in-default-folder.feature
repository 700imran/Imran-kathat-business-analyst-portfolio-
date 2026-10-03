# language: en
@DAA-104 @DAA-E1 @must
Feature: Load a named file
  Scenario: File name only
    Given "Stores.csv" exists in the configured input folder
    When load_file("Stores.csv") is called
    Then the dataframe is returned
