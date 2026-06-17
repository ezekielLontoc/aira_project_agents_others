# POC-1B Phase 2 Backend API and Service Logic

## Status

Phase 2 Backend API Foundation

## Purpose

This phase adds a backend API reference runtime for POC-1B login risk governance.

The implementation is additive and does not replace the POC-1 identity runtime.

## Implemented Capabilities

### Suspicious Login Risk Review

The API can create login risk events, assign severity from risk score, record risk reasons, and allow security review.

### Login Failure Auto-Triage

The API can triage repeated failed login attempts and recommend actions such as retry, step-up, or lock account.

### Account Lock / Unlock Human Approval

The API can lock an account, create an unlock request, approve an unlock request, reject an unlock request, and keep evidence of the decision.

### Policy-Based Step-Up Authentication

The API can create a local step-up challenge and verify the challenge before allowing login.

### AI-Assisted Login Incident Analysis

The API generates a human-readable incident summary when a high-risk login event is created.

### Policy Decision Recording

The API records policy decisions for allow, step-up, lock, deny, and review paths.

## Runtime Endpoints

- GET /health
- GET /api/v1/identity/risk/readiness
- GET /api/v1/identity/risk/microfunctions
- POST /api/v1/identity/risk/events
- GET /api/v1/identity/risk/events
- GET /api/v1/identity/risk/events/{eventId}
- POST /api/v1/identity/risk/events/{eventId}/review
- POST /api/v1/identity/risk/login-failures/triage
- GET /api/v1/identity/risk/login-failures
- GET /api/v1/identity/risk/incidents
- GET /api/v1/identity/risk/incidents/{incidentId}
- POST /api/v1/identity/risk/accounts/{identityId}/lock
- GET /api/v1/identity/risk/accounts/locked
- POST /api/v1/identity/risk/accounts/{identityId}/unlock-request
- POST /api/v1/identity/risk/unlock-requests/{requestId}/approve
- POST /api/v1/identity/risk/unlock-requests/{requestId}/reject
- POST /api/v1/identity/risk/step-up/challenges
- POST /api/v1/identity/risk/step-up/challenges/{challengeId}/verify
- GET /api/v1/identity/risk/policy-decisions

## Phase 2 Acceptance

Phase 2 is accepted when the validation harness proves:

- Readiness returns READY.
- MicroFunction catalog returns 40 keys.
- Risk event creation works.
- Risk event review works.
- Login failure triage works.
- Account lock works.
- Unlock request works.
- Unlock approval unlocks the account.
- Step-up challenge creation works.
- Step-up verification allows login.
- Policy decision records are available.
- Incident analysis is generated.
- Evidence is written.