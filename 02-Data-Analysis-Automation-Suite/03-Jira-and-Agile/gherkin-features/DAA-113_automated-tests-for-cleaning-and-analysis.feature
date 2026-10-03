# language: en
@DAA-113 @DAA-E5 @should
Feature: Automated tests
  Scenario: Cleaning rules
    Given a fixture with mixed-case headers, padded text, duplicates and blanks
    Then the test asserts every rule BRL-01 to BRL-05

  Scenario: Statistics
    Given a seeded dataset with known coefficients
    Then regression coefficients are within tolerance of the known values
