# language: en
@MIR-108 @MIR-E4 @must
Feature: Executive dashboard
  Scenario: Layout
    Then the top row shows five KPI cards, the centre shows a variance trend and a department heat map, and the left rail shows date, team, status and working-day slicers

  Scenario: Slicers filter visuals but not definitions
    When the user selects team "FUL-DXB"
    Then all visuals and KPI cards update to that team

  Scenario: Accessibility
    Then every visual has alt text and colour is never the only signal
