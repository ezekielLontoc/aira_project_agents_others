package com.aira.accelerator.agents.factory;

import java.time.OffsetDateTime;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

@Service
public class ApplicationFactoryService {

    private final JdbcTemplate jdbcTemplate;

    public ApplicationFactoryService(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public Map<String, Object> readiness() {
        int capabilities = count("SELECT COUNT(*) FROM aira_factory.application_factory_capability WHERE status = 'Active' AND fail_closed = TRUE");
        int templates = count("SELECT COUNT(*) FROM aira_factory.project_template WHERE status = 'Active' AND fail_closed = TRUE");
        int generators = count("SELECT COUNT(*) FROM aira_factory.blueprint_to_code_generator WHERE status = 'Active' AND fail_closed = TRUE");
        int steps = count("SELECT COUNT(*) FROM aira_factory.application_factory_orchestration_step WHERE status = 'Active' AND fail_closed = TRUE");
        int gates = count("SELECT COUNT(*) FROM aira_factory.application_factory_acceptance_gate WHERE status = 'Active' AND fail_closed = TRUE");
        int profiles = count("SELECT COUNT(*) FROM aira_factory.production_environment_profile WHERE status = 'Active' AND fail_closed = TRUE");

        boolean ready = capabilities >= 10
                && templates >= 3
                && generators >= 6
                && steps >= 10
                && gates >= 10
                && profiles >= 2;

        Map<String, Object> response = new LinkedHashMap<>();
        response.put("status", ready ? "UP" : "BLOCKED");
        response.put("readinessKey", "AIRA-ENTERPRISE-APPLICATION-FACTORY-FOUNDATION");
        response.put("readinessName", "AIRA Enterprise Application Factory Foundation");
        response.put("capabilityCount", capabilities);
        response.put("templateCount", templates);
        response.put("generatorCount", generators);
        response.put("orchestrationStepCount", steps);
        response.put("acceptanceGateCount", gates);
        response.put("productionProfileCount", profiles);
        response.put("applicationFactoryReady", ready);
        response.put("failClosed", true);
        response.put("checkedAt", OffsetDateTime.now());
        return response;
    }

    public List<Map<String, Object>> capabilities() {
        return jdbcTemplate.queryForList(
                "SELECT capability_key, capability_name, capability_category, status, fail_closed, requires_human_approval, evidence_required " +
                "FROM aira_factory.application_factory_capability ORDER BY capability_category, capability_key"
        );
    }

    public List<Map<String, Object>> templates() {
        return jdbcTemplate.queryForList(
                "SELECT template_key, template_name, template_category, runtime_stack, database_stack, frontend_stack, security_profile, production_profile_ready, status, fail_closed " +
                "FROM aira_factory.project_template ORDER BY template_key"
        );
    }

    public List<Map<String, Object>> generators() {
        return jdbcTemplate.queryForList(
                "SELECT generator_key, generator_name, generator_type, target_artifact, output_path_pattern, governed_by_agent, requires_approval, evidence_required, status, fail_closed " +
                "FROM aira_factory.blueprint_to_code_generator ORDER BY generator_key"
        );
    }

    public List<Map<String, Object>> orchestrationSteps() {
        return jdbcTemplate.queryForList(
                "SELECT step_key, step_order, step_name, responsible_agent, input_artifact, output_artifact, requires_human_approval, requires_evidence, fail_closed, status " +
                "FROM aira_factory.application_factory_orchestration_step ORDER BY step_order"
        );
    }

    public List<Map<String, Object>> acceptanceGates() {
        return jdbcTemplate.queryForList(
                "SELECT gate_key, gate_name, gate_category, gate_description, required, fail_closed, status " +
                "FROM aira_factory.application_factory_acceptance_gate ORDER BY gate_key"
        );
    }

    public List<Map<String, Object>> productionProfiles() {
        return jdbcTemplate.queryForList(
                "SELECT profile_key, profile_name, environment_type, runtime_policy, security_policy, evidence_policy, approval_policy, rollback_policy, status, fail_closed " +
                "FROM aira_factory.production_environment_profile ORDER BY profile_key"
        );
    }

    public List<Map<String, Object>> blueprintRequests() {
        return jdbcTemplate.queryForList(
                "SELECT request_key, application_name, business_domain, requested_template_key, requested_by, request_status, " +
                "architecture_ready, database_ready, api_contract_ready, frontend_ready, tests_ready, evidence_ready, approval_ready, production_profile_ready, fail_closed " +
                "FROM aira_factory.application_blueprint_request ORDER BY created_at DESC"
        );
    }

    private int count(String sql) {
        Integer result = jdbcTemplate.queryForObject(sql, Integer.class);
        return result == null ? 0 : result;
    }
}