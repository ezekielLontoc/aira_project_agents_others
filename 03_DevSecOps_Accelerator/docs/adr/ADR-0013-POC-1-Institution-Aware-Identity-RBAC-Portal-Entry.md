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