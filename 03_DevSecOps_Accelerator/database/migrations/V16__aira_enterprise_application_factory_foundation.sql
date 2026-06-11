CREATE SCHEMA IF NOT EXISTS aira_factory;

CREATE TABLE IF NOT EXISTS aira_factory.application_factory_capability (
    capability_key VARCHAR(120) PRIMARY KEY,
    capability_name VARCHAR(240) NOT NULL,
    capability_category VARCHAR(120) NOT NULL,
    description TEXT NOT NULL,
    status VARCHAR(40) NOT NULL DEFAULT 'Active',
    fail_closed BOOLEAN NOT NULL DEFAULT TRUE,
    requires_human_approval BOOLEAN NOT NULL DEFAULT TRUE,
    evidence_required BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS aira_factory.project_template (
    template_key VARCHAR(120) PRIMARY KEY,
    template_name VARCHAR(240) NOT NULL,
    template_category VARCHAR(120) NOT NULL,
    runtime_stack VARCHAR(240) NOT NULL,
    database_stack VARCHAR(240) NOT NULL,
    frontend_stack VARCHAR(240) NOT NULL,
    security_profile VARCHAR(240) NOT NULL,
    status VARCHAR(40) NOT NULL DEFAULT 'Active',
    production_profile_ready BOOLEAN NOT NULL DEFAULT FALSE,
    fail_closed BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS aira_factory.blueprint_to_code_generator (
    generator_key VARCHAR(120) PRIMARY KEY,
    generator_name VARCHAR(240) NOT NULL,
    generator_type VARCHAR(120) NOT NULL,
    target_artifact VARCHAR(240) NOT NULL,
    output_path_pattern TEXT NOT NULL,
    governed_by_agent VARCHAR(120) NOT NULL,
    requires_blueprint BOOLEAN NOT NULL DEFAULT TRUE,
    requires_approval BOOLEAN NOT NULL DEFAULT TRUE,
    evidence_required BOOLEAN NOT NULL DEFAULT TRUE,
    status VARCHAR(40) NOT NULL DEFAULT 'Active',
    fail_closed BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS aira_factory.application_factory_orchestration_step (
    step_key VARCHAR(120) PRIMARY KEY,
    step_order INTEGER NOT NULL,
    step_name VARCHAR(240) NOT NULL,
    responsible_agent VARCHAR(120) NOT NULL,
    input_artifact VARCHAR(240) NOT NULL,
    output_artifact VARCHAR(240) NOT NULL,
    requires_human_approval BOOLEAN NOT NULL DEFAULT TRUE,
    requires_evidence BOOLEAN NOT NULL DEFAULT TRUE,
    fail_closed BOOLEAN NOT NULL DEFAULT TRUE,
    status VARCHAR(40) NOT NULL DEFAULT 'Active',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT uq_application_factory_orchestration_step_order UNIQUE (step_order)
);

CREATE TABLE IF NOT EXISTS aira_factory.application_factory_acceptance_gate (
    gate_key VARCHAR(120) PRIMARY KEY,
    gate_name VARCHAR(240) NOT NULL,
    gate_category VARCHAR(120) NOT NULL,
    gate_description TEXT NOT NULL,
    required BOOLEAN NOT NULL DEFAULT TRUE,
    fail_closed BOOLEAN NOT NULL DEFAULT TRUE,
    status VARCHAR(40) NOT NULL DEFAULT 'Active',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS aira_factory.production_environment_profile (
    profile_key VARCHAR(120) PRIMARY KEY,
    profile_name VARCHAR(240) NOT NULL,
    environment_type VARCHAR(120) NOT NULL,
    runtime_policy TEXT NOT NULL,
    security_policy TEXT NOT NULL,
    evidence_policy TEXT NOT NULL,
    approval_policy TEXT NOT NULL,
    rollback_policy TEXT NOT NULL,
    status VARCHAR(40) NOT NULL DEFAULT 'Active',
    fail_closed BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS aira_factory.application_blueprint_request (
    request_key VARCHAR(120) PRIMARY KEY,
    application_name VARCHAR(240) NOT NULL,
    business_domain VARCHAR(240) NOT NULL,
    requested_template_key VARCHAR(120) REFERENCES aira_factory.project_template(template_key),
    requested_by VARCHAR(240) NOT NULL,
    request_status VARCHAR(80) NOT NULL DEFAULT 'Draft',
    architecture_ready BOOLEAN NOT NULL DEFAULT FALSE,
    database_ready BOOLEAN NOT NULL DEFAULT FALSE,
    api_contract_ready BOOLEAN NOT NULL DEFAULT FALSE,
    frontend_ready BOOLEAN NOT NULL DEFAULT FALSE,
    tests_ready BOOLEAN NOT NULL DEFAULT FALSE,
    evidence_ready BOOLEAN NOT NULL DEFAULT FALSE,
    approval_ready BOOLEAN NOT NULL DEFAULT FALSE,
    production_profile_ready BOOLEAN NOT NULL DEFAULT FALSE,
    fail_closed BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS aira_factory.application_factory_readiness_record (
    readiness_key VARCHAR(120) PRIMARY KEY,
    readiness_name VARCHAR(240) NOT NULL,
    status VARCHAR(80) NOT NULL,
    capability_count INTEGER NOT NULL DEFAULT 0,
    template_count INTEGER NOT NULL DEFAULT 0,
    generator_count INTEGER NOT NULL DEFAULT 0,
    orchestration_step_count INTEGER NOT NULL DEFAULT 0,
    acceptance_gate_count INTEGER NOT NULL DEFAULT 0,
    production_profile_count INTEGER NOT NULL DEFAULT 0,
    application_factory_ready BOOLEAN NOT NULL DEFAULT FALSE,
    fail_closed BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);