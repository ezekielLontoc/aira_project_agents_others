# POC-1 Runtime Validation Report

## Status

PASSED AFTER PATHVARIABLE APPROVAL REPAIR

## Important Correction

Earlier runtime evidence at commit 38c8a4e was superseded because identity APIs returned 404 before the latest WAR was deployed.

Runtime deployment repair commit 8ca51bb fixed the 404 deployment issue, but approval still returned 500.

Approval-flow repair commit c396965 still failed because the actual root cause was Spring MVC PathVariable binding.

Diagnostic commit 611ca9a and stack-trace commit 45f409a captured the exact backend exception:

Name for argument of type java.util.UUID not specified, and parameter name information not available via reflection.

This report supersedes all prior incomplete runtime reports. It records the corrected full runtime validation after explicitly naming @PathVariable requestId in IdentityAdminController.

## Date

2026-06-15 17:18:55 +08:00

## Runtime

- PostgreSQL container: aira-postgres17
- Database: aira_platform
- Security runtime base URL: http://192.168.179.193:9091
- Server IP: 192.168.179.193
- Security port: 9091
- Tomcat container: aira-accelerator-security
- Tomcat container ID: 452a80ed4a69
- Tomcat webapps path: /usr/local/tomcat/webapps

## SQL Validation

- POC-1 table count: 15
- Institution count: 1
- Permission count: 10
- Role permission count: 37
- Microfunction count: 58
- MF-IDENTITY-001 count: 1
- MF-IDENTITY-058 count: 1

## Runtime API Validation

- GET /api/v1/identity/readiness: PASSED
- GET /api/v1/identity/microfunctions: PASSED
- POST /api/v1/identity/signup: PASSED
- POST /api/v1/identity/verify-email: PASSED
- GET /api/v1/identity/admin/access-requests: PASSED
- POST /api/v1/identity/admin/access-requests/{requestId}/approve: PASSED
- POST /api/v1/identity/login: PASSED
- GET /api/v1/identity/session: PASSED
- GET /api/v1/identity/me: PASSED
- GET /api/v1/identity/landing-context: PASSED
- POST /api/v1/identity/logout: PASSED
- GET /api/v1/identity/session after logout: DENIED as expected

## Test Identity

- Email: poc1.runtime.pathvariable.20260615171825@aira.local
- Requested role: DEVELOPER
- Landing route: 

## Database Runtime Evidence

- Runtime identity count: 1
- Approved access request count: 1
- Active role assignment count: 1
- Login audit count: 3
- Microfunction execution count: 19

## Readiness Response

`json
{
    "failClosed":  true,
    "identityCoreApiReady":  true,
    "status":  "UP",
    "permissions":  10,
    "microfunctions":  58,
    "readinessKey":  "AIRA-POC1-PHASE2-IDENTITY-CORE-APIS",
    "phase":  "POC-1 Build Phase 2",
    "rolePermissions":  37,
    "timestamp":  "2026-06-15T09:18:51.866880471Z"
}
`",
",


`json
{
    "status":  "DENIED",
    "message":  "Invalid session."
}
`",
",


POC-1 identity core APIs are now fully validated through PostgreSQL and Tomcat runtime. Portal pages may begin in the next build phase.