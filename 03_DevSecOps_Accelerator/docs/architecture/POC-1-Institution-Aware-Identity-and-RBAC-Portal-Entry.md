# POC-1: Institution-Aware Identity and RBAC Portal Entry

## Status

Proposed for next AIRA build phase.

## Target Grade

10 / 10

## Classification

- POC-1
- Identity Foundation
- Portal Entry Experience
- Landing Page
- Signup / Request Access
- Email Verification
- Institution Approval
- Login
- Logout
- Session Management
- Institution-Aware RBAC
- Role-Based Dashboard Routing
- Audit-Backed Authentication
- Evidence-Backed Access Control
- Fail-Closed Enterprise Portal Entry

---

# 1. Executive Summary

POC-1 establishes the first real user identity, institution, and RBAC entry experience for AIRA.

AIRA has already completed Milestones 1-16, including the AI-native agent foundation, DevSecOps Accelerator, PostgreSQL 17 persistence, Tomcat 11 Docker runtime, protected APIs, governance readiness, evidence readiness, portal foundation, MVP release readiness, server-IP hardening, and the Enterprise Application Factory foundation.

POC-1 moves AIRA from a technical portal protected by a local API key into a governed enterprise portal entry model.

POC-1 is not only a login page. It is the identity entry foundation for the entire AIRA platform.

---

# 2. Current AIRA Baseline

- Milestones 1-16 complete
- AIRA Portal operational
- Server-IP runtime operational
- Protected APIs using X-AIRA-API-Key
- Agent Registry operational
- Governance readiness operational
- Evidence readiness operational
- Release readiness operational
- Application Factory foundation operational
- GitHub source of truth operational
- Fail-closed validation model operational

Current portal:

- http://192.168.179.193:9090/portal/index.html

Current Application Factory readiness API:

- http://192.168.179.193:9094/api/v1/agents/application-factory/readiness

Latest confirmed source-of-truth commit before POC-1 planning:

- 6fa5672

---

# 3. Purpose

The purpose of POC-1 is to establish a governed identity entry layer for AIRA.

POC-1 must ensure that users do not enter the AIRA operating portal unless they are known, verified, approved, assigned to an institution, assigned to a role, authorized for a route, and authenticated with a valid session.

Required capabilities:

- Public landing page
- Signup / request access page
- Email verification
- Institution approval
- Login page
- Session creation
- RBAC and institution context
- Role-based landing dashboard
- Logout
- Login audit
- Approval audit
- Evidence records
- Fail-closed access control

---

# 4. Design Principle

No identity, access, role, or institution decision should be frontend-only.

The backend must decide:

- Who the user is
- Which institution the user belongs to
- Whether the user is verified
- Whether the user is approved
- Which roles the user has
- Which permissions the user has
- Which dashboard route the user can access
- Whether the session is valid

The frontend may display and route, but it must not be the source of authority.

---

# 5. High-Level User Journey

1. User opens AIRA.
2. Public landing page loads.
3. User chooses Login or Request Access.
4. New user submits signup / request access.
5. Backend creates pending identity and verification token.
6. User verifies email.
7. Institution admin reviews and approves access.
8. User logs in.
9. Backend creates session.
10. Backend returns RBAC and institution context.
11. User lands on correct dashboard.
12. All major actions are audited and evidence-backed.

---

# 6. Public Landing Page

Recommended route:

- /portal/landing.html

Landing page should show:

- AIRA name
- AIRA purpose
- Institution-aware platform message
- Login button
- Request Access button
- Verify Email link
- Security and governance notice
- Public-safe system status summary

Landing page must not show:

- API keys
- Internal endpoints
- Protected runtime data
- Evidence records
- Governance records
- Agent details
- Application Factory details

---

# 7. Signup / Request Access Page

Recommended route:

- /portal/signup.html

Recommended signup fields:

- First Name
- Last Name
- Email
- Institution
- Institution Code or Domain
- Department / Team
- Requested Role
- Purpose / Reason for Access
- Password
- Confirm Password
- Accept Governance Policy
- Accept Terms of Use

Signup must not immediately activate full access.

Correct initial status:

- PENDING_EMAIL_VERIFICATION

Recommended generic signup response:

- If this request is eligible, verification instructions will be sent.

---

# 8. Email Verification

Recommended route:

- /portal/verify-email.html

Email verification confirms email ownership only. It does not confirm institution authorization, role assignment, or dashboard access.

Correct AIRA rule:

- Email verification confirms email ownership.
- Institution approval confirms authorization.
- RBAC assignment confirms allowed access.

Verification token rules:

- Single-use
- Time-limited
- Random
- Stored hashed in database
- Invalidated after use
- Audited
- Associated with one identity only
- Regenerated only through controlled resend flow

Recommended POC-1 expiry:

- 24 hours

Recommended production hardening expiry:

- 15 to 30 minutes for high-security deployments

---

# 9. Institution Approval

Institution approval is required because AIRA is not a public consumer app.

AIRA contains DevSecOps controls, governance records, evidence records, security audit records, agent registry, Application Factory capabilities, release readiness, and institution-level workspace context.

Institution approval confirms:

- User belongs to the institution
- User should be allowed into AIRA
- User should have a specific role
- User should receive specific permissions

Recommended admin route:

- /portal/admin/access-requests.html

If approved:

- Account becomes ACTIVE
- Institution approval flag becomes true
- Role assignment is created
- Approval audit record is created
- User receives approval notification
- User can login

If rejected:

- Account becomes REJECTED
- Approval audit record is created
- User receives generic access request update
- User cannot login

---

# 10. Login Page

Recommended route:

- /portal/login.html

Login fields:

- Email
- Password
- Institution code or tenant selector

Login success must return:

- Session token or session reference
- Identity profile
- Institution context
- Roles
- Permissions
- Landing route
- Session expiry

Login must be denied when:

- Email is not verified
- Institution approval is pending
- Account is rejected
- Account is suspended
- Account is locked
- Account is deactivated
- Role is not assigned
- Session policy fails
- Password is invalid
- Institution does not match

