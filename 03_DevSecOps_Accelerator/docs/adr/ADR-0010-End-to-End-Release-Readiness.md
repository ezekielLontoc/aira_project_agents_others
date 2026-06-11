# ADR-0010: End-to-End Release Readiness and Operating Model

## Status

Accepted

## Date

2026-06-11

## Context

AIRA has completed the MVP foundation milestones:

- Agent Runtime Foundation
- DevSecOps Accelerator Scaffold
- Spring Boot API Skeleton
- Multi-Module Maven Foundation
- Security Capability Scaffold
- PostgreSQL 17 Foundation
- Tomcat 11 Docker Runtime Foundation
- Runtime Persistence Foundation
- Service Persistence Integration
- Agent Registry and Governance APIs
- Security Enforcement Foundation
- Evidence and Audit Runtime Foundation
- CI/CD Quality Gate Foundation
- AIRA Portal / Frontend Foundation

AIRA now requires a final end-to-end release readiness and operating model milestone.

## Decision

Implement database-backed MVP release readiness, release gates, rollback readiness, operating model, human acceptance, and protected release readiness APIs.

## Protected APIs

- /api/v1/governance/release/readiness
- /api/v1/governance/release/gates
- /api/v1/governance/release/operating-model
- /api/v1/governance/release/rollback

## Consequences

### Positive

- MVP readiness is measurable.
- Release readiness is queryable through protected APIs.
- Rollback readiness is explicit.
- Operating model is recorded.
- Acceptance is evidence-backed.
- Final validation runs against runtime, persistence, security, evidence, portal, and CI/CD.

### Tradeoffs

- This is MVP release readiness, not production release automation.
- Production release still requires stronger identity, RBAC, secret management, deployment orchestration, backup automation, and formal approval workflow.

## Governance

AIRA is MVP-ready only when release readiness returns UP, mvpReady is true, rollbackReady is true, operatingModelReady is true, humanAcceptanceReady is true, and failClosed is true.

## Decision Owner

AIRA Platform Owner

## Implementation Owner

AIRA Platform Lead