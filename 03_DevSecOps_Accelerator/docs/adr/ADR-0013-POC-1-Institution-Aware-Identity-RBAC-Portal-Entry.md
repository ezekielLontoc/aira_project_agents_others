# ADR-0013: POC-1 Institution-Aware Identity and RBAC Portal Entry

## Status

Proposed

## Date

2026-06-15

## Context

AIRA has completed Milestones 1-16, including the AI-native agent foundation, DevSecOps Accelerator runtime, PostgreSQL 17 persistence, security enforcement, evidence readiness, portal foundation, MVP release readiness, server-IP hardening, and Enterprise Application Factory foundation.

The next proof-of-concept should add real identity and access flow to the AIRA Portal.

The current portal is operational and protected by API-key-based runtime controls, but it does not yet provide a full user identity lifecycle, signup/request access flow, email verification, institution approval, session management, or RBAC-based post-login routing.

## Decision

AIRA will implement POC-1 as an institution-aware identity and RBAC portal entry foundation.

The flow will include public landing page, signup/request access page, email verification, institution admin approval, login, logout, session context, RBAC and institution context, role-based landing dashboards, login audit, approval audit, evidence records, and fail-closed access behavior.

## Database Scope

POC-1 will introduce or plan the following identity-related tables under aira_security:

- institution
- institution_domain
- platform_identity
- platform_identity_credential
- identity_email_verification
- identity_access_request
- identity_role_assignment
- identity_session
- identity_login_audit
- identity_approval_audit
- identity_permission_catalog
- identity_role_permission

## Security Decision

AIRA will not use open signup that immediately grants access.

Access requires email verification, institution approval, RBAC role assignment, and a valid authenticated session.

## Consequences

AIRA will move from a technical portal into a governed enterprise portal entry model.

Users will not receive access immediately after signup.

The portal will support institution-aware routing and role-based dashboards.

All login, logout, approval, denial, and unauthorized-access events will be auditable and evidence-backed.

This preserves AIRA's fail-closed, evidence-backed, enterprise-grade operating model.

---

## Microfunctions Decision

AIRA will include POC-1 Microfunctions as governed workflow functions inside the identity layer.

These Microfunctions are not separate deployable microservices in POC-1. They are small, auditable, reusable, fail-closed identity workflow functions that support signup, email verification, institution approval, login, session management, RBAC landing, logout, audit, and evidence.

POC-1 will document and prepare the following Microfunction categories:

- Signup Microfunctions
- Email Verification Microfunctions
- Institution Approval Microfunctions
- Login and Session Microfunctions
- RBAC Landing Microfunctions
- Logout Microfunctions
- Evidence Microfunctions

POC-1 will also plan these Microfunction tables:

- aira_security.identity_microfunction_catalog
- aira_security.identity_microfunction_execution

## Microfunctions Consequences

The POC-1 implementation can be decomposed into small buildable units for AIRA agents.

Each critical identity action can be validated independently.

Audit and evidence behavior can be mapped directly to workflow functions.

Fail-closed behavior can be enforced at the microfunction level.

This improves AIRA's enterprise-grade posture and makes POC-1 more agent-ready.
