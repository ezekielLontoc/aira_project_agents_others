# ADR-0003: PostgreSQL 17 Runtime Persistence Foundation

## Status

Accepted

## Date

2026-06-11

## Context

AIRA requires a governed persistence foundation for agents, evidence, governance, security, testing, runtime readiness, observability, and knowledge records.

Earlier milestones established PostgreSQL 17 as the mandatory database runtime. Milestone 8 formalizes PostgreSQL 17 as the governed persistence foundation.

## Decision

Use PostgreSQL 17 as the official AIRA Runtime Persistence Foundation.

The persistence foundation will include schemas for:

- aira_security
- aira_governance
- aira_evidence
- aira_agents
- aira_runtime
- aira_observability
- aira_testing
- aira_knowledge

## Consequences

### Positive

- Central governed persistence model
- Audit-ready evidence tracking
- Agent registry and execution audit
- Security findings and secret controls
- Release gate tracking
- Runtime health tracking
- Knowledge artifact tracking
- PostgreSQL 17 standardization

### Tradeoffs

- Requires schema governance
- Requires migration discipline
- Requires validation before promotion
- Requires evidence capture for persistence changes

## Governance

No production-impacting persistence change may proceed without:

- Architecture review
- Security review
- Testing
- Documentation
- Evidence
- CI/CD validation
- Human approval
- Rollback plan

## Decision Owner

AIRA Architecture Owner

## Implementation Owner

AIRA Platform Lead