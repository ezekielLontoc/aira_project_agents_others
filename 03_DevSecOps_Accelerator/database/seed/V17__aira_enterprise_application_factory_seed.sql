INSERT INTO aira_factory.application_factory_capability
(capability_key, capability_name, capability_category, description, status, fail_closed, requires_human_approval, evidence_required)
VALUES
('APPLICATION_FACTORY_AGENT_ORCHESTRATOR','Application Factory Agent Orchestrator','Orchestration','Coordinates all AIRA agents for governed enterprise application builds.','Active',TRUE,TRUE,TRUE),
('BLUEPRINT_TO_CODE_GENERATOR','Blueprint-to-Code Generator','Generation','Transforms approved blueprints into governed code artifacts.','Active',TRUE,TRUE,TRUE),
('PROJECT_TEMPLATE_REGISTRY','Project Template Registry','Template','Stores approved enterprise app templates and stack profiles.','Active',TRUE,TRUE,TRUE),
('DATABASE_MIGRATION_GENERATOR','Database Migration Generator','Data','Generates PostgreSQL migrations and seed files from approved data models.','Active',TRUE,TRUE,TRUE),
('API_CONTRACT_GENERATOR','API Contract Generator','API','Generates REST API contracts and service/controller scaffolds.','Active',TRUE,TRUE,TRUE),
('FRONTEND_SCREEN_GENERATOR','Frontend Screen Generator','Frontend','Generates governed portal screens and runtime views.','Active',TRUE,TRUE,TRUE),
('TEST_GENERATOR','Test Generator','Testing','Generates validation, integration, contract, CORS, and security tests.','Active',TRUE,TRUE,TRUE),
('EVIDENCE_AUTO_LINKING','Evidence Auto-Linking','Evidence','Links blueprint, code, tests, approvals, and release artifacts to evidence packs.','Active',TRUE,TRUE,TRUE),
('HUMAN_APPROVAL_WORKFLOW','Human Approval Workflow','Governance','Requires explicit human approval before release readiness acceptance.','Active',TRUE,TRUE,TRUE),
('PRODUCTION_ENVIRONMENT_PROFILE','Production Environment Profile','Production','Defines production runtime, security, evidence, approval, and rollback controls.','Active',TRUE,TRUE,TRUE)
ON CONFLICT (capability_key) DO UPDATE
SET capability_name = EXCLUDED.capability_name,
    capability_category = EXCLUDED.capability_category,
    description = EXCLUDED.description,
    status = EXCLUDED.status,
    fail_closed = EXCLUDED.fail_closed,
    requires_human_approval = EXCLUDED.requires_human_approval,
    evidence_required = EXCLUDED.evidence_required,
    updated_at = NOW();

INSERT INTO aira_factory.project_template
(template_key, template_name, template_category, runtime_stack, database_stack, frontend_stack, security_profile, status, production_profile_ready, fail_closed)
VALUES
('SPRING_BOOT_POSTGRES_PORTAL_ENTERPRISE_APP','Spring Boot PostgreSQL Portal Enterprise Application','Enterprise Web Application','Spring Boot WAR on Tomcat 11 Docker Runtime','PostgreSQL 17','Server-IP-aware AIRA Portal Static Frontend','Fail-closed API key and RBAC-ready security profile','Active',TRUE,TRUE),
('GOVERNED_MICROSERVICE_API_APP','Governed Microservice API Application','Enterprise API Service','Spring Boot WAR on Tomcat 11 Docker Runtime','PostgreSQL 17','API-first with optional portal dashboard','Fail-closed protected API profile','Active',TRUE,TRUE),
('EVIDENCE_BACKED_INTERNAL_TOOL','Evidence-backed Internal Tool','Internal Operations Application','Spring Boot WAR on Tomcat 11 Docker Runtime','PostgreSQL 17','AIRA Portal Extension','Governed internal access profile','Active',TRUE,TRUE)
ON CONFLICT (template_key) DO UPDATE
SET template_name = EXCLUDED.template_name,
    template_category = EXCLUDED.template_category,
    runtime_stack = EXCLUDED.runtime_stack,
    database_stack = EXCLUDED.database_stack,
    frontend_stack = EXCLUDED.frontend_stack,
    security_profile = EXCLUDED.security_profile,
    status = EXCLUDED.status,
    production_profile_ready = EXCLUDED.production_profile_ready,
    fail_closed = EXCLUDED.fail_closed,
    updated_at = NOW();

