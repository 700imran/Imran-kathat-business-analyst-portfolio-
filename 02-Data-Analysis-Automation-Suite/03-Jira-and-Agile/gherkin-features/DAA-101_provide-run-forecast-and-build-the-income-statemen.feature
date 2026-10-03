# language: en
@DAA-101 @DAA-E1 @must
Feature: Three-statement forecast through the runner
  Scenario: Model task returns valuation outputs
    Given opening revenue, 5 forecast years and an industry benchmark
    When I run run_task("model")
    Then an income statement, cash flow statement and balance sheet are produced for each year
    And enterprise value and net present value are returned

  Scenario: Balance sheet balances
    Given a completed forecast
    Then assets equal liabilities plus equity in every year

  Scenario: Benchmark data is unavailable
    Given the market data provider returns no statements
    Then documented fallback assumptions are used and the output says so
