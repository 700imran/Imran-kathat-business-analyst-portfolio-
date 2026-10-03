# language: en
@MIR-101 @MIR-E1 @must
Feature: Clean messy ticket exports
  Scenario: Mixed date formats are parsed day-first
    Given the export has opened_at values "05/03/2025 09:00", "2025-03-05 09:00:00" and "05 Mar 2025 09:00"
    When the pipeline runs
    Then all three parse to 2025-03-05 09:00 in GST

  Scenario: Whitespace and null tokens
    Given a ticket_ref of "  t-100045  " and a txn_id of "N/A"
    Then ticket_ref becomes "T-100045" and txn_id is null

  Scenario: Amount formats
    Given actual_amount values "AED 1,200.50" and "(350.00)"
    Then they cast to 1200.50 and -350.00

  Scenario: Variance columns
    Given expected 1,000.00 and actual 1,020.00
    Then variance_amount_aed is 20.00 and variance_pct is 2.00
