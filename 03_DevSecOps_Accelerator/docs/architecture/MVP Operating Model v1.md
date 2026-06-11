# MVP Operating Model v1

## Status

Accepted after validation passes.

## Operating Principles

AIRA operates as a governed, fail-closed, evidence-backed AI-native platform.

Agents assist with architecture, development, security, testing, documentation, evidence, CI/CD, and knowledge fabric.

Agents do not silently approve, deploy, or bypass controls.

## Ownership

| Area | Owner |
|---|---|
| Runtime | AIRA Platform Lead |
| Architecture | AIRA Architecture Owner |
| Security | AIRA Security Owner |
| Evidence | AIRA Evidence and Compliance Owner |
| CI/CD | AIRA DevSecOps Owner |
| Portal | AIRA Platform Lead |
| Rollback | AIRA DevSecOps Owner |

## Support Model

The Platform Lead owns runtime health and service availability.

The Security Owner owns protected API behavior and key governance.

The Evidence Owner owns evidence readiness, traceability, and audit visibility.

The DevSecOps Owner owns quality gates, build reproducibility, Docker runtime, and rollback.

## Escalation Model

Escalate to the relevant owner when:

- any health endpoint is not UP
- persistence health is not UP
- protected APIs allow missing or wrong keys
- governance readiness is BLOCKED
- evidence readiness is BLOCKED
- portal readiness is BLOCKED
- quality gates fail
- release readiness is BLOCKED
- rollback readiness is BLOCKED

## Change Control Model

Changes require:

- source control commit
- Maven build
- WAR artifact validation
- Docker runtime validation
- health validation
- persistence validation
- security validation
- governance validation
- evidence validation
- portal validation
- quality gate record
- evidence record
- human approval before production promotion

## Rollback Model

Rollback requires:

- known-good Git commit
- reproducible WAR artifacts
- Docker image rebuild or prior image reference
- PostgreSQL backup/restore plan
- validation after rollback
- evidence capture
- human approval for production environments