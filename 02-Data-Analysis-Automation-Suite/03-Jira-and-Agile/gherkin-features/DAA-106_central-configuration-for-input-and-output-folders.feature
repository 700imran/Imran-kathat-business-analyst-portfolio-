# language: en
@DAA-106 @DAA-E2 @must
Feature: Configuration
  Scenario: Folders from configuration
    Given INPUT_DIR and OUTPUT_DIR are set
    Then all modules read and write only in those folders

  Scenario: Default location
    Given no configuration is set
    Then the suite uses folders next to the project and creates the output folder when first saving