Detailed denial reason should be stored in audit, not exposed in full to the user.

---

# 11. Session Management

A successful login should create a governed session.

Session should include:

- Session ID
- Identity ID
- Institution ID
- Roles
- Permissions
- Landing route
- Issued at
- Expires at
- Last activity at
- Client IP
- User agent
- Session status

Recommended session statuses:

- ACTIVE
- EXPIRED
- REVOKED
- LOGGED_OUT
- LOCKED

For POC-1 local implementation, browser localStorage or sessionStorage is acceptable.

For production hardening, use secure HTTP-only cookies, CSRF protection, token rotation, idle timeout, absolute timeout, and server-side revocation.

---

# 12. Post-Login Landing Page

Recommended route:

- /portal/home.html

Purpose:

- Resolve the authenticated user's RBAC and institution context.
- Redirect the user to the correct dashboard.

Recommended endpoint:

- GET /api/v1/identity/landing-context

Example landing context response:

    {
      "userEmail": "user@example.com",
      "displayName": "AIRA Developer User",
      "institutionKey": "AIRA-DEMO-INSTITUTION",
      "institutionName": "AIRA Demo Institution",
      "roles": ["DEVELOPER"],
      "permissions": ["VIEW_APPLICATION_FACTORY", "VIEW_QUALITY_GATES", "VIEW_ASSIGNED_EVIDENCE"],
      "landingRoute": "/portal/developer-dashboard.html",
      "sessionStatus": "ACTIVE"
    }

---

# 13. Recommended Role-Based Dashboards

## Platform Admin

Route:

- /portal/admin-dashboard.html

Can access all institutions, users, global security settings, agents, governance records, evidence records, platform readiness, and system-wide Application Factory controls.

## Institution Admin

Route:

- /portal/institution-dashboard.html

Can access own institution users, access requests, institution governance, evidence, applications, workspace readiness, and role assignments.

## Developer

Route:

- /portal/developer-dashboard.html

Can access assigned projects, Application Factory, blueprint requests, generated code status, test results, CI/CD quality gates, and developer evidence.

## Security Officer

Route:

- /portal/security-dashboard.html

Can access security findings, secret controls, access audit, login audit, API key governance, risk events, and security approvals.

## Auditor / Evidence Reviewer

Route:

- /portal/evidence-dashboard.html

Can access evidence packs, traceability links, release records, audit records, read-only governance state, and compliance views.

## Viewer

Route:

- /portal/viewer-dashboard.html

Can access read-only platform status, assigned institution overview, limited evidence summary, and limited readiness summary.

---

# 14. Recommended Database Schema

Recommended schema:

- aira_security

POC-1 should add or plan the following database tables:

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

Optional future tables:

- aira_security.identity_mfa_challenge
- aira_security.identity_password_reset
- aira_security.identity_device_trust
- aira_security.identity_risk_event
- aira_security.identity_terms_acceptance
- aira_security.identity_invitation

---

# 15. Database Table Details

## 15.1 aira_security.institution

Purpose: stores institution or tenant records.

| Column | Type | Required | Key | Description |
|---|---|---|---|---|
| institution_id | UUID | Yes | PK | Unique institution identifier |
| institution_key | VARCHAR(120) | Yes | UNIQUE | Stable institution key |
| institution_name | VARCHAR(240) | Yes | | Display name |
| institution_type | VARCHAR(80) | Yes | | ENTERPRISE, SCHOOL, GOVERNMENT, INTERNAL, DEMO |
| institution_status | VARCHAR(40) | Yes | | ACTIVE, SUSPENDED, DEACTIVATED |
| primary_domain | VARCHAR(240) | No | UNIQUE | Main email/domain hint |
| country_code | VARCHAR(10) | No | | Country code |
| timezone_name | VARCHAR(120) | No | | IANA timezone |
| created_at | TIMESTAMPTZ | Yes | | Record creation time |
| updated_at | TIMESTAMPTZ | Yes | | Last update time |

## 15.2 aira_security.institution_domain

Purpose: maps approved email domains to institutions.

| Column | Type | Required | Key | Description |
|---|---|---|---|---|
| domain_id | UUID | Yes | PK | Unique domain record |
| institution_id | UUID | Yes | FK | Institution owner |
| domain_name | VARCHAR(240) | Yes | UNIQUE | Email domain |
| domain_status | VARCHAR(40) | Yes | | ACTIVE, SUSPENDED, DEACTIVATED |
| auto_match_allowed | BOOLEAN | Yes | | Whether signup can infer institution from domain |
| approval_required | BOOLEAN | Yes | | Whether admin approval is still required |
| created_at | TIMESTAMPTZ | Yes | | Record creation time |
| updated_at | TIMESTAMPTZ | Yes | | Last update time |

## 15.3 aira_security.platform_identity

Purpose: stores user identity records.

| Column | Type | Required | Key | Description |
|---|---|---|---|---|
| identity_id | UUID | Yes | PK | Unique identity identifier |
| institution_id | UUID | No | FK | Institution assigned after approval |
| email | VARCHAR(320) | Yes | UNIQUE | User email |
| normalized_email | VARCHAR(320) | Yes | UNIQUE | Lowercase canonical email |
| first_name | VARCHAR(120) | Yes | | First name |
| last_name | VARCHAR(120) | Yes | | Last name |
| display_name | VARCHAR(240) | Yes | | Display name |
| department | VARCHAR(160) | No | | Department or team |
| job_title | VARCHAR(160) | No | | Job title |
| requested_role | VARCHAR(80) | No | | Role requested during signup |
| identity_status | VARCHAR(60) | Yes | | Current identity lifecycle status |
| email_verified | BOOLEAN | Yes | | Whether email was verified |
| institution_approved | BOOLEAN | Yes | | Whether institution admin approved |
| governance_terms_accepted | BOOLEAN | Yes | | Whether governance policy accepted |
| failed_login_count | INTEGER | Yes | | Failed login counter |
| locked_until | TIMESTAMPTZ | No | | Lock expiry |
| last_login_at | TIMESTAMPTZ | No | | Last successful login |
| created_at | TIMESTAMPTZ | Yes | | Record creation time |
| updated_at | TIMESTAMPTZ | Yes | | Last update time |

