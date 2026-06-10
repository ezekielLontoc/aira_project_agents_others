-- ============================================================
-- V1: AIRA Platform Foundation
-- Target: PostgreSQL 17
-- ============================================================

CREATE TABLE IF NOT EXISTS aira_security.platform_user (
    user_id UUID PRIMARY KEY,
    username VARCHAR(120) NOT NULL UNIQUE,
    display_name VARCHAR(200) NOT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'ACTIVE',
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS aira_security.platform_role (
    role_id UUID PRIMARY KEY,
    role_code VARCHAR(80) NOT NULL UNIQUE,
    description TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS aira_security.platform_permission (
    permission_id UUID PRIMARY KEY,
    permission_code VARCHAR(120) NOT NULL UNIQUE,
    description TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS aira_security.api_key_registry (
    api_key_id UUID PRIMARY KEY,
    owner_name VARCHAR(200) NOT NULL,
    purpose TEXT NOT NULL,
    key_hash TEXT,
    status VARCHAR(50) NOT NULL DEFAULT 'PLACEHOLDER',
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    expires_at TIMESTAMPTZ,
    revoked_at TIMESTAMPTZ
);

CREATE TABLE IF NOT EXISTS aira_security.security_audit_record (
    audit_id UUID PRIMARY KEY,
    actor VARCHAR(200) NOT NULL,
    action VARCHAR(200) NOT NULL,
    target_ref VARCHAR(300),
    decision VARCHAR(80) NOT NULL,
    evidence_ref VARCHAR(300),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS aira_governance.adr_record (
    adr_id UUID PRIMARY KEY,
    adr_code VARCHAR(80) NOT NULL UNIQUE,
    title VARCHAR(300) NOT NULL,
    status VARCHAR(80) NOT NULL,
    decision TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS aira_governance.technology_register_item (
    technology_id UUID PRIMARY KEY,
    technology_name VARCHAR(200) NOT NULL UNIQUE,
    classification VARCHAR(80) NOT NULL,
    purpose TEXT NOT NULL,
    status VARCHAR(80) NOT NULL DEFAULT 'ACTIVE',
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS aira_evidence.evidence_pack (
    evidence_pack_id UUID PRIMARY KEY,
    evidence_code VARCHAR(120) NOT NULL UNIQUE,
    title VARCHAR(300) NOT NULL,
    source_module VARCHAR(120) NOT NULL,
    status VARCHAR(80) NOT NULL DEFAULT 'DRAFT',
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS aira_agents.agent_registry (
    agent_id UUID PRIMARY KEY,
    agent_name VARCHAR(160) NOT NULL UNIQUE,
    classification VARCHAR(120) NOT NULL,
    status VARCHAR(80) NOT NULL DEFAULT 'SCAFFOLDED',
    endpoint_ref VARCHAR(300),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS aira_runtime.service_registry (
    service_id UUID PRIMARY KEY,
    service_name VARCHAR(160) NOT NULL UNIQUE,
    port INTEGER NOT NULL,
    status VARCHAR(80) NOT NULL DEFAULT 'OPERATIONAL',
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS aira_observability.platform_event (
    event_id UUID PRIMARY KEY,
    source_module VARCHAR(160) NOT NULL,
    event_type VARCHAR(160) NOT NULL,
    severity VARCHAR(50) NOT NULL DEFAULT 'INFO',
    message TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);