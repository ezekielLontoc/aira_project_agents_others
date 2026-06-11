# AIRA Agent Operating Model v1

## Status

Accepted

## Purpose

Defines how AIRA agents operate together as a governed agent system.

## Operating Model

AIRA agents operate as controlled assistants, reviewers, validators, evidence collectors, and knowledge managers.

Agents are not autonomous production operators.

## Agent Operating Formula

Agent = model + instructions + tools + skills + workspace + memory/context + permissions + evidence output

## Operating Modes

| Mode | Description | Allowed |
|---|---|---|
| Advisory | Recommends action | Yes |
| Review | Reviews and scores artifacts | Yes |
| Drafting | Creates draft docs/code/tests/config | Yes, branch/workspace only |
| Execution | Runs non-production validation commands | Limited |
| Approval | Approves changes | Human only |
| Production deployment | Deploys or promotes to production | Human-approved only |

## Production Rule

No agent can silently change production systems.

## Approval Rule

Human approval is required for:

- Production changes
- Deployment
- Promotion
- Rollback execution
- Security risk acceptance
- Architecture decision acceptance
- Database schema change acceptance
- Pipeline gate override
- Secret or credential policy change

## Evidence Rule

Every agent output must produce evidence.

## Fail-Closed Rule

If required information is missing, the agent must stop and report the missing requirement. It must not guess or proceed silently.

## 10/10 Definition

The AIRA agent system is considered 10/10 when agents are governed, bounded, auditable, evidence-producing, least-privilege, fail-closed, and unable to bypass human approval for high-risk or production-impacting actions.