# AIRA Agent Evidence Contract v1

## Status

Accepted

## Purpose

Defines mandatory evidence produced by every AIRA agent.

## Evidence Contract

| Agent | Required Evidence |
|---|---|
| architecture-agent | ADR, design review, architecture risk review, standard alignment record |
| developer-agent | PR draft, code diff, build log, implementation notes, test evidence |
| security-agent | Security finding, threat model, policy review, vulnerability triage, approval requirement |
| test-agent | Test report, coverage report, regression evidence, acceptance traceability |
| documentation-agent | Documentation update record, release notes, linked evidence references |
| evidence-agent | Evidence pack, audit trail, traceability matrix, missing evidence check |
| cicd-agent | Pipeline logs, scan results, build logs, release gate report, rollback checklist |
| knowledge-fabric-agent | Knowledge update log, link map, context pack summary, source traceability |

## Minimum Evidence Fields

Every evidence entry must include:

- Evidence ID
- Agent name
- Agent version
- Prompt version
- Model version
- Tool version
- Input reference
- Output reference
- Repository path or artifact reference
- Timestamp
- Risk level
- Approval requirement
- Human reviewer
- Related commit or PR
- Related test result
- Related security result
- Related documentation
- Fail-closed status

## Fail-Closed Evidence Rule

If required evidence is missing, the workflow cannot proceed to promotion.