# AIRA Agent Inventory and Agent Definition Report

## Executive Summary

This report establishes the official AIRA Agent Inventory and Agent Definition baseline. It defines agent identity, purpose, ownership, allowed actions, prohibited actions, runtime boundaries, tools, permissions, evidence expectations, governance controls, and interaction workflows.

The incorrect name cicid-agent is confirmed as a typo. The correct technical repository name is cicd-agent.

No AIRA agent is allowed to silently change production systems. High-risk actions require human approval, maker-checker control, evidence capture, and governance traceability.

## Simple Summary Table

| Agent | Main Purpose | Can Change Code? | Can Approve? | Can Deploy? | Evidence Produced | Risk Level | Owner |
|---|---|---|---|---|---|---|---|
| architecture-agent | Reviews enterprise architecture, solution design, MicroFunction design, API design, database design, workflow design, integration design, and alignment with AIRA standards. | No | No | No | ADR, architecture review report, design review checklist, decision traceability record. | Medium | AIRA Architecture Owner |
| developer-agent | Generates, modifies, or reviews code, configuration, API contracts, MicroFunctions, database migration drafts, and implementation notes. | Yes, branch only | No | No | Code diff, PR summary, build log, test log, implementation evidence. | High | AIRA Development Lead |
| security-agent | Reviews security requirements, access control, secrets handling, vulnerabilities, secure coding, threat models, RBAC, ABAC, OPA policies, and fail-closed behavior. | No | No | No | Security finding, threat model, policy review, vulnerability triage, approval record. | High | AIRA Security Owner |
| test-agent | Creates and validates unit tests, integration tests, API tests, UI tests, regression tests, security tests, and acceptance tests. | Yes, tests only | No | No | Test report, coverage report, test execution log, acceptance traceability. | Medium | AIRA QA/Test Lead |
| documentation-agent | Updates technical documentation, user guides, architecture documents, API documentation, release notes, decision records, and Obsidian documentation. | Docs only | No | No | Documentation update record, release notes, linked evidence references. | Low/Medium | AIRA Documentation Owner |
| evidence-agent | Collects and organizes evidence from commits, pull requests, test results, security scans, CI/CD results, logs, screenshots, approvals, and deployment records. | No | No | No | Evidence pack, audit trail, traceability matrix, missing evidence report. | Medium | AIRA Evidence and Compliance Owner |
| cicd-agent | Supports pipeline validation, build execution, test execution, security scanning, deployment checks, release gates, rollback checks, and promotion readiness. | Limited pipeline config only | No | Limited only with approval | Pipeline logs, scan results, build logs, release gate report, rollback checklist. | High/Critical | AIRA DevSecOps Owner |
| knowledge-fabric-agent | Manages Obsidian, LLM Wiki, AIRA documentation, reusable knowledge, lessons learned, design decisions, prompts, agent memory/context, and cross-document references. | Docs/knowledge only | No | No | Knowledge update log, link map, context pack summary, source traceability. | Medium | AIRA Knowledge Owner |

## Agent Inventory Matrix

