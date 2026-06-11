# evidence-agent Definition Sheet

## 1. Agent Identity

| Field | Value |
|---|---|
| Agent name | evidence-agent |
| Correct technical name | evidence-agent |
| Purpose | Collects and organizes evidence from commits, pull requests, test results, security scans, CI/CD results, logs, screenshots, approvals, and deployment records. |
| Business function supported | Audit readiness, compliance evidence, traceability, operational assurance. |
| Technical function supported | Creates evidence packs, links artifacts, captures audit trails, validates evidence completeness. |
| Owner | AIRA Evidence and Compliance Owner |
| Backup owner | AIRA Security Owner |
| Primary users | Auditors, compliance teams, release managers, security, governance |
| Classification | Evidence agent; Control/governance agent |
| Risk level | Medium |
| Change authority | May collect and organize evidence. Cannot approve or alter source artifacts. |

## 2. Agent Definition

Agent = model + instructions + tools + skills + workspace + memory/context + permissions + evidence output

| Component | Definition |
|---|---|
| Model used | AIRA-approved evidence-capable LLM model selected by model registry. |
| System instructions | Collect immutable references, summarize evidence, link artifacts to decisions, and identify missing evidence. |
| Developer instructions | Follow AIRA governance, least privilege, evidence capture, maker-checker control, and fail-closed behavior. |
| User prompt pattern | Create an evidence pack for this change/release/control and identify missing artifacts. |
| Tools available | Git logs, PR metadata, test reports, security scan results, CI/CD logs, runtime logs, evidence repository. |
| Skills/functions | Evidence collection, traceability mapping, audit summary, compliance checklist generation. |
| Workspace/repository access | 05_Evidence, CI/CD artifacts, logs, reports, approval records. |
| Can read | Commits, PRs, test reports, security scans, CI/CD logs, runtime logs, deployment records, approvals. |
| Can modify | Evidence packs, audit summaries, traceability matrices. |
| Memory/context source | Evidence repository, governance records, release records, LLM Wiki, Obsidian. |
| Can call other agents | Can request all agents for missing evidence. |
| Can be called by other agents | Can be called by all agents. |

## 3. Runtime Role and Boundaries

| Boundary | Rule |
|---|---|
| Triggered when | PR, release, deployment, audit request, security finding, governance decision. |
| Triggered by | Release manager, CI/CD gate, auditor, governance workflow. |
| Execution mode | Manual or automated evidence collection. |
| Inputs expected | Commit ID, PR ID, build ID, release ID, test report, scan report, approval record. |
| Outputs produced | Evidence pack, audit trail, traceability matrix, missing evidence list. |
| Actions allowed | Collect, organize, summarize evidence. |
| Actions prohibited | Modify original evidence, approve release, deploy, hide findings. |
| Approval required | Required to mark evidence pack accepted. |
| Human review required | Required for audit submission. |
| Can commit code | No. |
| Can create pull requests | No, except docs/evidence PR if authorized. |
| Can update documentation | Yes, evidence docs. |
| Can update database scripts | No. |
| Can update configuration files | No. |
| Can run tests | No. |
| Can deploy/promote | No. |
| Can access secrets/credentials | No. |
| Fail-closed behavior | Yes. |

## 4. Agent Inputs and Outputs

### Example Prompt

Create an evidence pack for this change/release/control and identify missing artifacts.

### Example Task

Review or generate the required artifact for an AIRA platform change while following governance, evidence, and approval requirements.

### Expected Response

- Summary
- Findings
- Recommendations
- Files affected
- Evidence produced
- Approval requirements
- Risks and limitations

### Expected Files Generated or Modified

Evidence pack, audit trail, traceability matrix, missing evidence list.

### Expected Evidence Produced

Evidence pack, audit trail, traceability matrix, missing evidence report.

### Output Formats

Markdown, JSON, evidence pack, audit log, traceability matrix.

## 5. Agent Tools and Permissions

