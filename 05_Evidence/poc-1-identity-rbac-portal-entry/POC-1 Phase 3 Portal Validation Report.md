# POC-1 Phase 3 Portal Validation Report

## Status

PASSED

## Date

2026-06-15 17:50:31 +08:00

## Runtime

- Portal base URL: http://192.168.179.193:9090/portal
- Identity base URL: http://192.168.179.193:9091
- API Tomcat container: aira-accelerator-api
- API Tomcat container ID: 0be025781c06

## Portal Files

- landing.html
- signup.html
- signup-submitted.html
- verify-email.html
- pending-approval.html
- login.html
- home.html
- admin-dashboard.html
- institution-dashboard.html
- developer-dashboard.html
- security-dashboard.html
- evidence-dashboard.html
- viewer-dashboard.html
- assets/poc1.css
- assets/poc1-api.js

## Smoke Tests

All portal pages and assets returned HTTP 2xx from the server IP runtime.

## Identity Runtime Integration

- Signup page calls /api/v1/identity/signup.
- Verify page calls /api/v1/identity/verify-email.
- Login page calls /api/v1/identity/login.
- Home router calls /api/v1/identity/session and /api/v1/identity/landing-context.
- Dashboards validate active session before showing role context.

## Conclusion

POC-1 Phase 3 static portal shell is built, deployed, and smoke-tested. Browser flow validation may proceed next.