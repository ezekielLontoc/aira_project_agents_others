# AIRA Portal Governance v1

## Status

Accepted after validation passes.

## Purpose

Define governance rules for the AIRA Portal / Frontend Foundation.

## Rules

| Rule | Requirement |
|---|---|
| Read-first | Portal must not mutate backend state in this milestone |
| No embedded secrets | Portal source must not hardcode production secrets |
| API key required | Protected APIs require X-AIRA-API-Key |
| Fail closed | Missing or wrong key must be denied |
| CORS constrained | Browser access is limited to http://localhost:9090 |
| Evidence-backed | Portal readiness must be recorded and validated |
| Regression-safe | Milestone 13 quality gates must still pass |

## Portal Scope

The portal may show:

- portal readiness
- agent registry readiness
- governance readiness
- evidence readiness
- evidence pack status
- quality gate baseline status

The portal may not:

- approve changes
- create releases
- deploy services
- rotate secrets
- change policies
- modify evidence
- bypass API security

## Future Expansion

Future milestones may add:

- login and identity
- RBAC-aware screens
- approval workflows
- release readiness dashboards
- rollback dashboards
- evidence review workflows