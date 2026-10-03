# language: en
@MAS-106 @MAS-E3 @should
Feature: FX rate service
  Scenario: Fresh rate is used
    Given the rate for EUR was fetched 3 hours ago
    Then it is used for conversion

  Scenario: Rate older than 24 hours is refused
    Given the rate for EUR was fetched 31 hours ago
    Then conversion fails with "FX_RATE_STALE" and an alert is sent

  Scenario: AED lines bypass the service
    Given a line in AED
    Then no rate lookup occurs
