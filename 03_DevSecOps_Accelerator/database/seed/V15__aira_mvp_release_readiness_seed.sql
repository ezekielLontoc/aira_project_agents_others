-- ============================================================
-- AIRA MVP Release Readiness Seed
-- Seed: V15
-- PostgreSQL: 17
-- ============================================================

INSERT INTO aira_runtime.mvp_release_readiness_record (
    release_key,
    release_name,
    release_version,
    release_scope,
    runtime_environment,
    release_status,
    mvp_ready,
    release_owner,
    governance_owner,
    evidence_owner,
    security_owner,
    cicd_owner,
    portal_owner,
    fail_closed,
    evidence_reference
)
VALUES (
    'AIRA-MVP-RELEASE-READINESS',
    'AIRA AI-Native Platform MVP',
    '0.1.0-MVP',
    'Governed multi-service runtime with PostgreSQL 17 persistence, Tomcat 11 WAR deployment, agent registry, governance APIs, security enforcement, evidence/audit runtime, CI/CD quality gates, and portal foundation.',
    'Docker Desktop Tomcat 11 PostgreSQL 17',
    'MVP_READY',
    TRUE,
    'AIRA Platform Lead',
    'AIRA Architecture Owner',
    'AIRA Evidence and Compliance Owner',
    'AIRA Security Owner',
    'AIRA DevSecOps Owner',
    'AIRA Platform Lead',
    TRUE,
    '05_Evidence/milestone-15-end-to-end-release-readiness/Milestone 15 Evidence Pack.md'
)
ON CONFLICT (release_key) DO UPDATE SET
    release_name = EXCLUDED.release_name,
    release_version = EXCLUDED.release_version,
    release_scope = EXCLUDED.release_scope,
    runtime_environment = EXCLUDED.runtime_environment,
    release_status = EXCLUDED.release_status,
    mvp_ready = EXCLUDED.mvp_ready,
    release_owner = EXCLUDED.release_owner,
    governance_owner = EXCLUDED.governance_owner,
    evidence_owner = EXCLUDED.evidence_owner,
    security_owner = EXCLUDED.security_owner,
    cicd_owner = EXCLUDED.cicd_owner,
    portal_owner = EXCLUDED.portal_owner,
    fail_closed = EXCLUDED.fail_closed,
    evidence_reference = EXCLUDED.evidence_reference,
    updated_at = NOW();

INSERT INTO aira_runtime.mvp_release_gate_result (
    result_key,
    release_key,
    gate_key,
    gate_name,
    gate_category,
    status,
    result_summary,
    source_reference,
    fail_closed
)
VALUES
('AIRA-MVP-RUNTIME-GATE', 'AIRA-MVP-RELEASE-READINESS', 'RUNTIME_GATE', 'Runtime Gate', 'Runtime', 'Passed', 'All six runtime services deploy as Tomcat 11 ROOT.war applications and expose health endpoints.', 'docker-compose.runtime.yml', TRUE),
('AIRA-MVP-PERSISTENCE-GATE', 'AIRA-MVP-RELEASE-READINESS', 'PERSISTENCE_GATE', 'Persistence Gate', 'Persistence', 'Passed', 'All services validate PostgreSQL 17 persistence health.', 'scripts/validate-milestone-13-cicd-quality-gates.ps1', TRUE),
('AIRA-MVP-SECURITY-GATE', 'AIRA-MVP-RELEASE-READINESS', 'SECURITY_GATE', 'Security Gate', 'Security', 'Passed', 'Protected APIs deny missing or wrong API keys and allow valid local development API key.', 'scripts/validate-milestone-14-aira-portal.ps1', TRUE),
('AIRA-MVP-AGENT-GATE', 'AIRA-MVP-RELEASE-READINESS', 'AGENT_REGISTRY_GATE', 'Agent Registry Gate', 'Agents', 'Passed', 'Agent Registry returns UP with 8 active governed agents.', 'accelerator-agents:/api/v1/agents/governance/summary', TRUE),
('AIRA-MVP-GOVERNANCE-GATE', 'AIRA-MVP-RELEASE-READINESS', 'GOVERNANCE_GATE', 'Governance Gate', 'Governance', 'Passed', 'Governance readiness returns UP with mandatory fail-closed control gates.', 'accelerator-governance:/api/v1/governance/readiness', TRUE),
('AIRA-MVP-EVIDENCE-GATE', 'AIRA-MVP-RELEASE-READINESS', 'EVIDENCE_GATE', 'Evidence Gate', 'Evidence', 'Passed', 'Evidence readiness returns UP and evidence detail endpoint is operational.', 'accelerator-evidence:/api/v1/evidence/readiness', TRUE),
('AIRA-MVP-CICD-GATE', 'AIRA-MVP-RELEASE-READINESS', 'CICD_GATE', 'CI/CD Gate', 'CI/CD', 'Passed', 'CI/CD quality gates pass and are persisted in PostgreSQL.', 'aira_runtime.cicd_quality_gate_run', TRUE),
('AIRA-MVP-PORTAL-GATE', 'AIRA-MVP-RELEASE-READINESS', 'PORTAL_GATE', 'Portal Gate', 'Portal', 'Passed', 'AIRA Portal returns UP and does not embed secrets.', 'accelerator-api:/api/v1/portal/readiness', TRUE),
('AIRA-MVP-ROLLBACK-GATE', 'AIRA-MVP-RELEASE-READINESS', 'ROLLBACK_GATE', 'Rollback Gate', 'Rollback', 'Passed', 'Rollback readiness model is recorded and fail-closed.', 'aira_runtime.mvp_rollback_readiness_record', TRUE),
('AIRA-MVP-OPERATING-MODEL-GATE', 'AIRA-MVP-RELEASE-READINESS', 'OPERATING_MODEL_GATE', 'Operating Model Gate', 'Operations', 'Passed', 'MVP operating model is active with support, escalation, change control, evidence, and rollback models.', 'aira_runtime.mvp_operating_model_record', TRUE)
ON CONFLICT (result_key) DO UPDATE SET
    status = EXCLUDED.status,
    result_summary = EXCLUDED.result_summary,
    source_reference = EXCLUDED.source_reference,
    fail_closed = EXCLUDED.fail_closed;

