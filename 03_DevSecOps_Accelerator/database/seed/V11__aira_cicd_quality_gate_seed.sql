-- ============================================================
-- AIRA CI/CD Quality Gate Seed
-- Seed: V11
-- PostgreSQL: 17
-- ============================================================

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
VALUES
('SOURCE_STRUCTURE_GATE', 'Source Structure Gate', 'Source', 'Validate expected AIRA repository and module structure.', 'Block when required directories or files are missing.', TRUE, TRUE, 'AIRA DevSecOps Owner', 'Active'),
('MAVEN_BUILD_GATE', 'Maven Build Gate', 'Build', 'Validate all Maven modules build successfully.', 'Block when Maven build fails.', TRUE, TRUE, 'AIRA Development Lead', 'Active'),
('WAR_ARTIFACT_GATE', 'WAR Artifact Gate', 'Package', 'Validate all Tomcat ROOT.war artifacts are produced.', 'Block when any required ROOT.war is missing.', TRUE, TRUE, 'AIRA DevSecOps Owner', 'Active'),
('DOCKER_BUILD_GATE', 'Docker Build Gate', 'Container', 'Validate all service Docker images build successfully.', 'Block when Docker image build fails.', TRUE, TRUE, 'AIRA DevSecOps Owner', 'Active'),
('DOCKER_RUNTIME_GATE', 'Docker Runtime Gate', 'Runtime', 'Validate the Docker runtime stack starts successfully.', 'Block when runtime containers do not start.', TRUE, TRUE, 'AIRA Platform Lead', 'Active'),
('BASE_HEALTH_GATE', 'Base Health Gate', 'Runtime Health', 'Validate all base service health endpoints return UP.', 'Block when any base service health endpoint is not UP.', TRUE, TRUE, 'AIRA Platform Lead', 'Active'),
('PERSISTENCE_HEALTH_GATE', 'Persistence Health Gate', 'Persistence', 'Validate all persistence health endpoints return UP.', 'Block when any persistence endpoint is not UP.', TRUE, TRUE, 'AIRA Platform Lead', 'Active'),
('SECURITY_ENFORCEMENT_GATE', 'Security Enforcement Gate', 'Security', 'Validate protected APIs deny missing/wrong key and allow valid key.', 'Block when protected API behavior is incorrect.', TRUE, TRUE, 'AIRA Security Owner', 'Active'),
('AGENT_REGISTRY_GATE', 'Agent Registry Gate', 'Agents', 'Validate Agent Registry summary and minimum active agents.', 'Block when Agent Registry is not ready.', TRUE, TRUE, 'AIRA Agent Governance Owner', 'Active'),
('GOVERNANCE_READINESS_GATE', 'Governance Readiness Gate', 'Governance', 'Validate governance readiness returns UP and failClosed true.', 'Block when governance readiness is not UP.', TRUE, TRUE, 'AIRA Architecture Owner', 'Active'),
('EVIDENCE_READINESS_GATE', 'Evidence Readiness Gate', 'Evidence', 'Validate evidence readiness returns UP and failClosed true.', 'Block when evidence readiness is not UP.', TRUE, TRUE, 'AIRA Evidence and Compliance Owner', 'Active'),
('EVIDENCE_DETAIL_GATE', 'Evidence Detail Gate', 'Evidence', 'Validate evidence pack detail and artifact endpoints work.', 'Block when evidence detail endpoints fail.', TRUE, TRUE, 'AIRA Evidence and Compliance Owner', 'Active'),
('GITHUB_ACTIONS_GATE', 'GitHub Actions Gate', 'CI/CD', 'Validate GitHub Actions quality gate workflow exists.', 'Block when workflow file is missing.', TRUE, TRUE, 'AIRA DevSecOps Owner', 'Active')
ON CONFLICT (gate_key) DO UPDATE SET
    gate_name = EXCLUDED.gate_name,
    gate_category = EXCLUDED.gate_category,
    gate_purpose = EXCLUDED.gate_purpose,
    blocking_rule = EXCLUDED.blocking_rule,
    required = EXCLUDED.required,
    fail_closed = EXCLUDED.fail_closed,
    owner = EXCLUDED.owner,
    status = EXCLUDED.status;