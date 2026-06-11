# ADR-0005: Agent Registry API and Governance API

## Status

Accepted

## Date

2026-06-11

## Context

Milestone 8 created governed persistence for agents, prompts, models, evidence, and governance controls.

Milestone 9 connected the AIRA services to PostgreSQL 17 and validated persistence health.

AIRA now requires runtime APIs to expose agent registry and governance data for future UI, workflows, and automation.

## Decision

Implement read-first Agent Registry APIs in accelerator-agents and read-first Governance APIs in accelerator-governance.

## Scope

Agent Registry APIs:

- List agents
- Get agent detail
- Get prompt versions
- Get model versions
- Get tool permissions
- Get agent governance summary

Governance APIs:

- List control gates
- List governance decisions
- List change requests
- List approval records
- Get governance readiness

## Safety Position

Milestone 10 does not introduce write APIs.

This preserves the governance rule that no agent or API may silently approve, deploy, promote, or modify production systems.

## Consequences

### Positive

- Agent registry is now runtime-accessible.
- Governance gates are now runtime-accessible.
- Future AIRA Portal can consume real APIs.
- Future security enforcement can wrap these APIs.
- Future write workflows can be added safely after RBAC and audit are implemented.

### Tradeoffs

- APIs are read-only in this milestone.
- Write workflows are deferred until security enforcement and audit are ready.
- Tool permission records may remain sparse until tool policy expansion.

## Governance

Read APIs are allowed.

Write APIs require future milestones for:

- Authentication
- Authorization
- RBAC
- API keys
- Audit logging
- Evidence binding
- Human approval workflow

## Decision Owner

AIRA Architecture Owner

## Implementation Owner

AIRA Platform Lead