INSERT INTO aira_factory.blueprint_to_code_generator
(generator_key, generator_name, generator_type, target_artifact, output_path_pattern, governed_by_agent, requires_blueprint, requires_approval, evidence_required, status, fail_closed)
VALUES
('ARCHITECTURE_BLUEPRINT_GENERATOR','Architecture Blueprint Generator','Architecture','Architecture document and ADR','docs/architecture/{application-name}/','architecture-agent',TRUE,TRUE,TRUE,'Active',TRUE),
('DATABASE_MIGRATION_GENERATOR','Database Migration Generator','Database','PostgreSQL migration and seed files','database/migrations and database/seed','developer-agent',TRUE,TRUE,TRUE,'Active',TRUE),
('API_CONTRACT_GENERATOR','API Contract Generator','API','Controller, service, DTO, and endpoint contract','src/main/java/{package}/api','developer-agent',TRUE,TRUE,TRUE,'Active',TRUE),
('FRONTEND_SCREEN_GENERATOR','Frontend Screen Generator','Frontend','Portal screen HTML/CSS/JS','src/main/resources/static/portal','developer-agent',TRUE,TRUE,TRUE,'Active',TRUE),
('TEST_GENERATOR','Test Generator','Testing','Validation and test scripts','scripts and src/test','test-agent',TRUE,TRUE,TRUE,'Active',TRUE),
('EVIDENCE_LINK_GENERATOR','Evidence Link Generator','Evidence','Evidence pack and traceability links','05_Evidence/{application-name}','evidence-agent',TRUE,TRUE,TRUE,'Active',TRUE)
ON CONFLICT (generator_key) DO UPDATE
SET generator_name = EXCLUDED.generator_name,
    generator_type = EXCLUDED.generator_type,
    target_artifact = EXCLUDED.target_artifact,
    output_path_pattern = EXCLUDED.output_path_pattern,
    governed_by_agent = EXCLUDED.governed_by_agent,
    requires_blueprint = EXCLUDED.requires_blueprint,
    requires_approval = EXCLUDED.requires_approval,
    evidence_required = EXCLUDED.evidence_required,
    status = EXCLUDED.status,
    fail_closed = EXCLUDED.fail_closed,
    updated_at = NOW();

