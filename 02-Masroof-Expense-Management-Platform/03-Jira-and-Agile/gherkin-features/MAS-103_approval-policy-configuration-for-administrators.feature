# language: en
@MAS-103 @MAS-E1 @must
Feature: Approval policy configuration
  Scenario: Change a threshold with an effective date
    Given the Controller changes the second tier from AED 3,000 to AED 5,000 effective 1 March
    When a line of AED 4,000 is submitted on 28 February and another on 2 March
    Then the 28 February line follows the old policy and the 2 March line follows the new one

  Scenario: Invalid policy is rejected
    When an administrator saves tiers 5,000 then 3,000
    Then saving fails with "Tiers must be ascending"

  Scenario: Policy changes are audited
    When the Controller saves a new policy version
    Then an audit record stores old values, new values, user and UTC timestamp
