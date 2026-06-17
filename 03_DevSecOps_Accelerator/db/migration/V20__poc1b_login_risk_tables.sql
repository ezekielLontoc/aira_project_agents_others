-- POC-1B V20 - Login Risk Tables
-- Additive-only migration for login risk review and triage.

CREATE SCHEMA IF NOT EXISTS aira_security;

CREATE TABLE IF NOT EXISTS aira_security.login_risk_event (
    risk_event_id TEXT PRIMARY KEY,
    institution_key TEXT NOT NULL,
    identity_id TEXT,
    email TEXT,
    event_type TEXT NOT NULL,
    risk_score INTEGER NOT NULL DEFAULT 0,
    severity TEXT NOT NULL DEFAULT 'LOW',
    status TEXT NOT NULL DEFAULT 'OPEN',
    source_ip TEXT,
    user_agent TEXT,
    device_fingerprint TEXT,
    risk_reasons JSONB NOT NULL DEFAULT '[]'::jsonb,
    evidence JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    reviewed_at TIMESTAMPTZ,
    reviewed_by TEXT,
    review_decision TEXT,
    review_notes TEXT,
    CONSTRAINT login_risk_event_score_range CHECK (risk_score >= 0 AND risk_score <= 100),
    CONSTRAINT login_risk_event_severity_check CHECK (severity IN ('LOW', 'MEDIUM', 'HIGH', 'CRITICAL')),
    CONSTRAINT login_risk_event_status_check CHECK (status IN ('OPEN', 'IN_REVIEW', 'CLOSED', 'ESCALATED'))
);

CREATE INDEX IF NOT EXISTS idx_login_risk_event_institution_status
    ON aira_security.login_risk_event (institution_key, status);

CREATE INDEX IF NOT EXISTS idx_login_risk_event_identity_created
    ON aira_security.login_risk_event (identity_id, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_login_risk_event_severity_created
    ON aira_security.login_risk_event (severity, created_at DESC);

CREATE TABLE IF NOT EXISTS aira_security.login_failure_triage (
    triage_id TEXT PRIMARY KEY,
    risk_event_id TEXT REFERENCES aira_security.login_risk_event(risk_event_id),
    institution_key TEXT NOT NULL,
    identity_id TEXT,
    email TEXT,
    failure_category TEXT NOT NULL,
    severity TEXT NOT NULL DEFAULT 'LOW',
    failed_attempts_in_window INTEGER NOT NULL DEFAULT 0,
    recommended_action TEXT NOT NULL DEFAULT 'ALLOW_RETRY',
    triage_summary TEXT NOT NULL,
    evidence JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT login_failure_triage_severity_check CHECK (severity IN ('LOW', 'MEDIUM', 'HIGH', 'CRITICAL')),
    CONSTRAINT login_failure_triage_action_check CHECK (recommended_action IN ('ALLOW_RETRY', 'STEP_UP', 'LOCK_ACCOUNT', 'SECURITY_REVIEW', 'DENY'))
);

CREATE INDEX IF NOT EXISTS idx_login_failure_triage_institution_created
    ON aira_security.login_failure_triage (institution_key, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_login_failure_triage_email_created
    ON aira_security.login_failure_triage (email, created_at DESC);

CREATE TABLE IF NOT EXISTS aira_security.login_incident_analysis (
    incident_id TEXT PRIMARY KEY,
    risk_event_id TEXT REFERENCES aira_security.login_risk_event(risk_event_id),
    institution_key TEXT NOT NULL,
    identity_id TEXT,
    incident_status TEXT NOT NULL DEFAULT 'OPEN',
    incident_severity TEXT NOT NULL DEFAULT 'LOW',
    analysis_summary TEXT NOT NULL,
    recommended_action TEXT NOT NULL,
    evidence_context JSONB NOT NULL DEFAULT '{}'::jsonb,
    ai_assisted BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    reviewed_at TIMESTAMPTZ,
    reviewed_by TEXT,
    CONSTRAINT login_incident_status_check CHECK (incident_status IN ('OPEN', 'IN_REVIEW', 'CLOSED', 'ESCALATED')),
    CONSTRAINT login_incident_severity_check CHECK (incident_severity IN ('LOW', 'MEDIUM', 'HIGH', 'CRITICAL'))
);

CREATE INDEX IF NOT EXISTS idx_login_incident_analysis_status_created
    ON aira_security.login_incident_analysis (incident_status, created_at DESC);