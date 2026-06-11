# Runtime Persistence Governance v1

## Status

Accepted

## Purpose

Defines governance controls for AIRA runtime persistence.

## Mandatory Controls

| Control | Rule |
|---|---|
| Human approval | Required for high-risk, critical, production, release, promotion, rollback, and risk acceptance actions |
| Maker-checker | The agent or person creating a change cannot approve that same change |
| Evidence binding | Every governed action must produce evidence |
| Fail closed | Missing required evidence, approval, tests, or security review blocks progression |
| Secret safety | No secret value may be stored in evidence, logs, or agent records |
| Agent restriction | Agents cannot silently change production systems |
| Versioning | Agent, prompt, model, tool, and knowledge-source versions must be tracked |
| Rollback readiness | Release and deployment actions require rollback evidence |
| Auditability | Persistence changes must be auditable |

## Gate Enforcement

The following gates are mandatory:

- Architecture Gate
- Development Gate
- Security Gate
- Test Gate
- Documentation Gate
- Evidence Gate
- CI/CD Gate
- Human Approval Gate
- Rollback Gate
- Knowledge Gate

## 10/10 Governance Position

Runtime persistence is considered complete when:

- All schemas exist.
- All core tables exist.
- Agent definitions are persisted.
- Control gates are seeded.
- Prompt/model version records exist.
- Secret controls exist.
- Evidence pack exists.
- Validation script passes.
- Health check script passes.
- Git commit and push are complete.