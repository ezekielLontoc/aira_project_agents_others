-- ============================================================
-- AIRA MVP Release Readiness Foundation
-- Migration: V14
-- PostgreSQL: 17
-- ============================================================

CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE SCHEMA IF NOT EXISTS aira_runtime;
CREATE SCHEMA IF NOT EXISTS aira_governance;
CREATE SCHEMA IF NOT EXISTS aira_evidence;

CREATE TABLE IF NOT EXISTS aira_runtime.mvp_release_readiness_record (
    mvp_release_readiness_record_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    release_key VARCHAR(180) NOT NULL UNIQUE,
    release_name VARCHAR(240) NOT NULL,
    release_version VARCHAR(80) NOT NULL,
    release_scope TEXT NOT NULL,
    runtime_environment VARCHAR(160) NOT NULL,
    release_status VARCHAR(60) NOT NULL CHECK (release_status IN ('Draft', 'Candidate', 'MVP_READY', 'Blocked', 'Released')),
    mvp_ready BOOLEAN NOT NULL DEFAULT FALSE,
    release_owner VARCHAR(160) NOT NULL,
    governance_owner VARCHAR(160) NOT NULL,
    evidence_owner VARCHAR(160) NOT NULL,
    security_owner VARCHAR(160) NOT NULL,
    cicd_owner VARCHAR(160) NOT NULL,
    portal_owner VARCHAR(160) NOT NULL,
    fail_closed BOOLEAN NOT NULL DEFAULT TRUE,
    evidence_reference TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS aira_runtime.mvp_release_gate_result (
    mvp_release_gate_result_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    result_key VARCHAR(220) NOT NULL UNIQUE,
    release_key VARCHAR(180) NOT NULL,
    gate_key VARCHAR(180) NOT NULL,
    gate_name VARCHAR(240) NOT NULL,
    gate_category VARCHAR(120) NOT NULL,
    status VARCHAR(60) NOT NULL CHECK (status IN ('Passed', 'Failed', 'Blocked', 'Not Applicable')),
    result_summary TEXT NOT NULL,
    source_reference TEXT,
    fail_closed BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS aira_runtime.mvp_operating_model_record (
    mvp_operating_model_record_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    operating_model_key VARCHAR(180) NOT NULL UNIQUE,
    release_key VARCHAR(180) NOT NULL,
    model_name VARCHAR(240) NOT NULL,
    model_status VARCHAR(60) NOT NULL CHECK (model_status IN ('Active', 'Blocked', 'Retired')),
    operating_principles TEXT NOT NULL,
    support_model TEXT NOT NULL,
    escalation_model TEXT NOT NULL,
    change_control_model TEXT NOT NULL,
    evidence_model TEXT NOT NULL,
    rollback_model TEXT NOT NULL,
    human_approval_required BOOLEAN NOT NULL DEFAULT TRUE,
    fail_closed BOOLEAN NOT NULL DEFAULT TRUE,
    evidence_reference TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS aira_runtime.mvp_rollback_readiness_record (
    mvp_rollback_readiness_record_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    rollback_key VARCHAR(180) NOT NULL UNIQUE,
    release_key VARCHAR(180) NOT NULL,
    rollback_status VARCHAR(60) NOT NULL CHECK (rollback_status IN ('Ready', 'Blocked', 'Not Required')),
    rollback_strategy TEXT NOT NULL,
    rollback_owner VARCHAR(160) NOT NULL,
    validation_method TEXT NOT NULL,
    evidence_reference TEXT,
    fail_closed BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS aira_runtime.mvp_acceptance_record (
    mvp_acceptance_record_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    acceptance_key VARCHAR(180) NOT NULL UNIQUE,
    release_key VARCHAR(180) NOT NULL,
    accepted_by VARCHAR(160) NOT NULL,
    acceptance_status VARCHAR(60) NOT NULL CHECK (acceptance_status IN ('Accepted', 'Pending', 'Rejected')),
    acceptance_summary TEXT NOT NULL,
    acceptance_date TIMESTAMPTZ,
    evidence_reference TEXT,
    human_approval_required BOOLEAN NOT NULL DEFAULT TRUE,
    fail_closed BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_mvp_release_readiness_status
ON aira_runtime.mvp_release_readiness_record(release_status);

CREATE INDEX IF NOT EXISTS idx_mvp_release_gate_result_release
ON aira_runtime.mvp_release_gate_result(release_key);

CREATE INDEX IF NOT EXISTS idx_mvp_release_gate_result_status
ON aira_runtime.mvp_release_gate_result(status);

CREATE INDEX IF NOT EXISTS idx_mvp_operating_model_release
ON aira_runtime.mvp_operating_model_record(release_key);

CREATE INDEX IF NOT EXISTS idx_mvp_rollback_release
ON aira_runtime.mvp_rollback_readiness_record(release_key);

CREATE INDEX IF NOT EXISTS idx_mvp_acceptance_release
ON aira_runtime.mvp_acceptance_record(release_key);

COMMENT ON TABLE aira_runtime.mvp_release_readiness_record IS 'Final MVP release readiness records for AIRA.';
COMMENT ON TABLE aira_runtime.mvp_release_gate_result IS 'End-to-end MVP release gate results.';
COMMENT ON TABLE aira_runtime.mvp_operating_model_record IS 'Operating model records for MVP runtime operation.';
COMMENT ON TABLE aira_runtime.mvp_rollback_readiness_record IS 'Rollback readiness records for MVP runtime.';
COMMENT ON TABLE aira_runtime.mvp_acceptance_record IS 'Human acceptance records for MVP release readiness.';