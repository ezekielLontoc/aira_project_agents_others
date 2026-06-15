# POC-1 Runtime Validation Report

## Status

PASSED AFTER RUNTIME DEPLOYMENT REPAIR

## Important Correction

The earlier runtime validation evidence at commit 38c8a4e is superseded because the identity APIs returned 404 before the latest WAR was deployed to the running Tomcat container.

This report records the corrected validation after direct deployment of accelerator-security target ROOT.war into the running Tomcat container mapped to port 9091.

## Date

2026-06-15 17:02:25 +08:00

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

- Email: poc1.runtime.repair.20260615170157@aira.local
- Requested role: DEVELOPER
- Landing route: 

## Database Runtime Evidence

- Runtime identity count: 1
- Approved access request count: 0
- Active role assignment count: 0
- Login audit count: 3
- Microfunction execution count: 4

## Readiness Response

`json
{
    "rolePermissions":  37,
    "timestamp":  "2026-06-15T09:02:21.185911025Z",
    "failClosed":  true,
    "identityCoreApiReady":  true,
    "status":  "UP",
    "permissions":  10,
    "microfunctions":  58,
    "readinessKey":  "AIRA-POC1-PHASE2-IDENTITY-CORE-APIS",
    "phase":  "POC-1 Build Phase 2"
}
`",
",


`json
{
    "message":  "Invalid session.",
    "status":  "DENIED"
}
`",
",


POC-1 identity core APIs are now validated through PostgreSQL and the Tomcat runtime. Portal pages may begin in the next build phase.