INSERT INTO aira_factory.application_factory_orchestration_step
(step_key, step_order, step_name, responsible_agent, input_artifact, output_artifact, requires_human_approval, requires_evidence, fail_closed, status)
VALUES
('STEP-01-BLUEPRINT-INTAKE',1,'Blueprint Intake','knowledge-fabric-agent','User application request','Structured application blueprint',TRUE,TRUE,TRUE,'Active'),
('STEP-02-ARCHITECTURE-DESIGN',2,'Architecture Design','architecture-agent','Structured application blueprint','Architecture document and ADR',TRUE,TRUE,TRUE,'Active'),
('STEP-03-DATABASE-DESIGN',3,'Database Design and Migration Plan','developer-agent','Approved architecture document','PostgreSQL migration and seed plan',TRUE,TRUE,TRUE,'Active'),
('STEP-04-API-CONTRACT-DESIGN',4,'API Contract Design','developer-agent','Approved architecture and data model','API contract and controller plan',TRUE,TRUE,TRUE,'Active'),
('STEP-05-SECURITY-REVIEW',5,'Security Review','security-agent','Architecture, API, and data model','Security control review',TRUE,TRUE,TRUE,'Active'),
('STEP-06-CODE-GENERATION',6,'Governed Code Generation','developer-agent','Approved blueprint package','Generated code scaffold',TRUE,TRUE,TRUE,'Active'),
('STEP-07-TEST-GENERATION',7,'Test Generation','test-agent','Generated code scaffold','Validation scripts and test plan',TRUE,TRUE,TRUE,'Active'),
('STEP-08-DOCUMENTATION-EVIDENCE',8,'Documentation and Evidence Linking','documentation-agent','Generated code, tests, and review evidence','Docs, ADRs, and evidence pack',TRUE,TRUE,TRUE,'Active'),
('STEP-09-CICD-QUALITY-GATES',9,'CI/CD Quality Gates','cicd-agent','Generated application artifact','Quality gate run results',TRUE,TRUE,TRUE,'Active'),
('STEP-10-RELEASE-READINESS',10,'Release Readiness and Human Approval','evidence-agent','Quality gate and evidence results','Release readiness and approval record',TRUE,TRUE,TRUE,'Active')
ON CONFLICT (step_key) DO UPDATE
SET step_order = EXCLUDED.step_order,
    step_name = EXCLUDED.step_name,
    responsible_agent = EXCLUDED.responsible_agent,
    input_artifact = EXCLUDED.input_artifact,
    output_artifact = EXCLUDED.output_artifact,
    requires_human_approval = EXCLUDED.requires_human_approval,
    requires_evidence = EXCLUDED.requires_evidence,
    fail_closed = EXCLUDED.fail_closed,
    status = EXCLUDED.status,
    updated_at = NOW();

INSERT INTO aira_factory.application_factory_acceptance_gate
(gate_key, gate_name, gate_category, gate_description, required, fail_closed, status)
VALUES
('FACTORY-BLUEPRINT-APPROVAL-GATE','Blueprint Approval Gate','Governance','Blueprints must be reviewed before generation.',TRUE,TRUE,'Active'),
('FACTORY-ARCHITECTURE-GATE','Architecture Gate','Architecture','Architecture document and ADR must exist before implementation.',TRUE,TRUE,'Active'),
('FACTORY-SECURITY-GATE','Security Gate','Security','Security controls and protected API strategy must be reviewed.',TRUE,TRUE,'Active'),
('FACTORY-DATABASE-GATE','Database Gate','Database','PostgreSQL migrations and seeds must be generated and validated.',TRUE,TRUE,'Active'),
('FACTORY-API-CONTRACT-GATE','API Contract Gate','API','API contract and protected endpoint strategy must be reviewed.',TRUE,TRUE,'Active'),
('FACTORY-FRONTEND-GATE','Frontend Gate','Frontend','Frontend screens must follow server-IP-aware runtime rules.',TRUE,TRUE,'Active'),
('FACTORY-TEST-GATE','Test Gate','Testing','Generated applications must include validation coverage.',TRUE,TRUE,'Active'),
('FACTORY-EVIDENCE-GATE','Evidence Gate','Evidence','Generated artifacts must be linked to evidence packs.',TRUE,TRUE,'Active'),
('FACTORY-PRODUCTION-PROFILE-GATE','Production Profile Gate','Production','Production environment profile must be reviewed.',TRUE,TRUE,'Active'),
('FACTORY-HUMAN-APPROVAL-GATE','Human Approval Gate','Approval','Human approval is required before release readiness.',TRUE,TRUE,'Active')
ON CONFLICT (gate_key) DO UPDATE
SET gate_name = EXCLUDED.gate_name,
    gate_category = EXCLUDED.gate_category,
    gate_description = EXCLUDED.gate_description,
    required = EXCLUDED.required,
    fail_closed = EXCLUDED.fail_closed,
    status = EXCLUDED.status,
    updated_at = NOW();