Identity status values: DRAFT, PENDING_EMAIL_VERIFICATION, EMAIL_VERIFIED, PENDING_INSTITUTION_APPROVAL, ACTIVE, SUSPENDED, REJECTED, LOCKED, DEACTIVATED.

## 15.4 aira_security.platform_identity_credential

Purpose: stores password credential metadata and password hash.

| Column | Type | Required | Key | Description |
|---|---|---|---|---|
| credential_id | UUID | Yes | PK | Unique credential identifier |
| identity_id | UUID | Yes | FK | Identity owner |
| credential_type | VARCHAR(40) | Yes | | PASSWORD, SSO, API, TEMPORARY |
| password_hash | TEXT | Yes | | Password hash |
| password_algorithm | VARCHAR(80) | Yes | | BCRYPT, ARGON2ID, PBKDF2 |
| password_status | VARCHAR(40) | Yes | | ACTIVE, RESET_REQUIRED, DISABLED |
| password_changed_at | TIMESTAMPTZ | No | | Last password change |
| expires_at | TIMESTAMPTZ | No | | Optional credential expiry |
| created_at | TIMESTAMPTZ | Yes | | Record creation time |
| updated_at | TIMESTAMPTZ | Yes | | Last update time |

Recommended POC-1 algorithm: BCRYPT. Recommended production hardening: ARGON2ID where available.

## 15.5 aira_security.identity_email_verification

Purpose: stores email verification token records.

| Column | Type | Required | Key | Description |
|---|---|---|---|---|
| verification_id | UUID | Yes | PK | Unique verification record |
| identity_id | UUID | Yes | FK | Identity owner |
| token_hash | TEXT | Yes | UNIQUE | Hashed verification token |
| verification_status | VARCHAR(40) | Yes | | PENDING, USED, EXPIRED, REVOKED |
| verification_channel | VARCHAR(40) | Yes | | EMAIL |
| sent_to_email | VARCHAR(320) | Yes | | Destination email |
| expires_at | TIMESTAMPTZ | Yes | | Token expiry |
| used_at | TIMESTAMPTZ | No | | When token was used |
| created_at | TIMESTAMPTZ | Yes | | Record creation time |

## 15.6 aira_security.identity_access_request

Purpose: stores signup/request access workflow records.

| Column | Type | Required | Key | Description |
|---|---|---|---|---|
| access_request_id | UUID | Yes | PK | Unique request identifier |
| identity_id | UUID | Yes | FK | Requesting identity |
| requested_institution_key | VARCHAR(120) | No | | Institution requested by user |
| requested_institution_id | UUID | No | FK | Matched institution |
| requested_role | VARCHAR(80) | Yes | | Requested role |
| request_reason | TEXT | No | | User-provided reason |
| request_status | VARCHAR(60) | Yes | | Request lifecycle status |
| email_verified_at | TIMESTAMPTZ | No | | Time email was verified |
| reviewed_by_identity_id | UUID | No | FK | Admin reviewer |
| reviewed_at | TIMESTAMPTZ | No | | Review time |
| approval_decision | VARCHAR(40) | No | | APPROVED, REJECTED |
| approval_notes | TEXT | No | | Admin notes |
| created_at | TIMESTAMPTZ | Yes | | Record creation time |
| updated_at | TIMESTAMPTZ | Yes | | Last update time |

Request status values: PENDING_EMAIL_VERIFICATION, EMAIL_VERIFIED, PENDING_INSTITUTION_APPROVAL, APPROVED, REJECTED, CANCELLED, EXPIRED.

## 15.7 aira_security.identity_role_assignment

Purpose: assigns roles to identities within institutions.

| Column | Type | Required | Key | Description |
|---|---|---|---|---|
| role_assignment_id | UUID | Yes | PK | Unique role assignment |
| identity_id | UUID | Yes | FK | Identity |
| institution_id | UUID | Yes | FK | Institution context |
| role_key | VARCHAR(80) | Yes | | Assigned role |
| assignment_status | VARCHAR(40) | Yes | | ACTIVE, SUSPENDED, REVOKED |
| assigned_by_identity_id | UUID | No | FK | Admin who assigned role |
| assigned_at | TIMESTAMPTZ | Yes | | Assignment time |
| revoked_at | TIMESTAMPTZ | No | | Revocation time |
| created_at | TIMESTAMPTZ | Yes | | Record creation time |
| updated_at | TIMESTAMPTZ | Yes | | Last update time |

Role key values: PLATFORM_ADMIN, INSTITUTION_ADMIN, DEVELOPER, SECURITY_OFFICER, AUDITOR, VIEWER.

## 15.8 aira_security.identity_permission_catalog

Purpose: defines available permissions for POC-1 and future AIRA modules.

| Column | Type | Required | Key | Description |
|---|---|---|---|---|
| permission_key | VARCHAR(120) | Yes | PK | Permission key |
| permission_name | VARCHAR(240) | Yes | | Human-readable name |
| permission_category | VARCHAR(120) | Yes | | PORTAL, AGENTS, GOVERNANCE, EVIDENCE, FACTORY, SECURITY |
| permission_description | TEXT | Yes | | Permission description |
| permission_status | VARCHAR(40) | Yes | | ACTIVE, DEPRECATED, DISABLED |
| created_at | TIMESTAMPTZ | Yes | | Record creation time |
| updated_at | TIMESTAMPTZ | Yes | | Last update time |

Permission keys: VIEW_PORTAL, VIEW_AGENT_REGISTRY, VIEW_GOVERNANCE, VIEW_EVIDENCE, VIEW_RELEASE_READINESS, VIEW_APPLICATION_FACTORY, MANAGE_ACCESS_REQUESTS, MANAGE_ROLE_ASSIGNMENTS, VIEW_SECURITY_AUDIT, VIEW_LOGIN_AUDIT.

## 15.9 aira_security.identity_role_permission

Purpose: maps roles to permissions.

