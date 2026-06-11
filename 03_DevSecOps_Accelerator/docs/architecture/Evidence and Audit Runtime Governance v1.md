# Evidence and Audit Runtime Governance v1

## Status

Accepted

## Purpose

Define governance rules for AIRA Evidence and Audit Runtime APIs.

## API Safety Model

Milestone 12 APIs are read-first.

They may:

- Read evidence packs
- Read evidence artifacts
- Read traceability links
- Read runtime audit records
- Read security audit records
- Report evidence readiness

They may not:

- Modify source evidence
- Delete evidence
- Approve evidence
- Approve releases
- Deploy or promote changes
- Expose secrets
- Bypass security enforcement

## Mandatory Controls

| Control | Rule |
|---|---|
| API key required | /api/v1/evidence/** requires X-AIRA-API-Key |
| Fail closed | Missing or wrong key returns 401 |
| Evidence no-secrets | Evidence artifacts must not contain secrets |
| Traceability required | Evidence readiness requires traceability |
| Runtime audit required | Evidence readiness requires runtime audit |
| Human approval | Official evidence acceptance requires human review |
| Immutable reference | Source artifacts should use immutable references when available |

## Evidence Readiness

Evidence readiness returns UP only when:

- Evidence pack exists
- Evidence artifacts exist
- Evidence artifacts are secret-free
- Traceability links exist
- Runtime audit records exist
- Active evidence API policy exists
- failClosed is true