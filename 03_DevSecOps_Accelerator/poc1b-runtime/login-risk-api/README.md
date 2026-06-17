# POC-1B Login Risk API Runtime

This is the Phase 2 backend API foundation for POC-1B.

It is a dependency-free Node.js reference runtime that implements the POC-1B API contract for:

- Suspicious Login Risk Review
- Login Failure Auto-Triage
- Account Lock / Unlock Human Approval
- Policy-Based Step-Up Authentication
- AI-Assisted Login Incident Analysis
- Policy decision recording
- MicroFunction catalog exposure

## Run

PowerShell command:

node .\03_DevSecOps_Accelerator\poc1b-runtime\login-risk-api\poc1b-login-risk-api-server.js --port 9191

## Validate

PowerShell command:

.\03_DevSecOps_Accelerator\scripts\poc1b\validate-poc1b-phase2-backend-api.ps1

## Scope Note

This Phase 2 runtime is additive and does not replace POC-1 identity runtime. It provides the governed backend API foundation for POC-1B before deeper integration into the main identity service.