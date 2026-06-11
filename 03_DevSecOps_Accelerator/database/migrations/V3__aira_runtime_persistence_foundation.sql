-- ============================================================
-- AIRA Runtime Persistence Foundation
-- Migration: V3
-- PostgreSQL: 17
--
-- Purpose:
-- Establish governed persistence foundation for:
-- - Agent registry and definitions
-- - Agent prompts, models, tools, and permissions
-- - Agent execution audit
-- - Governance controls and approval gates
-- - Evidence artifacts and traceability
-- - Runtime service health
-- - CI/CD release gates
-- - Security controls
-- - Testing records
-- - Knowledge fabric records
--
-- Governance:
-- - Fail closed on missing required information
-- - No silent production change
-- - Evidence required for governed actions
-- - Human approval required for high-risk changes
-- ============================================================

CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE SCHEMA IF NOT EXISTS aira_security;
CREATE SCHEMA IF NOT EXISTS aira_governance;
CREATE SCHEMA IF NOT EXISTS aira_evidence;
CREATE SCHEMA IF NOT EXISTS aira_agents;
CREATE SCHEMA IF NOT EXISTS aira_runtime;
CREATE SCHEMA IF NOT EXISTS aira_observability;
CREATE SCHEMA IF NOT EXISTS aira_testing;
CREATE SCHEMA IF NOT EXISTS aira_knowledge;

-- ============================================================
-- AIRA Governance: Change Requests
-- ============================================================

