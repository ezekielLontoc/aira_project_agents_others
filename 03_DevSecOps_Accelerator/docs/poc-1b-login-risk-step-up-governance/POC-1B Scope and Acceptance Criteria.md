# POC-1B Scope and Acceptance Criteria

## Name

POC-1B - Login Risk, Step-Up Authentication, and Account Lock Governance

## Status

Phase 0 Planning Baseline

## Parent Builds

- POC-1: Institution-Aware Identity and RBAC Portal Entry
- POC-1A: Playwright Enterprise Validation and Simulation Hardening

## Scope Items

### Suspicious Login Risk Review

Detect and review suspicious login behavior.

Acceptance:

- Risk event can be created.
- Risk event includes reason, severity, source, and status.
- Security officer can review the event.
- Evidence is generated.

### Login Failure Auto-Triage

Classify failed login attempts.

Acceptance:

- Failure reason is categorized.
- Severity is assigned.
- Recommended action is generated.
- Triage evidence is recorded.

### Account Lock / Unlock Human Approval

Lock accounts after risk threshold and unlock only through human approval.

Acceptance:

- Account can be locked.
- Locked account cannot log in.
- Unlock request can be created.
- Unlock request requires approval.
- Approved unlock restores login.
- Rejected unlock keeps account locked.
- Approval audit is recorded.

### Policy-Based Step-Up Authentication

Use policy to decide when extra authentication is required.

Acceptance:

- Policy decision can require step-up.
- Step-up challenge can be created.
- Step-up success allows login.
- Step-up failure denies login.
- Policy decision evidence is recorded.

### AI-Assisted Login Incident Analysis

Generate a human-readable analysis for login incidents.

Acceptance:

- Incident summary is generated.
- Recommended action is generated.
- Evidence context is included.
- Security officer can review analysis.

## Required Deliverables

- Flyway migration scripts
- OPA/Rego policies
- Flowable approval workflow
- API contracts
- Frontend screens
- Backend APIs
- Tests
- Evidence pack
- Closure summary

## Target Score

10/10 when all acceptance gates pass.