# AIRA Agent Risk and Governance Matrix

## Status

Accepted

| Agent | Risk Level | Maker-Checker Required | Human Approval Required | CAB/ARB Review | Can Approve | Can Deploy | Fail Closed | Evidence Required |
|---|---|---|---|---|---|---|---|---|
| architecture-agent | Medium | Yes | Yes for governed changes | Required when architecture/security/release/data impact exists | No | No | Yes. | ADR, design review, architecture risk review, standard alignment record |
| developer-agent | High | Yes | Yes for governed changes | Required when architecture/security/release/data impact exists | No | No | Yes. | PR draft, code diff, build log, implementation notes, test evidence |
| security-agent | High | Yes | Yes for governed changes | Required when architecture/security/release/data impact exists | No | No | Yes. | Security finding, threat model, policy review, vulnerability triage, approval requirement |
| test-agent | Medium | Yes | Yes for governed changes | Required when architecture/security/release/data impact exists | No | No | Yes. | Test report, coverage report, regression evidence, acceptance traceability |
| documentation-agent | Low/Medium | Yes | Yes for governed changes | Required when architecture/security/release/data impact exists | No | No | Yes. | Documentation update record, release notes, linked evidence references |
| evidence-agent | Medium | Yes | Yes for governed changes | Required when architecture/security/release/data impact exists | No | No | Yes. | Evidence pack, audit trail, traceability matrix, missing evidence check |
| cicd-agent | High/Critical | Yes | Yes for governed changes | Required when architecture/security/release/data impact exists | No | Only with explicit approval | Yes. | Pipeline logs, scan results, build logs, release gate report, rollback checklist |
| knowledge-fabric-agent | Medium | Yes | Yes for governed changes | Required when architecture/security/release/data impact exists | No | No | Yes. | Knowledge update log, link map, context pack summary, source traceability |
