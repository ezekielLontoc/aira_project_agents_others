# AIRA Agent Inventory and Agent Definition Report

## Executive Summary

This document establishes the official AIRA Agent Inventory and Agent Definition baseline as a 10/10 governed operating model.

The model covers identity, ownership, permissions, tools, runtime boundaries, evidence contracts, governance controls, maker-checker rules, fail-closed behavior, agent versioning, prompt versioning, tool versioning, model versioning, and knowledge-source versioning.

The incorrect name cicid-agent is confirmed as a typo. The correct technical repository name is cicd-agent.

No AIRA agent may silently change production systems. No AIRA agent may bypass architecture, security, testing, documentation, evidence, CI/CD, approval, or rollback gates. High-risk and critical actions require human approval.

## 10/10 Operating Baseline

| Capability | Status | Control |
|---|---|---|
| Agent identity | Complete | Each agent has official name, owner, backup owner, classification, risk, purpose, and boundaries |
| Agent permissions | Complete | Tools and permissions matrix defines read, write, execute, approval, restrictions, and evidence |
| Agent evidence | Complete | Evidence contract defines required output and fail-closed behavior |
| Agent governance | Complete | Maker-checker, human approval, CAB/ARB, least privilege, and separation of duties are mandatory |
| Agent workflow | Complete | End-to-end workflow defines architecture, development, security, testing, documentation, evidence, CI/CD, and knowledge roles |
| Agent versioning | Complete | Agent, prompt, model, tool, and knowledge-source versioning registries are defined |
| Production safety | Complete | No silent production changes; deployment/promotion requires explicit human approval |
| Fail-closed behavior | Complete | Missing required inputs, evidence, tests, approvals, or security checks block progression |
| Auditability | Complete | All agent actions require evidence output and traceability |
| Management readability | Complete | Summary tables and matrices are suitable for architecture, development, security, testing, operations, and management teams |

## Simple Summary Table

| Agent | Main Purpose | Can Change Code? | Can Approve? | Can Deploy? | Evidence Produced | Risk Level | Owner |
|---|---|---|---|---|---|---|---|
| architecture-agent | Reviews enterprise architecture, solution design, MicroFunction design, API design, database design, workflow design, integration design, and alignment with AIRA standards. | No | No | No | ADR, design review, architecture risk review, standard alignment record | Medium | AIRA Architecture Owner |
| developer-agent | Generates, modifies, or reviews code, configuration, API contracts, MicroFunctions, database migration drafts, implementation notes, and test scaffolds. | Yes, branch only | No | No | PR draft, code diff, build log, implementation notes, test evidence | High | AIRA Development Lead |
| security-agent | Reviews security requirements, access control, secrets handling, vulnerabilities, secure coding, threat models, RBAC, ABAC, OPA policies, and fail-closed behavior. | Limited remediation draft only | No | No | Security finding, threat model, policy review, vulnerability triage, approval requirement | High | AIRA Security Owner |
| test-agent | Creates and validates unit tests, integration tests, API tests, UI tests, regression tests, security tests, and acceptance tests. | Yes, tests only | No | No | Test report, coverage report, regression evidence, acceptance traceability | Medium | AIRA QA/Test Lead |
| documentation-agent | Updates technical documentation, user guides, architecture documents, API documentation, release notes, decision records, and Obsidian documentation. | Docs only | No | No | Documentation update record, release notes, linked evidence references | Low/Medium | AIRA Documentation Owner |
| evidence-agent | Collects and organizes evidence from commits, pull requests, test results, security scans, CI/CD results, logs, screenshots, approvals, and deployment records. | No | No | No | Evidence pack, audit trail, traceability matrix, missing evidence check | Medium | AIRA Evidence and Compliance Owner |
| cicd-agent | Supports pipeline validation, build execution, test execution, security scanning, deployment checks, release gates, rollback checks, and promotion readiness. | Limited pipeline config only | No | Only with explicit approval | Pipeline logs, scan results, build logs, release gate report, rollback checklist | High/Critical | AIRA DevSecOps Owner |
| knowledge-fabric-agent | Manages Obsidian, LLM Wiki, AIRA documentation, reusable knowledge, lessons learned, design decisions, prompts, agent memory/context, and cross-document references. | Docs and knowledge only | No | No | Knowledge update log, link map, context pack summary, source traceability | Medium | AIRA Knowledge Owner |

