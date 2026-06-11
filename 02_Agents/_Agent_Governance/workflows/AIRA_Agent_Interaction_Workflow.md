# AIRA Agent Interaction Workflow

## Status

Accepted

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

## Text Diagram

[Requirement]
      |
      v
[architecture-agent]
      |
      v
[developer-agent]
      |
      +--> [security-agent]
      |
      +--> [test-agent]
      |
      +--> [documentation-agent]
      |
      v
[evidence-agent]
      |
      v
[cicd-agent]
      |
      v
[knowledge-fabric-agent]
      |
      v
[Human Approver]
      |
      +--> Merge
      +--> Reject
      +--> Request Rework
      +--> Approve Promotion

## Workflow Details

### 1. New Requirement

architecture-agent reviews the requirement for enterprise architecture alignment, design boundaries, API impact, database impact, integration impact, and ADR requirements.

### 2. Code Generation

developer-agent drafts code, configuration, tests, API contracts, or migration drafts in a branch.

developer-agent cannot approve or deploy its own output.

### 3. Security Review

security-agent reviews authentication, authorization, RBAC, ABAC, OPA, secrets handling, vulnerabilities, secure coding, and fail-closed behavior.

High and critical findings block promotion.

### 4. Test Generation and Execution

test-agent creates or updates unit tests, integration tests, API tests, regression tests, security tests, and acceptance tests.

Failed required tests block promotion.

### 5. Documentation Update

documentation-agent updates README files, architecture docs, API docs, release notes, decision records, and Obsidian documentation.

Missing required documentation blocks release readiness.

### 6. Evidence Collection

evidence-agent collects commits, pull requests, test results, security scans, CI/CD logs, approvals, screenshots, deployment records, and runtime logs.

Missing required evidence blocks promotion.

### 7. CI/CD Validation

cicd-agent validates build, tests, scans, release gates, rollback readiness, deployment scripts, and promotion readiness.

cicd-agent cannot silently deploy to production.

### 8. Knowledge Update

knowledge-fabric-agent updates Obsidian, LLM Wiki, cross-document references, context packs, lessons learned, decision links, prompt references, and reusable knowledge.

### 9. Approval and Promotion

Human approver reviews all outputs and evidence.

Only approved changes may be merged or promoted.

## Promotion Recommendation

cicd-agent may recommend promotion only when:

- Architecture gate passed
- Development gate passed
- Security gate passed
- Test gate passed
- Documentation gate passed
- Evidence gate passed
- CI/CD gate passed
- Rollback gate passed
- Knowledge gate passed
- Human approval exists

## Final Approval

Only a human approver can approve merge, release, production deployment, or promotion.