# language: en
@MIR-105 @MIR-E3 @must
Feature: Clearance velocity
  Scenario: Weekend time is excluded
    Given a ticket opened Friday 16:00 GST and resolved Monday 10:00 GST
    Then its working hours are 18.0

  Scenario: Open tickets are excluded
    Given a ticket with no resolved date
    Then it is not part of the median

  Scenario: Parity with the Python pipeline
    When the measure is evaluated for March 2025
    Then it equals the median of resolution_hours_working from the pipeline within 0.1 hours

  Scenario: No resolved tickets in context
    Given a filter that selects no resolved tickets
    Then the card shows blank, not zero
