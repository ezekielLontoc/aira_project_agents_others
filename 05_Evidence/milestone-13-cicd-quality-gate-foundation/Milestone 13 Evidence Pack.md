# Milestone 13 Evidence Pack: CI/CD Quality Gate Foundation

## Status

Complete after validation passes.

## Scope

Establish database-backed CI/CD quality gates, local validation scripts, and GitHub Actions workflow.

## Evidence Items

| Evidence | Location |
|---|---|
| Quality gate migration | 03_DevSecOps_Accelerator/database/migrations/V10__aira_cicd_quality_gate_foundation.sql |
| Quality gate seed | 03_DevSecOps_Accelerator/database/seed/V11__aira_cicd_quality_gate_seed.sql |
| Apply script | 03_DevSecOps_Accelerator/scripts/apply-cicd-quality-gate-foundation.ps1 |
| Local gate runner | 03_DevSecOps_Accelerator/scripts/run-local-cicd-quality-gates.ps1 |
| Validation script | 03_DevSecOps_Accelerator/scripts/validate-milestone-13-cicd-quality-gates.ps1 |
| Summary script | 03_DevSecOps_Accelerator/scripts/show-cicd-quality-gate-summary.ps1 |
| GitHub Actions workflow | .github/workflows/aira-cicd-quality-gates.yml |
| Architecture doc | 03_DevSecOps_Accelerator/docs/architecture/CI-CD Quality Gate Foundation v1.md |
| Governance doc | 03_DevSecOps_Accelerator/docs/architecture/CI-CD Quality Gate Governance v1.md |
| ADR | 03_DevSecOps_Accelerator/docs/adr/ADR-0008-CI-CD-Quality-Gate-Foundation.md |

## Acceptance Criteria

Milestone 13 is accepted when:

- SQL migration applies.
- SQL seed applies.
- Maven build succeeds.
- All six ROOT.war files exist.
- Docker images rebuild successfully.
- Runtime stack starts.
- Base health endpoints return UP.
- Persistence endpoints return UP.
- Security enforcement gate passes.
- Agent Registry gate passes.
- Governance readiness gate passes.
- Evidence readiness gate passes.
- Evidence detail gate passes.
- GitHub Actions workflow exists.
- Quality gate records are persisted.
- Git commit and push complete after validation.

## Governance Result

AIRA now has a governed, auditable, fail-closed CI/CD Quality Gate Foundation.