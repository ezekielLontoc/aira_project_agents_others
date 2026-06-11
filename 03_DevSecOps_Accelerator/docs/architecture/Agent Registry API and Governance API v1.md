# Agent Registry API and Governance API v1

## Status

Accepted

## Milestone

Milestone 10

## Purpose

Expose the AIRA Agent Registry and Governance baseline through runtime APIs.

Milestone 10 turns the persisted data from Milestone 8 and the service persistence integration from Milestone 9 into usable service endpoints.

## Services Updated

| Service | Port | Purpose |
|---|---:|---|
| accelerator-agents | 9094 | Agent Registry API |
| accelerator-governance | 9092 | Governance API |

## Agent Registry APIs

| Method | Endpoint | Purpose |
|---|---|---|
| GET | /api/v1/agents | List all agent definitions |
| GET | /api/v1/agents/{agentName} | Get one agent definition |
| GET | /api/v1/agents/{agentName}/prompts | Get prompt versions for one agent |
| GET | /api/v1/agents/{agentName}/models | Get model versions for one agent |
| GET | /api/v1/agents/{agentName}/tools | Get tool permissions for one agent |
| GET | /api/v1/agents/governance/summary | Get registry readiness summary |

## Governance APIs

| Method | Endpoint | Purpose |
|---|---|---|
| GET | /api/v1/governance/control-gates | List mandatory control gates |
| GET | /api/v1/governance/decisions | List governance decisions |
| GET | /api/v1/governance/change-requests | List change requests |
| GET | /api/v1/governance/approvals | List approval records |
| GET | /api/v1/governance/readiness | Get governance readiness |

## Runtime URLs

Agent Registry:

- http://localhost:9094/api/v1/agents
- http://localhost:9094/api/v1/agents/architecture-agent
- http://localhost:9094/api/v1/agents/architecture-agent/prompts
- http://localhost:9094/api/v1/agents/architecture-agent/models
- http://localhost:9094/api/v1/agents/architecture-agent/tools
- http://localhost:9094/api/v1/agents/governance/summary

Governance:

- http://localhost:9092/api/v1/governance/control-gates
- http://localhost:9092/api/v1/governance/decisions
- http://localhost:9092/api/v1/governance/change-requests
- http://localhost:9092/api/v1/governance/approvals
- http://localhost:9092/api/v1/governance/readiness

## 10/10 Baseline

| Capability | Status |
|---|---|
| Agent Registry list API | Complete |
| Agent Registry detail API | Complete |
| Agent prompt version API | Complete |
| Agent model version API | Complete |
| Agent tool permission API | Complete |
| Agent governance summary API | Complete |
| Governance control gate API | Complete |
| Governance decision API | Complete |
| Governance change request API | Complete |
| Governance approval API | Complete |
| Governance readiness API | Complete |
| Runtime validation script | Complete |
| Evidence pack | Complete |
| ADR | Complete |
| Fail-closed readiness response | Complete |

## Governance Rule

Milestone 10 APIs are read-first. They expose governed state but do not approve, deploy, promote, or mutate production systems.

Write APIs may be introduced later only after security enforcement, authentication, RBAC, audit, evidence binding, and approval workflow are implemented.