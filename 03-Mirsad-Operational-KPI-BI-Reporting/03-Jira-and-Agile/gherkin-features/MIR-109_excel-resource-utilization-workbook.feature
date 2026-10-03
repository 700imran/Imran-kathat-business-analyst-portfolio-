# language: en
@MIR-109 @MIR-E4 @should
Feature: Utilization workbook
  Scenario: Utilization formula
    Given 6 FTE, 22 working days and 1,056 available hours with 900 booked hours
    Then utilization is 85.2%

  Scenario: Working days follow the calendar
    Then holiday dates are excluded from available hours
