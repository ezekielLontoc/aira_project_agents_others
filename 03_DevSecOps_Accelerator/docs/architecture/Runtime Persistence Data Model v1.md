# Runtime Persistence Data Model v1

## Status

Accepted

## Purpose

Defines the logical data model for the AIRA Runtime Persistence Foundation.

## Core Domains

### Governance Domain

Tables:

- aira_governance.change_request
- aira_governance.governance_decision
- aira_governance.control_gate
- aira_governance.approval_record

Purpose:

Tracks governed changes, architecture decisions, mandatory gates, and human approvals.

### Agent Domain

Tables:

- aira_agents.agent_definition
- aira_agents.agent_prompt_version
- aira_agents.agent_model_version
- aira_agents.agent_tool_permission
- aira_agents.agent_execution_audit

Purpose:

Tracks agent identity, versioning, prompts, models, tool permissions, and execution audit.

### Evidence Domain

Tables:

- aira_evidence.runtime_evidence_pack
- aira_evidence.evidence_artifact
- aira_evidence.evidence_traceability_link

Purpose:

Tracks evidence packs, atomic evidence artifacts, and traceability relationships.

### Security Domain

Tables:

- aira_security.security_finding
- aira_security.secret_control_record

Purpose:

Tracks security findings, risk states, and secret control requirements.

### Testing Domain

Tables:

- aira_testing.test_execution_record

Purpose:

Tracks test execution and quality evidence.

### Runtime Domain

Tables:

- aira_runtime.release_gate_check
- aira_runtime.deployment_readiness_record
- aira_runtime.rollback_readiness_record
- aira_runtime.persistence_audit_record

Purpose:

Tracks release readiness, promotion readiness, rollback readiness, and persistence audit.

### Observability Domain

Tables:

- aira_observability.runtime_health_snapshot

Purpose:

Tracks runtime service health evidence.

### Knowledge Domain

Tables:

- aira_knowledge.knowledge_artifact

Purpose:

Tracks Obsidian, LLM Wiki, documentation, context packs, prompts, and reusable knowledge references.

## Safety Constraints

The persistence model enforces:

- Agents cannot approve changes.
- Agents cannot silently make production changes.
- Evidence artifacts cannot contain secrets.
- Secret values cannot be stored.
- Agent direct access to secrets is not allowed.