# AIRA Agent Control Framework v1

## Status

Accepted

## Purpose

Defines mandatory controls for all AIRA agents.

## Control Principles

1. No silent production changes.
2. No bypass of architecture, security, testing, documentation, evidence, CI/CD, approval, or rollback gates.
3. High-risk and critical actions require human approval.
4. Agents must operate under least privilege.
5. Agents must fail closed when required inputs, evidence, approvals, tests, or security checks are missing.
6. Agents must produce traceable evidence.
7. Agents must not directly access or expose secrets.
8. Agents cannot approve their own output.
9. Production deployment requires explicit human approval.
10. Every change must be traceable to requirement, decision, implementation, test, security review, documentation, evidence, and approval.

## Mandatory Gates

| Gate | Required For | Blocking Condition |
|---|---|---|
| Architecture Gate | New design, major change, API, database, integration | Missing ADR, unresolved architecture risk |
| Development Gate | Code/config/database/pipeline changes | Unreviewed code or missing diff |
| Security Gate | Security-sensitive or production-impacting changes | High/critical finding, secret exposure, fail-open behavior |
| Test Gate | All implementation changes | Failed required test or missing coverage |
| Documentation Gate | Release, architecture, API, operations changes | Missing or outdated docs |
| Evidence Gate | PR, release, deployment, audit | Missing evidence pack |
| CI/CD Gate | Build, release, promotion | Failed build/test/scan or incomplete logs |
| Approval Gate | High-risk, critical, production, promotion | Missing human approval |
| Rollback Gate | Release or deployment | Missing rollback plan |
| Knowledge Gate | Major change or release | Missing Obsidian/LLM Wiki/context update |

## Control Enforcement

This framework is authoritative. Runtime systems, CI/CD pipelines, agent registries, and evidence persistence must enforce these controls as implementation matures.

## 10/10 Baseline

An agent is considered solid only when:

- Identity is defined.
- Ownership is assigned.
- Permissions are defined.
- Evidence output is defined.
- Approval rules are defined.
- Fail-closed rules are defined.
- Tools are governed.
- Knowledge sources are versioned.
- Prompt/model/tool versions are tracked.
- Production safety controls are active.