| Column | Type | Required | Key | Description |
|---|---|---|---|---|
| role_permission_id | UUID | Yes | PK | Unique mapping |
| role_key | VARCHAR(80) | Yes | | Role key |
| permission_key | VARCHAR(120) | Yes | FK | Permission |
| mapping_status | VARCHAR(40) | Yes | | ACTIVE, DISABLED |
| created_at | TIMESTAMPTZ | Yes | | Record creation time |
| updated_at | TIMESTAMPTZ | Yes | | Last update time |

## 15.10 aira_security.identity_session

Purpose: stores authenticated user sessions.

| Column | Type | Required | Key | Description |
|---|---|---|---|---|
| session_id | UUID | Yes | PK | Unique session identifier |
| identity_id | UUID | Yes | FK | Authenticated identity |
| institution_id | UUID | Yes | FK | Active institution context |
| session_token_hash | TEXT | Yes | UNIQUE | Hashed session token |
| session_status | VARCHAR(40) | Yes | | ACTIVE, EXPIRED, REVOKED, LOGGED_OUT, LOCKED |
| issued_at | TIMESTAMPTZ | Yes | | Session creation time |
| expires_at | TIMESTAMPTZ | Yes | | Session expiry |
| last_activity_at | TIMESTAMPTZ | No | | Last request time |
| logout_at | TIMESTAMPTZ | No | | Logout time |
| client_ip | VARCHAR(80) | No | | Client IP |
| user_agent | TEXT | No | | Browser/user agent |
| created_at | TIMESTAMPTZ | Yes | | Record creation time |
| updated_at | TIMESTAMPTZ | Yes | | Last update time |

## 15.11 aira_security.identity_login_audit

Purpose: stores login, logout, and session audit events.

| Column | Type | Required | Key | Description |
|---|---|---|---|---|
| login_audit_id | UUID | Yes | PK | Unique audit record |
| identity_id | UUID | No | FK | Identity if known |
| institution_id | UUID | No | FK | Institution if known |
| normalized_email | VARCHAR(320) | No | | Email used during login |
| event_type | VARCHAR(80) | Yes | | LOGIN_SUCCESS, LOGIN_FAILURE, LOGOUT, SESSION_EXPIRED |
| event_result | VARCHAR(40) | Yes | | ALLOWED, DENIED |
| denial_reason | VARCHAR(160) | No | | Reason login was denied |
| client_ip | VARCHAR(80) | No | | Client IP |
| user_agent | TEXT | No | | Browser/user agent |
| created_at | TIMESTAMPTZ | Yes | | Event time |

Event types: LOGIN_SUCCESS, LOGIN_FAILURE, LOGOUT, SESSION_CREATED, SESSION_EXPIRED, SESSION_REVOKED, UNAUTHORIZED_DASHBOARD_ACCESS.

Denial reasons: INVALID_CREDENTIALS, EMAIL_NOT_VERIFIED, PENDING_APPROVAL, ACCOUNT_REJECTED, ACCOUNT_SUSPENDED, ACCOUNT_LOCKED, ACCOUNT_DEACTIVATED, NO_ROLE_ASSIGNED, INVALID_SESSION, EXPIRED_SESSION.

## 15.12 aira_security.identity_approval_audit

Purpose: stores institution approval and role assignment audit events.

| Column | Type | Required | Key | Description |
|---|---|---|---|---|
| approval_audit_id | UUID | Yes | PK | Unique audit record |
| access_request_id | UUID | Yes | FK | Access request |
| target_identity_id | UUID | Yes | FK | User being reviewed |
| reviewer_identity_id | UUID | Yes | FK | Admin reviewer |
| institution_id | UUID | Yes | FK | Institution context |
| action_type | VARCHAR(80) | Yes | | APPROVE_ACCESS, REJECT_ACCESS, ASSIGN_ROLE, REVOKE_ROLE |
| action_result | VARCHAR(40) | Yes | | COMPLETED, DENIED |
| role_key | VARCHAR(80) | No | | Role affected |
| approval_notes | TEXT | No | | Admin notes |
| created_at | TIMESTAMPTZ | Yes | | Event time |

Action types: APPROVE_ACCESS, REJECT_ACCESS, ASSIGN_ROLE, REVOKE_ROLE, SUSPEND_USER, REACTIVATE_USER.

---

# 16. Recommended SQL DDL Draft

This is the recommended starting DDL for POC-1 implementation.

    CREATE EXTENSION IF NOT EXISTS pgcrypto;
    CREATE SCHEMA IF NOT EXISTS aira_security;

    CREATE TABLE IF NOT EXISTS aira_security.institution (
        institution_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
        institution_key VARCHAR(120) NOT NULL UNIQUE,
        institution_name VARCHAR(240) NOT NULL,
        institution_type VARCHAR(80) NOT NULL,
        institution_status VARCHAR(40) NOT NULL DEFAULT 'ACTIVE',
        primary_domain VARCHAR(240) UNIQUE,
        country_code VARCHAR(10),
        timezone_name VARCHAR(120),
        created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
        updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );

    CREATE TABLE IF NOT EXISTS aira_security.platform_identity (
        identity_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
        institution_id UUID REFERENCES aira_security.institution(institution_id),
        email VARCHAR(320) NOT NULL UNIQUE,
        normalized_email VARCHAR(320) NOT NULL UNIQUE,
        first_name VARCHAR(120) NOT NULL,
        last_name VARCHAR(120) NOT NULL,
        display_name VARCHAR(240) NOT NULL,
        identity_status VARCHAR(60) NOT NULL DEFAULT 'PENDING_EMAIL_VERIFICATION',
        email_verified BOOLEAN NOT NULL DEFAULT FALSE,
        institution_approved BOOLEAN NOT NULL DEFAULT FALSE,
        governance_terms_accepted BOOLEAN NOT NULL DEFAULT FALSE,
        failed_login_count INTEGER NOT NULL DEFAULT 0,
        locked_until TIMESTAMPTZ,
        last_login_at TIMESTAMPTZ,
        created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
        updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );

    CREATE TABLE IF NOT EXISTS aira_security.identity_session (
        session_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
        identity_id UUID NOT NULL REFERENCES aira_security.platform_identity(identity_id),
        institution_id UUID NOT NULL REFERENCES aira_security.institution(institution_id),
        session_token_hash TEXT NOT NULL UNIQUE,
        session_status VARCHAR(40) NOT NULL DEFAULT 'ACTIVE',
        issued_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
        expires_at TIMESTAMPTZ NOT NULL,
        last_activity_at TIMESTAMPTZ,
        logout_at TIMESTAMPTZ,
        client_ip VARCHAR(80),
        user_agent TEXT,
        created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
        updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );

