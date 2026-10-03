# language: en
@MIZ-102 @MIZ-E1 @should
Feature: Polling fallback for missed batches
  Scenario: Missed webhook is detected and backfilled
    Given the gateway publishes batch "B-20241105-02" at 21:30 UTC
    And no webhook was received
    When the poller runs at its next 15-minute interval
    Then batch "B-20241105-02" is fetched from the gateway API and ingested
    And the gap is recorded in the ingestion log with source "POLL"

  Scenario: Gateway API unavailable
    Given the gateway API returns HTTP 503
    When the poller fails 3 consecutive times
    Then an alert is sent to the recon-ops channel
    And the poller continues retrying with exponential backoff capped at 60 minutes

  Scenario: Poll and webhook race does not duplicate rows
    Given a webhook and the poller deliver batch "B-20241105-02" within the same minute
    Then raw_gateway_settlements contains each transaction once
