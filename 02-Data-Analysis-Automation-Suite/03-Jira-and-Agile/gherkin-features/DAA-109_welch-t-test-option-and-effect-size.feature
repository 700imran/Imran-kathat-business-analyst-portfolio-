# language: en
@DAA-109 @DAA-E3 @should
Feature: Group comparison
  Scenario: Welch option
    Given the groups have different variances
    When I choose Welch
    Then the t-test is run with equal_var false

  Scenario: Effect size
    Then the output includes the mean difference of the two groups
