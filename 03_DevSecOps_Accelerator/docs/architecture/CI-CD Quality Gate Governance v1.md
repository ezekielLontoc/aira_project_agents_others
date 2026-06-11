# CI/CD Quality Gate Governance v1

## Status

Accepted after validation passes.

## Purpose

Define governance rules for AIRA CI/CD quality gates.

## Mandatory Rules

| Rule | Requirement |
|---|---|
| Fail closed | Any failed mandatory gate blocks release readiness |
| Evidence required | Gate runs must create database-backed evidence |
| Build required | Maven build must pass |
| Artifact required | All ROOT.war artifacts must exist |
| Runtime required | Docker runtime must start |
| Health required | Base and persistence endpoints must return UP |
| Security required | Protected APIs must deny missing/wrong keys and allow valid keys |
| Governance required | Governance readiness must return UP |
| Evidence required | Evidence readiness and detail endpoints must pass |
| CI workflow required | GitHub Actions workflow must exist |

## Release Position

Milestone 13 does not deploy to production.

It establishes the quality gate foundation that future release and deployment workflows must pass.

## Production Safety

Production promotion requires future milestones for:

- approval workflow
- release readiness record
- rollback readiness record
- signed evidence pack
- human approval
- environment-specific secrets
- production-grade key management