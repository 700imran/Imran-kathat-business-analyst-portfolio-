# language: en
@DAA-112 @DAA-E4 @should
Feature: Model checks
  Scenario: Balance check
    Then assets minus liabilities minus equity is zero within 0.01 for every year

  Scenario: Cash tie-out
    Then closing cash on the balance sheet equals opening cash plus net change in cash
