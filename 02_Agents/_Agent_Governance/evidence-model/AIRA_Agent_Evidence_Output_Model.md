# AIRA Agent Evidence Output Model

## Purpose

Defines the minimum evidence expected from each AIRA agent.

## Evidence Rules

1. Every agent action must produce a traceable output.
2. High-risk agent actions require human approval.
3. Evidence must link to source artifacts where applicable.
4. Evidence must not include secrets.
5. Evidence must be versioned when stored in the repository.
6. Missing required evidence must fail closed.

## Evidence Types

| Evidence Type | Description |
|---|---|
| ADR | Architecture decision record |
| Design Review | Architecture or solution review |
| Code Diff | Proposed implementation changes |
| Pull Request | Reviewable change package |
| Build Log | Maven, Docker, or CI build output |
| Test Report | Unit, integration, API, regression, or acceptance result |
| Coverage Report | Code coverage or test completeness |
| Security Finding | Vulnerability, control gap, or policy issue |
| Policy Review | RBAC, ABAC, OPA, secrets, or fail-closed review |
| Evidence Pack | Traceability package for audit |
| Audit Log | Timeline of agent actions |
| Release Gate Report | CI/CD readiness and promotion recommendation |
| Knowledge Update Log | Obsidian, LLM Wiki, or context pack update |