# language: en
@MIZ-111 @MIZ-E5 @should
Feature: Audit export
  Scenario: Export for a closed period
    Given period "2024-12" is closed
    When the auditor requests the audit export
    Then the file lists every exception with flag, variance, owner, approver, timestamps in UTC and GST, and journal reference

  Scenario: Export of an open period is watermarked
    Given period "2025-01" is still open
    When the audit export is requested
    Then every page is marked "DRAFT - period open"
