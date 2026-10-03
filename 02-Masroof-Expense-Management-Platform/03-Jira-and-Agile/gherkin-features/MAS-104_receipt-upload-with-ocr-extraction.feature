# language: en
@MAS-104 @MAS-E2 @must
Feature: Receipt upload with OCR
  Scenario: Clear receipt is extracted within target time
    Given Fatima uploads a 1.8 MB photo of a Dubai restaurant tax invoice
    When extraction completes
    Then supplier, date, total and VAT amount are pre-filled
    And extraction finished within 6 seconds for 95% of uploads in the performance test

  Scenario: Low confidence fields need confirmation
    Given OCR reads the total with confidence 0.62
    When the report is submitted
    Then the field is marked "MANUAL_ENTRY_REQUIRED" until the employee confirms it

  Scenario: OCR times out
    Given the OCR service does not respond within 20 seconds
    Then the form opens in manual-entry mode with the receipt attached
    And no error blocks submission

  Scenario: Arabic and English mixed receipt
    Given a receipt with Arabic supplier name and English line items
    Then the supplier name is stored in UTF-8 and displayed correctly in the report

  Scenario: Oversized or wrong file type
    When a 25 MB video file is uploaded
    Then the upload is rejected with the allowed types and size limit
