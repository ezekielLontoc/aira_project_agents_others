# POC-1 Evidence Pack - Institution-Aware Identity and RBAC Portal Entry

## Status

Proposed

## Purpose

This evidence pack defines the expected evidence for POC-1.

POC-1 will establish AIRA's institution-aware identity and RBAC portal entry foundation.

## Evidence Scope

The evidence pack should cover:

- Landing page created
- Signup / request access page created
- Login page created
- Pending approval page created
- RBAC route resolver created
- Institution-aware database model created
- Email verification token model created
- Access request model created
- Session model created
- Login audit model created
- Approval audit model created
- Identity APIs created
- Admin approval APIs created
- Login validation passed
- Logout validation passed
- Invalid login denied
- Unverified user denied
- Pending approval user denied
- Unauthorized dashboard access denied
- Release readiness regression passed
- Application Factory readiness regression passed
- Maven build passed
- Docker runtime rebuild passed
- GitHub push completed

## Planned Source Files

Architecture document:

- 03_DevSecOps_Accelerator/docs/architecture/POC-1-Institution-Aware-Identity-and-RBAC-Portal-Entry.md

ADR:

- 03_DevSecOps_Accelerator/docs/adr/ADR-0013-POC-1-Institution-Aware-Identity-RBAC-Portal-Entry.md

Future evidence implementation folder:

- 05_Evidence/poc-1-identity-rbac-portal-entry

## Database Evidence Target

POC-1 should provide evidence for the following tables:

- aira_security.institution
- aira_security.institution_domain
- aira_security.platform_identity
- aira_security.platform_identity_credential
- aira_security.identity_email_verification
- aira_security.identity_access_request
- aira_security.identity_role_assignment
- aira_security.identity_session
- aira_security.identity_login_audit
- aira_security.identity_approval_audit
- aira_security.identity_permission_catalog
- aira_security.identity_role_permission

## Acceptance Target

POC-1 is accepted when identity entry, signup, verification, approval, login, session, RBAC routing, audit, evidence, and fail-closed validation all pass from the server-IP runtime.

## Target Grade

10 / 10