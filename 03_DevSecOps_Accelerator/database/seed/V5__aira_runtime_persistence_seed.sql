-- ============================================================
-- AIRA Runtime Persistence Seed Data
-- Seed: V5
-- PostgreSQL: 17
-- ============================================================

INSERT INTO aira_governance.control_gate (
    gate_key,
    gate_name,
    gate_category,
    purpose,
    blocking_rule,
    required_for,
    owner,
    is_mandatory,
    fail_closed
)
VALUES
('ARCHITECTURE_GATE', 'Architecture Gate', 'Architecture', 'Validates architecture, design, API, database, integration, and ADR alignment.', 'Blocks if architecture review or required ADR is missing.', 'New design, API change, database change, integration change, major implementation change.', 'AIRA Architecture Owner', TRUE, TRUE),
('DEVELOPMENT_GATE', 'Development Gate', 'Development', 'Validates branch-based implementation and code review readiness.', 'Blocks if change is unreviewed or has no code diff evidence.', 'Source code, configuration, API contract, or database migration changes.', 'AIRA Development Lead', TRUE, TRUE),
('SECURITY_GATE', 'Security Gate', 'Security', 'Validates security, access control, secrets, vulnerabilities, RBAC, ABAC, OPA, and fail-closed behavior.', 'Blocks unresolved high or critical findings.', 'Security-sensitive and production-impacting changes.', 'AIRA Security Owner', TRUE, TRUE),
('TEST_GATE', 'Test Gate', 'Testing', 'Validates required tests and quality evidence.', 'Blocks failed required tests or missing test evidence.', 'All implementation changes.', 'AIRA QA/Test Lead', TRUE, TRUE),
('DOCUMENTATION_GATE', 'Documentation Gate', 'Documentation', 'Validates required documentation and release notes.', 'Blocks if required documentation is missing or stale.', 'Architecture, API, release, operations, and user-facing changes.', 'AIRA Documentation Owner', TRUE, TRUE),
('EVIDENCE_GATE', 'Evidence Gate', 'Evidence', 'Validates evidence pack completeness.', 'Blocks when required evidence is missing.', 'PRs, releases, deployments, audits.', 'AIRA Evidence and Compliance Owner', TRUE, TRUE),
('CICD_GATE', 'CI/CD Gate', 'CI/CD', 'Validates build, tests, scans, package, and pipeline readiness.', 'Blocks failed build, tests, scans, or missing pipeline logs.', 'Builds, releases, deployments, promotions.', 'AIRA DevSecOps Owner', TRUE, TRUE),
('APPROVAL_GATE', 'Human Approval Gate', 'Approval', 'Validates explicit human approval for high-risk and production-impacting actions.', 'Blocks if approval is missing.', 'High-risk, critical, production, promotion, rollback, release actions.', 'Human Approver', TRUE, TRUE),
('ROLLBACK_GATE', 'Rollback Gate', 'Rollback', 'Validates rollback readiness and rollback evidence.', 'Blocks if rollback plan or evidence is missing.', 'Release and deployment actions.', 'AIRA DevSecOps Owner', TRUE, TRUE),
('KNOWLEDGE_GATE', 'Knowledge Gate', 'Knowledge', 'Validates Obsidian, LLM Wiki, documentation, and context updates.', 'Blocks major changes when knowledge update is missing.', 'Major change, release, incident, architecture decision.', 'AIRA Knowledge Owner', TRUE, TRUE)
ON CONFLICT (gate_key) DO UPDATE SET
    gate_name = EXCLUDED.gate_name,
    gate_category = EXCLUDED.gate_category,
    purpose = EXCLUDED.purpose,
    blocking_rule = EXCLUDED.blocking_rule,
    required_for = EXCLUDED.required_for,
    owner = EXCLUDED.owner,
    is_mandatory = EXCLUDED.is_mandatory,
    fail_closed = EXCLUDED.fail_closed;

