# Enterprise Server-IP Runtime Hardening Evidence

## Status

Complete after validation passes.

## Server IP

192.168.179.193

## Evidence

| Evidence | Location |
|---|---|
| Compose override | 03_DevSecOps_Accelerator/docker-compose.enterprise-ip.yml |
| Enterprise env example | 03_DevSecOps_Accelerator/.env.enterprise.example |
| Local enterprise env | 03_DevSecOps_Accelerator/.env.enterprise.local |
| Start script | 03_DevSecOps_Accelerator/scripts/start-enterprise-ip-runtime.ps1 |
| Validation script | 03_DevSecOps_Accelerator/scripts/validate-enterprise-ip-runtime.ps1 |
| Portal frontend | 03_DevSecOps_Accelerator/accelerator-api/src/main/resources/static/portal |
| Portal readiness API | 03_DevSecOps_Accelerator/accelerator-api/src/main/java/com/aira/accelerator/api/portal |
| CORS configs | accelerator-agents, accelerator-governance, accelerator-evidence ApiSecurityWebConfig.java |
| Architecture doc | 03_DevSecOps_Accelerator/docs/architecture/Enterprise Server-IP Runtime Hardening v1.md |
| ADR | 03_DevSecOps_Accelerator/docs/adr/ADR-0011-Enterprise-Server-IP-Runtime-Hardening.md |

## Acceptance

This hardening is accepted when:

- GitHub source remains clean before commit.
- Maven build succeeds.
- All six WAR files build.
- Docker runtime starts using enterprise override.
- localhost endpoints return UP.
- server-IP endpoints return UP.
- portal loads from server IP.
- portal readiness returns server-IP URL.
- CORS accepts server-IP portal origin.
- protected APIs deny missing key.
- protected APIs allow valid key.
- release readiness returns UP.
- mvpReady is true.
- failClosed is true.