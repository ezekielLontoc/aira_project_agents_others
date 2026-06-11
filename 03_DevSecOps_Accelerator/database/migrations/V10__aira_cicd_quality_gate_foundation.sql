-- ============================================================
-- AIRA CI/CD Quality Gate Foundation
-- Migration: V10
-- PostgreSQL: 17
-- ============================================================

CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE SCHEMA IF NOT EXISTS aira_runtime;
CREATE SCHEMA IF NOT EXISTS aira_evidence;

CREATE TABLE IF NOT EXISTS aira_runtime.cicd_quality_gate_definition (
    quality_gate_definition_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    gate_key VARCHAR(160) NOT NULL UNIQUE,
    gate_name VARCHAR(240) NOT NULL,
    gate_category VARCHAR(120) NOT NULL,
    gate_purpose TEXT NOT NULL,
    blocking_rule TEXT NOT NULL,
    required BOOLEAN NOT NULL DEFAULT TRUE,
    fail_closed BOOLEAN NOT NULL DEFAULT TRUE,
    owner VARCHAR(160) NOT NULL,
    status VARCHAR(40) NOT NULL CHECK (status IN ('Active', 'Suspended', 'Retired')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS aira_runtime.cicd_quality_gate_run (
    quality_gate_run_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    run_key VARCHAR(180) NOT NULL UNIQUE,
    run_type VARCHAR(80) NOT NULL,
    branch_name VARCHAR(240),
    commit_sha VARCHAR(160),
    runtime_environment VARCHAR(120) NOT NULL,
    triggered_by VARCHAR(160) NOT NULL,
    status VARCHAR(40) NOT NULL CHECK (status IN ('Started', 'Passed', 'Failed', 'Blocked')),
    fail_closed BOOLEAN NOT NULL DEFAULT TRUE,
    evidence_reference TEXT,
    started_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    completed_at TIMESTAMPTZ
);

CREATE TABLE IF NOT EXISTS aira_runtime.cicd_quality_gate_result (
    quality_gate_result_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    result_key VARCHAR(220) NOT NULL UNIQUE,
    run_key VARCHAR(180) NOT NULL,
    gate_key VARCHAR(160) NOT NULL,
    gate_name VARCHAR(240) NOT NULL,
    gate_category VARCHAR(120) NOT NULL,
    status VARCHAR(40) NOT NULL CHECK (status IN ('Passed', 'Failed', 'Blocked', 'Skipped')),
    command_text TEXT,
    result_summary TEXT NOT NULL,
    evidence_reference TEXT,
    fail_closed BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_cicd_quality_gate_definition_status
ON aira_runtime.cicd_quality_gate_definition(status);

CREATE INDEX IF NOT EXISTS idx_cicd_quality_gate_run_status
ON aira_runtime.cicd_quality_gate_run(status);

CREATE INDEX IF NOT EXISTS idx_cicd_quality_gate_run_started_at
ON aira_runtime.cicd_quality_gate_run(started_at);

CREATE INDEX IF NOT EXISTS idx_cicd_quality_gate_result_run
ON aira_runtime.cicd_quality_gate_result(run_key);

CREATE INDEX IF NOT EXISTS idx_cicd_quality_gate_result_status
ON aira_runtime.cicd_quality_gate_result(status);

COMMENT ON TABLE aira_runtime.cicd_quality_gate_definition IS 'Definitions for mandatory AIRA CI/CD quality gates.';
COMMENT ON TABLE aira_runtime.cicd_quality_gate_run IS 'Runtime records for local and CI quality gate runs.';
COMMENT ON TABLE aira_runtime.cicd_quality_gate_result IS 'Individual quality gate results for a CI/CD quality gate run.';