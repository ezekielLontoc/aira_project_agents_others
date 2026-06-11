-- ============================================================
-- AIRA Portal Frontend Foundation
-- Migration: V12
-- PostgreSQL: 17
-- ============================================================

CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE SCHEMA IF NOT EXISTS aira_runtime;

CREATE TABLE IF NOT EXISTS aira_runtime.portal_readiness_record (
    portal_readiness_record_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    readiness_key VARCHAR(180) NOT NULL UNIQUE,
    portal_name VARCHAR(200) NOT NULL,
    portal_url TEXT NOT NULL,
    served_by_service VARCHAR(120) NOT NULL,
    frontend_mode VARCHAR(80) NOT NULL,
    api_key_required_for_backend BOOLEAN NOT NULL DEFAULT TRUE,
    embeds_secret BOOLEAN NOT NULL DEFAULT FALSE,
    status VARCHAR(40) NOT NULL CHECK (status IN ('Active', 'Blocked', 'Retired')),
    fail_closed BOOLEAN NOT NULL DEFAULT TRUE,
    evidence_reference TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_portal_readiness_record_status
ON aira_runtime.portal_readiness_record(status);

COMMENT ON TABLE aira_runtime.portal_readiness_record IS 'Readiness records for the AIRA Portal / Frontend Foundation.';