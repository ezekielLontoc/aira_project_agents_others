-- ============================================================
-- AIRA PostgreSQL 17 Foundation
-- Database: aira_platform
-- ============================================================

CREATE SCHEMA IF NOT EXISTS aira_security;
CREATE SCHEMA IF NOT EXISTS aira_governance;
CREATE SCHEMA IF NOT EXISTS aira_evidence;
CREATE SCHEMA IF NOT EXISTS aira_agents;
CREATE SCHEMA IF NOT EXISTS aira_runtime;
CREATE SCHEMA IF NOT EXISTS aira_observability;

COMMENT ON SCHEMA aira_security IS 'Identity, roles, permissions, API keys, and security audit records.';
COMMENT ON SCHEMA aira_governance IS 'ADRs, policies, technology register, exceptions, and review records.';
COMMENT ON SCHEMA aira_evidence IS 'Evidence packs, audit artifacts, control traces, and compliance records.';
COMMENT ON SCHEMA aira_agents IS 'Agent registry, agent contracts, prompt registry, and execution records.';
COMMENT ON SCHEMA aira_runtime IS 'Runtime state, service registry, environment metadata, and platform events.';
COMMENT ON SCHEMA aira_observability IS 'Operational events, health records, metrics summaries, and traces.';