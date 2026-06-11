# Milestone 12 Evidence Pack: Evidence and Audit Runtime Foundation

## Status

Complete after validation passes.

## Scope

Expose protected Evidence and Audit Runtime APIs.

## Evidence Items

| Evidence | Location |
|---|---|
| Evidence migration | 03_DevSecOps_Accelerator/database/migrations/V8__aira_evidence_audit_runtime_foundation.sql |
| Evidence seed | 03_DevSecOps_Accelerator/database/seed/V9__aira_evidence_audit_runtime_seed.sql |
| Apply script | 03_DevSecOps_Accelerator/scripts/apply-evidence-audit-runtime-foundation.ps1 |
| Evidence API service | 03_DevSecOps_Accelerator/accelerator-evidence/src/main/java/com/aira/accelerator/evidence/api/EvidenceRuntimeService.java |
| Evidence API controller | 03_DevSecOps_Accelerator/accelerator-evidence/src/main/java/com/aira/accelerator/evidence/api/EvidenceRuntimeController.java |
| Evidence readiness response | 03_DevSecOps_Accelerator/accelerator-evidence/src/main/java/com/aira/accelerator/evidence/api/EvidenceReadinessResponse.java |
| Security enforcement classes | 03_DevSecOps_Accelerator/accelerator-evidence/src/main/java/com/aira/accelerator/evidence/security |
| Validation script | 03_DevSecOps_Accelerator/scripts/validate-milestone-12-evidence-audit-runtime.ps1 |
| Summary script | 03_DevSecOps_Accelerator/scripts/show-milestone-12-evidence-summary.ps1 |
| Architecture doc | 03_DevSecOps_Accelerator/docs/architecture/Evidence and Audit Runtime Foundation v1.md |
| Governance doc | 03_DevSecOps_Accelerator/docs/architecture/Evidence and Audit Runtime Governance v1.md |
| ADR | 03_DevSecOps_Accelerator/docs/adr/ADR-0007-Evidence-Audit-Runtime-Foundation.md |

## Acceptance Criteria

Milestone 12 is accepted when:

- SQL migration applies.
- SQL seed applies.
- Maven build succeeds.
- All WAR files exist.
- Docker images rebuild successfully.
- Base health endpoints return UP.
- Persistence endpoints return UP.
- Evidence APIs deny missing key.
- Evidence APIs deny wrong key.
- Evidence APIs allow correct key.
- Evidence packs endpoint returns at least 1 pack.
- Evidence artifacts endpoint returns at least 4 artifacts.
- Traceability endpoint returns at least 1 link.
- Runtime audit endpoint returns at least 1 record.
- Evidence readiness returns UP.
- failClosed is true.
- Git commit and push complete after validation.

## Governance Result

AIRA evidence and audit runtime data is now protected, queryable, and readiness-validated.