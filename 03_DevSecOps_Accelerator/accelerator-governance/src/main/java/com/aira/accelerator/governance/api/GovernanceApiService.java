package com.aira.accelerator.governance.api;

import java.time.OffsetDateTime;
import java.util.List;
import java.util.Map;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

@Service
public class GovernanceApiService {

    private final JdbcTemplate jdbcTemplate;

    public GovernanceApiService(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public List<Map<String, Object>> listControlGates() {
        return jdbcTemplate.queryForList(
                "SELECT " +
                "gate_key, gate_name, gate_category, purpose, blocking_rule, required_for, " +
                "owner, is_mandatory, fail_closed, created_at " +
                "FROM aira_governance.control_gate " +
                "ORDER BY gate_key"
        );
    }

    public List<Map<String, Object>> listGovernanceDecisions() {
        return jdbcTemplate.queryForList(
                "SELECT " +
                "decision_key, change_key, decision_type, decision_title, decision_summary, " +
                "decision_status, approver, approval_required, evidence_required, evidence_reference, " +
                "adr_reference, created_at, decided_at " +
                "FROM aira_governance.governance_decision " +
                "ORDER BY created_at DESC"
        );
    }

    public List<Map<String, Object>> listChangeRequests() {
        return jdbcTemplate.queryForList(
                "SELECT " +
                "change_key, title, description, requested_by, business_owner, technical_owner, " +
                "risk_level, status, source_reference, created_at, updated_at " +
                "FROM aira_governance.change_request " +
                "ORDER BY created_at DESC"
        );
    }

    public List<Map<String, Object>> listApprovals() {
        return jdbcTemplate.queryForList(
                "SELECT " +
                "approval_key, change_key, approval_type, approval_status, requested_by, approver, " +
                "approval_reason, evidence_reference, approved_at, created_at " +
                "FROM aira_governance.approval_record " +
                "ORDER BY created_at DESC"
        );
    }

    public GovernanceReadinessResponse readiness() {
        int controlGates = count("SELECT COUNT(*) FROM aira_governance.control_gate WHERE is_mandatory = TRUE AND fail_closed = TRUE");
        int activeAgents = count("SELECT COUNT(*) FROM aira_agents.agent_definition WHERE status = 'Active'");
        int approvedPromptVersions = count("SELECT COUNT(*) FROM aira_agents.agent_prompt_version WHERE approval_status = 'Approved'");
        int approvedModelVersions = count("SELECT COUNT(*) FROM aira_agents.agent_model_version WHERE approval_status = 'Approved' AND approved_for_use = TRUE");
        int evidencePacks = count("SELECT COUNT(*) FROM aira_evidence.runtime_evidence_pack");
        int secretControls = count("SELECT COUNT(*) FROM aira_security.secret_control_record WHERE secret_value_stored = FALSE AND agent_direct_access_allowed = FALSE");

        boolean architectureGateReady = gateExists("ARCHITECTURE_GATE");
        boolean securityGateReady = gateExists("SECURITY_GATE");
        boolean testGateReady = gateExists("TEST_GATE");
        boolean evidenceGateReady = gateExists("EVIDENCE_GATE");
        boolean approvalGateReady = gateExists("APPROVAL_GATE");

        boolean ready =
                controlGates >= 10
                && activeAgents >= 8
                && approvedPromptVersions >= 8
                && approvedModelVersions >= 8
                && evidencePacks >= 1
                && secretControls >= 2
                && architectureGateReady
                && securityGateReady
                && testGateReady
                && evidenceGateReady
                && approvalGateReady;

        return new GovernanceReadinessResponse(
                ready ? "UP" : "BLOCKED",
                controlGates,
                activeAgents,
                approvedPromptVersions,
                approvedModelVersions,
                evidencePacks,
                secretControls,
                architectureGateReady,
                securityGateReady,
                testGateReady,
                evidenceGateReady,
                approvalGateReady,
                true,
                OffsetDateTime.now()
        );
    }

    private boolean gateExists(String gateKey) {
        Integer result = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM aira_governance.control_gate WHERE gate_key = ? AND is_mandatory = TRUE AND fail_closed = TRUE",
                Integer.class,
                gateKey
        );

        return result != null && result > 0;
    }

    private int count(String sql) {
        Integer result = jdbcTemplate.queryForObject(sql, Integer.class);
        return result == null ? 0 : result;
    }
}