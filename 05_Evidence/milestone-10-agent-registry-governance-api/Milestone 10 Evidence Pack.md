# Milestone 10 Evidence Pack: Agent Registry API and Governance API

## Status

Complete after validation passes.

## Scope

Expose Agent Registry and Governance APIs from the AIRA runtime services.

## Evidence Items

| Evidence | Location |
|---|---|
| Agent Registry service | 03_DevSecOps_Accelerator/accelerator-agents/src/main/java/com/aira/accelerator/agents/registry/AgentRegistryService.java |
| Agent Registry controller | 03_DevSecOps_Accelerator/accelerator-agents/src/main/java/com/aira/accelerator/agents/registry/AgentRegistryController.java |
| Agent Registry summary response | 03_DevSecOps_Accelerator/accelerator-agents/src/main/java/com/aira/accelerator/agents/registry/AgentRegistrySummaryResponse.java |
| Governance API service | 03_DevSecOps_Accelerator/accelerator-governance/src/main/java/com/aira/accelerator/governance/api/GovernanceApiService.java |
| Governance API controller | 03_DevSecOps_Accelerator/accelerator-governance/src/main/java/com/aira/accelerator/governance/api/GovernanceApiController.java |
| Governance readiness response | 03_DevSecOps_Accelerator/accelerator-governance/src/main/java/com/aira/accelerator/governance/api/GovernanceReadinessResponse.java |
| Validation script | 03_DevSecOps_Accelerator/scripts/validate-milestone-10-agent-governance-api.ps1 |
| Summary script | 03_DevSecOps_Accelerator/scripts/show-milestone-10-api-summary.ps1 |
| Architecture doc | 03_DevSecOps_Accelerator/docs/architecture/Agent Registry API and Governance API v1.md |
| Governance doc | 03_DevSecOps_Accelerator/docs/architecture/Agent Registry API Governance v1.md |
| ADR | 03_DevSecOps_Accelerator/docs/adr/ADR-0005-Agent-Registry-Governance-API.md |

## Acceptance Criteria

Milestone 10 is accepted when:

- Maven build succeeds.
- All six WAR files exist.
- Docker images rebuild successfully.
- All base health endpoints return UP.
- All persistence endpoints return UP.
- Agent Registry list returns at least 8 agents.
- Agent detail returns architecture-agent.
- Agent prompt endpoint returns at least 1 prompt version.
- Agent model endpoint returns at least 1 model version.
- Governance control gates endpoint returns at least 10 gates.
- Governance readiness returns UP.
- failClosed is true.
- Git commit and push complete after validation.

## Governance Result

Milestone 10 exposes read-first Agent Registry and Governance APIs while preserving safety boundaries.