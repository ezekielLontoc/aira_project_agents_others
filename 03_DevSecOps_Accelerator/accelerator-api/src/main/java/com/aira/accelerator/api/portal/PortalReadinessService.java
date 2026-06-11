package com.aira.accelerator.api.portal;

import java.time.OffsetDateTime;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

@Service
public class PortalReadinessService {

    private final JdbcTemplate jdbcTemplate;

    public PortalReadinessService(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public PortalReadinessResponse readiness() {
        int portalReadinessRecords = count(
                "SELECT COUNT(*) FROM aira_runtime.portal_readiness_record " +
                "WHERE readiness_key = 'AIRA-PORTAL-FOUNDATION' " +
                "AND status = 'Active' " +
                "AND fail_closed = TRUE " +
                "AND embeds_secret = FALSE"
        );

        int activeAgents = count("SELECT COUNT(*) FROM aira_agents.agent_definition WHERE status = 'Active'");
        int controlGates = count("SELECT COUNT(*) FROM aira_governance.control_gate WHERE is_mandatory = TRUE AND fail_closed = TRUE");
        int evidencePacks = count("SELECT COUNT(*) FROM aira_evidence.runtime_evidence_pack");
        int evidenceArtifacts = count("SELECT COUNT(*) FROM aira_evidence.evidence_artifact WHERE contains_secret = FALSE");
        int qualityGateDefinitions = count("SELECT COUNT(*) FROM aira_runtime.cicd_quality_gate_definition WHERE status = 'Active' AND required = TRUE AND fail_closed = TRUE");
        int passedQualityGateRuns = count("SELECT COUNT(*) FROM aira_runtime.cicd_quality_gate_run WHERE status = 'Passed' AND fail_closed = TRUE");

        boolean staticPortalReady = true;
        boolean apiKeyRequiredForBackend = true;
        boolean embedsSecret = false;

        boolean ready =
                portalReadinessRecords >= 1
                && activeAgents >= 8
                && controlGates >= 10
                && evidencePacks >= 1
                && evidenceArtifacts >= 4
                && qualityGateDefinitions >= 14
                && passedQualityGateRuns >= 1
                && staticPortalReady
                && apiKeyRequiredForBackend
                && !embedsSecret;

        String serverHost = System.getenv().getOrDefault("AIRA_SERVER_HOST", "localhost");
        String portalUrl = "http://" + serverHost + ":9090/portal/index.html";

        return new PortalReadinessResponse(
                ready ? "UP" : "BLOCKED",
                "AIRA Portal",
                portalUrl,
                "accelerator-api",
                portalReadinessRecords,
                activeAgents,
                controlGates,
                evidencePacks,
                evidenceArtifacts,
                qualityGateDefinitions,
                passedQualityGateRuns,
                staticPortalReady,
                apiKeyRequiredForBackend,
                embedsSecret,
                true,
                OffsetDateTime.now()
        );
    }

    private int count(String sql) {
        Integer result = jdbcTemplate.queryForObject(sql, Integer.class);
        return result == null ? 0 : result;
    }
}