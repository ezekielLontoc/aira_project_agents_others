# POC-1 Runtime Validation Report

## Status

PASSED

## Date

2026-06-15 16:59:15 +08:00

## Runtime

- PostgreSQL container: aira-postgres17
- Database: aira_platform
- Security runtime base URL: http://192.168.179.193:9091
- Server IP: 192.168.179.193
- Security port: 9091

## Git Baseline

- Source baseline before runtime validation: c8fe44a or later

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

- Email: poc1.runtime.20260615165844@aira.local
- Requested role: DEVELOPER
- Landing route: 

## Database Runtime Evidence

- Runtime identity count: 0
- Approved access request count: 0
- Active role assignment count: 0
- Login audit count: 0
- Microfunction execution count: 0

## Readiness Response

`json

`",
",


`json

`",
",


POC-1 identity core APIs are validated through PostgreSQL and Tomcat runtime. Portal pages may begin in the next build phase.