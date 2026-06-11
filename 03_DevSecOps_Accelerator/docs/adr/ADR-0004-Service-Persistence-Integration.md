# ADR-0004: Service Persistence Integration

## Status

Accepted

## Date

2026-06-11

## Context

Milestone 8 created the AIRA Runtime Persistence Foundation in PostgreSQL 17. The six AIRA Spring Boot services must now connect to this database and validate that the governed baseline exists.

## Decision

All AIRA services will use JDBC with PostgreSQL through Spring Boot datasource configuration.

Each service will expose a persistence health endpoint:

/api/persistence/health

The endpoint validates:

- Database connectivity
- Agent definitions
- Control gates
- Prompt versions
- Model versions
- Evidence packs
- Evidence artifacts
- Secret controls
- Persistence audit records

## Runtime

Docker
-> Tomcat 11
-> Spring Boot WAR
-> JDBC / HikariCP
-> PostgreSQL 17

## Consequences

### Positive

- Services now depend on governed runtime persistence
- Runtime readiness becomes more meaningful
- Fail-closed persistence behavior is visible
- Future APIs can use PostgreSQL foundation
- Agent Registry API and Governance API can proceed next

### Tradeoffs

- Services require PostgreSQL availability
- Local runtime requires datasource configuration
- Persistence baseline must be applied before service readiness

## Governance

No production service may be promoted unless persistence validation passes.

## Decision Owner

AIRA Architecture Owner

## Implementation Owner

AIRA Platform Lead