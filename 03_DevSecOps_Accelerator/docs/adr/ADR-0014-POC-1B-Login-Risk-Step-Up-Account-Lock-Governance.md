# ADR-0014: POC-1B Login Risk, Step-Up Authentication, and Account Lock Governance

Status: Accepted for Build Baseline

Date: 2026-06-17

## Context

POC-1 delivered institution-aware identity and RBAC portal entry. POC-1A delivered Playwright enterprise validation and simulation hardening.

The next governed capability is to strengthen the login security layer. POC-1B introduces suspicious login review, login failure auto-triage, account lock and unlock approval, policy-based step-up authentication, and AI-assisted login incident analysis.

POC-1B must be additive. It must not break POC-1 or POC-1A.

## Decision

Create POC-1B as a separate governed security extension:

POC-1B - Login Risk, Step-Up Authentication, and Account Lock Governance

This will introduce:

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

## Architectural Principles

1. Additive-only changes.
2. No destructive migration.
3. No weakening of POC-1 login or POC-1A validation.
4. Every security decision must produce evidence.
5. Every lock/unlock action must be auditable.
6. Every policy decision must be traceable.
7. High-risk login behavior must trigger governed review or step-up.
8. Human approval must control account unlock.
9. Tests must include ordered and randomized MicroFunction validation.
10. POC-1B cannot close until runtime, UI, policies, workflow, tests, and evidence all pass.

## Consequences

Positive:

- Stronger login security posture.
- Better auditability.
- Better incident response.
- Better institution-level trust.
- Better future readiness for SOC and governance workflows.

Trade-offs:

- More tables and evidence files.
- More frontend screens.
- More approval workflow complexity.
- More test cases.
- More operational retention considerations for generated evidence.

## Acceptance

POC-1B is accepted only when:

- Database migrations are additive and validated.
- OPA/Rego policy checks pass.
- Flowable unlock approval workflow is validated.
- API contracts are implemented and tested.
- Frontend screens work through browser tests.
- Login risk and account lock behavior is proven through simulation.
- MicroFunctions pass ordered and randomized validation.
- Evidence pack records all results.
- Final Playwright / API simulation passes 10/10.