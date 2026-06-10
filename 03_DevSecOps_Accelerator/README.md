# AIRA DevSecOps Accelerator

## Purpose

The AIRA DevSecOps Accelerator is the internal platform layer that replaces external accelerators such as Supabase.

It provides:

- Agent runtime integration
- Governance enforcement
- Security controls
- Evidence generation
- API orchestration
- PostgreSQL-backed persistence
- Knowledge Fabric connectivity
- CI/CD integration
- Observability

## Core Modules

| Module | Purpose |
|---|---|
| accelerator-core | Shared platform domain logic |
| accelerator-api | REST/API boundary |
| accelerator-security | Identity, access, policy controls |
| accelerator-governance | ADR, TRB, ARB, standards enforcement |
| accelerator-evidence | Evidence pack and audit artifact generation |
| accelerator-agents | Agent runtime integration |
| accelerator-observability | Logs, metrics, traces, runtime health |
| accelerator-config | Environment and platform configuration |

## Runtime Strategy

Java/Spring/Tomcat owns the governed enterprise platform.

AI agent execution can be integrated through Python, MCP, or future agent runtimes.

## PostgreSQL 17 Foundation

PostgreSQL 17 is mandatory for the AIRA DevSecOps Accelerator persistence foundation.

Initial schemas:

- aira_security
- aira_governance
- aira_evidence
- aira_agents
- aira_runtime
- aira_observability

Database profiles are configured but not auto-enabled.