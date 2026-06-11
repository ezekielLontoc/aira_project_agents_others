# Milestone 11 Evidence Pack: Security Enforcement Foundation

## Status

Complete after validation passes.

## Scope

Protect Agent Registry and Governance APIs with API-key based enforcement.

## Evidence Items

| Evidence | Location |
|---|---|
| Security migration | 03_DevSecOps_Accelerator/database/migrations/V6__aira_security_enforcement_foundation.sql |
| Security seed | 03_DevSecOps_Accelerator/database/seed/V7__aira_security_enforcement_seed.sql |
| Apply script | 03_DevSecOps_Accelerator/scripts/apply-security-enforcement-foundation.ps1 |
| Validation script | 03_DevSecOps_Accelerator/scripts/validate-milestone-11-security-enforcement.ps1 |
| Audit summary script | 03_DevSecOps_Accelerator/scripts/show-security-audit-summary.ps1 |
| Architecture doc | 03_DevSecOps_Accelerator/docs/architecture/Security Enforcement Foundation v1.md |
| Governance doc | 03_DevSecOps_Accelerator/docs/architecture/Security Enforcement Governance v1.md |
| ADR | 03_DevSecOps_Accelerator/docs/adr/ADR-0006-Security-Enforcement-Foundation.md |

## Acceptance Criteria

Milestone 11 is accepted when:

- Security migration applies.
- Security seed applies.
- Maven build succeeds.
- Docker images rebuild successfully.
- Base health endpoints remain public and UP.
- Persistence endpoints remain public and UP.
- Protected Agent Registry APIs deny missing key.
- Protected Governance APIs deny missing key.
- Protected APIs deny wrong key.
- Protected APIs allow correct key.
- Security audit records are written.
- Git commit and push complete after validation.

## Governance Result

AIRA protected APIs now fail closed when API key validation fails.