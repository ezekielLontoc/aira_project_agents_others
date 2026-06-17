# POC-1B Phase 1 Database Migration Evidence

## Status

PASSED

## Migration Root

D:\ChatGPT Workspace Folder Projects\AIRA Projects\03_DevSecOps_Accelerator\db\migration

## Migration Files

- V20__poc1b_login_risk_tables.sql
- V21__poc1b_step_up_and_account_lock_tables.sql
- V22__poc1b_login_risk_microfunction_seed_data.sql

## Runtime Database Validation

Container: aira-postgres17  
Database: aira_platform  
Schema: aira_security

## Tables Validated

- aira_security.login_risk_event
- aira_security.login_failure_triage
- aira_security.login_incident_analysis
- aira_security.account_lock
- aira_security.account_unlock_request
- aira_security.step_up_challenge
- aira_security.login_policy_decision
- aira_security.login_risk_microfunction_catalog
- aira_security.login_risk_microfunction_execution

## MicroFunction Seed Validation

Expected seed rows: 40  
Actual seed rows: 40

First key validated:

- MF-LOGIN-RISK-001

Final key validated:

- MF-LOGIN-RISK-040

## Decision

POC-1B Phase 1 additive database foundation is accepted.