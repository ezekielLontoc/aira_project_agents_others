# POC-1B Phase 2 Backend API Validation Evidence

## Status

PASSED

## Score

10/10 Phase 2 Backend API Foundation

## Completed At

2026-06-17T17:06:21.3927473+08:00

## Runtime

- Runtime type: dependency-free Node.js reference API
- Base URL: http://127.0.0.1:9191
- Server file: 03_DevSecOps_Accelerator/poc1b-runtime/login-risk-api/poc1b-login-risk-api-server.js

## Validation Run Evidence

- JSON: 05_Evidence/poc-1b-login-risk-step-up-governance/POC-1B Phase 2 Backend API Validation Run.json
- stdout: 05_Evidence/poc-1b-login-risk-step-up-governance/POC-1B Phase 2 Backend API Server stdout.txt
- stderr: 05_Evidence/poc-1b-login-risk-step-up-governance/POC-1B Phase 2 Backend API Server stderr.txt

## Validation Results

- Status: PASSED
- Score: 10/10 Phase 2 Backend API Foundation
- Check count: 23
- MicroFunction count: 40
- Policy decision count: 1
- Created risk event: risk-1781687180873-f65f9701
- Created incident: incident-1781687180874-c763f553
- Created unlock request: unlock-1781687180902-6893cb90
- Created step-up challenge: stepup-1781687180910-7e8f8621

## Validated Capabilities

- Readiness endpoint
- MicroFunction catalog endpoint
- Suspicious login risk event creation
- Suspicious login risk event review
- Login failure auto-triage
- Account lock
- Locked account query
- Unlock request creation
- Human approval unlock
- Step-up challenge creation
- Step-up challenge verification
- Policy decision recording
- AI-assisted incident analysis
- Event listing
- Incident listing
- Login failure listing

## Decision

POC-1B Phase 2 backend API foundation is accepted based on real validation run evidence.