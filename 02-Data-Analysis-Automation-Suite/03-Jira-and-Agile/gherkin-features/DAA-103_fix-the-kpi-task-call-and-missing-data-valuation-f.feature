# language: en
@DAA-103 @DAA-E1 @must
Feature: KPI task
  Scenario: Valid ticker
    When I run run_task("kpi") and enter ticker "WMT"
    Then a one-row KPI table is saved with P/E, P/B, earnings yield and dividend yield

  Scenario: Missing earnings per share
    Given the provider returns no EPS
    Then the valuation column says "Insufficient data" instead of "Overvalued"
