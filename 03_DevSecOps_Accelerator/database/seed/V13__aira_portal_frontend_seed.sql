-- ============================================================
-- AIRA Portal Frontend Foundation Seed
-- Seed: V13
-- PostgreSQL: 17
-- ============================================================

INSERT INTO aira_runtime.portal_readiness_record (
    readiness_key,
    portal_name,
    portal_url,
    served_by_service,
    frontend_mode,
    api_key_required_for_backend,
    embeds_secret,
    status,
    fail_closed,
    evidence_reference
)
VALUES (
    'AIRA-PORTAL-FOUNDATION',
    'AIRA Portal',
    'http://localhost:9090/portal/index.html',
    'accelerator-api',
    'Static HTML CSS JavaScript served by Spring Boot/Tomcat',
    TRUE,
    FALSE,
    'Active',
    TRUE,
    '05_Evidence/milestone-14-aira-portal-frontend-foundation/Milestone 14 Evidence Pack.md'
)
ON CONFLICT (readiness_key) DO UPDATE SET
    portal_name = EXCLUDED.portal_name,
    portal_url = EXCLUDED.portal_url,
    served_by_service = EXCLUDED.served_by_service,
    frontend_mode = EXCLUDED.frontend_mode,
    api_key_required_for_backend = EXCLUDED.api_key_required_for_backend,
    embeds_secret = EXCLUDED.embeds_secret,
    status = EXCLUDED.status,
    fail_closed = EXCLUDED.fail_closed,
    evidence_reference = EXCLUDED.evidence_reference,
    updated_at = NOW();

INSERT INTO aira_runtime.cicd_quality_gate_definition (
    gate_key,
    gate_name,
    gate_category,
    gate_purpose,
    blocking_rule,
    required,
    fail_closed,
    owner,
    status
)
VALUES (
    'PORTAL_FOUNDATION_GATE',
    'Portal Foundation Gate',
    'Portal',
    'Validate the AIRA Portal frontend, portal readiness API, CORS access, and protected backend API connectivity.',
    'Block when portal page, portal readiness, CORS, or protected API checks fail.',
    TRUE,
    TRUE,
    'AIRA Platform Lead',
    'Active'
)
ON CONFLICT (gate_key) DO UPDATE SET
    gate_name = EXCLUDED.gate_name,
    gate_category = EXCLUDED.gate_category,
    gate_purpose = EXCLUDED.gate_purpose,
    blocking_rule = EXCLUDED.blocking_rule,
    required = EXCLUDED.required,
    fail_closed = EXCLUDED.fail_closed,
    owner = EXCLUDED.owner,
    status = EXCLUDED.status;