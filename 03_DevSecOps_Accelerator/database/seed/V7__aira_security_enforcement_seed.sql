-- ============================================================
-- AIRA Security Enforcement Seed
-- Seed: V7
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
('LOCAL-DEV-AGENTS-READ', 'aira-local-dev-key-change-me', 'Local Development API Key', 'accelerator-agents', '/api/v1/agents', TRUE, FALSE, FALSE, TRUE, TRUE, 'Active'),
('LOCAL-DEV-GOVERNANCE-READ', 'aira-local-dev-key-change-me', 'Local Development API Key', 'accelerator-governance', '/api/v1/governance', TRUE, FALSE, FALSE, TRUE, TRUE, 'Active')
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