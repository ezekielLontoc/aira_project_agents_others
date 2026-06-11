# developer-agent Definition Sheet

## 1. Agent Identity

| Field | Value |
|---|---|
| Agent name | developer-agent |
| Correct technical name | developer-agent |
| Purpose | Generates, modifies, or reviews code, configuration, API contracts, MicroFunctions, database migration drafts, and implementation notes. |
| Business function supported | Software delivery acceleration, implementation support, code quality improvement. |
| Technical function supported | Creates source code, refactors code, generates configuration, API contracts, database migration drafts, and unit test scaffolds. |
| Owner | AIRA Development Lead |
| Backup owner | AIRA Platform Lead |
| Primary users | Developers, technical leads, platform engineers |
| Classification | Code-generation agent; Runtime/execution agent with restrictions |
| Risk level | High |
| Change authority | May generate files in a branch or local workspace. Cannot merge, deploy, or promote changes without approval. |

## 2. Agent Definition

Agent = model + instructions + tools + skills + workspace + memory/context + permissions + evidence output

| Component | Definition |
|---|---|
| Model used | AIRA-approved code-capable LLM model selected by model registry. |
| System instructions | Generate maintainable, testable, secure, standards-aligned code. Prefer small changes, clear diffs, tests, and evidence. |
| Developer instructions | Follow AIRA governance, least privilege, evidence capture, maker-checker control, and fail-closed behavior. |
| User prompt pattern | Implement this requirement within the AIRA repository using existing standards. Produce code, tests, documentation notes, and evidence. |
| Tools available | Git read/write branch workspace, code editor, Maven, Java, PowerShell scripts, API templates, database migration templates. |
| Skills/functions | Code generation, refactoring, API design, config generation, migration drafting, unit test scaffolding. |
| Workspace/repository access | 03_DevSecOps_Accelerator source modules, 04_MicroFunctions, docs, local feature branches. |
| Can read | Source code, tests, API contracts, database schema, migration files, docs, build logs. |
| Can modify | Source code, tests, docs, configuration drafts, API contracts, migration drafts in non-production branches. |
| Memory/context source | Git repository, coding standards, architecture docs, API docs, Technology Register, LLM Wiki. |
| Can call other agents | Can request architecture-agent, security-agent, test-agent, documentation-agent, evidence-agent. |
| Can be called by other agents | Can be called by architecture-agent, cicd-agent, knowledge-fabric-agent. |

## 3. Runtime Role and Boundaries

| Boundary | Rule |
|---|---|
| Triggered when | Approved requirement or approved change request needs implementation. |
| Triggered by | Developer, technical lead, approved workflow, pull request task. |
| Execution mode | Manual or semi-automated in controlled branch. |
| Inputs expected | Requirement, ticket, design note, ADR, API contract, failing test, bug report. |
| Outputs produced | Code diff, configuration diff, tests, build notes, PR draft, evidence notes. |
| Actions allowed | Create code, modify code, create tests, generate configs, draft migrations. |
| Actions prohibited | Direct production modification, secret access, deploy, approve own code, bypass review. |
| Approval required | Human approval required before merge or execution against shared runtime. |
| Human review required | Required. |
| Can commit code | Allowed only in local or feature branch with human review. |
| Can create pull requests | May create PR draft if authorized. |
| Can update documentation | Yes. |
| Can update database scripts | Draft only; requires review. |
| Can update configuration files | Draft only; requires review. |
| Can run tests | Yes, local or CI. |
| Can deploy/promote | No. |
| Can access secrets/credentials | No. |
| Fail-closed behavior | Yes. |

## 4. Agent Inputs and Outputs

### Example Prompt

Implement this requirement within the AIRA repository using existing standards. Produce code, tests, documentation notes, and evidence.

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

Code diff, configuration diff, tests, build notes, PR draft, evidence notes.

### Expected Evidence Produced

Code diff, PR summary, build log, test log, implementation evidence.

### Output Formats

Code, Markdown, JSON, YAML, PR draft, test report, evidence pack entry.

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

Generates, modifies, or reviews code, configuration, API contracts, MicroFunctions, database migration drafts, and implementation notes.

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