Full POC-1 implementation should include all tables listed in section 14 and section 15.

---

# 17. Recommended Seed Data

Recommended seed institution:

- AIRA-DEMO-INSTITUTION
- AIRA Demo Institution
- INTERNAL
- ACTIVE
- aira.local
- PH
- Asia/Manila

Recommended roles:

- PLATFORM_ADMIN
- INSTITUTION_ADMIN
- DEVELOPER
- SECURITY_OFFICER
- AUDITOR
- VIEWER

Recommended demo users:

- platform.admin@aira.local
- institution.admin@aira.local
- developer@aira.local
- security.officer@aira.local
- auditor@aira.local
- viewer@aira.local

Seed credentials are for local development only and must not be used in production.

---

# 18. Recommended API Design

Public portal pages:

- GET /portal/landing.html
- GET /portal/login.html
- GET /portal/signup.html
- GET /portal/signup-submitted.html
- GET /portal/verify-email.html
- GET /portal/pending-approval.html

Identity APIs:

- POST /api/v1/identity/signup
- POST /api/v1/identity/verify-email
- POST /api/v1/identity/login
- POST /api/v1/identity/logout
- GET /api/v1/identity/session
- GET /api/v1/identity/me

Context APIs:

- GET /api/v1/identity/landing-context
- GET /api/v1/identity/institution-context
- GET /api/v1/identity/rbac-context

Admin approval APIs:

- GET /api/v1/identity/admin/access-requests
- GET /api/v1/identity/admin/access-requests/{requestId}
- POST /api/v1/identity/admin/access-requests/{requestId}/approve
- POST /api/v1/identity/admin/access-requests/{requestId}/reject

Audit APIs:

- GET /api/v1/identity/admin/login-audit
- GET /api/v1/identity/admin/approval-audit

---

# 19. Recommended Request and Response Models

Signup request should include firstName, lastName, email, institutionKey, department, jobTitle, requestedRole, requestReason, password, confirmPassword, acceptGovernancePolicy, and acceptTermsOfUse.

Signup response should return status PENDING_EMAIL_VERIFICATION and a generic message.

Login request should include email, password, and institutionKey.

Login response should return AUTHENTICATED, session token/reference, expiry, identity, institution, roles, permissions, and landingRoute.

Me response should return authenticated, email, displayName, institutionKey, roles, and permissions.

---

# 20. Recommended Portal Files

- accelerator-api/src/main/resources/static/portal/landing.html
- accelerator-api/src/main/resources/static/portal/login.html
- accelerator-api/src/main/resources/static/portal/signup.html
- accelerator-api/src/main/resources/static/portal/signup-submitted.html
- accelerator-api/src/main/resources/static/portal/verify-email.html
- accelerator-api/src/main/resources/static/portal/pending-approval.html
- accelerator-api/src/main/resources/static/portal/home.html
- accelerator-api/src/main/resources/static/portal/admin-dashboard.html
- accelerator-api/src/main/resources/static/portal/institution-dashboard.html
- accelerator-api/src/main/resources/static/portal/developer-dashboard.html
- accelerator-api/src/main/resources/static/portal/security-dashboard.html
- accelerator-api/src/main/resources/static/portal/evidence-dashboard.html
- accelerator-api/src/main/resources/static/portal/viewer-dashboard.html
- accelerator-api/src/main/resources/static/portal/assets/aira-identity.css
- accelerator-api/src/main/resources/static/portal/assets/aira-identity.js
- accelerator-api/src/main/resources/static/portal/assets/aira-rbac-router.js

---

# 21. Recommended Java Package Structure

Recommended module:

- accelerator-security

Recommended package:

- com.aira.accelerator.security.identity

Recommended classes:

- IdentitySignupRequest.java
- IdentitySignupResponse.java
- IdentityLoginRequest.java
- IdentityLoginResponse.java
- IdentitySessionResponse.java
- IdentityMeResponse.java
- IdentityLandingContextResponse.java
- IdentityAccessRequestResponse.java
- IdentityApprovalRequest.java
- IdentityVerificationRequest.java
- IdentityController.java
- IdentityAdminController.java
- IdentityService.java
- IdentityApprovalService.java
- IdentityAuditService.java
- IdentitySessionService.java

---

# 22. Email Notifications

Recommended email notifications:

- Verify your AIRA account email
- Your AIRA access request is pending institution approval
- New AIRA access request requires review
- Your AIRA account is approved
- AIRA access request update

Email verification should include a verification link, avoid exposing internal approval rules, and avoid revealing whether another account exists.

---

# 23. Recommended Security Rules

Mandatory rules:

- No hardcoded production passwords
- No embedded secrets in frontend
- No full access immediately after signup
- No access before email verification
- No access before institution approval
- No access before role assignment
- No frontend-only authorization decisions
- No silent approval
- No unaudited login
- No unaudited approval
- No token reuse after verification
- No active session after logout

Fail-closed behavior:

- Missing session -> block
- Invalid session -> block
- Expired session -> block
- Unverified email -> block
- Pending approval -> block
- No role -> block
- Unauthorized dashboard -> block
- Wrong institution -> block

---

# 24. Recommended Evidence Records

POC-1 should create evidence for:

- Signup request submitted
- Email verification generated
- Email verification completed
- Institution approval requested
- Institution approval completed
- Login success
- Login failure
- Logout completed
- Session expired
- RBAC landing route resolved
- Unauthorized access blocked

Recommended evidence pack:

- 05_Evidence/poc-1-identity-rbac-portal-entry/POC-1 Evidence Pack.md