| Agent | Correct Technical Name | Purpose | Business Function | Technical Function | Owner | Backup Owner | Primary Users | Classification | Risk | Change Authority |
|---|---|---|---|---|---|---|---|---|---|---|
| architecture-agent | architecture-agent | Reviews enterprise architecture, solution design, MicroFunction design, API design, database design, workflow design, integration design, and alignment with AIRA standards. | Architecture governance, solution assurance, design consistency, technology alignment. | Reviews architecture artifacts, ADRs, API contracts, database designs, integration flows, service boundaries, and platform standards. | AIRA Architecture Owner | AIRA Platform Lead | Architects, technical leads, product owners, developers, governance reviewers | Review agent; Control/governance agent | Medium | Recommend only by default. May create draft ADRs and review notes, but cannot apply production-impacting changes. |
| developer-agent | developer-agent | Generates, modifies, or reviews code, configuration, API contracts, MicroFunctions, database migration drafts, and implementation notes. | Software delivery acceleration, implementation support, code quality improvement. | Creates source code, refactors code, generates configuration, API contracts, database migration drafts, and unit test scaffolds. | AIRA Development Lead | AIRA Platform Lead | Developers, technical leads, platform engineers | Code-generation agent; Runtime/execution agent with restrictions | High | May generate files in a branch or local workspace. Cannot merge, deploy, or promote changes without approval. |
| security-agent | security-agent | Reviews security requirements, access control, secrets handling, vulnerabilities, secure coding, threat models, RBAC, ABAC, OPA policies, and fail-closed behavior. | Security assurance, risk reduction, compliance support. | Threat modeling, secure code review, policy review, dependency review, secrets handling review, vulnerability triage. | AIRA Security Owner | AIRA Risk and Compliance Lead | Security engineers, architects, developers, auditors, release managers | Review agent; Control/governance agent | High | Recommend only by default. May generate policy drafts and remediation suggestions, but cannot silently change controls. |
| test-agent | test-agent | Creates and validates unit tests, integration tests, API tests, UI tests, regression tests, security tests, and acceptance tests. | Quality assurance, release confidence, regression protection. | Generates tests, executes tests, reviews coverage, validates acceptance criteria, produces test evidence. | AIRA QA/Test Lead | AIRA Development Lead | QA engineers, developers, release managers, product owners | Review agent; Runtime/execution agent | Medium | May generate or update test files. Cannot approve release or deploy. |
| documentation-agent | documentation-agent | Updates technical documentation, user guides, architecture documents, API documentation, release notes, decision records, and Obsidian documentation. | Knowledge sharing, onboarding, compliance support, release communication. | Generates and updates Markdown docs, ADR drafts, runbooks, API docs, release notes, Obsidian notes. | AIRA Documentation Owner | AIRA Knowledge Owner | Developers, architects, QA, operations, management, auditors | Knowledge-management agent | Low/Medium | May update documentation in branch or documentation workspace. Cannot approve technical decisions. |
| evidence-agent | evidence-agent | Collects and organizes evidence from commits, pull requests, test results, security scans, CI/CD results, logs, screenshots, approvals, and deployment records. | Audit readiness, compliance evidence, traceability, operational assurance. | Creates evidence packs, links artifacts, captures audit trails, validates evidence completeness. | AIRA Evidence and Compliance Owner | AIRA Security Owner | Auditors, compliance teams, release managers, security, governance | Evidence agent; Control/governance agent | Medium | May collect and organize evidence. Cannot approve or alter source artifacts. |
| cicd-agent | cicd-agent | Supports pipeline validation, build execution, test execution, security scanning, deployment checks, release gates, rollback checks, and promotion readiness. | DevSecOps automation, release readiness, quality gates, operational control. | Validates CI/CD workflows, executes builds/tests/scans, reviews pipeline logs, checks promotion readiness. | AIRA DevSecOps Owner | AIRA Platform Lead | DevSecOps engineers, release managers, developers, QA, security | Runtime/execution agent; Control/governance agent | High/Critical | Limited. Can run non-production validation. Cannot deploy or promote without explicit human approval. |
| knowledge-fabric-agent | knowledge-fabric-agent | Manages Obsidian, LLM Wiki, AIRA documentation, reusable knowledge, lessons learned, design decisions, prompts, agent memory/context, and cross-document references. | Enterprise knowledge management, memory, reuse, decision continuity. | Indexes knowledge, links documents, maintains context packs, updates Obsidian and LLM Wiki references. | AIRA Knowledge Owner | AIRA Documentation Owner | All AIRA teams, agents, architects, developers, security, QA, operations | Knowledge-management agent | Medium | May update documentation and knowledge indexes. Cannot modify source code or production systems. |

## Individual Agent Definition Sheets

- architecture-agent: definition-sheets/architecture-agent.md
- developer-agent: definition-sheets/developer-agent.md
- security-agent: definition-sheets/security-agent.md
- test-agent: definition-sheets/test-agent.md
- documentation-agent: definition-sheets/documentation-agent.md
- evidence-agent: definition-sheets/evidence-agent.md
- cicd-agent: definition-sheets/cicd-agent.md
- knowledge-fabric-agent: definition-sheets/knowledge-fabric-agent.md

## Agent Interaction Workflow

Standard AIRA workflow:

1. New requirement is submitted.
2. architecture-agent reviews solution alignment.
3. developer-agent drafts implementation.
4. security-agent reviews controls and risk.
5. test-agent creates and validates test coverage.
6. documentation-agent updates documentation.
7. evidence-agent creates evidence pack.
8. cicd-agent validates pipeline, build, scan, and release readiness.
9. knowledge-fabric-agent updates Obsidian, LLM Wiki, and context references.
10. Human approver decides whether to merge, promote, or reject.

## Governance and Risk Assessment

All agents operate under the following controls:

- Maker-checker control is required for code, configuration, database, pipeline, or release changes.
- Human approval is required for production-impacting actions.
- CAB or ARB review is required for architecture, production, security, or platform-impacting changes.
- Agent output must be version controlled when it changes repository content.
- Evidence must be linked to commits, PRs, build logs, tests, security scans, and approvals.
- Agents must follow least privilege.
- No agent may bypass security, testing, documentation, evidence, or approval gates.
- All high-risk actions must fail closed if required inputs are missing.

## Gaps, Risks, and Recommendations

Current limitations:

- Owners are named as roles and should be mapped to real people.
- Agent model registry is not yet implemented.
- Tool permission enforcement is not yet automated.
- Agent execution audit persistence is not yet implemented.
- Secret access policy must be enforced technically, not only documented.
- Agent prompt versioning and model versioning need formal registry tables.
- Evidence packs are currently Markdown-based and should be persisted in PostgreSQL during Milestone 8.

Recommended improvements before actual development:

1. Implement an Agent Registry in PostgreSQL.
2. Implement prompt versioning.
3. Implement tool permission enforcement.
4. Implement evidence persistence.
5. Implement agent execution logs.
6. Implement maker-checker workflow in CI/CD.
7. Implement secret redaction and no-secret-access controls.
8. Implement PR-based change workflow for code-writing agents.

## Appendix

Related folders:

- 02_Agents
- 02_Agents/_Agent_Governance
- 03_DevSecOps_Accelerator
- 03_DevSecOps_Accelerator/docs/architecture
- 05_Evidence
