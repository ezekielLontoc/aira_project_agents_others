# Security Enforcement Foundation v1

## Status

Accepted

## Milestone

Milestone 11

## Purpose

Introduce enforceable API security controls for AIRA protected runtime APIs.

## Security Model

AIRA uses an API-key based enforcement foundation.

Header:

X-AIRA-API-Key

Local development key:

aira-local-dev-key-change-me

## Protected APIs

| Service | Protected Path |
|---|---|
| accelerator-agents | /api/v1/agents/** |
| accelerator-governance | /api/v1/governance/** |

## Public APIs

| Endpoint | Purpose |
|---|---|
| /api/health | Runtime health |
| /api/v1/security/health | Security service health |
| /api/persistence/health | Persistence health |
| /actuator/** | Actuator health/info |

## Enforcement Behavior

| Scenario | Expected Result |
|---|---|
| No API key | 401 DENIED |
| Wrong API key | 401 DENIED |
| Valid API key with active policy | 200 OK |
| Missing policy | 401 DENIED |
| Database validation failure | 401 DENIED, fail closed |

## Security Audit

Security decisions are recorded in:

aira_security.api_security_audit_event

Decisions:

- PUBLIC
- ALLOW
- DENY

## 10/10 Baseline

| Capability | Status |
|---|---|
| API key enforcement | Complete |
| Protected Agent Registry API | Complete |
| Protected Governance API | Complete |
| Public health endpoints preserved | Complete |
| Security audit event table | Complete |
| API key access policy table | Complete |
| Fail-closed deny behavior | Complete |
| Validation script | Complete |
| Evidence pack | Complete |
| ADR | Complete |

## Governance Rule

No protected API may be accessed without a valid API key and active policy.