INSERT INTO aira_agents.agent_definition (
    agent_name,
    correct_technical_name,
    purpose,
    business_function,
    technical_function,
    owner,
    backup_owner,
    classification,
    risk_level,
    can_change_code,
    can_approve,
    can_deploy,
    production_change_allowed,
    requires_human_approval,
    fail_closed,
    evidence_output,
    status,
    agent_version
)
VALUES
('architecture-agent', 'architecture-agent', 'Reviews enterprise architecture, solution design, MicroFunction design, API design, database design, workflow design, integration design, and alignment with AIRA standards.', 'Architecture governance and design assurance.', 'Architecture, ADR, API, database, workflow, and integration review.', 'AIRA Architecture Owner', 'AIRA Platform Lead', 'Review agent; Control/governance agent', 'Medium', FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, 'ADR, design review, architecture risk review, standard alignment record', 'Active', '1.0.0'),
('developer-agent', 'developer-agent', 'Generates, modifies, or reviews code, configuration, API contracts, MicroFunctions, database migration drafts, implementation notes, and test scaffolds.', 'Software delivery acceleration.', 'Code generation, refactoring, configuration, API contract, and migration drafting.', 'AIRA Development Lead', 'AIRA Platform Lead', 'Code-generation agent; Runtime/execution agent with strict controls', 'High', TRUE, FALSE, FALSE, FALSE, TRUE, TRUE, 'PR draft, code diff, build log, implementation notes, test evidence', 'Active', '1.0.0'),
('security-agent', 'security-agent', 'Reviews security requirements, access control, secrets handling, vulnerabilities, secure coding, threat models, RBAC, ABAC, OPA policies, and fail-closed behavior.', 'Security assurance and risk reduction.', 'Threat modeling, secure code review, policy review, and vulnerability triage.', 'AIRA Security Owner', 'AIRA Risk and Compliance Lead', 'Review agent; Control/governance agent', 'High', FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, 'Security finding, threat model, policy review, vulnerability triage, approval requirement', 'Active', '1.0.0'),
('test-agent', 'test-agent', 'Creates and validates unit tests, integration tests, API tests, UI tests, regression tests, security tests, and acceptance tests.', 'Quality assurance and release confidence.', 'Test generation, execution, coverage review, and acceptance validation.', 'AIRA QA/Test Lead', 'AIRA Development Lead', 'Review agent; Runtime/execution agent', 'Medium', TRUE, FALSE, FALSE, FALSE, TRUE, TRUE, 'Test report, coverage report, regression evidence, acceptance traceability', 'Active', '1.0.0'),
('documentation-agent', 'documentation-agent', 'Updates technical documentation, user guides, architecture documents, API documentation, release notes, decision records, and Obsidian documentation.', 'Knowledge sharing and documentation governance.', 'Markdown, ADR, API documentation, runbook, and release note generation.', 'AIRA Documentation Owner', 'AIRA Knowledge Owner', 'Knowledge-management agent', 'Medium', FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, 'Documentation update record, release notes, linked evidence references', 'Active', '1.0.0'),
('evidence-agent', 'evidence-agent', 'Collects and organizes evidence from commits, pull requests, test results, security scans, CI/CD results, logs, screenshots, approvals, and deployment records.', 'Audit readiness and compliance traceability.', 'Evidence pack creation, artifact linking, audit trail creation, and completeness checking.', 'AIRA Evidence and Compliance Owner', 'AIRA Security Owner', 'Evidence agent; Control/governance agent', 'Medium', FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, 'Evidence pack, audit trail, traceability matrix, missing evidence check', 'Active', '1.0.0'),
('cicd-agent', 'cicd-agent', 'Supports pipeline validation, build execution, test execution, security scanning, deployment checks, release gates, rollback checks, and promotion readiness.', 'DevSecOps automation and release readiness.', 'Pipeline validation, build/test/scan execution, release gate evaluation, rollback readiness.', 'AIRA DevSecOps Owner', 'AIRA Platform Lead', 'Runtime/execution agent; Control/governance agent', 'Critical', TRUE, FALSE, FALSE, FALSE, TRUE, TRUE, 'Pipeline logs, scan results, build logs, release gate report, rollback checklist', 'Active', '1.0.0'),
('knowledge-fabric-agent', 'knowledge-fabric-agent', 'Manages Obsidian, LLM Wiki, AIRA documentation, reusable knowledge, lessons learned, design decisions, prompts, agent memory/context, and cross-document references.', 'Enterprise knowledge management and context continuity.', 'Knowledge indexing, linking, context pack creation, prompt catalog support.', 'AIRA Knowledge Owner', 'AIRA Documentation Owner', 'Knowledge-management agent', 'Medium', FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, 'Knowledge update log, link map, context pack summary, source traceability', 'Active', '1.0.0')
ON CONFLICT (agent_name) DO UPDATE SET
    correct_technical_name = EXCLUDED.correct_technical_name,
    purpose = EXCLUDED.purpose,
    business_function = EXCLUDED.business_function,
    technical_function = EXCLUDED.technical_function,
    owner = EXCLUDED.owner,
    backup_owner = EXCLUDED.backup_owner,
    classification = EXCLUDED.classification,
    risk_level = EXCLUDED.risk_level,
    can_change_code = EXCLUDED.can_change_code,
    can_approve = EXCLUDED.can_approve,
    can_deploy = EXCLUDED.can_deploy,
    production_change_allowed = EXCLUDED.production_change_allowed,
    requires_human_approval = EXCLUDED.requires_human_approval,
    fail_closed = EXCLUDED.fail_closed,
    evidence_output = EXCLUDED.evidence_output,
    status = EXCLUDED.status,
    agent_version = EXCLUDED.agent_version,
    updated_at = NOW();

INSERT INTO aira_agents.agent_prompt_version (
    agent_name,
    prompt_id,
    prompt_version,
    prompt_purpose,
    prompt_location,
    approval_status,
    effective_from
)
SELECT
    agent_name,
    agent_name || '-prompt',
    '1.0.0',
    'Baseline governed prompt for ' || agent_name,
    '02_Agents/_Agent_Governance/definition-sheets/' || agent_name || '.md',
    'Approved',
    NOW()
FROM aira_agents.agent_definition
ON CONFLICT (agent_name, prompt_id, prompt_version) DO NOTHING;

