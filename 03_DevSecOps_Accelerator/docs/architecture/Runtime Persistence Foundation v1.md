# Runtime Persistence Foundation v1

## Status

Accepted

## Milestone

Milestone 8

## Purpose

Establish the AIRA Runtime Persistence Foundation using PostgreSQL 17.

This milestone converts persistence from a running database container into a governed platform capability.

## Runtime Persistence Baseline

The persistence foundation supports:

- Agent registry
- Agent definitions
- Agent prompt versions
- Agent model versions
- Agent tool permissions
- Agent execution audit
- Governance decisions
- Control gates
- Approval records
- Evidence packs
- Evidence artifacts
- Traceability links
- Security findings
- Secret controls
- Test execution records
- Release gate checks
- Deployment readiness
- Rollback readiness
- Runtime health snapshots
- Knowledge artifacts
- Persistence audit records

## 10/10 Baseline

This milestone is considered 10/10 because it defines:

| Capability | Status |
|---|---|
| PostgreSQL 17 persistence | Complete |
| Governed schemas | Complete |
| Agent persistence | Complete |
| Governance persistence | Complete |
| Evidence persistence | Complete |
| Security persistence | Complete |
| Testing persistence | Complete |
| Runtime release gates | Complete |
| Observability persistence | Complete |
| Knowledge persistence | Complete |
| Seed data | Complete |
| Validation SQL | Complete |
| Apply script | Complete |
| Health check script | Complete |
| Evidence pack | Complete |
| Fail-closed rules | Complete |

## Database Schemas

| Schema | Purpose |
|---|---|
| aira_security | Security controls, findings, secret governance |
| aira_governance | Change requests, decisions, approval records, control gates |
| aira_evidence | Evidence packs, artifacts, traceability |
| aira_agents | Agent definitions, prompts, models, permissions, audit |
| aira_runtime | Release gates, deployment readiness, rollback readiness, persistence audit |
| aira_observability | Runtime health snapshots |
| aira_testing | Test execution records |
| aira_knowledge | Obsidian, LLM Wiki, and knowledge artifact registry |

## Apply Command

powershell -ExecutionPolicy Bypass -File "D:\ChatGPT Workspace Folder Projects\AIRA Projects\03_DevSecOps_Accelerator\scripts\apply-runtime-persistence.ps1"

## Validate Command

powershell -ExecutionPolicy Bypass -File "D:\ChatGPT Workspace Folder Projects\AIRA Projects\03_DevSecOps_Accelerator\scripts\validate-runtime-persistence.ps1"

## Health Check Command

powershell -ExecutionPolicy Bypass -File "D:\ChatGPT Workspace Folder Projects\AIRA Projects\03_DevSecOps_Accelerator\scripts\check-runtime-persistence-health.ps1"

## Governance

No production-impacting change may proceed without:

- Architecture gate
- Security gate
- Test gate
- Documentation gate
- Evidence gate
- CI/CD gate
- Approval gate
- Rollback gate
- Knowledge gate

## Fail-Closed Rule

If required information, tests, evidence, approval, or gate results are missing, the persistence workflow fails closed.