---

# 25. Recommended ADR

Recommended ADR file:

- 03_DevSecOps_Accelerator/docs/adr/ADR-0013-POC-1-Institution-Aware-Identity-RBAC-Portal-Entry.md

Recommended ADR decision:

- AIRA will use an institution-aware identity flow with email verification, institution approval, RBAC assignment, audited sessions, and fail-closed portal access.

---

# 26. Recommended POC-1 Acceptance Criteria

POC-1 is accepted when:

- Landing page loads from server IP
- Signup page loads from server IP
- User can submit access request
- Account starts as PENDING_EMAIL_VERIFICATION
- Verification token is created
- Email verification endpoint works
- Verified user moves to PENDING_INSTITUTION_APPROVAL
- Admin can approve access request
- Approved user becomes ACTIVE
- Role assignment is created
- User can login
- Session endpoint returns authenticated session
- Me endpoint returns user, institution, role, and permissions
- Landing context returns correct dashboard route
- User is redirected to RBAC dashboard after login
- Logout clears session
- Invalid login is denied
- Unverified user is denied
- Pending approval user is denied
- Missing session is denied
- Wrong role is denied from unauthorized dashboard
- Login audit records are created
- Approval audit records are created
- Maven build succeeds
- Docker runtime rebuild succeeds
- Portal works from server IP
- GitHub commit and push succeed

---

# 27. Recommended POC-1 Validation Script Scope

Validation script should check source files, SQL migrations, SQL seed files, Maven build, WAR files, Docker runtime rebuild, public pages, signup endpoint, verification endpoint, admin approval endpoint, login endpoint, me endpoint, landing context, logout, invalid login denial, unverified user denial, pending approval denial, database counts, audit records, release readiness regression, Application Factory readiness regression, clean working tree, and GitHub push.

---

# 28. Recommended Build Order

1. Add POC-1 database migration.
2. Add POC-1 seed data.
3. Add Identity Java DTOs.
4. Add Identity services.
5. Add Identity controller.
6. Add admin approval controller.
7. Add landing page.
8. Add signup page.
9. Add login page.
10. Add pending approval page.
11. Add RBAC home/router page.
12. Add role-based dashboard placeholders.
13. Add identity CSS and JS.
14. Add validation script.
15. Add docs and ADR.
16. Add evidence pack.
17. Build Maven.
18. Rebuild Docker runtime.
19. Validate server-IP portal flow.
20. Commit and push.

---

# 29. POC-1 Enterprise Grade Target

POC-1 is 10 / 10 when it is:

- Institution-aware
- RBAC-aware
- Email-verified
- Admin-approved
- Session-backed
- Audit-backed
- Evidence-backed
- Fail-closed
- Server-IP-ready
- GitHub-backed
- Validated end-to-end

---

# 30. Final Recommendation

Build POC-1 as Institution-Aware Identity and RBAC Portal Entry, not only as a username/password login page.

The best AIRA-grade design is:

Landing Page -> Signup / Request Access -> Email Verification -> Institution Approval -> Login -> Session Context -> RBAC + Institution Landing Page -> Role-Based Dashboard -> Audit + Evidence.

This keeps AIRA governed, enterprise-grade, fail-closed, evidence-backed, institution-aware, role-aware, and application-factory-ready.

---

# 31. POC-1 Microfunctions

## 31.1 Purpose

POC-1 should include AIRA Microfunctions as governed workflow functions inside the identity layer.

Microfunctions are not separate deployable microservices in POC-1. They are small, auditable, reusable, fail-closed identity workflow functions that can later be extracted, orchestrated, tested, and agent-assisted.

Recommended classification:

- POC-1 Microfunctions = governed workflow functions inside the identity layer.
- They support signup, verification, approval, login, session, RBAC landing, logout, audit, and evidence.
- They prepare POC-1 for future AIRA agent execution and automated validation.

## 31.2 Why Microfunctions Matter for AIRA

Microfunctions align POC-1 with the AIRA operating model because they are:

- Agent-ready
- Audit-ready
- Evidence-ready
- Reusable
- Composable
- Governed
- Fail-closed
- Workflow-driven
- Future automation-ready

Microfunctions allow AIRA agents to reason about identity workflows step by step instead of treating login and signup as one opaque block.

## 31.3 Signup Microfunctions

| Key | Microfunction | Purpose | Audit | Evidence | Fail Closed |
|---|---|---|---|---|---|
| MF-IDENTITY-001 | ValidateSignupInput | Validate submitted signup fields and required governance acceptance | Yes | Yes | Yes |
| MF-IDENTITY-002 | NormalizeEmailAddress | Lowercase and canonicalize email address | Yes | No | Yes |
| MF-IDENTITY-003 | ResolveInstitutionFromDomain | Match email domain or submitted institution key to institution | Yes | Yes | Yes |
| MF-IDENTITY-004 | CreatePendingIdentity | Create identity with PENDING_EMAIL_VERIFICATION status | Yes | Yes | Yes |
| MF-IDENTITY-005 | HashIdentityPassword | Hash submitted password using approved algorithm | Yes | No | Yes |
| MF-IDENTITY-006 | CreateAccessRequest | Create request access workflow record | Yes | Yes | Yes |
| MF-IDENTITY-007 | CreateEmailVerificationToken | Create single-use time-limited verification token | Yes | Yes | Yes |
| MF-IDENTITY-008 | QueueVerificationEmail | Queue or send verification email | Yes | Yes | Yes |
| MF-IDENTITY-009 | RecordSignupAudit | Record signup attempt and result | Yes | No | Yes |
| MF-IDENTITY-010 | CreateSignupEvidenceEvent | Create evidence event for signup submission | Yes | Yes | Yes |

## 31.4 Email Verification Microfunctions

