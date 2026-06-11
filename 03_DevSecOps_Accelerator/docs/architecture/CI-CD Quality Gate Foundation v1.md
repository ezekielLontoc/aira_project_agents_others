# CI/CD Quality Gate Foundation v1

## Status

Accepted after validation passes.

## Milestone

Milestone 13

## Purpose

Establish the AIRA CI/CD Quality Gate Foundation.

Milestone 13 formalizes delivery controls for build, packaging, Docker runtime, runtime health, persistence health, security enforcement, governance readiness, agent registry readiness, evidence readiness, evidence details, and GitHub Actions.

## Quality Gates

| Gate | Category | Purpose |
|---|---|---|
| SOURCE_STRUCTURE_GATE | Source | Validate expected repository and module structure |
| MAVEN_BUILD_GATE | Build | Validate Maven reactor build |
| WAR_ARTIFACT_GATE | Package | Validate all ROOT.war artifacts |
| DOCKER_BUILD_GATE | Container | Validate Docker image builds |
| DOCKER_RUNTIME_GATE | Runtime | Validate Docker runtime startup |
| BASE_HEALTH_GATE | Runtime Health | Validate all base health endpoints |
| PERSISTENCE_HEALTH_GATE | Persistence | Validate all persistence endpoints |
| SECURITY_ENFORCEMENT_GATE | Security | Validate protected API behavior |
| AGENT_REGISTRY_GATE | Agents | Validate Agent Registry readiness |
| GOVERNANCE_READINESS_GATE | Governance | Validate Governance readiness |
| EVIDENCE_READINESS_GATE | Evidence | Validate Evidence readiness |
| EVIDENCE_DETAIL_GATE | Evidence | Validate Evidence detail APIs |
| GITHUB_ACTIONS_GATE | CI/CD | Validate GitHub Actions workflow exists |

## Local Validation

Run:

powershell -ExecutionPolicy Bypass -File ".\scripts\validate-milestone-13-cicd-quality-gates.ps1"

## Quality Gate Summary

Run:

powershell -ExecutionPolicy Bypass -File ".\scripts\show-cicd-quality-gate-summary.ps1"

## GitHub Actions

Workflow:

.github/workflows/aira-cicd-quality-gates.yml

## 10/10 Baseline

| Capability | Status |
|---|---|
| Database-backed gate definitions | Complete |
| Database-backed gate runs | Complete |
| Database-backed gate results | Complete |
| Local quality gate runner | Complete |
| GitHub Actions workflow | Complete |
| Maven build validation | Complete |
| WAR artifact validation | Complete |
| Docker build validation | Complete |
| Runtime health validation | Complete |
| Persistence health validation | Complete |
| Security enforcement validation | Complete |
| Agent registry validation | Complete |
| Governance readiness validation | Complete |
| Evidence readiness validation | Complete |
| Evidence detail validation | Complete |
| Fail-closed behavior | Complete |

## Governance Rule

AIRA code changes are not release-ready unless all mandatory quality gates pass.