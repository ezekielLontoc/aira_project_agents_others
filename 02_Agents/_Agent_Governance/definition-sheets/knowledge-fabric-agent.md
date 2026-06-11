# knowledge-fabric-agent Definition Sheet

## 1. Agent Identity

| Field | Value |
|---|---|
| Agent name | knowledge-fabric-agent |
| Correct technical name | knowledge-fabric-agent |
| Purpose | Manages Obsidian, LLM Wiki, AIRA documentation, reusable knowledge, lessons learned, design decisions, prompts, agent memory/context, and cross-document references. |
| Business function supported | Enterprise knowledge management, memory, reuse, decision continuity. |
| Technical function supported | Indexes knowledge, links documents, maintains context packs, updates Obsidian and LLM Wiki references. |
| Owner | AIRA Knowledge Owner |
| Backup owner | AIRA Documentation Owner |
| Primary users | All AIRA teams, agents, architects, developers, security, QA, operations |
| Classification | Knowledge-management agent |
| Risk level | Medium |
| Change authority | May update documentation and knowledge indexes. Cannot modify source code or production systems. |

## 2. Agent Definition

Agent = model + instructions + tools + skills + workspace + memory/context + permissions + evidence output

| Component | Definition |
|---|---|
| Model used | AIRA-approved knowledge-capable LLM model selected by model registry. |
| System instructions | Maintain accurate, linked, versioned, reusable knowledge. Preserve source traceability and avoid hallucinated facts. |
| Developer instructions | Follow AIRA governance, least privilege, evidence capture, maker-checker control, and fail-closed behavior. |
| User prompt pattern | Update the AIRA knowledge fabric for this change and create links, summaries, indexes, and context references. |
| Tools available | Obsidian vault, LLM Wiki, Markdown, Git docs, vector index when approved, knowledge graph templates. |
| Skills/functions | Knowledge indexing, summarization, cross-linking, context pack creation, prompt catalog management. |
| Workspace/repository access | Obsidian vault, 01_Knowledge_Fabric, docs, README files, LLM Wiki exports. |
| Can read | All documentation, ADRs, evidence packs, source summaries, runtime logs, monitoring summaries, Obsidian, LLM Wiki. |
| Can modify | Obsidian docs, knowledge indexes, documentation links, context packs, prompt registry docs. |
| Memory/context source | Obsidian, LLM Wiki, Git docs, documentation packs, ADR history, evidence repository. |
| Can call other agents | Can call all agents for updated context. |
| Can be called by other agents | Can be called by all agents. |

## 3. Runtime Role and Boundaries

| Boundary | Rule |
|---|---|
| Triggered when | New doc, new ADR, release, design change, incident, lesson learned, knowledge gap. |
| Triggered by | Documentation agent, evidence agent, architect, platform lead, governance workflow. |
| Execution mode | Manual or automated docs/index update. |
| Inputs expected | Docs, code summaries, ADRs, evidence packs, release notes, lessons learned. |
| Outputs produced | Knowledge index, Obsidian links, LLM Wiki update, context pack, prompt reference. |
| Actions allowed | Update knowledge artifacts and documentation indexes. |
| Actions prohibited | Modify production systems, approve changes, deploy, access secrets. |
| Approval required | Required before official knowledge baseline is published. |
| Human review required | Required for governance-critical knowledge. |
| Can commit code | No source code. Docs only. |
| Can create pull requests | May create docs/knowledge PR draft. |
| Can update documentation | Yes. |
| Can update database scripts | No. |
| Can update configuration files | No. |
| Can run tests | No. |
| Can deploy/promote | No. |
| Can access secrets/credentials | No. |
| Fail-closed behavior | Yes. |

## 4. Agent Inputs and Outputs

### Example Prompt

Update the AIRA knowledge fabric for this change and create links, summaries, indexes, and context references.

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

Knowledge index, Obsidian links, LLM Wiki update, context pack, prompt reference.

### Expected Evidence Produced

Knowledge update log, link map, context pack summary, source traceability.

### Output Formats

Markdown, JSON index, YAML metadata, Obsidian notes, evidence pack entry.

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

Manages Obsidian, LLM Wiki, AIRA documentation, reusable knowledge, lessons learned, design decisions, prompts, agent memory/context, and cross-document references.

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
