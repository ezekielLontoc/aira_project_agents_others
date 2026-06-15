# POC-1 Login Session Runtime Repair Log

## Status

PASSED

## Date

2026-06-15 17:23:31 +08:00

## Issue

Login returned HTTP 500 after successful approval.

## Likely Root Cause

IdentityService.loadSession cast the PostgreSQL expires_at timestamptz value directly to OffsetDateTime. The JDBC driver may return java.sql.Timestamp or another temporal type.

## Repair

- Replaced direct OffsetDateTime cast with toOffsetDateTime(row.get("expires_at")).
- Added helper conversion for OffsetDateTime, java.sql.Timestamp, Instant, and LocalDateTime.
- Rebuilt accelerator-security WAR.
- Redeployed ROOT.war into Tomcat container mapped to port 9091.
- Re-ran the complete runtime identity flow.

## Runtime Result

- Approval returned APPROVED.
- Login returned session token.
- Session returned authenticated true.
- Me returned authenticated true.
- Landing route resolved to /portal/developer-dashboard.html.
- Logout returned LOGGED_OUT.
- Session after logout returned DENIED.

## Test Identity

- poc1.runtime.pathvariable.20260615171825@aira.local