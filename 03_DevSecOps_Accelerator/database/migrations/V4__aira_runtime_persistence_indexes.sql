-- ============================================================
-- AIRA Runtime Persistence Indexes
-- Migration: V4
-- PostgreSQL: 17
-- ============================================================

CREATE INDEX IF NOT EXISTS idx_change_request_status ON aira_governance.change_request(status);
CREATE INDEX IF NOT EXISTS idx_change_request_risk ON aira_governance.change_request(risk_level);

CREATE INDEX IF NOT EXISTS idx_governance_decision_status ON aira_governance.governance_decision(decision_status);
CREATE INDEX IF NOT EXISTS idx_governance_decision_change_key ON aira_governance.governance_decision(change_key);

CREATE INDEX IF NOT EXISTS idx_approval_record_status ON aira_governance.approval_record(approval_status);
CREATE INDEX IF NOT EXISTS idx_approval_record_change_key ON aira_governance.approval_record(change_key);

CREATE INDEX IF NOT EXISTS idx_agent_definition_status ON aira_agents.agent_definition(status);
CREATE INDEX IF NOT EXISTS idx_agent_definition_risk ON aira_agents.agent_definition(risk_level);

CREATE INDEX IF NOT EXISTS idx_agent_execution_agent ON aira_agents.agent_execution_audit(agent_name);
CREATE INDEX IF NOT EXISTS idx_agent_execution_status ON aira_agents.agent_execution_audit(status);
CREATE INDEX IF NOT EXISTS idx_agent_execution_risk ON aira_agents.agent_execution_audit(risk_level);

CREATE INDEX IF NOT EXISTS idx_evidence_pack_status ON aira_evidence.runtime_evidence_pack(evidence_status);
CREATE INDEX IF NOT EXISTS idx_evidence_artifact_pack ON aira_evidence.evidence_artifact(evidence_pack_key);
CREATE INDEX IF NOT EXISTS idx_evidence_artifact_type ON aira_evidence.evidence_artifact(artifact_type);

CREATE INDEX IF NOT EXISTS idx_security_finding_severity ON aira_security.security_finding(severity);
CREATE INDEX IF NOT EXISTS idx_security_finding_status ON aira_security.security_finding(status);

CREATE INDEX IF NOT EXISTS idx_test_execution_status ON aira_testing.test_execution_record(execution_status);
CREATE INDEX IF NOT EXISTS idx_test_execution_change_key ON aira_testing.test_execution_record(change_key);

CREATE INDEX IF NOT EXISTS idx_release_gate_status ON aira_runtime.release_gate_check(gate_status);
CREATE INDEX IF NOT EXISTS idx_release_gate_change_key ON aira_runtime.release_gate_check(change_key);

CREATE INDEX IF NOT EXISTS idx_deployment_readiness_status ON aira_runtime.deployment_readiness_record(readiness_status);
CREATE INDEX IF NOT EXISTS idx_rollback_readiness_status ON aira_runtime.rollback_readiness_record(rollback_status);

CREATE INDEX IF NOT EXISTS idx_runtime_health_service ON aira_observability.runtime_health_snapshot(service_name);
CREATE INDEX IF NOT EXISTS idx_runtime_health_status ON aira_observability.runtime_health_snapshot(status);

CREATE INDEX IF NOT EXISTS idx_knowledge_artifact_type ON aira_knowledge.knowledge_artifact(artifact_type);
CREATE INDEX IF NOT EXISTS idx_knowledge_source_system ON aira_knowledge.knowledge_artifact(source_system);

-- ============================================================
-- Safety Checks
-- ============================================================

ALTER TABLE aira_agents.agent_definition
    DROP CONSTRAINT IF EXISTS chk_agent_no_approval_without_human;

ALTER TABLE aira_agents.agent_definition
    ADD CONSTRAINT chk_agent_no_approval_without_human
    CHECK (
        can_approve = FALSE
    );

ALTER TABLE aira_agents.agent_definition
    DROP CONSTRAINT IF EXISTS chk_agent_no_production_change;

ALTER TABLE aira_agents.agent_definition
    ADD CONSTRAINT chk_agent_no_production_change
    CHECK (
        production_change_allowed = FALSE
    );

ALTER TABLE aira_evidence.evidence_artifact
    DROP CONSTRAINT IF EXISTS chk_evidence_no_secret;

ALTER TABLE aira_evidence.evidence_artifact
    ADD CONSTRAINT chk_evidence_no_secret
    CHECK (
        contains_secret = FALSE
    );

ALTER TABLE aira_security.secret_control_record
    DROP CONSTRAINT IF EXISTS chk_secret_value_never_stored;

ALTER TABLE aira_security.secret_control_record
    ADD CONSTRAINT chk_secret_value_never_stored
    CHECK (
        secret_value_stored = FALSE
        AND agent_direct_access_allowed = FALSE
    );