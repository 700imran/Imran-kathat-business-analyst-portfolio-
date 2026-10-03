# language: en
@MIZ-101 @MIZ-E1 @must
Feature: Webhook settlement ingestion
  Background:
    Given the gateway "GW-A" signs webhooks with a shared secret
    And the ingestion endpoint is configured for the Asia/Dubai reporting zone

  @happy
  Scenario: Valid signed batch is ingested
    When "GW-A" posts event "settlement.batch.completed" for batch "B-20241104-01" with 412 rows
    And the HMAC signature is valid
    Then the endpoint responds 200 within 2 seconds
    And 412 rows exist in raw_gateway_settlements with batch_id "B-20241104-01"
    And settlement_date_gst is computed from settlement_utc

  @security
  Scenario: Invalid signature is rejected
    When a request arrives with an HMAC that does not match the payload
    Then the endpoint responds 401
    And no rows are written
    And a security event is logged with the source IP

  @idempotency
  Scenario: Duplicate delivery of the same batch
    Given batch "B-20241104-01" was ingested earlier
    When the gateway re-delivers the same batch with the same idempotency key
    Then the endpoint responds 200
    And the row count for the batch stays 412

  @edge
  Scenario: Malformed row goes to the dead-letter queue
    When a batch arrives where row 37 has a null transaction_ref
    Then rows 1-36 and 38-n are ingested
    And row 37 is written to the dead-letter queue with reason "NULL_TRANSACTION_REF"
    And an alert is posted to the recon-ops channel
