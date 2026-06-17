# POC-1B Evidence Pack

## Name

POC-1B - Login Risk, Step-Up Authentication, and Account Lock Governance

## Status

Phase 0 Planning Baseline Accepted

## Score

Phase 0: 10/10 planning baseline if validation passes.

## Parent Builds

- POC-1: Institution-Aware Identity and RBAC Portal Entry
- POC-1A: Playwright Enterprise Validation and Simulation Hardening

## Scope

POC-1B includes:

- Suspicious Login Risk Review
- Login Failure Auto-Triage
- Account Lock / Unlock Human Approval
- Policy-Based Step-Up Authentication
- AI-Assisted Login Incident Analysis
- Additive MicroFunction transaction configuration
- Flyway migrations
- OPA/Rego policies
- Flowable approval workflow
- API contracts
- Frontend screens
- Tests
- Evidence
- Documentation

## Phase 0 Outputs

- ADR
- Architecture document
- Scope and acceptance criteria
- MicroFunction catalog
- Flyway migration plan
- OPA/Rego planning policy
- Flowable unlock approval workflow plan
- API contract draft
- Frontend screen plan
- Test plan

## Phase 0 Decision

POC-1B is approved to proceed into implementation as an additive governed security capability.

## Next Phase

POC-1B Phase 1 - Database migrations, MicroFunction seed data, and policy/workflow skeleton validation.

# POC-1B Phase 1 Technical Foundation Evidence

Status: ACCEPTED

Score: 10/10 Phase 1 Technical Foundation

Phase 1 completed additive database migrations, runtime PostgreSQL validation, MicroFunction seed data, OPA/Rego policy test assets, Flowable unlock approval workflow skeleton validation, and evidence generation.

Validated runtime database schema:

- aira_security.login_risk_event
- aira_security.login_failure_triage
- aira_security.login_incident_analysis
- aira_security.account_lock
- aira_security.account_unlock_request
- aira_security.step_up_challenge
- aira_security.login_policy_decision
- aira_security.login_risk_microfunction_catalog
- aira_security.login_risk_microfunction_execution

Validated MicroFunction seed range:

- MF-LOGIN-RISK-001 through MF-LOGIN-RISK-040

Seed count:

- 40

Decision:

POC-1B Phase 1 is accepted as the additive technical foundation before backend API implementation.

# # # POC-1B Phase 2 Backend API Foundation Evidence

Status: ACCEPTED

Score: 10/10 Phase 2 Backend API Foundation

Correction note:

Phase 2 backend validation was repaired and rerun successfully. The final repair starts Node from the server working directory, handles paths with spaces correctly, uses separate stdout/stderr .txt logs, and requires real JSON evidence.

Validation result:

- PASSED

Check count:

- 23

MicroFunction count:

- 40

Policy decision count:

- 1

Decision:

POC-1B Phase 2 is accepted as the backend API foundation before frontend screen implementation.

# # # # # POC-1B Phase 3 Frontend Browser Validation Evidence

Status: ACCEPTED

Score: 10/10 Phase 3 Frontend Browser Validation

Correction note:

Phase 3 browser validation was repaired and rerun successfully. The final repair scoped Playwright to only tests/aira-poc1b-phase3-frontend.spec.js, made the incident review test self-contained, cleaned accidental non-POC-1B evidence output, and required real JSON and Playwright evidence.

Validated screens:

- security-login-risk-dashboard.html
- login-incident-review.html
- login-failure-triage.html
- account-lock-review.html
- unlock-approval.html
- step-up-auth.html

Browser validation:

- Status: PASSED
- Expected tests: 9
- Playwright status: PASSED

Decision:

POC-1B Phase 3 is accepted as the frontend screen and browser validation foundation.
