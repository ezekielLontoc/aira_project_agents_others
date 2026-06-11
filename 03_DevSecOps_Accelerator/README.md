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
## Tomcat 11 Docker Runtime

AIRA services are deployed as WAR files into Apache Tomcat 11 containers.

Host ports remain 9090 through 9095.

Container application port is 8080 because Tomcat listens internally on 8080.
## Milestone 8 - Runtime Persistence Foundation

AIRA now includes a governed PostgreSQL 17 runtime persistence foundation.

Core capabilities:

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
- Security findings
- Secret controls
- Test execution records
- Release gate checks
- Deployment readiness
- Rollback readiness
- Runtime health snapshots
- Knowledge artifacts

Apply:

powershell -ExecutionPolicy Bypass -File ".\scripts\apply-runtime-persistence.ps1"

Validate:

powershell -ExecutionPolicy Bypass -File ".\scripts\validate-runtime-persistence.ps1"

Health check:

powershell -ExecutionPolicy Bypass -File ".\scripts\check-runtime-persistence-health.ps1"
## Milestone 9 - Service Persistence Integration

AIRA services now connect to PostgreSQL 17 runtime persistence.

Persistence health endpoints:

- http://localhost:9090/api/persistence/health
- http://localhost:9091/api/persistence/health
- http://localhost:9092/api/persistence/health
- http://localhost:9093/api/persistence/health
- http://localhost:9094/api/persistence/health
- http://localhost:9095/api/persistence/health

Validate:

powershell -ExecutionPolicy Bypass -File ".\scripts\validate-service-persistence-integration.ps1"

Restart and validate:

powershell -ExecutionPolicy Bypass -File ".\scripts\restart-and-validate-service-persistence.ps1"
## Milestone 10 - Agent Registry API and Governance API

AIRA now exposes read-first runtime APIs for Agent Registry and Governance.

Agent Registry:

- http://localhost:9094/api/v1/agents
- http://localhost:9094/api/v1/agents/architecture-agent
- http://localhost:9094/api/v1/agents/architecture-agent/prompts
- http://localhost:9094/api/v1/agents/architecture-agent/models
- http://localhost:9094/api/v1/agents/architecture-agent/tools
- http://localhost:9094/api/v1/agents/governance/summary

Governance:

- http://localhost:9092/api/v1/governance/control-gates
- http://localhost:9092/api/v1/governance/decisions
- http://localhost:9092/api/v1/governance/change-requests
- http://localhost:9092/api/v1/governance/approvals
- http://localhost:9092/api/v1/governance/readiness

Validate:

powershell -ExecutionPolicy Bypass -File ".\scripts\validate-milestone-10-agent-governance-api.ps1"

Show summary:

powershell -ExecutionPolicy Bypass -File ".\scripts\show-milestone-10-api-summary.ps1"
## Milestone 11 - Security Enforcement Foundation

AIRA now protects Agent Registry and Governance APIs using API-key based enforcement.

Header:

X-AIRA-API-Key

Local development key:

aira-local-dev-key-change-me

Protected examples:

powershell -Command "Invoke-RestMethod -Uri 'http://localhost:9094/api/v1/agents' -Headers @{ 'X-AIRA-API-Key' = 'aira-local-dev-key-change-me' }"

powershell -Command "Invoke-RestMethod -Uri 'http://localhost:9092/api/v1/governance/readiness' -Headers @{ 'X-AIRA-API-Key' = 'aira-local-dev-key-change-me' }"

Validate:

powershell -ExecutionPolicy Bypass -File ".\scripts\validate-milestone-11-security-enforcement.ps1"

Security audit summary:

powershell -ExecutionPolicy Bypass -File ".\scripts\show-security-audit-summary.ps1"
## Milestone 12 - Evidence and Audit Runtime Foundation

AIRA now exposes protected Evidence and Audit Runtime APIs.

Header:

X-AIRA-API-Key

Local development key:

aira-local-dev-key-change-me

Protected examples:

powershell -Command "Invoke-RestMethod -Uri 'http://localhost:9093/api/v1/evidence/readiness' -Headers @{ 'X-AIRA-API-Key' = 'aira-local-dev-key-change-me' }"

powershell -Command "Invoke-RestMethod -Uri 'http://localhost:9093/api/v1/evidence/packs' -Headers @{ 'X-AIRA-API-Key' = 'aira-local-dev-key-change-me' }"

Validate:

powershell -ExecutionPolicy Bypass -File ".\scripts\validate-milestone-12-evidence-audit-runtime.ps1"

Show summary:

powershell -ExecutionPolicy Bypass -File ".\scripts\show-milestone-12-evidence-summary.ps1"
## Milestone 13 - CI/CD Quality Gate Foundation

AIRA now includes database-backed CI/CD quality gates, local validation scripts, and GitHub Actions workflow.

Validate locally:

powershell -ExecutionPolicy Bypass -File ".\scripts\validate-milestone-13-cicd-quality-gates.ps1"

Show quality gate summary:

powershell -ExecutionPolicy Bypass -File ".\scripts\show-cicd-quality-gate-summary.ps1"

GitHub Actions workflow:

.github/workflows/aira-cicd-quality-gates.yml
## Milestone 14 - AIRA Portal / Frontend Foundation

AIRA now includes a dependency-light portal served by accelerator-api.

Portal:

http://localhost:9090/portal/index.html

Portal readiness:

http://localhost:9090/api/v1/portal/readiness

Validate:

powershell -ExecutionPolicy Bypass -File ".\scripts\validate-milestone-14-aira-portal.ps1"

Show summary:

powershell -ExecutionPolicy Bypass -File ".\scripts\show-portal-readiness-summary.ps1"
## Milestone 15 - End-to-End Release Readiness and Operating Model

AIRA now includes MVP release readiness, rollback readiness, operating model, human acceptance, and protected release readiness APIs.

Protected release readiness API:

http://localhost:9092/api/v1/governance/release/readiness

Validate:

powershell -ExecutionPolicy Bypass -File ".\scripts\validate-milestone-15-mvp-release-readiness.ps1"

Show summary:

powershell -ExecutionPolicy Bypass -File ".\scripts\show-mvp-release-readiness-summary.ps1"