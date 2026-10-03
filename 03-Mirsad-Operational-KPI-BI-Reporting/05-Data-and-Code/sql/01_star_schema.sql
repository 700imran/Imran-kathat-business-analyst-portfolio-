-- Mirsad star schema (PostgreSQL). Same structure as the Power BI model.
CREATE TABLE Dim_Date (date_key INT PRIMARY KEY, full_date DATE NOT NULL UNIQUE, year_num SMALLINT, quarter_num SMALLINT, month_num SMALLINT, month_name VARCHAR(12), year_month_key INT NOT NULL,
  iso_week_num SMALLINT, day_name VARCHAR(12), is_weekend BOOLEAN NOT NULL, is_uae_public_holiday BOOLEAN NOT NULL DEFAULT FALSE, is_working_day BOOLEAN NOT NULL);
CREATE TABLE Dim_OperationsTeam (team_key INT PRIMARY KEY, team_code VARCHAR(20) UNIQUE NOT NULL, team_name VARCHAR(80) NOT NULL, department VARCHAR(60) NOT NULL, location VARCHAR(40) NOT NULL, team_lead VARCHAR(80));
CREATE TABLE Dim_ResolutionStatus (status_key VARCHAR(20) PRIMARY KEY, status_name VARCHAR(40) NOT NULL, is_terminal BOOLEAN NOT NULL, sort_order SMALLINT NOT NULL);
CREATE TABLE Fact_DiscrepancyResolution (
  resolution_key BIGINT PRIMARY KEY, ticket_ref VARCHAR(30) NOT NULL UNIQUE, txn_id VARCHAR(64) NOT NULL,
  opened_date_key INT NOT NULL REFERENCES Dim_Date(date_key), resolved_date_key INT REFERENCES Dim_Date(date_key),
  team_key INT NOT NULL REFERENCES Dim_OperationsTeam(team_key), status_key VARCHAR(20) NOT NULL REFERENCES Dim_ResolutionStatus(status_key),
  opened_at_gst TIMESTAMP NOT NULL, resolved_at_gst TIMESTAMP, expected_amount_aed NUMERIC(14,2) NOT NULL, actual_amount_aed NUMERIC(14,2) NOT NULL,
  variance_amount_aed NUMERIC(14,2) NOT NULL, variance_pct NUMERIC(8,2), net_margin_aed NUMERIC(14,2), resolution_hours_raw NUMERIC(10,2));
CREATE TABLE Fact_BudgetAllocation (team_key INT REFERENCES Dim_OperationsTeam(team_key), year_month_key INT, budgeted_margin_aed NUMERIC(14,2) NOT NULL, PRIMARY KEY (team_key, year_month_key));
CREATE TABLE Fact_ResourceUtilization (team_key INT REFERENCES Dim_OperationsTeam(team_key), year_month_key INT, fte INT, available_hours INT, booked_hours INT, PRIMARY KEY (team_key, year_month_key));

-- Integrity checks after load: each returns zero rows when healthy
SELECT f.resolution_key FROM Fact_DiscrepancyResolution f LEFT JOIN Dim_OperationsTeam t USING (team_key) WHERE t.team_key IS NULL;
SELECT f.resolution_key FROM Fact_DiscrepancyResolution f LEFT JOIN Dim_Date d ON d.date_key = f.opened_date_key WHERE d.date_key IS NULL;
SELECT resolution_key FROM Fact_DiscrepancyResolution WHERE resolved_at_gst < opened_at_gst;