INSERT INTO aira_factory.production_environment_profile
(profile_key, profile_name, environment_type, runtime_policy, security_policy, evidence_policy, approval_policy, rollback_policy, status, fail_closed)
VALUES
('LOCAL-ENTERPRISE-SERVER-IP-PROFILE','Local Enterprise Server-IP Profile','Local Enterprise Validation','Docker Tomcat 11 runtime with server-IP-aware portal and protected APIs.','Protected APIs require X-AIRA-API-Key.','Evidence packs and readiness records are mandatory.','Human approval required before release readiness acceptance.','Rollback plan and runtime restore path must be documented.','Active',TRUE),
('PRODUCTION-READY-PROFILE','Production-ready Environment Profile','Production','Containerized runtime, externalized environment variables, registry deployment, and health checks.','No embedded secrets, rotated credentials, role-based access, protected APIs, and audited service identity.','Evidence packs, traceability records, release gates, and audit history are mandatory.','Human approval workflow required for production promotion.','Rollback plan, backup restore, and release revert path are mandatory.','Active',TRUE)
ON CONFLICT (profile_key) DO UPDATE
SET profile_name = EXCLUDED.profile_name,
    environment_type = EXCLUDED.environment_type,
    runtime_policy = EXCLUDED.runtime_policy,
    security_policy = EXCLUDED.security_policy,
    evidence_policy = EXCLUDED.evidence_policy,
    approval_policy = EXCLUDED.approval_policy,
    rollback_policy = EXCLUDED.rollback_policy,
    status = EXCLUDED.status,
    fail_closed = EXCLUDED.fail_closed,
    updated_at = NOW();

INSERT INTO aira_factory.application_blueprint_request
(request_key, application_name, business_domain, requested_template_key, requested_by, request_status, production_profile_ready, fail_closed)
VALUES
('SAMPLE-ENTERPRISE-APPLICATION-BLUEPRINT','Sample Enterprise Application','Demonstration','SPRING_BOOT_POSTGRES_PORTAL_ENTERPRISE_APP','AIRA platform owner','Draft',TRUE,TRUE)
ON CONFLICT (request_key) DO UPDATE
SET application_name = EXCLUDED.application_name,
    business_domain = EXCLUDED.business_domain,
    requested_template_key = EXCLUDED.requested_template_key,
    requested_by = EXCLUDED.requested_by,
    request_status = EXCLUDED.request_status,
    production_profile_ready = EXCLUDED.production_profile_ready,
    fail_closed = EXCLUDED.fail_closed,
    updated_at = NOW();

INSERT INTO aira_factory.application_factory_readiness_record
(readiness_key, readiness_name, status, capability_count, template_count, generator_count, orchestration_step_count, acceptance_gate_count, production_profile_count, application_factory_ready, fail_closed)
SELECT
    'AIRA-ENTERPRISE-APPLICATION-FACTORY-FOUNDATION',
    'AIRA Enterprise Application Factory Foundation',
    'UP',
    (SELECT COUNT(*) FROM aira_factory.application_factory_capability WHERE status = 'Active' AND fail_closed = TRUE),
    (SELECT COUNT(*) FROM aira_factory.project_template WHERE status = 'Active' AND fail_closed = TRUE),
    (SELECT COUNT(*) FROM aira_factory.blueprint_to_code_generator WHERE status = 'Active' AND fail_closed = TRUE),
    (SELECT COUNT(*) FROM aira_factory.application_factory_orchestration_step WHERE status = 'Active' AND fail_closed = TRUE),
    (SELECT COUNT(*) FROM aira_factory.application_factory_acceptance_gate WHERE status = 'Active' AND fail_closed = TRUE),
    (SELECT COUNT(*) FROM aira_factory.production_environment_profile WHERE status = 'Active' AND fail_closed = TRUE),
    TRUE,
    TRUE
ON CONFLICT (readiness_key) DO UPDATE
SET status = EXCLUDED.status,
    capability_count = EXCLUDED.capability_count,
    template_count = EXCLUDED.template_count,
    generator_count = EXCLUDED.generator_count,
    orchestration_step_count = EXCLUDED.orchestration_step_count,
    acceptance_gate_count = EXCLUDED.acceptance_gate_count,
    production_profile_count = EXCLUDED.production_profile_count,
    application_factory_ready = EXCLUDED.application_factory_ready,
    fail_closed = EXCLUDED.fail_closed,
    updated_at = NOW();