# AIRA Agent Risk and Governance Matrix

| Agent | Risk Level | Maker-Checker Required | Human Approval Required | CAB/ARB Review | Can Approve | Can Deploy | Fail Closed | Evidence Required |
|---|---|---|---|---|---|---|---|---|
| architecture-agent | Medium | Yes | Yes for changes | If architecture/security/release impact | No | No | Yes | ADR, architecture review report, design review checklist, decision traceability record. |
| developer-agent | High | Yes | Yes for changes | If architecture/security/release impact | No | No | Yes | Code diff, PR summary, build log, test log, implementation evidence. |
| security-agent | High | Yes | Yes for changes | If architecture/security/release impact | No | No | Yes | Security finding, threat model, policy review, vulnerability triage, approval record. |
| test-agent | Medium | Yes | Yes for changes | If architecture/security/release impact | No | No | Yes | Test report, coverage report, test execution log, acceptance traceability. |
| documentation-agent | Low/Medium | Yes | Yes for changes | If architecture/security/release impact | No | No | Yes | Documentation update record, release notes, linked evidence references. |
| evidence-agent | Medium | Yes | Yes for changes | If architecture/security/release impact | No | No | Yes | Evidence pack, audit trail, traceability matrix, missing evidence report. |
| cicd-agent | High/Critical | Yes | Yes for changes | If architecture/security/release impact | No | Limited with approval | Yes | Pipeline logs, scan results, build logs, release gate report, rollback checklist. |
| knowledge-fabric-agent | Medium | Yes | Yes for changes | If architecture/security/release impact | No | No | Yes | Knowledge update log, link map, context pack summary, source traceability. |
