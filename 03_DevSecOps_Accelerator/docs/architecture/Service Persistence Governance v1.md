# Service Persistence Governance v1

## Status

Accepted

## Purpose

Defines governance requirements for AIRA service-to-database integration.

## Mandatory Controls

| Control | Rule |
|---|---|
| Database connectivity | All services must validate PostgreSQL connectivity |
| Baseline verification | Services must verify required Milestone 8 records |
| Fail closed | Missing database or baseline data blocks readiness |
| Secrets | Services must not expose database passwords through endpoints |
| Evidence | Validation results must be captured as evidence |
| Human approval | Production datasource changes require human approval |
| Least privilege | Services use controlled database credentials |
| Versioning | Persistence integration changes are version controlled |

## Production Safety

No service may silently switch databases, alter production schemas, or bypass persistence validation.

## Runtime Readiness

A service is runtime-ready only when:

- Tomcat container is up
- Base health endpoint is up
- Persistence endpoint is up
- Database status is UP
- Baseline counts meet minimum thresholds
- failClosed is true

## Gate

Service Persistence Gate is mandatory before API expansion, Agent Registry API, Governance API, and Evidence API development.