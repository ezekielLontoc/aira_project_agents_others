# AIRA Agent Sample Prompts and Outputs

## architecture-agent

### Example Prompt

Review this architecture/design/API/database/workflow against AIRA standards and produce findings, recommendations, ADR impacts, and evidence.

### Example Task

Assess or produce the required AIRA artifact for a governed platform change.

### Expected Response

- Summary
- Scope
- Findings or generated artifacts
- Risks
- Files generated or modified
- Evidence produced
- Approval requirements

### Expected Evidence

ADR, architecture review report, design review checklist, decision traceability record.

### Output Format

Markdown, ADR, review matrix, JSON finding summary, evidence pack entry.

## developer-agent

### Example Prompt

Implement this requirement within the AIRA repository using existing standards. Produce code, tests, documentation notes, and evidence.

### Example Task

Assess or produce the required AIRA artifact for a governed platform change.

### Expected Response

- Summary
- Scope
- Findings or generated artifacts
- Risks
- Files generated or modified
- Evidence produced
- Approval requirements

### Expected Evidence

Code diff, PR summary, build log, test log, implementation evidence.

### Output Format

Code, Markdown, JSON, YAML, PR draft, test report, evidence pack entry.

## security-agent

### Example Prompt

Review this change for security, access control, secrets, vulnerabilities, policy compliance, and fail-closed behavior.

### Example Task

Assess or produce the required AIRA artifact for a governed platform change.

### Expected Response

- Summary
- Scope
- Findings or generated artifacts
- Risks
- Files generated or modified
- Evidence produced
- Approval requirements

### Expected Evidence

Security finding, threat model, policy review, vulnerability triage, approval record.

### Output Format

Security finding, Markdown, JSON, evidence pack entry, policy review.

## test-agent

### Example Prompt

Create tests for this requirement/code/API and provide expected results, test data, and evidence output.

### Example Task

Assess or produce the required AIRA artifact for a governed platform change.

### Expected Response

- Summary
- Scope
- Findings or generated artifacts
- Risks
- Files generated or modified
- Evidence produced
- Approval requirements

### Expected Evidence

Test report, coverage report, test execution log, acceptance traceability.

### Output Format

Markdown, JSON, test report, code, evidence pack entry.

## documentation-agent

### Example Prompt

Document this change, architecture, API, release, runbook, or decision using AIRA documentation standards.

### Example Task

Assess or produce the required AIRA artifact for a governed platform change.

### Expected Response

- Summary
- Scope
- Findings or generated artifacts
- Risks
- Files generated or modified
- Evidence produced
- Approval requirements

### Expected Evidence

Documentation update record, release notes, linked evidence references.

### Output Format

Markdown, ADR, release notes, API documentation, evidence pack entry.

## evidence-agent

### Example Prompt

Create an evidence pack for this change/release/control and identify missing artifacts.

### Example Task

Assess or produce the required AIRA artifact for a governed platform change.

### Expected Response

- Summary
- Scope
- Findings or generated artifacts
- Risks
- Files generated or modified
- Evidence produced
- Approval requirements

### Expected Evidence

Evidence pack, audit trail, traceability matrix, missing evidence report.

### Output Format

Markdown, JSON, evidence pack, audit log, traceability matrix.

## cicd-agent

### Example Prompt

Validate this pipeline/release/change for build, test, scan, evidence, rollback, and promotion readiness.

### Example Task

Assess or produce the required AIRA artifact for a governed platform change.

### Expected Response

- Summary
- Scope
- Findings or generated artifacts
- Risks
- Files generated or modified
- Evidence produced
- Approval requirements

### Expected Evidence

Pipeline logs, scan results, build logs, release gate report, rollback checklist.

### Output Format

Markdown, JSON, pipeline report, security finding summary, evidence pack entry.

## knowledge-fabric-agent

### Example Prompt

Update the AIRA knowledge fabric for this change and create links, summaries, indexes, and context references.

### Example Task

Assess or produce the required AIRA artifact for a governed platform change.

### Expected Response

- Summary
- Scope
- Findings or generated artifacts
- Risks
- Files generated or modified
- Evidence produced
- Approval requirements

### Expected Evidence

Knowledge update log, link map, context pack summary, source traceability.

### Output Format

Markdown, JSON index, YAML metadata, Obsidian notes, evidence pack entry.

