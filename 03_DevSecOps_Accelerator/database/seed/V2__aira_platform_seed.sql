-- ============================================================
-- V2: AIRA Platform Seed Data
-- Target: PostgreSQL 17
-- ============================================================

INSERT INTO aira_runtime.service_registry (
    service_id,
    service_name,
    port,
    status
)
VALUES
    (gen_random_uuid(), 'accelerator-api', 9090, 'OPERATIONAL'),
    (gen_random_uuid(), 'accelerator-security', 9091, 'OPERATIONAL'),
    (gen_random_uuid(), 'accelerator-governance', 9092, 'OPERATIONAL'),
    (gen_random_uuid(), 'accelerator-evidence', 9093, 'OPERATIONAL'),
    (gen_random_uuid(), 'accelerator-agents', 9094, 'OPERATIONAL'),
    (gen_random_uuid(), 'accelerator-observability', 9095, 'OPERATIONAL')
ON CONFLICT (service_name) DO NOTHING;

INSERT INTO aira_agents.agent_registry (
    agent_id,
    agent_name,
    classification,
    status
)
VALUES
    (gen_random_uuid(), 'knowledge-fabric-agent', 'Strategic AIRA Agent', 'SCAFFOLDED'),
    (gen_random_uuid(), 'architecture-agent', 'Strategic AIRA Agent', 'SCAFFOLDED'),
    (gen_random_uuid(), 'developer-agent', 'Strategic AIRA Agent', 'SCAFFOLDED'),
    (gen_random_uuid(), 'security-agent', 'Strategic AIRA Agent', 'SCAFFOLDED'),
    (gen_random_uuid(), 'test-agent', 'Strategic AIRA Agent', 'SCAFFOLDED'),
    (gen_random_uuid(), 'documentation-agent', 'Strategic AIRA Agent', 'SCAFFOLDED'),
    (gen_random_uuid(), 'evidence-agent', 'Strategic AIRA Agent', 'SCAFFOLDED'),
    (gen_random_uuid(), 'cicd-agent', 'Strategic AIRA Agent', 'SCAFFOLDED')
ON CONFLICT (agent_name) DO NOTHING;