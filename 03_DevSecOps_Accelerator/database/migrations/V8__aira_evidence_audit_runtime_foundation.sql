-- ============================================================
-- AIRA Evidence and Audit Runtime Foundation
-- Migration: V8
-- PostgreSQL: 17
-- ============================================================

CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE SCHEMA IF NOT EXISTS aira_evidence;
CREATE SCHEMA IF NOT EXISTS aira_runtime;
CREATE SCHEMA IF NOT EXISTS aira_security;

-- Ensure Milestone 11 security structures exist even if this is run independently.

CREATE TABLE IF NOT EXISTS aira_security.api_key_access_policy (
    api_key_access_policy_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    policy_key VARCHAR(160) NOT NULL UNIQUE,
    api_key_id VARCHAR(160) NOT NULL,
    api_key_label VARCHAR(200) NOT NULL,
    allowed_service VARCHAR(120) NOT NULL,
    allowed_path_prefix VARCHAR(300) NOT NULL,
    can_read BOOLEAN NOT NULL DEFAULT TRUE,
    can_write BOOLEAN NOT NULL DEFAULT FALSE,
    can_execute BOOLEAN NOT NULL DEFAULT FALSE,
    requires_human_approval BOOLEAN NOT NULL DEFAULT TRUE,
    fail_closed BOOLEAN NOT NULL DEFAULT TRUE,
    status VARCHAR(40) NOT NULL CHECK (status IN ('Active', 'Suspended', 'Retired')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS aira_security.api_security_audit_event (
    api_security_audit_event_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    event_key VARCHAR(180) NOT NULL UNIQUE,
    service_name VARCHAR(120) NOT NULL,
    request_path TEXT NOT NULL,
    request_method VARCHAR(20) NOT NULL,
    principal_label VARCHAR(200),
    decision VARCHAR(40) NOT NULL CHECK (decision IN ('ALLOW', 'DENY', 'PUBLIC')),
    reason TEXT NOT NULL,
    fail_closed BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_api_key_access_policy_service
ON aira_security.api_key_access_policy(allowed_service);

CREATE INDEX IF NOT EXISTS idx_api_key_access_policy_status
ON aira_security.api_key_access_policy(status);

CREATE INDEX IF NOT EXISTS idx_api_security_audit_event_service
ON aira_security.api_security_audit_event(service_name);

CREATE INDEX IF NOT EXISTS idx_api_security_audit_event_decision
ON aira_security.api_security_audit_event(decision);

CREATE INDEX IF NOT EXISTS idx_api_security_audit_event_created_at
ON aira_security.api_security_audit_event(created_at);

-- Evidence runtime audit summary table for milestone-level operational tracking.

CREATE TABLE IF NOT EXISTS aira_evidence.evidence_runtime_audit_record (
    evidence_runtime_audit_record_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    audit_key VARCHAR(180) NOT NULL UNIQUE,
    evidence_pack_key VARCHAR(160),
    action_type VARCHAR(120) NOT NULL,
    action_summary TEXT NOT NULL,
    actor VARCHAR(160) NOT NULL,
    decision VARCHAR(40) NOT NULL CHECK (decision IN ('RECORDED', 'VALIDATED', 'BLOCKED', 'FAILED')),
    fail_closed BOOLEAN NOT NULL DEFAULT TRUE,
    evidence_reference TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_evidence_runtime_audit_pack
ON aira_evidence.evidence_runtime_audit_record(evidence_pack_key);

CREATE INDEX IF NOT EXISTS idx_evidence_runtime_audit_decision
ON aira_evidence.evidence_runtime_audit_record(decision);

COMMENT ON TABLE aira_evidence.evidence_runtime_audit_record IS 'Runtime audit records for evidence API, validation, and audit readiness operations.';