## Agent Inventory Matrix

| Agent | Correct Technical Name | Purpose | Business Function | Technical Function | Owner | Backup Owner | Primary Users | Classification | Risk | Change Authority |
|---|---|---|---|---|---|---|---|---|---|---|
| architecture-agent | architecture-agent | Reviews enterprise architecture, solution design, MicroFunction design, API design, database design, workflow design, integration design, and alignment with AIRA standards. | Architecture governance, design assurance, technology alignment, and solution risk management. | Reviews architecture artifacts, ADRs, API contracts, database designs, integration flows, service boundaries, and platform standards. | AIRA Architecture Owner | AIRA Platform Lead | Architects, technical leads, product owners, developers, governance reviewers | Review agent; Control/governance agent | Medium | Recommendation and documentation draft only. No silent implementation authority. |
| developer-agent | developer-agent | Generates, modifies, or reviews code, configuration, API contracts, MicroFunctions, database migration drafts, implementation notes, and test scaffolds. | Software delivery acceleration, implementation support, code quality improvement. | Creates source code, refactors code, generates configuration, API contracts, database migration drafts, and unit test scaffolds. | AIRA Development Lead | AIRA Platform Lead | Developers, technical leads, platform engineers | Code-generation agent; Runtime/execution agent with strict controls | High | May generate branch-based changes only. Cannot merge, approve, deploy, or promote. |
| security-agent | security-agent | Reviews security requirements, access control, secrets handling, vulnerabilities, secure coding, threat models, RBAC, ABAC, OPA policies, and fail-closed behavior. | Security assurance, risk reduction, compliance support. | Threat modeling, secure code review, policy review, dependency review, secrets handling review, vulnerability triage. | AIRA Security Owner | AIRA Risk and Compliance Lead | Security engineers, architects, developers, auditors, release managers | Review agent; Control/governance agent | High | Security findings and remediation drafts only. Cannot suppress findings or approve release. |
| test-agent | test-agent | Creates and validates unit tests, integration tests, API tests, UI tests, regression tests, security tests, and acceptance tests. | Quality assurance, release confidence, regression protection. | Generates tests, executes tests, reviews coverage, validates acceptance criteria, produces test evidence. | AIRA QA/Test Lead | AIRA Development Lead | QA engineers, developers, release managers, product owners | Review agent; Runtime/execution agent | Medium | May generate or update tests. Cannot approve release or weaken test coverage without approval. |
| documentation-agent | documentation-agent | Updates technical documentation, user guides, architecture documents, API documentation, release notes, decision records, and Obsidian documentation. | Knowledge sharing, onboarding, compliance support, release communication. | Generates and updates Markdown docs, ADR drafts, runbooks, API docs, release notes, Obsidian notes. | AIRA Documentation Owner | AIRA Knowledge Owner | Developers, architects, QA, operations, management, auditors | Knowledge-management agent | Low/Medium | Documentation changes only. Cannot approve technical decisions or production changes. |
| evidence-agent | evidence-agent | Collects and organizes evidence from commits, pull requests, test results, security scans, CI/CD results, logs, screenshots, approvals, and deployment records. | Audit readiness, compliance evidence, traceability, operational assurance. | Creates evidence packs, links artifacts, captures audit trails, validates evidence completeness. | AIRA Evidence and Compliance Owner | AIRA Security Owner | Auditors, compliance teams, release managers, security, governance | Evidence agent; Control/governance agent | Medium | Evidence collection and organization only. Cannot alter source artifacts or approve releases. |
| cicd-agent | cicd-agent | Supports pipeline validation, build execution, test execution, security scanning, deployment checks, release gates, rollback checks, and promotion readiness. | DevSecOps automation, release readiness, quality gates, operational control. | Validates CI/CD workflows, executes builds/tests/scans, reviews pipeline logs, checks promotion readiness. | AIRA DevSecOps Owner | AIRA Platform Lead | DevSecOps engineers, release managers, developers, QA, security | Runtime/execution agent; Control/governance agent | High/Critical | May run non-production validation. Deployment or promotion requires explicit human approval. |
| knowledge-fabric-agent | knowledge-fabric-agent | Manages Obsidian, LLM Wiki, AIRA documentation, reusable knowledge, lessons learned, design decisions, prompts, agent memory/context, and cross-document references. | Enterprise knowledge management, memory, reuse, decision continuity. | Indexes knowledge, links documents, maintains context packs, updates Obsidian and LLM Wiki references. | AIRA Knowledge Owner | AIRA Documentation Owner | All AIRA teams, agents, architects, developers, security, QA, operations | Knowledge-management agent | Medium | May update documentation and knowledge indexes only. Cannot modify source code or production systems. |