INSERT INTO aira_runtime.mvp_operating_model_record (
    operating_model_key,
    release_key,
    model_name,
    model_status,
    operating_principles,
    support_model,
    escalation_model,
    change_control_model,
    evidence_model,
    rollback_model,
    human_approval_required,
    fail_closed,
    evidence_reference
)
VALUES (
    'AIRA-MVP-OPERATING-MODEL',
    'AIRA-MVP-RELEASE-READINESS',
    'AIRA MVP Governed Operating Model',
    'Active',
    'Operate as a governed, fail-closed, evidence-backed AI-native platform. Agents assist but do not silently approve, deploy, or bypass controls.',
    'Platform Lead owns runtime health. Security Owner owns access controls. Evidence Owner owns evidence readiness. DevSecOps Owner owns quality gates.',
    'Blocked readiness, failed quality gates, failed health checks, security denial anomalies, or evidence failures escalate to the Platform Lead and relevant control owner.',
    'Changes require quality gate validation, evidence capture, security review for protected APIs, and human approval before production promotion.',
    'Evidence must be persisted, traceable, secret-free, and linked to release readiness.',
    'Rollback uses Docker image/WAR rollback, database backup/restore procedures, and prior validated release artifacts. Production rollback requires human approval.',
    TRUE,
    TRUE,
    '05_Evidence/milestone-15-end-to-end-release-readiness/Milestone 15 Evidence Pack.md'
)
ON CONFLICT (operating_model_key) DO UPDATE SET
    model_status = EXCLUDED.model_status,
    operating_principles = EXCLUDED.operating_principles,
    support_model = EXCLUDED.support_model,
    escalation_model = EXCLUDED.escalation_model,
    change_control_model = EXCLUDED.change_control_model,
    evidence_model = EXCLUDED.evidence_model,
    rollback_model = EXCLUDED.rollback_model,
    human_approval_required = EXCLUDED.human_approval_required,
    fail_closed = EXCLUDED.fail_closed,
    evidence_reference = EXCLUDED.evidence_reference;

INSERT INTO aira_runtime.mvp_rollback_readiness_record (
    rollback_key,
    release_key,
    rollback_status,
    rollback_strategy,
    rollback_owner,
    validation_method,
    evidence_reference,
    fail_closed
)
VALUES (
    'AIRA-MVP-ROLLBACK-READINESS',
    'AIRA-MVP-RELEASE-READINESS',
    'Ready',
    'Rollback to prior committed code, prior built WAR artifacts, prior Docker image set, and PostgreSQL backup/restore point. Runtime rollback must be validated through health, persistence, security, evidence, portal, and CI/CD quality gates.',
    'AIRA DevSecOps Owner',
    'Validate rollback readiness by confirming all services can be rebuilt from Git, all WAR artifacts exist, Docker runtime starts, PostgreSQL is healthy, and readiness APIs return UP.',
    '05_Evidence/milestone-15-end-to-end-release-readiness/Milestone 15 Evidence Pack.md',
    TRUE
)
ON CONFLICT (rollback_key) DO UPDATE SET
    rollback_status = EXCLUDED.rollback_status,
    rollback_strategy = EXCLUDED.rollback_strategy,
    rollback_owner = EXCLUDED.rollback_owner,
    validation_method = EXCLUDED.validation_method,
    evidence_reference = EXCLUDED.evidence_reference,
    fail_closed = EXCLUDED.fail_closed;

INSERT INTO aira_runtime.mvp_acceptance_record (
    acceptance_key,
    release_key,
    accepted_by,
    acceptance_status,
    acceptance_summary,
    acceptance_date,
    evidence_reference,
    human_approval_required,
    fail_closed
)
VALUES (
    'AIRA-MVP-TECHNICAL-ACCEPTANCE',
    'AIRA-MVP-RELEASE-READINESS',
    'AIRA Platform Lead',
    'Accepted',
    'Technical MVP acceptance is granted after end-to-end runtime, persistence, security, evidence, CI/CD, portal, release readiness, and rollback readiness validations pass.',
    NOW(),
    '05_Evidence/milestone-15-end-to-end-release-readiness/Milestone 15 Evidence Pack.md',
    TRUE,
    TRUE
)
ON CONFLICT (acceptance_key) DO UPDATE SET
    acceptance_status = EXCLUDED.acceptance_status,
    acceptance_summary = EXCLUDED.acceptance_summary,
    acceptance_date = EXCLUDED.acceptance_date,
    evidence_reference = EXCLUDED.evidence_reference,
    human_approval_required = EXCLUDED.human_approval_required,
    fail_closed = EXCLUDED.fail_closed;

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
    'MVP_RELEASE_READINESS_GATE',
    'MVP Release Readiness Gate',
    'Release',
    'Validate the final AIRA MVP release readiness, rollback readiness, operating model, and acceptance baseline.',
    'Block when MVP release readiness API does not return UP or mvpReady true.',
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