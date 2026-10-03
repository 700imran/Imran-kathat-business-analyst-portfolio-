# Definition of Ready and Done

> Simulated portfolio project. Client, people and data are fictional.

## Definition of Ready (story enters a sprint)

- Story written as As a / I want / So that, linked to epic and requirement ID
- Acceptance criteria in Gherkin with at least one boundary and one negative scenario
- Business rules referenced by ID (BRL-xx); no open question blocks the story
- Estimated in Fibonacci points by the team; split if 13 or more
- Dependencies identified (ERP sandbox, fee schedules, test data)

## Definition of Done

- Code reviewed and merged; unit tests pass; Gherkin scenarios automated or executed manually with evidence
- SQL changes tested against fixture file `04_fixtures_and_assertions.sql`
- No open S1 or S2 defects on the story
- Data-quality validations (`05_data_quality_validations.sql`) return zero rows
- Documentation updated (Confluence rule page, Jira description)
- Product Owner accepted in sprint review
