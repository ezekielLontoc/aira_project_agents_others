# Evidence and Audit Runtime Foundation v1

## Status

Accepted

## Milestone

Milestone 12

## Purpose

Expose governed Evidence and Audit runtime APIs from accelerator-evidence.

Milestone 12 makes evidence packs, evidence artifacts, traceability links, runtime audit records, and security audit events accessible through protected runtime APIs.

## Service Updated

| Service | Port | Purpose |
|---|---:|---|
| accelerator-evidence | 9093 | Evidence and Audit Runtime API |

## Protected Evidence APIs

| Method | Endpoint | Purpose |
|---|---|---|
| GET | /api/v1/evidence/packs | List evidence packs |
| GET | /api/v1/evidence/packs/{evidencePackKey} | Get one evidence pack |
| GET | /api/v1/evidence/packs/{evidencePackKey}/artifacts | List artifacts for one pack |
| GET | /api/v1/evidence/artifacts | List evidence artifacts |
| GET | /api/v1/evidence/traceability | List traceability links |
| GET | /api/v1/evidence/runtime-audit | List evidence runtime audit records |
| GET | /api/v1/evidence/security-audit | List API security audit events |
| GET | /api/v1/evidence/readiness | Get evidence readiness |

## Security

Header:

X-AIRA-API-Key

Local development key:

aira-local-dev-key-change-me

## Runtime URLs

- http://localhost:9093/api/v1/evidence/packs
- http://localhost:9093/api/v1/evidence/packs/MILESTONE-8-RUNTIME-PERSISTENCE
- http://localhost:9093/api/v1/evidence/packs/MILESTONE-8-RUNTIME-PERSISTENCE/artifacts
- http://localhost:9093/api/v1/evidence/artifacts
- http://localhost:9093/api/v1/evidence/traceability
- http://localhost:9093/api/v1/evidence/runtime-audit
- http://localhost:9093/api/v1/evidence/security-audit
- http://localhost:9093/api/v1/evidence/readiness

## 10/10 Baseline

| Capability | Status |
|---|---|
| Evidence pack API | Complete |
| Evidence artifact API | Complete |
| Traceability API | Complete |
| Runtime audit API | Complete |
| Security audit API | Complete |
| Evidence readiness API | Complete |
| API-key protection | Complete |
| Fail-closed behavior | Complete |
| Validation script | Complete |
| Evidence pack | Complete |
| ADR | Complete |

## Governance Rule

Evidence APIs are read-first. They do not modify evidence, approve changes, deploy systems, or bypass governance.

Write APIs may be introduced only after stronger RBAC, audit, approval, and evidence immutability controls are implemented.