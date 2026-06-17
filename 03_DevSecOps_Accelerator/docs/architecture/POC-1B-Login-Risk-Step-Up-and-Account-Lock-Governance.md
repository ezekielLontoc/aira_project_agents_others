# POC-1B Architecture: Login Risk, Step-Up Authentication, and Account Lock Governance

## Purpose

POC-1B extends the POC-1 identity and RBAC system with governed login risk controls.

The goal is to detect risky login behavior, classify login failures, lock risky accounts, require human approval for unlock, trigger step-up authentication when policy requires it, and create AI-assisted incident analysis for review.

## Scope

POC-1B includes:

1. Suspicious Login Risk Review
2. Login Failure Auto-Triage
3. Account Lock / Unlock Human Approval
4. Policy-Based Step-Up Authentication
5. AI-Assisted Login Incident Analysis
6. Additive MicroFunction transaction configuration
7. Flyway migrations
8. OPA/Rego policies
9. Flowable approval workflow
10. API contracts
11. Frontend screens
12. Tests
13. Evidence
14. Documentation

## High-Level Flow

### Suspicious Login Risk Review

Login attempt -> risk signal capture -> risk scoring -> suspicious event -> security review queue -> decision evidence.

### Login Failure Auto-Triage

Failed login -> classify failure -> assign severity -> recommend action -> audit event.

### Account Lock / Unlock Human Approval

Repeated risk -> account locked -> unlock request -> approval workflow -> approve/reject -> audit evidence.

### Step-Up Authentication

Login risk detected -> policy evaluation -> step-up required -> challenge created -> challenge verified -> login allowed or denied.

### AI-Assisted Incident Analysis

Risk event -> evidence context -> incident summary -> recommended action -> security officer review.

## New Runtime Concepts

- Login risk event
- Login failure triage
- Account lock
- Unlock request
- Step-up challenge
- Login incident analysis
- Policy decision
- Login risk microfunction execution

## Roles

- SECURITY_OFFICER: reviews login risk, incidents, account locks, unlock requests.
- INSTITUTION_ADMIN: approves institution-scoped unlock requests.
- PLATFORM_ADMIN: full visibility and override.
- DEVELOPER / VIEWER / AUDITOR: may be required to complete step-up authentication.

## Non-Goals for Phase 0

Phase 0 does not implement runtime behavior. It creates the governed planning baseline, contracts, policy plan, workflow plan, MicroFunction map, test plan, evidence pack, and build commands.

## Success Criteria

POC-1B succeeds when the implemented runtime proves:

- Risk events are created.
- Login failures are triaged.
- Accounts can be locked.
- Locked accounts cannot log in.
- Unlock requires human approval.
- Approved unlock restores login.
- Step-up is required by policy.
- Step-up success allows login.
- Step-up failure denies login.
- Incident analysis is generated.
- Evidence is recorded.
- Tests pass.