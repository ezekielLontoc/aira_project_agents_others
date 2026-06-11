package com.aira.accelerator.agents.registry;

import java.time.OffsetDateTime;
import java.util.List;
import java.util.Map;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

@Service
public class AgentRegistryService {

    private final JdbcTemplate jdbcTemplate;

    public AgentRegistryService(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public List<Map<String, Object>> listAgents() {
        return jdbcTemplate.queryForList(
                "SELECT " +
                "agent_name, correct_technical_name, purpose, business_function, technical_function, " +
                "owner, backup_owner, classification, risk_level, can_change_code, can_approve, " +
                "can_deploy, production_change_allowed, requires_human_approval, fail_closed, " +
                "evidence_output, status, agent_version, created_at, updated_at " +
                "FROM aira_agents.agent_definition " +
                "ORDER BY agent_name"
        );
    }

    public Map<String, Object> getAgent(String agentName) {
        List<Map<String, Object>> rows = jdbcTemplate.queryForList(
                "SELECT " +
                "agent_name, correct_technical_name, purpose, business_function, technical_function, " +
                "owner, backup_owner, classification, risk_level, can_change_code, can_approve, " +
                "can_deploy, production_change_allowed, requires_human_approval, fail_closed, " +
                "evidence_output, status, agent_version, created_at, updated_at " +
                "FROM aira_agents.agent_definition " +
                "WHERE agent_name = ?",
                agentName
        );

        if (rows.isEmpty()) {
            throw new AgentRegistryNotFoundException("Agent not found: " + agentName);
        }

        return rows.get(0);
    }

    public List<Map<String, Object>> getPromptVersions(String agentName) {
        assertAgentExists(agentName);

        return jdbcTemplate.queryForList(
                "SELECT " +
                "agent_name, prompt_id, prompt_version, prompt_purpose, prompt_location, " +
                "approved_by, approval_status, effective_from, effective_to, created_at " +
                "FROM aira_agents.agent_prompt_version " +
                "WHERE agent_name = ? " +
                "ORDER BY prompt_id, prompt_version",
                agentName
        );
    }

    public List<Map<String, Object>> getModelVersions(String agentName) {
        assertAgentExists(agentName);

        return jdbcTemplate.queryForList(
                "SELECT " +
                "agent_name, model_provider, model_name, model_version, model_policy, " +
                "approved_for_use, approved_by, approval_status, created_at " +
                "FROM aira_agents.agent_model_version " +
                "WHERE agent_name = ? " +
                "ORDER BY model_provider, model_name, model_version",
                agentName
        );
    }

    public List<Map<String, Object>> getToolPermissions(String agentName) {
        assertAgentExists(agentName);

        return jdbcTemplate.queryForList(
                "SELECT " +
                "agent_name, tool_name, tool_purpose, can_read, can_write, can_execute, " +
                "approval_required, risk_level, evidence_required, restrictions, created_at " +
                "FROM aira_agents.agent_tool_permission " +
                "WHERE agent_name = ? " +
                "ORDER BY tool_name",
                agentName
        );
    }

    public AgentRegistrySummaryResponse summary() {
        int activeAgents = count("SELECT COUNT(*) FROM aira_agents.agent_definition WHERE status = 'Active'");
        int promptVersions = count("SELECT COUNT(*) FROM aira_agents.agent_prompt_version WHERE approval_status = 'Approved'");
        int modelVersions = count("SELECT COUNT(*) FROM aira_agents.agent_model_version WHERE approval_status = 'Approved' AND approved_for_use = TRUE");
        int toolPermissions = count("SELECT COUNT(*) FROM aira_agents.agent_tool_permission");

        boolean baselineReady =
                activeAgents >= 8
                && promptVersions >= 8
                && modelVersions >= 8;

        return new AgentRegistrySummaryResponse(
                baselineReady ? "UP" : "BLOCKED",
                activeAgents,
                promptVersions,
                modelVersions,
                toolPermissions,
                true,
                OffsetDateTime.now()
        );
    }

    private void assertAgentExists(String agentName) {
        Integer count = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM aira_agents.agent_definition WHERE agent_name = ?",
                Integer.class,
                agentName
        );

        if (count == null || count == 0) {
            throw new AgentRegistryNotFoundException("Agent not found: " + agentName);
        }
    }

    private int count(String sql) {
        Integer result = jdbcTemplate.queryForObject(sql, Integer.class);
        return result == null ? 0 : result;
    }
}