# Enterprise Application Factory Governance v1

## Status

Accepted after validation.

## Principle

AIRA application generation must remain governed, traceable, human-approved, and fail-closed.

## Mandatory gates

1. Blueprint Approval Gate
2. Architecture Gate
3. Security Gate
4. Database Gate
5. API Contract Gate
6. Frontend Gate
7. Test Gate
8. Evidence Gate
9. Production Profile Gate
10. Human Approval Gate

## Agent responsibilities

| Agent | Responsibility |
|---|---|
| architecture-agent | Architecture blueprint, boundaries, ADRs |
| developer-agent | Blueprint-to-code, API, database, frontend generation |
| security-agent | Security review and access control governance |
| test-agent | Test generation and validation |
| documentation-agent | Documentation and operating model |
| evidence-agent | Evidence pack and traceability |
| cicd-agent | Build and quality gates |
| knowledge-fabric-agent | Blueprint intake and reusable project knowledge |

## Fail-closed rules

The factory must stop when blueprint, architecture, security, migration, API contract, tests, evidence, production profile, or approval is missing.