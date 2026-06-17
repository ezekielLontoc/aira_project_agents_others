-- POC-1B V22 - Login Risk MicroFunction Seed Data
-- Additive seed data for MF-LOGIN-RISK-001 through MF-LOGIN-RISK-040.

CREATE SCHEMA IF NOT EXISTS aira_security;

CREATE TABLE IF NOT EXISTS aira_security.login_risk_microfunction_catalog (
    microfunction_key TEXT PRIMARY KEY,
    microfunction_name TEXT NOT NULL,
    microfunction_purpose TEXT NOT NULL,
    domain TEXT NOT NULL DEFAULT 'LOGIN_RISK',
    active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS aira_security.login_risk_microfunction_execution (
    execution_id TEXT PRIMARY KEY,
    microfunction_key TEXT NOT NULL REFERENCES aira_security.login_risk_microfunction_catalog(microfunction_key),
    institution_key TEXT,
    identity_id TEXT,
    execution_status TEXT NOT NULL DEFAULT 'RECORDED',
    transaction_ref TEXT,
    input_summary JSONB NOT NULL DEFAULT '{}'::jsonb,
    output_summary JSONB NOT NULL DEFAULT '{}'::jsonb,
    evidence JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT login_risk_mf_execution_status_check CHECK (execution_status IN ('RECORDED', 'PASSED', 'FAILED', 'SKIPPED'))
);

CREATE INDEX IF NOT EXISTS idx_login_risk_mf_execution_key_created
    ON aira_security.login_risk_microfunction_execution (microfunction_key, created_at DESC);

INSERT INTO aira_security.login_risk_microfunction_catalog (
    microfunction_key,
    microfunction_name,
    microfunction_purpose,
    domain,
    active,
    updated_at
)
VALUES
('MF-LOGIN-RISK-001', 'Capture login attempt', 'Record every login attempt with identity, institution, device, IP, user agent, and result context.', 'LOGIN_RISK', true, now()),
('MF-LOGIN-RISK-002', 'Classify login failure', 'Classify failed login attempts into actionable failure categories.', 'LOGIN_RISK', true, now()),
('MF-LOGIN-RISK-003', 'Detect repeated failed attempts', 'Detect repeated failures inside the configured policy window.', 'LOGIN_RISK', true, now()),
('MF-LOGIN-RISK-004', 'Detect unknown device', 'Detect whether a login came from a new or unusual device signal.', 'LOGIN_RISK', true, now()),
('MF-LOGIN-RISK-005', 'Detect institution mismatch', 'Detect login attempt mismatch between identity and institution.', 'LOGIN_RISK', true, now()),
('MF-LOGIN-RISK-006', 'Calculate login risk score', 'Calculate risk score using failure, device, institution, role, and policy factors.', 'LOGIN_RISK', true, now()),
('MF-LOGIN-RISK-007', 'Persist login risk event', 'Store login risk event for review and evidence.', 'LOGIN_RISK', true, now()),
('MF-LOGIN-RISK-008', 'Trigger suspicious login review', 'Place suspicious login event into security review queue.', 'LOGIN_RISK', true, now()),
('MF-LOGIN-RISK-009', 'Create login incident record', 'Create incident record when policy or risk threshold is reached.', 'LOGIN_RISK', true, now()),
('MF-LOGIN-RISK-010', 'Generate incident summary', 'Generate human-readable incident analysis.', 'LOGIN_RISK', true, now()),
('MF-LOGIN-RISK-011', 'Recommend triage action', 'Recommend allow, deny, step-up, lock, or review action.', 'LOGIN_RISK', true, now()),
('MF-LOGIN-RISK-012', 'Lock account', 'Lock identity after policy threshold or human decision.', 'LOGIN_RISK', true, now()),
('MF-LOGIN-RISK-013', 'Create unlock request', 'Create governed unlock request for locked account.', 'LOGIN_RISK', true, now()),
('MF-LOGIN-RISK-014', 'Route unlock request to approval', 'Route unlock request through approval workflow.', 'LOGIN_RISK', true, now()),
('MF-LOGIN-RISK-015', 'Approve unlock request', 'Approve unlock request after human review.', 'LOGIN_RISK', true, now()),
('MF-LOGIN-RISK-016', 'Reject unlock request', 'Reject unlock request and keep account locked.', 'LOGIN_RISK', true, now()),
('MF-LOGIN-RISK-017', 'Unlock account', 'Unlock account after approved request.', 'LOGIN_RISK', true, now()),
('MF-LOGIN-RISK-018', 'Audit lock decision', 'Record audit evidence for account lock.', 'LOGIN_RISK', true, now()),
('MF-LOGIN-RISK-019', 'Audit unlock decision', 'Record audit evidence for account unlock.', 'LOGIN_RISK', true, now()),
('MF-LOGIN-RISK-020', 'Evaluate step-up policy', 'Determine whether login requires step-up authentication.', 'LOGIN_RISK', true, now()),
('MF-LOGIN-RISK-021', 'Create step-up challenge', 'Create step-up challenge for the login attempt.', 'LOGIN_RISK', true, now()),
('MF-LOGIN-RISK-022', 'Validate step-up challenge', 'Validate submitted step-up challenge.', 'LOGIN_RISK', true, now()),
('MF-LOGIN-RISK-023', 'Expire step-up challenge', 'Expire stale or exceeded step-up challenge.', 'LOGIN_RISK', true, now()),
('MF-LOGIN-RISK-024', 'Deny login after failed step-up', 'Deny login when step-up challenge fails.', 'LOGIN_RISK', true, now()),
('MF-LOGIN-RISK-025', 'Allow login after successful step-up', 'Allow login after successful step-up challenge.', 'LOGIN_RISK', true, now()),
('MF-LOGIN-RISK-026', 'Apply OPA login policy', 'Evaluate OPA policy for login decision.', 'LOGIN_RISK', true, now()),
('MF-LOGIN-RISK-027', 'Apply OPA account lock policy', 'Evaluate OPA policy for account lock decision.', 'LOGIN_RISK', true, now()),
('MF-LOGIN-RISK-028', 'Apply OPA step-up policy', 'Evaluate OPA policy for step-up decision.', 'LOGIN_RISK', true, now()),
('MF-LOGIN-RISK-029', 'Record policy decision', 'Persist policy decision output.', 'LOGIN_RISK', true, now()),
('MF-LOGIN-RISK-030', 'Record policy evidence', 'Persist policy input, output, and evidence context.', 'LOGIN_RISK', true, now()),
('MF-LOGIN-RISK-031', 'Notify security officer', 'Create notification for security officer review.', 'LOGIN_RISK', true, now()),
('MF-LOGIN-RISK-032', 'Notify institution admin', 'Create notification for institution admin review.', 'LOGIN_RISK', true, now()),
('MF-LOGIN-RISK-033', 'Query suspicious login queue', 'Read suspicious login queue for portal dashboard.', 'LOGIN_RISK', true, now()),
('MF-LOGIN-RISK-034', 'Query locked accounts', 'Read locked accounts for review.', 'LOGIN_RISK', true, now()),
('MF-LOGIN-RISK-035', 'Query login incident history', 'Read incident history for review and evidence.', 'LOGIN_RISK', true, now()),
('MF-LOGIN-RISK-036', 'Export login risk evidence', 'Export login risk evidence for evidence pack.', 'LOGIN_RISK', true, now()),
('MF-LOGIN-RISK-037', 'Reconcile risk event state', 'Reconcile event state with lock, incident, and approval records.', 'LOGIN_RISK', true, now()),
('MF-LOGIN-RISK-038', 'Validate approval workflow state', 'Validate unlock workflow state transitions.', 'LOGIN_RISK', true, now()),
('MF-LOGIN-RISK-039', 'Run login risk readiness check', 'Expose runtime readiness status for POC-1B login risk capability.', 'LOGIN_RISK', true, now()),
('MF-LOGIN-RISK-040', 'Run login risk simulation check', 'Run simulation check for login risk flows.', 'LOGIN_RISK', true, now())
ON CONFLICT (microfunction_key) DO UPDATE SET
    microfunction_name = EXCLUDED.microfunction_name,
    microfunction_purpose = EXCLUDED.microfunction_purpose,
    domain = EXCLUDED.domain,
    active = EXCLUDED.active,
    updated_at = now();