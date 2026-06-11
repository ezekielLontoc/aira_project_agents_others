-- ============================================================
-- AIRA Evidence and Audit Runtime Seed
-- Seed: V9
-- PostgreSQL: 17
-- ============================================================

INSERT INTO aira_security.api_key_access_policy (
    policy_key,
    api_key_id,
    api_key_label,
    allowed_service,
    allowed_path_prefix,
    can_read,
    can_write,
    can_execute,
    requires_human_approval,
    fail_closed,
    status
)
VALUES
('LOCAL-DEV-EVIDENCE-READ', 'aira-local-dev-key-change-me', 'Local Development API Key', 'accelerator-evidence', '/api/v1/evidence', TRUE, FALSE, FALSE, TRUE, TRUE, 'Active')
ON CONFLICT (policy_key) DO UPDATE SET
    api_key_id = EXCLUDED.api_key_id,
    api_key_label = EXCLUDED.api_key_label,
    allowed_service = EXCLUDED.allowed_service,
    allowed_path_prefix = EXCLUDED.allowed_path_prefix,
    can_read = EXCLUDED.can_read,
    can_write = EXCLUDED.can_write,
    can_execute = EXCLUDED.can_execute,
    requires_human_approval = EXCLUDED.requires_human_approval,
    fail_closed = EXCLUDED.fail_closed,
    status = EXCLUDED.status;

INSERT INTO aira_evidence.evidence_traceability_link (
    link_key,
    evidence_pack_key,
    source_type,
    source_reference,
    target_type,
    target_reference,
    relationship_type
)
VALUES
('M8-TRACE-MIGRATION-V3-TO-PACK', 'MILESTONE-8-RUNTIME-PERSISTENCE', 'Database Migration', 'V3__aira_runtime_persistence_foundation.sql', 'Evidence Pack', 'MILESTONE-8-RUNTIME-PERSISTENCE', 'supports'),
('M8-TRACE-MIGRATION-V4-TO-PACK', 'MILESTONE-8-RUNTIME-PERSISTENCE', 'Database Migration', 'V4__aira_runtime_persistence_indexes.sql', 'Evidence Pack', 'MILESTONE-8-RUNTIME-PERSISTENCE', 'supports'),
('M8-TRACE-SEED-V5-TO-PACK', 'MILESTONE-8-RUNTIME-PERSISTENCE', 'Database Seed', 'V5__aira_runtime_persistence_seed.sql', 'Evidence Pack', 'MILESTONE-8-RUNTIME-PERSISTENCE', 'supports'),
('M12-TRACE-EVIDENCE-API-TO-PACK', 'MILESTONE-8-RUNTIME-PERSISTENCE', 'Runtime API', 'accelerator-evidence:/api/v1/evidence', 'Evidence Pack', 'MILESTONE-8-RUNTIME-PERSISTENCE', 'exposes')
ON CONFLICT (link_key) DO UPDATE SET
    evidence_pack_key = EXCLUDED.evidence_pack_key,
    source_type = EXCLUDED.source_type,
    source_reference = EXCLUDED.source_reference,
    target_type = EXCLUDED.target_type,
    target_reference = EXCLUDED.target_reference,
    relationship_type = EXCLUDED.relationship_type;

INSERT INTO aira_evidence.evidence_runtime_audit_record (
    audit_key,
    evidence_pack_key,
    action_type,
    action_summary,
    actor,
    decision,
    fail_closed,
    evidence_reference
)
VALUES
('MILESTONE-12-EVIDENCE-AUDIT-API-CREATED', 'MILESTONE-8-RUNTIME-PERSISTENCE', 'Evidence API Foundation', 'Created protected Evidence and Audit Runtime Foundation APIs.', 'evidence-agent', 'RECORDED', TRUE, '05_Evidence/milestone-12-evidence-audit-runtime-foundation/Milestone 12 Evidence Pack.md'),
('MILESTONE-12-EVIDENCE-READINESS-VALIDATED', 'MILESTONE-8-RUNTIME-PERSISTENCE', 'Evidence Readiness Validation', 'Evidence readiness baseline requires packs, artifacts, traceability, runtime audit, and fail-closed behavior.', 'evidence-agent', 'VALIDATED', TRUE, '03_DevSecOps_Accelerator/scripts/validate-milestone-12-evidence-audit-runtime.ps1')
ON CONFLICT (audit_key) DO UPDATE SET
    evidence_pack_key = EXCLUDED.evidence_pack_key,
    action_type = EXCLUDED.action_type,
    action_summary = EXCLUDED.action_summary,
    actor = EXCLUDED.actor,
    decision = EXCLUDED.decision,
    fail_closed = EXCLUDED.fail_closed,
    evidence_reference = EXCLUDED.evidence_reference;