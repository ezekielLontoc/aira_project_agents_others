# AIRA Agent Interaction Workflow

## Standard Flow

New Requirement
-> architecture-agent
-> developer-agent
-> security-agent
-> test-agent
-> documentation-agent
-> evidence-agent
-> cicd-agent
-> knowledge-fabric-agent
-> Human Approval
-> Merge or Reject
-> Promotion Recommendation

## Workflow Details

### 1. New Requirement

Started by product owner, architect, platform lead, or developer.

architecture-agent reviews the requirement for enterprise alignment, solution boundaries, integration design, API design, data impact, and ADR needs.

### 2. Code Generation

developer-agent creates proposed code, configuration, API contracts, or migration drafts in a branch.

developer-agent cannot approve or deploy its own output.

### 3. Security Review

security-agent reviews authentication, authorization, RBAC, ABAC, OPA policies, secrets handling, vulnerabilities, secure coding, and fail-closed behavior.

High and critical findings block promotion.

### 4. Test Generation and Execution

test-agent creates or updates unit tests, integration tests, API tests, regression tests, security tests, and acceptance tests.

test-agent produces test evidence and coverage evidence.

### 5. Documentation Update

documentation-agent updates README files, architecture docs, API docs, release notes, decision records, and Obsidian documentation.

### 6. Evidence Collection

evidence-agent collects commits, pull requests, test results, security scans, CI/CD logs, approvals, screenshots, deployment records, and runtime logs.

### 7. CI/CD Validation

cicd-agent validates build, tests, scans, release gates, rollback readiness, deployment scripts, and promotion readiness.

cicd-agent cannot silently deploy to production.

### 8. Knowledge Update

knowledge-fabric-agent updates Obsidian, LLM Wiki, cross-document references, context packs, lessons learned, decision links, prompt references, and reusable knowledge.

### 9. Approval and Promotion

Human approver reviews outputs and evidence.

Only approved changes may be merged or promoted.

## Review Responsibilities

| Responsibility | Agent |
|---|---|
| Starts architecture workflow | architecture-agent |
| Drafts implementation | developer-agent |
| Reviews security | security-agent |
| Validates tests | test-agent |
| Prepares documentation | documentation-agent |
| Produces evidence | evidence-agent |
| Validates CI/CD | cicd-agent |
| Updates knowledge | knowledge-fabric-agent |
| Recommends promotion | cicd-agent with architecture/security/test/evidence inputs |
| Approves promotion | Human approver only |