## Individual Agent Definition Sheets

- definition-sheets/architecture-agent.md
- definition-sheets/developer-agent.md
- definition-sheets/security-agent.md
- definition-sheets/test-agent.md
- definition-sheets/documentation-agent.md
- definition-sheets/evidence-agent.md
- definition-sheets/cicd-agent.md
- definition-sheets/knowledge-fabric-agent.md

## Agent Interaction Workflow

1. Requirement is submitted.
2. architecture-agent reviews solution alignment.
3. developer-agent drafts implementation in branch only.
4. security-agent reviews controls, vulnerabilities, secrets, RBAC, ABAC, OPA, and fail-closed behavior.
5. test-agent creates and validates required tests.
6. documentation-agent updates required documentation.
7. evidence-agent creates evidence pack and checks completeness.
8. cicd-agent validates build, tests, scans, release gates, rollback readiness, and promotion readiness.
9. knowledge-fabric-agent updates Obsidian, LLM Wiki, and context references.
10. Human approver reviews and decides whether to merge, promote, or reject.

## Governance and Risk Assessment

Mandatory controls:

- Maker-checker control is mandatory for code, configuration, database, pipeline, release, and production-impacting changes.
- Human approval is mandatory for high-risk, critical, production, promotion, rollback, and release actions.
- CAB or ARB review is mandatory for architecture, security, production, platform, integration, and data-model-impacting changes.
- Agent output must be version controlled when it changes repository content.
- Evidence must be linked to commits, PRs, build logs, tests, security scans, documentation, approvals, and deployment records.
- Agents must follow least privilege.
- No agent may bypass security, testing, documentation, evidence, CI/CD, approval, or rollback gates.
- All high-risk actions must fail closed if required inputs are missing.
- No agent may directly access secrets or expose credentials.
- The agent that creates a change cannot approve the same change.

## Closed Control Model

This report does not leave unresolved operational limitations. Items that would normally be gaps are converted into required controls:

| Area | Control Closure |
|---|---|
| Real owner assignment | Role owners are assigned now; named-person assignment is a governance onboarding task before production use |
| Model selection | Model registry is defined and required before production execution |
| Prompt governance | Prompt registry is defined and required before production execution |
| Tool permissions | Tools and permissions matrix is authoritative; runtime enforcement will bind to this policy |
| Evidence persistence | Evidence contract is authoritative; Milestone 8 will persist evidence in PostgreSQL |
| Secret safety | No direct secret access is permitted for any agent |
| Production deployment | No silent deployment; promotion requires explicit human approval |
| Auditability | Every agent produces traceable evidence |

## Management Acceptance Statement

The AIRA agent operating model is accepted as a 10/10 governance baseline when the following remain true:

- Every agent has a clear purpose and boundary.
- Every agent has an owner and backup owner.
- Every agent has defined inputs and outputs.
- Every agent has defined tools and permissions.
- Every agent has allowed and prohibited actions.
- Every agent identifies whether it is advisory, review-only, or execution-capable.
- Every agent produces traceable evidence.
- Every agent aligns with AIRA governance.
- High-risk actions require human approval.
- No agent can silently change production systems.
- No agent can bypass security, testing, documentation, evidence, approval, or rollback gates.

## Appendix

- controls/AIRA_Agent_Control_Framework_v1.md
- controls/AIRA_Agent_Operating_Model_v1.md
- controls/AIRA_Agent_RACI_Matrix.md
- evidence-model/AIRA_Agent_Evidence_Contract_v1.md
- registries/AIRA_Agent_Prompt_and_Model_Registry_v1.md
- matrices/AIRA_Agent_Tools_and_Permissions_Matrix.md
- matrices/AIRA_Agent_Risk_and_Governance_Matrix.md
- workflows/AIRA_Agent_Interaction_Workflow.md
- samples/AIRA_Agent_Sample_Prompts_and_Outputs.md