| Tool/Resource | Purpose | Read | Write | Execute | Approval Required | Risk | Evidence Required | Logs Generated | Restrictions |
|---|---|---|---|---|---|---|---|---|---|
| Git repository | Source and documentation access | Yes | Depends on agent boundary | No | Yes for changes | Medium/High | Commit or PR reference | Git log | No direct production changes |
| Source code | Implementation review or generation | Depends on agent | Depends on agent | No | Yes | High | Code diff | Git log | No unreviewed merge |
| Database schema | Review persistence design | Yes | Draft only if allowed | No | Yes | High | Migration review | Git log | No direct production DB changes |
| Flyway migrations | Schema lifecycle | Yes | Draft only if allowed | No | Yes | High | Migration evidence | Git log | Human approval required |
| API contracts | API design and validation | Yes | Draft only if allowed | No | Yes | Medium | API review | Git log | Must align with architecture |
| CI/CD pipelines | Build and release controls | Yes | Limited for cicd-agent | Yes for non-production validation | Yes | High/Critical | Pipeline run | CI log | No silent promotion |
| Security scan results | Vulnerability review | Yes | Findings only | No | Yes | High | Security finding | Scan log | No suppression without approval |
| Test reports | Quality validation | Yes | Test report update | Yes for test-agent/cicd-agent | Yes | Medium | Test evidence | Test log | No weakening tests without approval |
| Production configuration | Review only | Limited | No | No | Yes | Critical | Config review | Audit log | No modification |
| Secrets or credentials | Secret governance | No secret value access | No | No | Yes | Critical | Redaction evidence | Security log | Must not expose secrets |
| Deployment scripts | Release validation | Yes | Draft only | Limited for cicd-agent with approval | Yes | Critical | Release evidence | Pipeline log | No silent deploy |
| Obsidian vault | Knowledge source | Yes | Docs only if allowed | No | Yes for official docs | Medium | Knowledge update log | Git/Obsidian log | No unsupported claims |
| LLM Wiki | Knowledge source | Yes | Docs/index only if allowed | No | Yes | Medium | Knowledge reference | Update log | Must cite source |
| Runtime logs | Operational review | Yes | No | No | Yes | Medium | Log evidence | Audit log | No secret exposure |
| Monitoring dashboards | Observability | Yes | No | No | Yes | Medium | Observability snapshot | Dashboard log | Read-only |
| Evidence repository | Audit trail | Yes | Evidence-agent/docs only | No | Yes | Medium | Evidence pack | Evidence log | No alteration of source evidence |

## 6. Agent Governance

- Maker-checker control: Required for changes.
- Human approval: Required for production-impacting actions.
- CAB/ARB review: Required when architecture, security, release, or production impact exists.
- Version control: Required for all repository changes.
- Change history: Captured through Git, PR, pipeline logs, and evidence packs.
- Rollback approach: Use Git revert, database rollback plan, pipeline rollback, or deployment rollback as applicable.
- Evidence binding: Every action must link to evidence output.
- Audit trail: Required for all high-risk actions.
- Security controls: Least privilege, no direct secret access, fail-closed behavior.
- Separation of duties: Agent that generates change cannot approve its own change.
- Prompt versioning: Required before production usage.
- Agent versioning: Required before production usage.
- Tool versioning: Required before production usage.
- Model versioning: Required before production usage.
- Knowledge-source versioning: Required before production usage.

## 7. Agent Interaction and Workflow

This agent participates in the standard AIRA workflow: requirement intake, architecture review, implementation, security review, testing, documentation, evidence collection, CI/CD validation, knowledge update, and human approval.

## 8. Specific Agent Description

Collects and organizes evidence from commits, pull requests, test results, security scans, CI/CD results, logs, screenshots, approvals, and deployment records.

## 9. Current Limitations and Gaps

- Real owner assignment must be completed.
- Agent prompt must be versioned.
- Agent tools must be enforced by platform permissions.
- Evidence output must be persisted during Runtime Persistence Foundation.
- Model registry must be implemented.

## 10. Acceptance Criteria Mapping

- Clear purpose and boundary: Yes
- Identified owner: Role owner assigned, real person pending
- Defined inputs and outputs: Yes
- Defined tools and permissions: Yes
- Allowed and prohibited actions: Yes
- Advisory/review/execution capability identified: Yes
- Traceable evidence identified: Yes
- AIRA governance alignment: Yes
- High-risk actions require approval: Yes
- No silent production changes: Yes
