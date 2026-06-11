# Milestone 14 Evidence Pack: AIRA Portal / Frontend Foundation

## Status

Complete after validation passes.

## Scope

Create the AIRA Portal / Frontend Foundation served from accelerator-api.

## Evidence Items

| Evidence | Location |
|---|---|
| Portal migration | 03_DevSecOps_Accelerator/database/migrations/V12__aira_portal_frontend_foundation.sql |
| Portal seed | 03_DevSecOps_Accelerator/database/seed/V13__aira_portal_frontend_seed.sql |
| Apply script | 03_DevSecOps_Accelerator/scripts/apply-portal-frontend-foundation.ps1 |
| Portal validation script | 03_DevSecOps_Accelerator/scripts/validate-milestone-14-aira-portal.ps1 |
| Portal summary script | 03_DevSecOps_Accelerator/scripts/show-portal-readiness-summary.ps1 |
| Portal readiness API | 03_DevSecOps_Accelerator/accelerator-api/src/main/java/com/aira/accelerator/api/portal |
| Portal HTML | 03_DevSecOps_Accelerator/accelerator-api/src/main/resources/static/portal/index.html |
| Portal CSS | 03_DevSecOps_Accelerator/accelerator-api/src/main/resources/static/portal/assets/aira-portal.css |
| Portal JavaScript | 03_DevSecOps_Accelerator/accelerator-api/src/main/resources/static/portal/assets/aira-portal.js |
| CORS security config | accelerator-agents, accelerator-governance, accelerator-evidence security config |
| GitHub Actions workflow update | .github/workflows/aira-cicd-quality-gates.yml |
| Architecture doc | 03_DevSecOps_Accelerator/docs/architecture/AIRA Portal Frontend Foundation v1.md |
| Governance doc | 03_DevSecOps_Accelerator/docs/architecture/AIRA Portal Governance v1.md |
| ADR | 03_DevSecOps_Accelerator/docs/adr/ADR-0009-AIRA-Portal-Frontend-Foundation.md |

## Acceptance Criteria

Milestone 14 is accepted when:

- SQL migration applies.
- SQL seed applies.
- Maven build succeeds.
- All six ROOT.war files exist.
- Docker images rebuild successfully.
- Base health endpoints return UP.
- Persistence endpoints return UP.
- Portal page returns 200.
- Portal CSS and JavaScript return 200.
- Portal readiness returns UP.
- Portal embedsSecret is false.
- CORS preflight passes for agents, governance, and evidence APIs.
- Protected APIs still deny missing or wrong API keys.
- Protected APIs allow valid local development API key.
- Milestone 13 quality gates still pass.
- Git commit and push complete after validation.

## Governance Result

AIRA now has a governed, read-first portal foundation with protected backend API access and no embedded secrets.