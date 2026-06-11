# ADR-0009: AIRA Portal / Frontend Foundation

## Status

Accepted

## Date

2026-06-11

## Context

AIRA has backend services, PostgreSQL persistence, protected runtime APIs, evidence and audit APIs, and CI/CD quality gates.

AIRA now requires a frontend foundation to make the runtime state visible through a governed portal.

## Decision

Implement a dependency-light static portal served by accelerator-api.

The portal is built with:

- HTML
- CSS
- JavaScript
- Spring Boot static resources
- Tomcat 11 WAR deployment

No Node.js dependency is introduced in this milestone.

## Security

The portal does not embed secrets.

Protected backend APIs continue to require:

X-AIRA-API-Key

Browser access is enabled through constrained CORS from:

http://localhost:9090

## Consequences

### Positive

- AIRA now has a visible control surface.
- No new frontend toolchain is required.
- Portal deploys with existing Tomcat runtime.
- Protected APIs remain protected.
- Portal readiness is validated and evidence-backed.

### Tradeoffs

- This is a foundation, not a full production UI.
- Local browser storage is used only for local development API key convenience.
- Future identity and RBAC are still required for production.

## Governance

Portal actions are read-first in this milestone.

No write, approval, deployment, or production mutation capability is introduced.

## Decision Owner

AIRA Platform Owner

## Implementation Owner

AIRA Platform Lead