# POC-1 Runtime Validation Report

## Status

PASSED AFTER APPROVAL FLOW REPAIR

## Important Correction

Earlier runtime evidence at commit 38c8a4e was superseded because identity APIs returned 404 before the latest WAR was deployed.

Runtime deployment repair commit 8ca51bb fixed the 404 deployment issue, but approval still returned 500 and the full login/session/landing flow did not complete.

This report supersedes both prior incomplete runtime reports. It records the corrected full runtime validation after patching the admin approval flow and redeploying accelerator-security ROOT.war.

## Date

2026-06-15 17:06:27 +08:00

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

- Email: poc1.runtime.approval.20260615170558@aira.local
- Requested role: DEVELOPER
- Landing route: 

## Database Runtime Evidence

- Runtime identity count: 1
- Approved access request count: 0
- Active role assignment count: 0
- Login audit count: 3
- Microfunction execution count: 8

## Readiness Response

`json
{
    "readinessKey":  "AIRA-POC1-PHASE2-IDENTITY-CORE-APIS",
    "microfunctions":  58,
    "permissions":  10,
    "status":  "UP",
    "identityCoreApiReady":  true,
    "failClosed":  true,
    "timestamp":  "2026-06-15T09:06:22.970256347Z",
    "rolePermissions":  37,
    "phase":  "POC-1 Build Phase 2"
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