CREATE TABLE IF NOT EXISTS aira_governance.change_request (
    change_request_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    change_key VARCHAR(120) NOT NULL UNIQUE,
    title VARCHAR(300) NOT NULL,
    description TEXT NOT NULL,
    requested_by VARCHAR(160) NOT NULL,
    business_owner VARCHAR(160) NOT NULL,
    technical_owner VARCHAR(160) NOT NULL,
    risk_level VARCHAR(30) NOT NULL CHECK (risk_level IN ('Low', 'Medium', 'High', 'Critical')),
    status VARCHAR(40) NOT NULL CHECK (status IN ('Draft', 'Under Review', 'Approved', 'Rejected', 'Implemented', 'Closed')),
    source_reference TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE aira_governance.change_request IS 'Governed change request record for AIRA platform work.';

-- ============================================================
-- AIRA Governance: Decisions
-- ============================================================

CREATE TABLE IF NOT EXISTS aira_governance.governance_decision (
    governance_decision_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    decision_key VARCHAR(120) NOT NULL UNIQUE,
    change_key VARCHAR(120),
    decision_type VARCHAR(80) NOT NULL,
    decision_title VARCHAR(300) NOT NULL,
    decision_summary TEXT NOT NULL,
    decision_status VARCHAR(40) NOT NULL CHECK (decision_status IN ('Proposed', 'Accepted', 'Rejected', 'Superseded')),
    approver VARCHAR(160),
    approval_required BOOLEAN NOT NULL DEFAULT TRUE,
    evidence_required BOOLEAN NOT NULL DEFAULT TRUE,
    evidence_reference TEXT,
    adr_reference TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    decided_at TIMESTAMPTZ
);

COMMENT ON TABLE aira_governance.governance_decision IS 'Architecture, security, release, and platform governance decision records.';

-- ============================================================
-- AIRA Governance: Control Gates
-- ============================================================

CREATE TABLE IF NOT EXISTS aira_governance.control_gate (
    control_gate_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    gate_key VARCHAR(120) NOT NULL UNIQUE,
    gate_name VARCHAR(200) NOT NULL,
    gate_category VARCHAR(80) NOT NULL,
    purpose TEXT NOT NULL,
    blocking_rule TEXT NOT NULL,
    required_for TEXT NOT NULL,
    owner VARCHAR(160) NOT NULL,
    is_mandatory BOOLEAN NOT NULL DEFAULT TRUE,
    fail_closed BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE aira_governance.control_gate IS 'Mandatory gates for architecture, security, testing, documentation, evidence, CI/CD, approval, rollback, and knowledge.';

-- ============================================================
-- AIRA Governance: Approval Records
-- ============================================================

CREATE TABLE IF NOT EXISTS aira_governance.approval_record (
    approval_record_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    approval_key VARCHAR(160) NOT NULL UNIQUE,
    change_key VARCHAR(120),
    approval_type VARCHAR(80) NOT NULL,
    approval_status VARCHAR(40) NOT NULL CHECK (approval_status IN ('Pending', 'Approved', 'Rejected', 'Revoked')),
    requested_by VARCHAR(160) NOT NULL,
    approver VARCHAR(160),
    approval_reason TEXT,
    evidence_reference TEXT,
    approved_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE aira_governance.approval_record IS 'Human approval records for governed actions.';

-- ============================================================
-- AIRA Agents: Agent Definition
-- ============================================================

CREATE TABLE IF NOT EXISTS aira_agents.agent_definition (
    agent_definition_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    agent_name VARCHAR(120) NOT NULL UNIQUE,
    correct_technical_name VARCHAR(120) NOT NULL,
    purpose TEXT NOT NULL,
    business_function TEXT NOT NULL,
    technical_function TEXT NOT NULL,
    owner VARCHAR(160) NOT NULL,
    backup_owner VARCHAR(160) NOT NULL,
    classification VARCHAR(160) NOT NULL,
    risk_level VARCHAR(30) NOT NULL CHECK (risk_level IN ('Low', 'Medium', 'High', 'Critical')),
    can_change_code BOOLEAN NOT NULL DEFAULT FALSE,
    can_approve BOOLEAN NOT NULL DEFAULT FALSE,
    can_deploy BOOLEAN NOT NULL DEFAULT FALSE,
    production_change_allowed BOOLEAN NOT NULL DEFAULT FALSE,
    requires_human_approval BOOLEAN NOT NULL DEFAULT TRUE,
    fail_closed BOOLEAN NOT NULL DEFAULT TRUE,
    evidence_output TEXT NOT NULL,
    status VARCHAR(40) NOT NULL CHECK (status IN ('Draft', 'Active', 'Suspended', 'Retired')),
    agent_version VARCHAR(40) NOT NULL DEFAULT '1.0.0',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE aira_agents.agent_definition IS 'Official governed definition of each AIRA agent.';

-- ============================================================
-- AIRA Agents: Prompt Versions
-- ============================================================

CREATE TABLE IF NOT EXISTS aira_agents.agent_prompt_version (
    prompt_version_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    agent_name VARCHAR(120) NOT NULL,
    prompt_id VARCHAR(160) NOT NULL,
    prompt_version VARCHAR(40) NOT NULL,
    prompt_purpose TEXT NOT NULL,
    prompt_location TEXT NOT NULL,
    approved_by VARCHAR(160),
    approval_status VARCHAR(40) NOT NULL CHECK (approval_status IN ('Draft', 'Approved', 'Rejected', 'Retired')),
    effective_from TIMESTAMPTZ,
    effective_to TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(agent_name, prompt_id, prompt_version)
);

COMMENT ON TABLE aira_agents.agent_prompt_version IS 'Versioned prompt registry for AIRA agents.';

-- ============================================================
-- AIRA Agents: Model Versions
-- ============================================================

CREATE TABLE IF NOT EXISTS aira_agents.agent_model_version (
    model_version_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    agent_name VARCHAR(120) NOT NULL,
    model_provider VARCHAR(120) NOT NULL,
    model_name VARCHAR(160) NOT NULL,
    model_version VARCHAR(120) NOT NULL,
    model_policy VARCHAR(300) NOT NULL,
    approved_for_use BOOLEAN NOT NULL DEFAULT FALSE,
    approved_by VARCHAR(160),
    approval_status VARCHAR(40) NOT NULL CHECK (approval_status IN ('Draft', 'Approved', 'Rejected', 'Retired')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(agent_name, model_provider, model_name, model_version)
);

COMMENT ON TABLE aira_agents.agent_model_version IS 'Versioned model registry for AIRA agent execution.';

-- ============================================================
-- AIRA Agents: Tool Permissions
-- ============================================================

CREATE TABLE IF NOT EXISTS aira_agents.agent_tool_permission (
    tool_permission_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    agent_name VARCHAR(120) NOT NULL,
    tool_name VARCHAR(160) NOT NULL,
    tool_purpose TEXT NOT NULL,
    can_read BOOLEAN NOT NULL DEFAULT FALSE,
    can_write BOOLEAN NOT NULL DEFAULT FALSE,
    can_execute BOOLEAN NOT NULL DEFAULT FALSE,
    approval_required BOOLEAN NOT NULL DEFAULT TRUE,
    risk_level VARCHAR(30) NOT NULL CHECK (risk_level IN ('Low', 'Medium', 'High', 'Critical')),
    evidence_required BOOLEAN NOT NULL DEFAULT TRUE,
    restrictions TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(agent_name, tool_name)
);

COMMENT ON TABLE aira_agents.agent_tool_permission IS 'Tool permissions matrix persisted for AIRA agents.';

-- ============================================================
-- AIRA Agents: Execution Audit
-- ============================================================

CREATE TABLE IF NOT EXISTS aira_agents.agent_execution_audit (
    agent_execution_audit_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    execution_key VARCHAR(160) NOT NULL UNIQUE,
    agent_name VARCHAR(120) NOT NULL,
    agent_version VARCHAR(40) NOT NULL,
    prompt_version VARCHAR(40) NOT NULL,
    model_reference VARCHAR(300) NOT NULL,
    triggered_by VARCHAR(160) NOT NULL,
    execution_mode VARCHAR(60) NOT NULL CHECK (execution_mode IN ('Manual', 'Automated Advisory', 'Automated Validation', 'Controlled Execution')),
    input_reference TEXT NOT NULL,
    output_reference TEXT,
    action_summary TEXT NOT NULL,
    risk_level VARCHAR(30) NOT NULL CHECK (risk_level IN ('Low', 'Medium', 'High', 'Critical')),
    approval_required BOOLEAN NOT NULL DEFAULT TRUE,
    approval_reference TEXT,
    evidence_reference TEXT,
    status VARCHAR(40) NOT NULL CHECK (status IN ('Started', 'Completed', 'Failed', 'Blocked')),
    fail_closed BOOLEAN NOT NULL DEFAULT TRUE,
    started_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    completed_at TIMESTAMPTZ
);

COMMENT ON TABLE aira_agents.agent_execution_audit IS 'Audit trail for every governed AIRA agent execution.';

-- ============================================================
-- AIRA Evidence: Evidence Packs
-- ============================================================

CREATE TABLE IF NOT EXISTS aira_evidence.runtime_evidence_pack (
    runtime_evidence_pack_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    evidence_pack_key VARCHAR(160) NOT NULL UNIQUE,
    change_key VARCHAR(120),
    release_key VARCHAR(120),
    title VARCHAR(300) NOT NULL,
    summary TEXT NOT NULL,
    evidence_status VARCHAR(40) NOT NULL CHECK (evidence_status IN ('Draft', 'Complete', 'Incomplete', 'Accepted', 'Rejected')),
    created_by VARCHAR(160) NOT NULL,
    reviewed_by VARCHAR(160),
    accepted_by VARCHAR(160),
    accepted_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE aira_evidence.runtime_evidence_pack IS 'Evidence pack for AIRA runtime changes, releases, validations, and audits.';

-- ============================================================
-- AIRA Evidence: Evidence Artifacts
-- ============================================================

CREATE TABLE IF NOT EXISTS aira_evidence.evidence_artifact (
    evidence_artifact_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    evidence_pack_key VARCHAR(160) NOT NULL,
    artifact_key VARCHAR(160) NOT NULL,
    artifact_type VARCHAR(80) NOT NULL,
    artifact_title VARCHAR(300) NOT NULL,
    artifact_reference TEXT NOT NULL,
    source_system VARCHAR(120) NOT NULL,
    produced_by_agent VARCHAR(120),
    immutable_reference TEXT,
    risk_level VARCHAR(30) NOT NULL CHECK (risk_level IN ('Low', 'Medium', 'High', 'Critical')),
    contains_secret BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(evidence_pack_key, artifact_key)
);

COMMENT ON TABLE aira_evidence.evidence_artifact IS 'Atomic evidence artifact references. Secret-containing evidence is not allowed.';

-- ============================================================
-- AIRA Evidence: Traceability Links
-- ============================================================

CREATE TABLE IF NOT EXISTS aira_evidence.evidence_traceability_link (
    evidence_traceability_link_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    link_key VARCHAR(160) NOT NULL UNIQUE,
    evidence_pack_key VARCHAR(160) NOT NULL,
    source_type VARCHAR(80) NOT NULL,
    source_reference TEXT NOT NULL,
    target_type VARCHAR(80) NOT NULL,
    target_reference TEXT NOT NULL,
    relationship_type VARCHAR(80) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE aira_evidence.evidence_traceability_link IS 'Traceability from requirement to code, test, security, documentation, approval, and release evidence.';

-- ============================================================
-- AIRA Security: Security Findings
-- ============================================================

CREATE TABLE IF NOT EXISTS aira_security.security_finding (
    security_finding_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    finding_key VARCHAR(160) NOT NULL UNIQUE,
    change_key VARCHAR(120),
    finding_title VARCHAR(300) NOT NULL,
    finding_description TEXT NOT NULL,
    severity VARCHAR(30) NOT NULL CHECK (severity IN ('Low', 'Medium', 'High', 'Critical')),
    status VARCHAR(40) NOT NULL CHECK (status IN ('Open', 'Accepted Risk', 'Remediated', 'False Positive', 'Closed')),
    affected_component VARCHAR(200) NOT NULL,
    remediation_required BOOLEAN NOT NULL DEFAULT TRUE,
    risk_acceptance_required BOOLEAN NOT NULL DEFAULT FALSE,
    evidence_reference TEXT,
    created_by VARCHAR(160) NOT NULL,
    reviewed_by VARCHAR(160),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    closed_at TIMESTAMPTZ
);

COMMENT ON TABLE aira_security.security_finding IS 'Security findings generated by security review, scanning, or governance checks.';

-- ============================================================
-- AIRA Security: Secret Control
-- ============================================================

CREATE TABLE IF NOT EXISTS aira_security.secret_control_record (
    secret_control_record_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    control_key VARCHAR(160) NOT NULL UNIQUE,
    control_name VARCHAR(200) NOT NULL,
    control_description TEXT NOT NULL,
    secret_value_stored BOOLEAN NOT NULL DEFAULT FALSE,
    agent_direct_access_allowed BOOLEAN NOT NULL DEFAULT FALSE,
    rotation_required BOOLEAN NOT NULL DEFAULT TRUE,
    evidence_reference TEXT,
    owner VARCHAR(160) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE aira_security.secret_control_record IS 'Secret governance controls. Secret values must never be stored here.';

-- ============================================================
-- AIRA Testing: Test Execution
-- ============================================================

CREATE TABLE IF NOT EXISTS aira_testing.test_execution_record (
    test_execution_record_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    test_run_key VARCHAR(160) NOT NULL UNIQUE,
    change_key VARCHAR(120),
    test_type VARCHAR(80) NOT NULL,
    test_scope VARCHAR(200) NOT NULL,
    execution_status VARCHAR(40) NOT NULL CHECK (execution_status IN ('Passed', 'Failed', 'Skipped', 'Blocked')),
    total_tests INTEGER NOT NULL DEFAULT 0,
    passed_tests INTEGER NOT NULL DEFAULT 0,
    failed_tests INTEGER NOT NULL DEFAULT 0,
    skipped_tests INTEGER NOT NULL DEFAULT 0,
    coverage_reference TEXT,
    report_reference TEXT,
    executed_by VARCHAR(160) NOT NULL,
    executed_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    evidence_reference TEXT
);

COMMENT ON TABLE aira_testing.test_execution_record IS 'Test execution evidence for unit, integration, API, UI, regression, security, and acceptance tests.';

-- ============================================================
-- AIRA Runtime: Release Gates
-- ============================================================

CREATE TABLE IF NOT EXISTS aira_runtime.release_gate_check (
    release_gate_check_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    release_gate_key VARCHAR(160) NOT NULL UNIQUE,
    change_key VARCHAR(120),
    gate_key VARCHAR(120) NOT NULL,
    gate_status VARCHAR(40) NOT NULL CHECK (gate_status IN ('Pending', 'Passed', 'Failed', 'Waived', 'Blocked')),
    gate_result_summary TEXT NOT NULL,
    waiver_required BOOLEAN NOT NULL DEFAULT FALSE,
    waiver_approval_reference TEXT,
    evidence_reference TEXT,
    evaluated_by VARCHAR(160) NOT NULL,
    evaluated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE aira_runtime.release_gate_check IS 'Release readiness and promotion gate checks.';

-- ============================================================
-- AIRA Runtime: Deployment Readiness
-- ============================================================

CREATE TABLE IF NOT EXISTS aira_runtime.deployment_readiness_record (
    deployment_readiness_record_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    readiness_key VARCHAR(160) NOT NULL UNIQUE,
    release_key VARCHAR(120) NOT NULL,
    environment_name VARCHAR(80) NOT NULL,
    readiness_status VARCHAR(40) NOT NULL CHECK (readiness_status IN ('Pending', 'Ready', 'Not Ready', 'Blocked')),
    architecture_gate_passed BOOLEAN NOT NULL DEFAULT FALSE,
    security_gate_passed BOOLEAN NOT NULL DEFAULT FALSE,
    test_gate_passed BOOLEAN NOT NULL DEFAULT FALSE,
    documentation_gate_passed BOOLEAN NOT NULL DEFAULT FALSE,
    evidence_gate_passed BOOLEAN NOT NULL DEFAULT FALSE,
    cicd_gate_passed BOOLEAN NOT NULL DEFAULT FALSE,
    rollback_gate_passed BOOLEAN NOT NULL DEFAULT FALSE,
    human_approval_reference TEXT,
    evidence_reference TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE aira_runtime.deployment_readiness_record IS 'Deployment readiness record with mandatory gates.';

-- ============================================================
-- AIRA Runtime: Rollback Readiness
-- ============================================================

CREATE TABLE IF NOT EXISTS aira_runtime.rollback_readiness_record (
    rollback_readiness_record_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    rollback_key VARCHAR(160) NOT NULL UNIQUE,
    release_key VARCHAR(120) NOT NULL,
    environment_name VARCHAR(80) NOT NULL,
    rollback_strategy TEXT NOT NULL,
    rollback_tested BOOLEAN NOT NULL DEFAULT FALSE,
    rollback_status VARCHAR(40) NOT NULL CHECK (rollback_status IN ('Draft', 'Ready', 'Not Ready', 'Executed', 'Failed')),
    approval_reference TEXT,
    evidence_reference TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE aira_runtime.rollback_readiness_record IS 'Rollback readiness and rollback execution governance.';

-- ============================================================
-- AIRA Observability: Runtime Health Snapshots
-- ============================================================

CREATE TABLE IF NOT EXISTS aira_observability.runtime_health_snapshot (
    runtime_health_snapshot_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    snapshot_key VARCHAR(160) NOT NULL UNIQUE,
    service_name VARCHAR(160) NOT NULL,
    container_name VARCHAR(160),
    host_port INTEGER,
    container_port INTEGER,
    status VARCHAR(40) NOT NULL CHECK (status IN ('UP', 'DOWN', 'DEGRADED', 'UNKNOWN')),
    health_endpoint TEXT,
    observed_by VARCHAR(160) NOT NULL,
    observed_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    evidence_reference TEXT
);

COMMENT ON TABLE aira_observability.runtime_health_snapshot IS 'Runtime health status records for AIRA services.';

-- ============================================================
-- AIRA Knowledge: Knowledge Artifacts
-- ============================================================

CREATE TABLE IF NOT EXISTS aira_knowledge.knowledge_artifact (
    knowledge_artifact_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    knowledge_key VARCHAR(160) NOT NULL UNIQUE,
    title VARCHAR(300) NOT NULL,
    artifact_type VARCHAR(80) NOT NULL,
    source_system VARCHAR(120) NOT NULL,
    artifact_reference TEXT NOT NULL,
    version VARCHAR(40) NOT NULL DEFAULT '1.0.0',
    owner VARCHAR(160) NOT NULL,
    last_reviewed_by VARCHAR(160),
    last_reviewed_at TIMESTAMPTZ,
    evidence_reference TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE aira_knowledge.knowledge_artifact IS 'Obsidian, LLM Wiki, documentation, prompts, context packs, and reusable knowledge records.';

-- ============================================================
-- Runtime Persistence Audit
-- ============================================================

CREATE TABLE IF NOT EXISTS aira_runtime.persistence_audit_record (
    persistence_audit_record_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    audit_key VARCHAR(160) NOT NULL UNIQUE,
    action_type VARCHAR(120) NOT NULL,
    action_summary TEXT NOT NULL,
    actor VARCHAR(160) NOT NULL,
    evidence_reference TEXT,
    status VARCHAR(40) NOT NULL CHECK (status IN ('Started', 'Completed', 'Failed', 'Blocked')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE aira_runtime.persistence_audit_record IS 'Audit record for persistence foundation operations.';