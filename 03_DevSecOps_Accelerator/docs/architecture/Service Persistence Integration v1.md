# Service Persistence Integration v1

## Status

Accepted

## Milestone

Milestone 9

## Purpose

Connect all AIRA Spring Boot services to the PostgreSQL 17 runtime persistence foundation created in Milestone 8.

## Scope

This milestone integrates persistence into:

- accelerator-api
- accelerator-security
- accelerator-governance
- accelerator-evidence
- accelerator-agents
- accelerator-observability

## Runtime Model

Docker
-> Apache Tomcat 11
-> ROOT.war
-> Spring Boot Service
-> JDBC / HikariCP
-> PostgreSQL 17
-> AIRA Runtime Persistence Foundation

## Persistence Endpoint

Each service exposes:

/api/persistence/health

## Validation Behavior

Each service validates:

- PostgreSQL connectivity
- Agent definition baseline
- Control gate baseline
- Prompt version baseline
- Model version baseline
- Evidence pack baseline
- Evidence artifact baseline
- Secret control baseline
- Persistence audit baseline

## Fail-Closed Behavior

If the database is unavailable or required baseline records are missing, the endpoint returns a blocked/down status.

## Service URLs

| Service | URL |
|---|---|
| accelerator-api | http://localhost:9090/api/persistence/health |
| accelerator-security | http://localhost:9091/api/persistence/health |
| accelerator-governance | http://localhost:9092/api/persistence/health |
| accelerator-evidence | http://localhost:9093/api/persistence/health |
| accelerator-agents | http://localhost:9094/api/persistence/health |
| accelerator-observability | http://localhost:9095/api/persistence/health |

## 10/10 Baseline

| Capability | Status |
|---|---|
| JDBC dependency | Complete |
| PostgreSQL driver | Complete |
| HikariCP configuration | Complete |
| Docker datasource environment | Complete |
| Persistence health endpoint | Complete |
| Fail-closed persistence check | Complete |
| Service validation script | Complete |
| Restart and validation script | Complete |
| Architecture documentation | Complete |
| ADR | Complete |
| Evidence pack | Complete |

## Validation Command

powershell -ExecutionPolicy Bypass -File ".\scripts\validate-service-persistence-integration.ps1"

## Restart and Validate Command

powershell -ExecutionPolicy Bypass -File ".\scripts\restart-and-validate-service-persistence.ps1"

## Governance Rule

AIRA services must not be considered runtime-ready unless persistence health passes.