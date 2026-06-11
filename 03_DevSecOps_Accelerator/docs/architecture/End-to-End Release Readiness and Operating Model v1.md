# End-to-End Release Readiness and Operating Model v1

## Status

Accepted after validation passes.

## Milestone

Milestone 15

## Purpose

Establish the final AIRA MVP release readiness and operating model baseline.

Milestone 15 confirms that AIRA is ready as an MVP runtime foundation across services, persistence, security, governance, evidence, CI/CD, portal, rollback, and operations.

## Protected Release APIs

| Method | Endpoint | Purpose |
|---|---|---|
| GET | /api/v1/governance/release/readiness | MVP release readiness |
| GET | /api/v1/governance/release/gates | MVP release gate results |
| GET | /api/v1/governance/release/operating-model | MVP operating model |
| GET | /api/v1/governance/release/rollback | MVP rollback readiness |

## Runtime URL

http://localhost:9092/api/v1/governance/release/readiness

Requires:

X-AIRA-API-Key

## MVP Scope

The MVP includes:

- Tomcat 11 WAR runtime
- PostgreSQL 17 persistence
- Docker runtime stack
- Agent Registry API
- Governance API
- Security enforcement
- Evidence and audit runtime
- CI/CD quality gates
- AIRA Portal
- MVP release readiness API
- MVP rollback readiness
- MVP operating model

## Release Readiness Gates

| Gate | Status |
|---|---|
| Runtime Gate | Passed |
| Persistence Gate | Passed |
| Security Gate | Passed |
| Agent Registry Gate | Passed |
| Governance Gate | Passed |
| Evidence Gate | Passed |
| CI/CD Gate | Passed |
| Portal Gate | Passed |
| Rollback Gate | Passed |
| Operating Model Gate | Passed |

## 10/10 MVP Baseline

| Capability | Status |
|---|---|
| Runtime health | Complete |
| Persistence health | Complete |
| Security enforcement | Complete |
| Agent Registry readiness | Complete |
| Governance readiness | Complete |
| Evidence readiness | Complete |
| CI/CD quality gates | Complete |
| Portal readiness | Complete |
| Release readiness API | Complete |
| Rollback readiness | Complete |
| Operating model | Complete |
| Human acceptance record | Complete |
| Evidence pack | Complete |
| ADR | Complete |

## Governance Rule

The MVP is release-ready only when all mandatory readiness checks pass and failClosed is true.