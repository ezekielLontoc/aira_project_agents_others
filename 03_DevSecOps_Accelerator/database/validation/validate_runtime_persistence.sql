-- ============================================================
-- AIRA Runtime Persistence Validation
-- PostgreSQL 17
-- Fail-closed validation script
-- ============================================================

\echo 'AIRA Runtime Persistence Validation Started'

SELECT 'schemas' AS check_name, COUNT(*) AS found_count
FROM information_schema.schemata
WHERE schema_name IN (
    'aira_security',
    'aira_governance',
    'aira_evidence',
    'aira_agents',
    'aira_runtime',
    'aira_observability',
    'aira_testing',
    'aira_knowledge'
);

SELECT 'agent_definitions' AS check_name, COUNT(*) AS found_count
FROM aira_agents.agent_definition
WHERE status = 'Active';

SELECT 'mandatory_control_gates' AS check_name, COUNT(*) AS found_count
FROM aira_governance.control_gate
WHERE is_mandatory = TRUE
AND fail_closed = TRUE;

SELECT 'agent_prompt_versions' AS check_name, COUNT(*) AS found_count
FROM aira_agents.agent_prompt_version
WHERE approval_status = 'Approved';

SELECT 'agent_model_versions' AS check_name, COUNT(*) AS found_count
FROM aira_agents.agent_model_version
WHERE approval_status = 'Approved'
AND approved_for_use = TRUE;

SELECT 'secret_controls' AS check_name, COUNT(*) AS found_count
FROM aira_security.secret_control_record
WHERE secret_value_stored = FALSE
AND agent_direct_access_allowed = FALSE;

SELECT 'evidence_packs' AS check_name, COUNT(*) AS found_count
FROM aira_evidence.runtime_evidence_pack
WHERE evidence_pack_key = 'MILESTONE-8-RUNTIME-PERSISTENCE';

SELECT 'evidence_artifacts' AS check_name, COUNT(*) AS found_count
FROM aira_evidence.evidence_artifact
WHERE evidence_pack_key = 'MILESTONE-8-RUNTIME-PERSISTENCE'
AND contains_secret = FALSE;

SELECT 'persistence_audit_records' AS check_name, COUNT(*) AS found_count
FROM aira_runtime.persistence_audit_record
WHERE audit_key = 'MILESTONE-8-PERSISTENCE-FOUNDATION-CREATED';

-- Fail-closed validation summary
WITH validation_results AS (
    SELECT 'schemas' AS check_name, COUNT(*) AS found_count, 8 AS expected_minimum
    FROM information_schema.schemata
    WHERE schema_name IN ('aira_security','aira_governance','aira_evidence','aira_agents','aira_runtime','aira_observability','aira_testing','aira_knowledge')

    UNION ALL

    SELECT 'agent_definitions', COUNT(*), 8
    FROM aira_agents.agent_definition
    WHERE status = 'Active'

    UNION ALL

    SELECT 'mandatory_control_gates', COUNT(*), 10
    FROM aira_governance.control_gate
    WHERE is_mandatory = TRUE
    AND fail_closed = TRUE

    UNION ALL

    SELECT 'agent_prompt_versions', COUNT(*), 8
    FROM aira_agents.agent_prompt_version
    WHERE approval_status = 'Approved'

    UNION ALL

    SELECT 'agent_model_versions', COUNT(*), 8
    FROM aira_agents.agent_model_version
    WHERE approval_status = 'Approved'
    AND approved_for_use = TRUE

    UNION ALL

    SELECT 'secret_controls', COUNT(*), 2
    FROM aira_security.secret_control_record
    WHERE secret_value_stored = FALSE
    AND agent_direct_access_allowed = FALSE

    UNION ALL

    SELECT 'evidence_pack', COUNT(*), 1
    FROM aira_evidence.runtime_evidence_pack
    WHERE evidence_pack_key = 'MILESTONE-8-RUNTIME-PERSISTENCE'

    UNION ALL

    SELECT 'evidence_artifacts', COUNT(*), 4
    FROM aira_evidence.evidence_artifact
    WHERE evidence_pack_key = 'MILESTONE-8-RUNTIME-PERSISTENCE'
    AND contains_secret = FALSE
)
SELECT
    check_name,
    found_count,
    expected_minimum,
    CASE
        WHEN found_count >= expected_minimum THEN 'PASS'
        ELSE 'FAIL'
    END AS validation_status
FROM validation_results
ORDER BY check_name;

\echo 'AIRA Runtime Persistence Validation Completed'