| Key | Microfunction | Purpose | Audit | Evidence | Fail Closed |
|---|---|---|---|---|---|
| MF-IDENTITY-011 | ValidateVerificationToken | Validate verification token hash, expiry, and status | Yes | Yes | Yes |
| MF-IDENTITY-012 | ExpireOldVerificationTokens | Mark expired pending tokens as expired | Yes | No | Yes |
| MF-IDENTITY-013 | MarkEmailVerified | Mark identity email_verified = true | Yes | Yes | Yes |
| MF-IDENTITY-014 | MoveAccessRequestToPendingApproval | Move request to PENDING_INSTITUTION_APPROVAL | Yes | Yes | Yes |
| MF-IDENTITY-015 | NotifyInstitutionAdmin | Notify institution admin of verified pending request | Yes | Yes | Yes |
| MF-IDENTITY-016 | RecordVerificationAudit | Record verification attempt and result | Yes | No | Yes |
| MF-IDENTITY-017 | CreateVerificationEvidenceEvent | Create evidence event for email verification | Yes | Yes | Yes |

## 31.5 Institution Approval Microfunctions

| Key | Microfunction | Purpose | Audit | Evidence | Fail Closed |
|---|---|---|---|---|---|
| MF-IDENTITY-018 | ListPendingAccessRequests | List verified requests awaiting review | Yes | No | Yes |
| MF-IDENTITY-019 | ValidateReviewerAuthority | Confirm reviewer can approve for institution | Yes | Yes | Yes |
| MF-IDENTITY-020 | ApproveAccessRequest | Approve a verified access request | Yes | Yes | Yes |
| MF-IDENTITY-021 | RejectAccessRequest | Reject an access request | Yes | Yes | Yes |
| MF-IDENTITY-022 | AssignInstitutionRole | Assign institution-scoped role to identity | Yes | Yes | Yes |
| MF-IDENTITY-023 | ActivateIdentity | Mark identity ACTIVE after approval and role assignment | Yes | Yes | Yes |
| MF-IDENTITY-024 | NotifyUserAccessApproved | Notify user access is approved | Yes | Yes | No |
| MF-IDENTITY-025 | NotifyUserAccessRejected | Notify user request update without sensitive policy detail | Yes | Yes | No |
| MF-IDENTITY-026 | RecordApprovalAudit | Record approval/rejection audit event | Yes | No | Yes |
| MF-IDENTITY-027 | CreateApprovalEvidenceEvent | Create evidence event for approval decision | Yes | Yes | Yes |

## 31.6 Login and Session Microfunctions

| Key | Microfunction | Purpose | Audit | Evidence | Fail Closed |
|---|---|---|---|---|---|
| MF-IDENTITY-028 | ValidateLoginInput | Validate email, password, and institution selector | Yes | No | Yes |
| MF-IDENTITY-029 | LoadIdentityByEmail | Load identity using normalized email | Yes | No | Yes |
| MF-IDENTITY-030 | VerifyPassword | Verify password against stored hash | Yes | No | Yes |
| MF-IDENTITY-031 | CheckEmailVerified | Block login if email is not verified | Yes | Yes | Yes |
| MF-IDENTITY-032 | CheckInstitutionApproved | Block login if institution approval is missing | Yes | Yes | Yes |
| MF-IDENTITY-033 | CheckIdentityStatus | Block login if identity is suspended, locked, rejected, or deactivated | Yes | Yes | Yes |
| MF-IDENTITY-034 | CheckRoleAssignment | Block login if no active role assignment exists | Yes | Yes | Yes |
| MF-IDENTITY-035 | CreateIdentitySession | Create governed active session | Yes | Yes | Yes |
| MF-IDENTITY-036 | RecordLoginSuccessAudit | Record successful login | Yes | No | Yes |
| MF-IDENTITY-037 | RecordLoginFailureAudit | Record failed login | Yes | No | Yes |
| MF-IDENTITY-038 | IncrementFailedLoginCounter | Increment failed login count | Yes | No | Yes |
| MF-IDENTITY-039 | LockIdentityIfThresholdExceeded | Lock identity when threshold is exceeded | Yes | Yes | Yes |

## 31.7 RBAC Landing Microfunctions

| Key | Microfunction | Purpose | Audit | Evidence | Fail Closed |
|---|---|---|---|---|---|
| MF-IDENTITY-040 | LoadActiveSession | Load and validate active session | Yes | No | Yes |
| MF-IDENTITY-041 | ResolveInstitutionContext | Resolve active institution context | Yes | Yes | Yes |
| MF-IDENTITY-042 | ResolveRoleAssignments | Resolve active role assignments | Yes | Yes | Yes |
| MF-IDENTITY-043 | ResolvePermissionSet | Resolve permissions from roles | Yes | Yes | Yes |
| MF-IDENTITY-044 | ResolveLandingRoute | Select correct dashboard route | Yes | Yes | Yes |
| MF-IDENTITY-045 | ValidateDashboardAccess | Validate access to requested dashboard | Yes | Yes | Yes |
| MF-IDENTITY-046 | BlockUnauthorizedDashboard | Fail closed when dashboard is unauthorized | Yes | Yes | Yes |
| MF-IDENTITY-047 | RecordUnauthorizedAccessAudit | Record unauthorized dashboard attempt | Yes | No | Yes |
| MF-IDENTITY-048 | CreateRBACEvidenceEvent | Create evidence event for RBAC route decision | Yes | Yes | Yes |

## 31.8 Logout Microfunctions

| Key | Microfunction | Purpose | Audit | Evidence | Fail Closed |
|---|---|---|---|---|---|
| MF-IDENTITY-049 | ValidateLogoutSession | Validate logout session reference | Yes | No | Yes |
| MF-IDENTITY-050 | RevokeSession | Revoke active session | Yes | Yes | Yes |
| MF-IDENTITY-051 | ClearSessionContext | Clear local session context | Yes | No | No |
| MF-IDENTITY-052 | RecordLogoutAudit | Record logout event | Yes | No | Yes |
| MF-IDENTITY-053 | CreateLogoutEvidenceEvent | Create evidence event for logout | Yes | Yes | Yes |

## 31.9 Evidence Microfunctions

