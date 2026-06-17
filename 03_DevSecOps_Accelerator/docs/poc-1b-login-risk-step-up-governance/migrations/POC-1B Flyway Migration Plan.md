# POC-1B Flyway Migration Plan

## Goal

Add POC-1B tables without breaking POC-1 or POC-1A.

## Additive Tables

- aira_security.login_risk_event
- aira_security.login_failure_triage
- aira_security.account_lock
- aira_security.account_unlock_request
- aira_security.step_up_challenge
- aira_security.login_incident_analysis
- aira_security.login_policy_decision
- aira_security.login_risk_microfunction_execution

## Migration Rules

- Additive only.
- No destructive schema changes.
- No table drops.
- No column removals.
- No weakening of existing identity constraints.
- Every table must support evidence and audit traceability.

## Planned Migrations

- V20__poc1b_login_risk_tables.sql
- V21__poc1b_step_up_and_account_lock_tables.sql
- V22__poc1b_login_risk_microfunction_seed_data.sql