# AIRA Portal Frontend Foundation v1

## Status

Accepted after validation passes.

## Milestone

Milestone 14

## Purpose

Create the AIRA Portal / Frontend Foundation.

The portal is a dependency-light static frontend served by accelerator-api through Tomcat 11. It provides a governed dashboard for runtime readiness across Agent Registry, Governance, Evidence, and CI/CD quality gates.

## Portal URL

http://localhost:9090/portal/index.html

Short route:

http://localhost:9090/portal

## Portal Backend Readiness API

http://localhost:9090/api/v1/portal/readiness

## Backend APIs Used

| Capability | Endpoint | Service |
|---|---|---|
| Agent Registry Summary | /api/v1/agents/governance/summary | accelerator-agents |
| Governance Readiness | /api/v1/governance/readiness | accelerator-governance |
| Evidence Readiness | /api/v1/evidence/readiness | accelerator-evidence |
| Evidence Pack Detail | /api/v1/evidence/packs/MILESTONE-8-RUNTIME-PERSISTENCE | accelerator-evidence |
| Evidence Pack Artifacts | /api/v1/evidence/packs/MILESTONE-8-RUNTIME-PERSISTENCE/artifacts | accelerator-evidence |

## Security Model

The portal static files are public.

Protected backend APIs still require:

X-AIRA-API-Key

The portal does not embed secrets. The API key is entered by the user and stored only in local browser localStorage for local development.

## CORS

Protected services allow browser access from:

http://localhost:9090

Allowed methods:

- GET
- OPTIONS

Allowed headers:

- X-AIRA-API-Key
- Content-Type
- Authorization

## 10/10 Baseline

| Capability | Status |
|---|---|
| Static portal served by accelerator-api | Complete |
| Portal readiness API | Complete |
| Browser dashboard for platform readiness | Complete |
| API key input for protected APIs | Complete |
| No embedded secrets | Complete |
| CORS support for protected APIs | Complete |
| Protected API fail-closed behavior retained | Complete |
| Portal validation script | Complete |
| GitHub Actions portal file validation | Complete |
| Documentation | Complete |
| ADR | Complete |
| Evidence pack | Complete |

## Governance Rule

The portal is a read-first control surface. It cannot approve, deploy, mutate production systems, or bypass protected backend API security.