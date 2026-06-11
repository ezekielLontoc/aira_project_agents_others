# ADR-0011: Enterprise Server-IP Runtime Hardening

## Status

Accepted

## Date

2026-06-11

## Context

AIRA MVP validation succeeded from GitHub main at commit e573b14. The runtime was validated using localhost URLs. Enterprise server access requires the runtime to resolve from the server machine IP instead of assuming localhost.

## Decision

Implement server-IP-aware runtime access.

The runtime now uses:

- AIRA_SERVER_HOST
- AIRA_PORTAL_ALLOWED_ORIGINS
- docker-compose.enterprise-ip.yml
- dynamic portal JavaScript endpoint resolution
- env-driven CORS origin configuration

## Consequences

### Positive

- Portal can be opened through the server machine IP.
- Protected APIs support CORS from the server-IP portal origin.
- Backend API security remains fail-closed.
- Runtime URLs are no longer hardcoded to localhost in the portal.
- Validation checks both localhost and server-IP access.

## Governance

The portal remains read-first. Protected APIs require X-AIRA-API-Key. Missing or wrong keys return 401.