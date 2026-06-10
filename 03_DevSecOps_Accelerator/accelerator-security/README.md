# accelerator-security

## Purpose

The accelerator-security module provides the security boundary for the AIRA DevSecOps Accelerator.

## Port

9091

## Initial Capabilities

| Capability | Status |
|---|---|
| Security health endpoint | Complete |
| RBAC role catalog | Complete |
| Permission catalog | Complete |
| Token placeholder | Complete |
| Current user endpoint | Complete |
| Policy catalog | Complete |
| API key placeholder endpoints | Complete |
| Production action blocking | Complete |

## Endpoints

| Method | Endpoint | Purpose |
|---|---|---|
| GET | /api/v1/security/health | Security module health |
| POST | /api/v1/auth/token | Issue local placeholder token |
| GET | /api/v1/auth/me | Current local user |
| GET | /api/v1/policies | Security policies |
| GET | /api/v1/roles | Roles and permissions |
| POST | /api/v1/api-keys | Create placeholder API key |
| GET | /api/v1/api-keys | List placeholder API keys |
| DELETE | /api/v1/api-keys/{id} | Revoke placeholder API key |