| Key | Microfunction | Purpose | Audit | Evidence | Fail Closed |
|---|---|---|---|---|---|
| MF-IDENTITY-054 | CreateIdentityEvidenceRecord | Create standard identity evidence record | Yes | Yes | Yes |
| MF-IDENTITY-055 | LinkEvidenceToIdentity | Link evidence event to identity | Yes | Yes | Yes |
| MF-IDENTITY-056 | LinkEvidenceToInstitution | Link evidence event to institution | Yes | Yes | Yes |
| MF-IDENTITY-057 | LinkEvidenceToAccessRequest | Link evidence event to access request | Yes | Yes | Yes |
| MF-IDENTITY-058 | ValidateEvidenceCompleteness | Validate required evidence exists for acceptance | Yes | Yes | Yes |

## 31.10 Agent Alignment

POC-1 Microfunctions allow AIRA agents to participate safely:

- security-agent can inspect login failures, lockout, token use, and session anomalies.
- evidence-agent can collect verification, approval, login, logout, and RBAC route evidence.
- governance-agent can validate institution approval and role assignment rules.
- developer-agent can implement microfunctions as reusable identity-layer units.
- test-agent can generate acceptance tests per microfunction.
- cicd-agent can validate identity quality gates.
- documentation-agent can keep API, database, and workflow docs aligned.
- knowledge-fabric-agent can map identity decisions to institutional knowledge.

---

# 32. Microfunction Database Tables

## 32.1 Table: aira_security.identity_microfunction_catalog

Purpose: defines the governed POC-1 identity microfunctions.

| Column | Type | Required | Key | Description |
|---|---|---|---|---|
| microfunction_key | VARCHAR(120) | Yes | PK | Stable microfunction key such as MF-IDENTITY-001 |
| microfunction_name | VARCHAR(240) | Yes | | Human-readable microfunction name |
| microfunction_category | VARCHAR(120) | Yes | | SIGNUP, VERIFICATION, APPROVAL, LOGIN_SESSION, RBAC_LANDING, LOGOUT, EVIDENCE |
| microfunction_description | TEXT | Yes | | Description of the microfunction responsibility |
| owning_module | VARCHAR(120) | Yes | | accelerator-security for POC-1 |
| execution_phase | VARCHAR(120) | Yes | | Workflow phase where function runs |
| fail_closed_required | BOOLEAN | Yes | | Whether failure must block the workflow |
| audit_required | BOOLEAN | Yes | | Whether audit event is required |
| evidence_required | BOOLEAN | Yes | | Whether evidence event is required |
| microfunction_status | VARCHAR(40) | Yes | | ACTIVE, PLANNED, DEPRECATED, DISABLED |
| created_at | TIMESTAMPTZ | Yes | | Record creation time |
| updated_at | TIMESTAMPTZ | Yes | | Last update time |

Recommended constraints:

    PRIMARY KEY (microfunction_key)

## 32.2 Table: aira_security.identity_microfunction_execution

Purpose: records execution outcomes for POC-1 identity microfunctions.

| Column | Type | Required | Key | Description |
|---|---|---|---|---|
| execution_id | UUID | Yes | PK | Unique execution record |
| microfunction_key | VARCHAR(120) | Yes | FK | Executed microfunction |
| identity_id | UUID | No | FK | Related identity when available |
| institution_id | UUID | No | FK | Related institution when available |
| access_request_id | UUID | No | FK | Related access request when available |
| session_id | UUID | No | FK | Related session when available |
| correlation_id | VARCHAR(160) | Yes | | Workflow correlation ID |
| execution_status | VARCHAR(40) | Yes | | STARTED, PASSED, FAILED, BLOCKED, SKIPPED |
| input_summary | TEXT | No | | Safe summary of inputs, no secrets |
| output_summary | TEXT | No | | Safe summary of outputs, no secrets |
| failure_reason | TEXT | No | | Failure or block reason |
| started_at | TIMESTAMPTZ | Yes | | Execution start |
| completed_at | TIMESTAMPTZ | No | | Execution completion |
| created_at | TIMESTAMPTZ | Yes | | Record creation time |

Recommended constraints:

    PRIMARY KEY (execution_id)
    FOREIGN KEY (microfunction_key) REFERENCES aira_security.identity_microfunction_catalog(microfunction_key)
    FOREIGN KEY (identity_id) REFERENCES aira_security.platform_identity(identity_id)
    FOREIGN KEY (institution_id) REFERENCES aira_security.institution(institution_id)
    FOREIGN KEY (access_request_id) REFERENCES aira_security.identity_access_request(access_request_id)
    FOREIGN KEY (session_id) REFERENCES aira_security.identity_session(session_id)

---

# 33. Microfunction Acceptance Criteria

POC-1 Microfunctions are accepted when:

- All planned microfunctions are documented in the architecture markdown.
- Microfunction catalog table is created or planned in migration scope.
- Microfunction execution table is created or planned in migration scope.
- Signup flow references signup microfunctions.
- Email verification flow references verification microfunctions.
- Institution approval flow references approval microfunctions.
- Login/session flow references login and session microfunctions.
- RBAC landing flow references RBAC microfunctions.
- Logout flow references logout microfunctions.
- Evidence flow references evidence microfunctions.
- Fail-closed microfunctions block unsafe continuation.
- Audit-required microfunctions create audit records.
- Evidence-required microfunctions create evidence records.
- Validation script checks microfunction catalog and execution readiness.
- Agents can use the microfunction list as the POC-1 build breakdown.

---

# 34. Agent Build Readiness

After this Microfunctions update is pushed, POC-1 is ready for the next step: having the AIRA agents build the POC-1 implementation.

The recommended agent build sequence is:

1. architecture-agent validates the POC-1 architecture and microfunction model.
2. security-agent validates identity, session, token, and RBAC controls.
3. developer-agent implements migrations, services, controllers, and portal pages.
4. test-agent creates validation and regression checks.
5. evidence-agent creates evidence records and evidence pack updates.
6. documentation-agent keeps architecture, ADR, and API docs aligned.
7. cicd-agent adds quality gates for POC-1 identity flows.
8. knowledge-fabric-agent maps identity workflow knowledge for future reuse.

POC-1 should not begin implementation until this documentation, ADR, and evidence baseline are committed and pushed.
