# Security Enforcement Governance v1

## Status

Accepted

## Purpose

Defines governance rules for AIRA API security enforcement.

## Mandatory Rules

| Rule | Requirement |
|---|---|
| No silent access | Protected APIs require API key |
| No secret exposure | API keys must not be printed in logs or responses |
| Fail closed | Missing/invalid key denies access |
| Audit trail | Security decisions must be recorded |
| Least privilege | API key policy grants only needed paths |
| Read-first | Milestone 11 protects read APIs only |
| Human approval | Production API key creation/change requires approval |

## Current Scope

Milestone 11 protects:

- Agent Registry APIs
- Governance APIs

## Future Scope

Future milestones may extend security to:

- Evidence APIs
- Write APIs
- Approval APIs
- Release APIs
- Portal APIs

## Production Safety

The local development API key must be replaced before production use.