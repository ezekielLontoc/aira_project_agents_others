# POC-1 Final Closure Summary

## Status

ACCEPTED

## Closure Date

2026-06-17 08:46:07 +08:00

## POC Name

POC-1 - Institution-Aware Identity and RBAC Portal Entry

## Final Result

POC-1 is complete, validated, evidence-backed, committed, pushed, and accepted for the defined local governed runtime scope.

## Final Accepted Commit

- Final evidence commit: 5612991d898b250fa9e763e4663ac5bb6f699d0d

## Runtime Baseline

- Portal runtime: http://192.168.179.193:9090/portal
- Identity runtime: http://192.168.179.193:9091
- Portal host/IP: 192.168.179.193
- Runtime mode: Local Tomcat and PostgreSQL governed POC runtime

## Validated User

- Browser account: poc1.browser.20260615180057@aira.local
- Institution key: AIRA-DEMO-INSTITUTION
- Role: DEVELOPER
- Landing route: /portal/developer-dashboard.html

## Accepted Capabilities

### 1. Institution-Aware Signup

- Signup page is served from the portal runtime.
- Signup creates an access request against the identity runtime.
- Institution key validation supports AIRA-DEMO-INSTITUTION.
- Local verification token supports POC-only email verification.

### 2. Email Verification

- Verification API accepts the local verification token.
- Identity progresses into institution approval flow.

### 3. Institution Approval

- Admin approval endpoint activates the identity.
- Role assignment is created during approval.
- Approval audit evidence is captured by runtime tables.

### 4. Login and Session

- Login accepts the verified and approved browser test account.
- Runtime returns a session token.
- Session token is stored in browser localStorage.
- Session endpoint authenticates the active browser session.

### 5. RBAC Landing Context

- Landing context resolves the authenticated user to /portal/developer-dashboard.html.
- Developer dashboard is protected by active session state.
- Role display shows DEVELOPER.

### 6. Home Router

- Home router detects active browser session.
- Home router displays the resolved landing route.
- Unauthenticated state redirects to login.

### 7. Logout

- Logout endpoint invalidates the session.
- Session after logout returns DENIED.

### 8. Evidence Readiness

- Evidence pack updated.
- Phase 3B final browser validation report created.
- Role display polish report created.
- CORS repair report created.
- Build/runtime validation evidence retained.

## Accepted Browser Validation

Browser-confirmed final state:

- URL: http://192.168.179.193:9090/portal/developer-dashboard.html
- Display: Signed in as poc1.browser.20260615180057@aira.local with role DEVELOPER.
- Landing route: /portal/developer-dashboard.html
- Developer dashboard rendered successfully.

## Accepted Automated Runtime Validation

- Portal developer dashboard returned HTTP 2xx.
- Portal home router returned HTTP 2xx.
- Portal login page returned HTTP 2xx.
- Portal signup page returned HTTP 2xx.
- Portal JavaScript returned HTTP 2xx.
- Portal JavaScript includes resolveRoleLabel.
- Identity API login returned a session token.
- Identity API session returned authenticated true.
- Identity API landing-context returned /portal/developer-dashboard.html.
- Identity API logout returned LOGGED_OUT.
- Identity API session after logout returned DENIED.

## Commits Included In POC-1 Closure Path

- bf03ae1 - update complete identity RBAC portal entry markdown
- ff75cbf - add identity microfunctions planning baseline
- 5f858f9 - add phase 1 identity database and microfunction foundation
- c8fe44a - repair phase 2 identity core API build dependency
- 58560a3 - fix login timestamp conversion and validate runtime flow
- bc3c8ec - add phase 3 identity portal pages
- e2165b9 - repair portal CORS for browser identity flow
- 72e7440 - polish phase 3B portal role display
- 5612991 - finalize phase 3B browser validation evidence

## Known Local POC Constraints

These items are intentionally outside the POC-1 local validation scope and belong to production hardening:

- Real email delivery instead of local-only verification token.
- HTTPS and production TLS termination.
- Externalized secrets and managed secret rotation.
- MFA, password reset, invitation flow, and device trust.
- Admin review UI for access requests.
- Audit review UI for login and approval trails.
- Production-grade deployment topology.

## Final Acceptance Statement

POC-1 is accepted as a 10/10 local governed runtime build for the defined scope: institution-aware signup, verification, approval, login, session context, RBAC landing, role dashboard, logout, and evidence-backed validation.

## Recommended Next Build Phase

Proceed to POC-2 from this clean baseline. Recommended POC-2 direction:

- Institution Admin Console and Access Governance
- access-request review UI
- approval/rejection screens
- role assignment management
- login/approval audit dashboards
- evidence export from portal
- institution-level visibility controls