INSERT INTO aira_agents.agent_model_version (
    agent_name,
    model_provider,
    model_name,
    model_version,
    model_policy,
    approved_for_use,
    approval_status
)
SELECT
    agent_name,
    'AIRA Model Registry',
    'AIRA-approved model for ' || agent_name,
    '1.0.0',
    'Use only models approved by AIRA governance and recorded in the model registry.',
    TRUE,
    'Approved'
FROM aira_agents.agent_definition
ON CONFLICT (agent_name, model_provider, model_name, model_version) DO NOTHING;

INSERT INTO aira_security.secret_control_record (
    control_key,
    control_name,
    control_description,
    secret_value_stored,
    agent_direct_access_allowed,
    rotation_required,
    owner
)
VALUES
('NO_AGENT_SECRET_ACCESS', 'No Agent Secret Access', 'No AIRA agent may directly read, print, store, or expose secret values.', FALSE, FALSE, TRUE, 'AIRA Security Owner'),
('SECRET_REDACTION_REQUIRED', 'Secret Redaction Required', 'Logs, evidence, and documentation must redact secrets and credentials.', FALSE, FALSE, TRUE, 'AIRA Security Owner')
ON CONFLICT (control_key) DO UPDATE SET
    control_name = EXCLUDED.control_name,
    control_description = EXCLUDED.control_description,
    secret_value_stored = EXCLUDED.secret_value_stored,
    agent_direct_access_allowed = EXCLUDED.agent_direct_access_allowed,
    rotation_required = EXCLUDED.rotation_required,
    owner = EXCLUDED.owner;

INSERT INTO aira_evidence.runtime_evidence_pack (
    evidence_pack_key,
    title,
    summary,
    evidence_status,
    created_by
)
VALUES
('MILESTONE-8-RUNTIME-PERSISTENCE', 'Milestone 8 Runtime Persistence Evidence Pack', 'Evidence pack for the PostgreSQL 17 runtime persistence foundation.', 'Complete', 'evidence-agent')
ON CONFLICT (evidence_pack_key) DO UPDATE SET
    title = EXCLUDED.title,
    summary = EXCLUDED.summary,
    evidence_status = EXCLUDED.evidence_status;

INSERT INTO aira_evidence.evidence_artifact (
    evidence_pack_key,
    artifact_key,
    artifact_type,
    artifact_title,
    artifact_reference,
    source_system,
    produced_by_agent,
    immutable_reference,
    risk_level,
    contains_secret
)
VALUES
('MILESTONE-8-RUNTIME-PERSISTENCE', 'M8-MIGRATION-V3', 'Database Migration', 'Runtime Persistence Foundation Migration', '03_DevSecOps_Accelerator/database/migrations/V3__aira_runtime_persistence_foundation.sql', 'Git Repository', 'developer-agent', 'Git tracked file', 'High', FALSE),
('MILESTONE-8-RUNTIME-PERSISTENCE', 'M8-MIGRATION-V4', 'Database Migration', 'Runtime Persistence Indexes Migration', '03_DevSecOps_Accelerator/database/migrations/V4__aira_runtime_persistence_indexes.sql', 'Git Repository', 'developer-agent', 'Git tracked file', 'High', FALSE),
('MILESTONE-8-RUNTIME-PERSISTENCE', 'M8-SEED-V5', 'Database Seed', 'Runtime Persistence Seed Data', '03_DevSecOps_Accelerator/database/seed/V5__aira_runtime_persistence_seed.sql', 'Git Repository', 'developer-agent', 'Git tracked file', 'Medium', FALSE),
('MILESTONE-8-RUNTIME-PERSISTENCE', 'M8-VALIDATION', 'Validation Script', 'Runtime Persistence Validation SQL', '03_DevSecOps_Accelerator/database/validation/validate_runtime_persistence.sql', 'Git Repository', 'test-agent', 'Git tracked file', 'Medium', FALSE)
ON CONFLICT (evidence_pack_key, artifact_key) DO UPDATE SET
    artifact_type = EXCLUDED.artifact_type,
    artifact_title = EXCLUDED.artifact_title,
    artifact_reference = EXCLUDED.artifact_reference,
    source_system = EXCLUDED.source_system,
    produced_by_agent = EXCLUDED.produced_by_agent,
    immutable_reference = EXCLUDED.immutable_reference,
    risk_level = EXCLUDED.risk_level,
    contains_secret = EXCLUDED.contains_secret;

INSERT INTO aira_runtime.persistence_audit_record (
    audit_key,
    action_type,
    action_summary,
    actor,
    evidence_reference,
    status
)
VALUES
('MILESTONE-8-PERSISTENCE-FOUNDATION-CREATED', 'Persistence Foundation', 'Created AIRA runtime persistence foundation schemas, tables, indexes, seed data, validation checks, and evidence records.', 'developer-agent', 'MILESTONE-8-RUNTIME-PERSISTENCE', 'Completed')
ON CONFLICT (audit_key) DO UPDATE SET
    action_summary = EXCLUDED.action_summary,
    actor = EXCLUDED.actor,
    evidence_reference = EXCLUDED.evidence_reference,
    status = EXCLUDED.status;