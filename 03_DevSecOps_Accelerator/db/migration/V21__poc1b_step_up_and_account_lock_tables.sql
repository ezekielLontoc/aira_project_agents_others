-- POC-1B V21 - Step-Up and Account Lock Tables
-- Additive-only migration for account lock, unlock approval, and step-up challenge.

CREATE SCHEMA IF NOT EXISTS aira_security;

CREATE TABLE IF NOT EXISTS aira_security.account_lock (
    account_lock_id TEXT PRIMARY KEY,
    institution_key TEXT NOT NULL,
    identity_id TEXT NOT NULL,
    email TEXT,
    lock_status TEXT NOT NULL DEFAULT 'LOCKED',
    lock_reason TEXT NOT NULL,
    lock_source TEXT NOT NULL DEFAULT 'POLICY',
    risk_event_id TEXT REFERENCES aira_security.login_risk_event(risk_event_id),
    locked_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    locked_by TEXT,
    unlocked_at TIMESTAMPTZ,
    unlocked_by TEXT,
    unlock_reason TEXT,
    evidence JSONB NOT NULL DEFAULT '{}'::jsonb,
    CONSTRAINT account_lock_status_check CHECK (lock_status IN ('LOCKED', 'UNLOCKED')),
    CONSTRAINT account_lock_source_check CHECK (lock_source IN ('POLICY', 'SECURITY_OFFICER', 'PLATFORM_ADMIN', 'SYSTEM'))
);

CREATE UNIQUE INDEX IF NOT EXISTS uq_account_lock_active_identity
    ON aira_security.account_lock (identity_id)
    WHERE lock_status = 'LOCKED';

CREATE INDEX IF NOT EXISTS idx_account_lock_institution_status
    ON aira_security.account_lock (institution_key, lock_status);

CREATE TABLE IF NOT EXISTS aira_security.account_unlock_request (
    unlock_request_id TEXT PRIMARY KEY,
    account_lock_id TEXT REFERENCES aira_security.account_lock(account_lock_id),
    institution_key TEXT NOT NULL,
    identity_id TEXT NOT NULL,
    requested_by TEXT NOT NULL,
    request_status TEXT NOT NULL DEFAULT 'PENDING',
    request_reason TEXT NOT NULL,
    workflow_instance_id TEXT,
    approval_required BOOLEAN NOT NULL DEFAULT true,
    approved_by TEXT,
    approved_at TIMESTAMPTZ,
    rejected_by TEXT,
    rejected_at TIMESTAMPTZ,
    decision_notes TEXT,
    evidence JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT unlock_request_status_check CHECK (request_status IN ('PENDING', 'APPROVED', 'REJECTED', 'CANCELLED'))
);

CREATE INDEX IF NOT EXISTS idx_unlock_request_institution_status
    ON aira_security.account_unlock_request (institution_key, request_status);

CREATE INDEX IF NOT EXISTS idx_unlock_request_identity_created
    ON aira_security.account_unlock_request (identity_id, created_at DESC);

CREATE TABLE IF NOT EXISTS aira_security.step_up_challenge (
    challenge_id TEXT PRIMARY KEY,
    institution_key TEXT NOT NULL,
    identity_id TEXT,
    email TEXT,
    risk_event_id TEXT REFERENCES aira_security.login_risk_event(risk_event_id),
    challenge_type TEXT NOT NULL DEFAULT 'LOCAL_CODE',
    challenge_status TEXT NOT NULL DEFAULT 'PENDING',
    challenge_code_hash TEXT,
    attempts INTEGER NOT NULL DEFAULT 0,
    max_attempts INTEGER NOT NULL DEFAULT 3,
    expires_at TIMESTAMPTZ NOT NULL DEFAULT (now() + interval '10 minutes'),
    verified_at TIMESTAMPTZ,
    denied_at TIMESTAMPTZ,
    evidence JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT step_up_status_check CHECK (challenge_status IN ('PENDING', 'VERIFIED', 'DENIED', 'EXPIRED')),
    CONSTRAINT step_up_type_check CHECK (challenge_type IN ('LOCAL_CODE', 'POLICY_CHALLENGE', 'APPROVAL_REQUIRED'))
);

CREATE INDEX IF NOT EXISTS idx_step_up_challenge_identity_status
    ON aira_security.step_up_challenge (identity_id, challenge_status);

CREATE INDEX IF NOT EXISTS idx_step_up_challenge_expires
    ON aira_security.step_up_challenge (expires_at);

CREATE TABLE IF NOT EXISTS aira_security.login_policy_decision (
    policy_decision_id TEXT PRIMARY KEY,
    institution_key TEXT NOT NULL,
    identity_id TEXT,
    policy_name TEXT NOT NULL,
    decision TEXT NOT NULL,
    allow_login BOOLEAN NOT NULL DEFAULT false,
    require_step_up BOOLEAN NOT NULL DEFAULT false,
    lock_account BOOLEAN NOT NULL DEFAULT false,
    require_unlock_approval BOOLEAN NOT NULL DEFAULT true,
    deny_reasons JSONB NOT NULL DEFAULT '[]'::jsonb,
    policy_input JSONB NOT NULL DEFAULT '{}'::jsonb,
    policy_output JSONB NOT NULL DEFAULT '{}'::jsonb,
    evidence JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT login_policy_decision_check CHECK (decision IN ('ALLOW', 'STEP_UP', 'LOCK', 'DENY', 'REVIEW'))
);

CREATE INDEX IF NOT EXISTS idx_login_policy_decision_institution_created
    ON aira_security.login_policy_decision (institution_key, created_at DESC);