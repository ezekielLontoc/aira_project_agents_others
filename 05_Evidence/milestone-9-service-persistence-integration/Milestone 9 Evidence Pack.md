# Milestone 9 Evidence Pack: Service Persistence Integration

## Status

Complete

## Scope

Connect all AIRA services to PostgreSQL 17 runtime persistence.

## Evidence Items

| Evidence | Location |
|---|---|
| Service datasource configuration | Each module src/main/resources/application.yml |
| Persistence response model | Each module persistence/PersistenceHealthResponse.java |
| Persistence service | Each module persistence/RuntimePersistenceService.java |
| Persistence controller | Each module persistence/RuntimePersistenceController.java |
| Docker Compose datasource env | 03_DevSecOps_Accelerator/docker-compose.runtime.yml |
| Validation script | 03_DevSecOps_Accelerator/scripts/validate-service-persistence-integration.ps1 |
| Restart and validate script | 03_DevSecOps_Accelerator/scripts/restart-and-validate-service-persistence.ps1 |
| Summary script | 03_DevSecOps_Accelerator/scripts/show-service-persistence-summary.ps1 |
| Architecture doc | 03_DevSecOps_Accelerator/docs/architecture/Service Persistence Integration v1.md |
| Governance doc | 03_DevSecOps_Accelerator/docs/architecture/Service Persistence Governance v1.md |
| ADR | 03_DevSecOps_Accelerator/docs/adr/ADR-0004-Service-Persistence-Integration.md |

## Acceptance Criteria

Milestone 9 is accepted when:

- Maven build succeeds.
- Docker images build successfully.
- Tomcat 11 containers start successfully.
- Base health endpoints remain available.
- /api/persistence/health returns UP on all services.
- Database status is UP.
- Baseline counts meet minimum thresholds.
- failClosed is true.
- Git commit and push complete.

## Governance Result

All AIRA services are now persistence-aware and fail closed if governed runtime persistence is unavailable or incomplete.