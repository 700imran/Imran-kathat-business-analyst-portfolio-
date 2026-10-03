# language: en
@MAS-101 @MAS-E1 @must
Feature: Tiered approval routing for expense lines

  Background:
    Given the approval policy is active with tiers at AED 1,000 / 5,000 / 25,000
    And employee "Fatima" reports to line manager "Omar", who reports to department head "Rania"

  Scenario: Line at exactly AED 1,000.00 needs one approval (boundary, inclusive)
    Given Fatima submits a single expense line of AED 1,000.00
    When the report enters approval
    Then the approval chain contains only "Omar"

  Scenario: Line at AED 1,000.01 adds the department head
    Given Fatima submits a single expense line of AED 1,000.01
    When the report enters approval
    Then the approval chain is "Omar" then "Rania"
    And "Rania" receives the task only after "Omar" approves

  Scenario: Report total is high but every line is low
    Given Fatima submits a report with 6 lines of AED 900.00 each at different merchants
    When the report enters approval
    Then each line is routed to "Omar" only

  Scenario: Same-merchant lines on the same day are aggregated
    Given Fatima submits two lines of AED 700.00 for merchant "Gulf Tech Rentals" on the same date
    When the report enters approval
    Then the combined AED 1,400.00 is evaluated against the tiers
    And the audit log records reason "SPLIT_SUSPECTED_AGGREGATED"

  Scenario: Line above AED 5,000 reaches the Finance Controller
    Given Fatima submits a line of AED 7,350.00
    When "Omar" and "Rania" have approved in sequence
    Then a task is created for the Finance Controller

  Scenario: Self-approval is blocked
    Given Omar submits an expense line of AED 1,500.00
    When the report enters approval
    Then Omar is excluded from the chain and it starts at Omar's own manager

  Scenario: Rejection stops the chain
    Given the chain is "Omar" then "Rania"
    When Omar rejects the line without a comment
    Then the reject action fails with message "Comment required"
