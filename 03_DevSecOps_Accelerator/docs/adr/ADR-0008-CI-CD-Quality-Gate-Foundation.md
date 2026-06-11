# ADR-0008: CI/CD Quality Gate Foundation

## Status

Accepted

## Date

2026-06-11

## Context

AIRA has established runtime services, PostgreSQL persistence, service persistence integration, Agent Registry APIs, Governance APIs, Security Enforcement, and Evidence/Audit Runtime APIs.

AIRA now requires governed CI/CD quality gates to validate platform readiness before future release and deployment automation.

## Decision

Implement a CI/CD Quality Gate Foundation with:

- database-backed gate definitions
- database-backed gate runs
- database-backed gate results
- local quality gate runner
- GitHub Actions workflow
- fail-closed validation behavior

## Quality Gate Scope

The foundation validates:

- source structure
- Maven build
- WAR artifacts
- Docker image build
- Docker runtime startup
- base health endpoints
- persistence health endpoints
- API-key security enforcement
- Agent Registry readiness
- Governance readiness
- Evidence readiness
- Evidence detail APIs
- GitHub Actions workflow presence

## Consequences

### Positive

- Delivery quality becomes measurable.
- Quality gates become auditable.
- Runtime readiness is validated before future release work.
- GitHub Actions foundation is established.
- Evidence is stored in PostgreSQL.

### Tradeoffs

- This milestone does not deploy to production.
- Future release automation still requires approval and rollback workflows.
- GitHub Actions validates build/package/container but not local Docker runtime endpoints.

## Governance

Any failed mandatory quality gate blocks release readiness.

## Decision Owner

AIRA DevSecOps Owner

## Implementation Owner

AIRA Platform Lead