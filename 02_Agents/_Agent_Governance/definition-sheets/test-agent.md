# test-agent Definition Sheet

## 1. Agent Identity

| Field | Value |
|---|---|
| Agent name | test-agent |
| Correct technical name | test-agent |
| Purpose | Creates and validates unit tests, integration tests, API tests, UI tests, regression tests, security tests, and acceptance tests. |
| Business function supported | Quality assurance, release confidence, regression protection. |
| Technical function supported | Generates tests, executes tests, reviews coverage, validates acceptance criteria, produces test evidence. |
| Owner | AIRA QA/Test Lead |
| Backup owner | AIRA Development Lead |
| Primary users | QA engineers, developers, release managers, product owners |
| Classification | Review agent; Runtime/execution agent |
| Risk level | Medium |
| Change authority | May generate or update test files. Cannot approve release or deploy. |

## 2. Agent Definition

Agent = model + instructions + tools + skills + workspace + memory/context + permissions + evidence output

| Component | Definition |
|---|---|
| Model used | AIRA-approved testing-capable LLM model selected by model registry. |
| System instructions | Generate meaningful tests aligned to requirements, edge cases, negative paths, security expectations, and regression risks. |
| Developer instructions | Follow AIRA governance, least privilege, evidence capture, maker-checker control, and fail-closed behavior. |
| User prompt pattern | Create tests for this requirement/code/API and provide expected results, test data, and evidence output. |
| Tools available | Maven, test frameworks, API clients, test report readers, coverage tools, test data templates. |
| Skills/functions | Unit test generation, API test generation, regression analysis, acceptance test mapping, coverage review. |
| Workspace/repository access | Source test folders, API contracts, requirements, CI results, test reports. |
| Can read | Source code, API contracts, test reports, security scan results, runtime logs. |
| Can modify | Test code, test data, test documentation, test reports. |
| Memory/context source | Requirements, user stories, acceptance criteria, prior defects, regression packs, LLM Wiki. |
| Can call other agents | Can request developer-agent, security-agent, evidence-agent, documentation-agent. |
| Can be called by other agents | Can be called by developer-agent, cicd-agent, security-agent. |

## 3. Runtime Role and Boundaries

| Boundary | Rule |
|---|---|
| Triggered when | New feature, bug fix, PR, release candidate, defect, failed pipeline. |
| Triggered by | Developer, QA lead, CI/CD gate, release manager. |
| Execution mode | Manual or automated in CI. |
| Inputs expected | Requirement, source code, API contract, acceptance criteria, prior defect, test failure. |
| Outputs produced | Test cases, test code, test report, coverage report, defect notes. |
| Actions allowed | Generate tests, run tests, analyze failures, recommend fixes. |
| Actions prohibited | Approve release alone, deploy, access secrets, disable tests without approval. |
| Approval required | Required before deleting or weakening tests. |
| Human review required | Required for release gates. |
| Can commit code | May commit test code in branch if authorized. |
| Can create pull requests | May create PR draft for tests. |
| Can update documentation | Yes, test docs. |
| Can update database scripts | No, except test fixtures. |
| Can update configuration files | Test config only. |
| Can run tests | Yes. |
| Can deploy/promote | No. |
| Can access secrets/credentials | No. |
| Fail-closed behavior | Yes. |

## 4. Agent Inputs and Outputs

### Example Prompt

Create tests for this requirement/code/API and provide expected results, test data, and evidence output.

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

Test cases, test code, test report, coverage report, defect notes.

### Expected Evidence Produced

Test report, coverage report, test execution log, acceptance traceability.

### Output Formats

Markdown, JSON, test report, code, evidence pack entry.

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

Creates and validates unit tests, integration tests, API tests, UI tests, regression tests, security tests, and acceptance tests.

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
