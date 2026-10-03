# language: en
@DAA-110 @DAA-E3 @should
Feature: Relation output
  Scenario: Several predictors
    Given predictors "store_area" and "daily_customer_count"
    Then the output has one row per predictor with correlation and p-value
