# AIRA Agent RACI Matrix

## RACI Meaning

| Code | Meaning |
|---|---|
| R | Responsible |
| A | Accountable |
| C | Consulted |
| I | Informed |

## Matrix

| Activity | architecture-agent | developer-agent | security-agent | test-agent | documentation-agent | evidence-agent | cicd-agent | knowledge-fabric-agent | Human Approver |
|---|---|---|---|---|---|---|---|---|---|
| Requirement review | R | C | C | C | I | I | I | I | A |
| Architecture review | R | C | C | I | C | I | I | C | A |
| ADR creation | R | C | C | I | R | I | I | C | A |
| Code generation | C | R | C | C | I | I | I | I | A |
| Code review | C | R | C | C | I | I | I | I | A |
| Security review | C | C | R | C | I | C | C | I | A |
| Test generation | I | C | C | R | I | I | C | I | A |
| Test execution | I | C | C | R | I | C | R | I | A |
| Documentation update | C | C | C | C | R | C | I | R | A |
| Evidence pack | I | I | C | C | C | R | C | C | A |
| Pipeline validation | I | C | C | C | I | C | R | I | A |
| Release readiness | C | C | C | C | C | R | R | I | A |
| Promotion recommendation | C | I | C | C | I | C | R | I | A |
| Production approval | I | I | C | C | I | C | C | I | A |
| Knowledge update | C | I | I | I | R | C | I | R | A |

## Separation of Duties

The agent responsible for producing a change cannot be accountable for approving the change.

Final accountability belongs to the human approver.