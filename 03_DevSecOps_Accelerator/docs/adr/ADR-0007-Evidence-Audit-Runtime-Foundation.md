# ADR-0007: Evidence and Audit Runtime Foundation

## Status

Accepted

## Date

2026-06-11

## Context

AIRA has established governed persistence, service persistence integration, Agent Registry APIs, Governance APIs, and API-key security enforcement.

AIRA now requires runtime APIs to expose evidence and audit data for governance, compliance, release readiness, and future portal use.

## Decision

Implement protected read-first Evidence and Audit Runtime APIs in accelerator-evidence.

The APIs expose:

- Evidence packs
- Evidence artifacts
- Traceability links
- Runtime audit records
- Security audit events
- Evidence readiness

## Security

All /api/v1/evidence/** endpoints require:

X-AIRA-API-Key

## Consequences

### Positive

- Evidence becomes runtime-accessible.
- Audit records become visible through governed APIs.
- Evidence readiness can be validated automatically.
- Future portal dashboards can consume evidence data.
- Release readiness can depend on evidence API validation.

### Tradeoffs

- APIs are read-only in this milestone.
- Write APIs are deferred until RBAC, approval workflow, immutability, and audit controls are stronger.
- Local development uses a default API key that must be replaced before production use.

## Governance

Evidence APIs cannot alter source evidence or approve release.

Production evidence acceptance requires human approval and immutable source references.

## Decision Owner

AIRA Evidence and Compliance Owner

## Implementation Owner

AIRA Platform Lead