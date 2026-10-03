# language: en
@DAA-107 @DAA-E2 @must
Feature: Setup
  Scenario: Fresh environment
    Given a new virtual environment
    When I install requirements.txt and follow the README
    Then run_task("clean") completes on the sample file
