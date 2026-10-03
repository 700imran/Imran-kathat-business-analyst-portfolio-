# language: en
@MIZ-104 @MIZ-E2 @must
Feature: Fee schedule pricing with VAT on fee
  Scenario: Fee equals contracted schedule
    Given the schedule for CARD_VISA is 2.40% + AED 1.00
    And invoice gross is AED 5,250.00
    Then expected fee is AED 127.00 and VAT on fee is AED 6.35
    And a gateway fee of AED 127.00 with fee VAT AED 6.35 produces no breach

  Scenario: Gateway overcharges
    Given the gateway charged 2.90% + AED 1.00 on AED 5,250.00 (fee AED 153.25, VAT AED 7.66)
    When reconciliation runs
    Then the row is tagged FEE_VARIANCE_BREACH
    And fee_variance is AED 27.56
    And the owner is "payments-partnerships"

  Scenario: Schedule changes mid-month
    Given the CARD_MC rate changed from 2.50% to 2.30% effective 16 Nov
    When a settlement dated 15 Nov and one dated 17 Nov are reconciled
    Then each is priced with the rate effective on its own settlement date

  Scenario: Rail without a contracted schedule
    Given a settlement arrives on rail "AANI" with no schedule row
    When it carries a non-zero fee
    Then it is tagged FEE_VARIANCE_BREACH
