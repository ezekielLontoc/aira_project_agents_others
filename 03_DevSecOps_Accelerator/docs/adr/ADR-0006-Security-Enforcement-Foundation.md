# ADR-0006: Security Enforcement Foundation

## Status

Accepted

## Date

2026-06-11

## Context

Milestone 10 introduced read-first Agent Registry and Governance APIs.

These APIs expose governed platform state and must not remain openly accessible as the platform matures.

## Decision

Introduce an API-key based security enforcement foundation.

Protected APIs require:

X-AIRA-API-Key

The first protected APIs are:

- /api/v1/agents/**
- /api/v1/governance/**

## Consequences

### Positive

- Protected APIs now require authentication material.
- Unauthorized access fails closed.
- Security decisions are auditable.
- A foundation exists for future RBAC and approval workflows.

### Tradeoffs

- This is not final enterprise authentication.
- Local development uses a default key.
- Future milestones must replace or extend this with stronger identity, RBAC, and secret management.

## Governance

No protected API may bypass security enforcement.

Production API keys require human approval, rotation, evidence, and audit.

## Decision Owner

AIRA Security Owner

## Implementation Owner

AIRA Platform Lead