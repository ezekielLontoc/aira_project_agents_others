# Milestone 15 Evidence Pack: End-to-End Release Readiness and Operating Model

## Status

Complete after validation passes.

## Scope

Finalize the AIRA MVP release readiness and operating model baseline.

## Evidence Items

| Evidence | Location |
|---|---|
| Release readiness migration | 03_DevSecOps_Accelerator/database/migrations/V14__aira_mvp_release_readiness_foundation.sql |
| Release readiness seed | 03_DevSecOps_Accelerator/database/seed/V15__aira_mvp_release_readiness_seed.sql |
| Apply script | 03_DevSecOps_Accelerator/scripts/apply-mvp-release-readiness-foundation.ps1 |
| Validation script | 03_DevSecOps_Accelerator/scripts/validate-milestone-15-mvp-release-readiness.ps1 |
| Summary script | 03_DevSecOps_Accelerator/scripts/show-mvp-release-readiness-summary.ps1 |
| Release readiness API | 03_DevSecOps_Accelerator/accelerator-governance/src/main/java/com/aira/accelerator/governance/release |
| Architecture doc | 03_DevSecOps_Accelerator/docs/architecture/End-to-End Release Readiness and Operating Model v1.md |
| Operating model doc | 03_DevSecOps_Accelerator/docs/architecture/MVP Operating Model v1.md |
| ADR | 03_DevSecOps_Accelerator/docs/adr/ADR-0010-End-to-End-Release-Readiness.md |

## Acceptance Criteria

Milestone 15 is accepted when:

- SQL migration applies.
- SQL seed applies.
- Maven build succeeds.
- All six ROOT.war files exist.
- Docker images rebuild successfully.
- Base health endpoints return UP.
- Persistence endpoints return UP.
- Protected APIs deny missing or wrong key.
- Protected APIs allow valid key.
- Agent Registry returns UP.
- Governance readiness returns UP.
- Evidence readiness returns UP.
- Portal readiness returns UP.
- Release readiness returns UP.
- releaseStatus is MVP_READY.
- mvpReady is true.
- rollbackReady is true.
- operatingModelReady is true.
- humanAcceptanceReady is true.
- failClosed is true.
- Milestone 13 quality gates still pass.
- Git commit and push complete after validation.

## Governance Result

AIRA is MVP-ready as a governed, evidence-backed, fail-closed runtime foundation.