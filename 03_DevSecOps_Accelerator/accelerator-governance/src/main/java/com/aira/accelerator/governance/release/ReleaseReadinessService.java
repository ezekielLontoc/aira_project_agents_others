package com.aira.accelerator.governance.release;

import java.time.OffsetDateTime;
import java.util.List;
import java.util.Map;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

@Service
public class ReleaseReadinessService {

    private final JdbcTemplate jdbcTemplate;

    public ReleaseReadinessService(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public ReleaseReadinessResponse readiness() {
        Map<String, Object> release = releaseRecord();

        String releaseKey = String.valueOf(release.get("release_key"));
        String releaseName = String.valueOf(release.get("release_name"));
        String releaseVersion = String.valueOf(release.get("release_version"));
        String releaseStatus = String.valueOf(release.get("release_status"));
        boolean mvpReadyRecord = Boolean.TRUE.equals(release.get("mvp_ready"));

        int activeAgents = count("SELECT COUNT(*) FROM aira_agents.agent_definition WHERE status = 'Active'");
        int controlGates = count("SELECT COUNT(*) FROM aira_governance.control_gate WHERE is_mandatory = TRUE AND fail_closed = TRUE");
        int evidencePacks = count("SELECT COUNT(*) FROM aira_evidence.runtime_evidence_pack");
        int evidenceArtifacts = count("SELECT COUNT(*) FROM aira_evidence.evidence_artifact WHERE contains_secret = FALSE");
        int traceabilityLinks = count("SELECT COUNT(*) FROM aira_evidence.evidence_traceability_link");
        int activeSecretControls = count("SELECT COUNT(*) FROM aira_security.secret_control_record WHERE secret_value_stored = FALSE AND agent_direct_access_allowed = FALSE");
        int qualityGateDefinitions = count("SELECT COUNT(*) FROM aira_runtime.cicd_quality_gate_definition WHERE status = 'Active' AND required = TRUE AND fail_closed = TRUE");
        int passedQualityGateRuns = count("SELECT COUNT(*) FROM aira_runtime.cicd_quality_gate_run WHERE status = 'Passed' AND fail_closed = TRUE");
        int portalReadinessRecords = count("SELECT COUNT(*) FROM aira_runtime.portal_readiness_record WHERE status = 'Active' AND fail_closed = TRUE AND embeds_secret = FALSE");
        int releaseGateResults = count("SELECT COUNT(*) FROM aira_runtime.mvp_release_gate_result WHERE release_key = 'AIRA-MVP-RELEASE-READINESS'");
        int passedReleaseGateResults = count("SELECT COUNT(*) FROM aira_runtime.mvp_release_gate_result WHERE release_key = 'AIRA-MVP-RELEASE-READINESS' AND status = 'Passed' AND fail_closed = TRUE");
        int operatingModelRecords = count("SELECT COUNT(*) FROM aira_runtime.mvp_operating_model_record WHERE release_key = 'AIRA-MVP-RELEASE-READINESS' AND model_status = 'Active' AND fail_closed = TRUE AND human_approval_required = TRUE");
        int rollbackReadinessRecords = count("SELECT COUNT(*) FROM aira_runtime.mvp_rollback_readiness_record WHERE release_key = 'AIRA-MVP-RELEASE-READINESS' AND rollback_status = 'Ready' AND fail_closed = TRUE");
        int acceptanceRecords = count("SELECT COUNT(*) FROM aira_runtime.mvp_acceptance_record WHERE release_key = 'AIRA-MVP-RELEASE-READINESS' AND acceptance_status = 'Accepted' AND human_approval_required = TRUE AND fail_closed = TRUE");

        boolean runtimeReady = qualityGateDefinitions >= 15 && passedQualityGateRuns >= 1;
        boolean persistenceReady = evidencePacks >= 1 && activeSecretControls >= 2;
        boolean securityReady = activeSecretControls >= 2;
        boolean agentRegistryReady = activeAgents >= 8;
        boolean governanceReady = controlGates >= 10;
        boolean evidenceReady = evidencePacks >= 1 && evidenceArtifacts >= 4 && traceabilityLinks >= 4;
        boolean cicdReady = qualityGateDefinitions >= 15 && passedQualityGateRuns >= 1;
        boolean portalReady = portalReadinessRecords >= 1;
        boolean rollbackReady = rollbackReadinessRecords >= 1;
        boolean operatingModelReady = operatingModelRecords >= 1;
        boolean humanAcceptanceReady = acceptanceRecords >= 1;
        boolean releaseRecordReady = "MVP_READY".equals(releaseStatus) && mvpReadyRecord;

        boolean ready =
                runtimeReady
                && persistenceReady
                && securityReady
                && agentRegistryReady
                && governanceReady
                && evidenceReady
                && cicdReady
                && portalReady
                && rollbackReady
                && operatingModelReady
                && humanAcceptanceReady
                && releaseRecordReady
                && releaseGateResults >= 10
                && passedReleaseGateResults >= 10;

        return new ReleaseReadinessResponse(
                ready ? "UP" : "BLOCKED",
                releaseKey,
                releaseName,
                releaseVersion,
                releaseStatus,
                ready,
                activeAgents,
                controlGates,
                evidencePacks,
                evidenceArtifacts,
                traceabilityLinks,
                activeSecretControls,
                qualityGateDefinitions,
                passedQualityGateRuns,
                portalReadinessRecords,
                releaseGateResults,
                passedReleaseGateResults,
                operatingModelRecords,
                rollbackReadinessRecords,
                acceptanceRecords,
                runtimeReady,
                persistenceReady,
                securityReady,
                agentRegistryReady,
                governanceReady,
                evidenceReady,
                cicdReady,
                portalReady,
                rollbackReady,
                operatingModelReady,
                humanAcceptanceReady,
                true,
                OffsetDateTime.now()
        );
    }

    public List<Map<String, Object>> releaseGateResults() {
        return jdbcTemplate.queryForList(
                "SELECT " +
                "release_key, gate_key, gate_name, gate_category, status, result_summary, " +
                "source_reference, fail_closed, created_at " +
                "FROM aira_runtime.mvp_release_gate_result " +
                "WHERE release_key = 'AIRA-MVP-RELEASE-READINESS' " +
                "ORDER BY gate_category, gate_key"
        );
    }

    public List<Map<String, Object>> operatingModel() {
        return jdbcTemplate.queryForList(
                "SELECT " +
                "operating_model_key, release_key, model_name, model_status, operating_principles, " +
                "support_model, escalation_model, change_control_model, evidence_model, rollback_model, " +
                "human_approval_required, fail_closed, evidence_reference, created_at " +
                "FROM aira_runtime.mvp_operating_model_record " +
                "WHERE release_key = 'AIRA-MVP-RELEASE-READINESS' " +
                "ORDER BY created_at DESC"
        );
    }

    public List<Map<String, Object>> rollbackReadiness() {
        return jdbcTemplate.queryForList(
                "SELECT " +
                "rollback_key, release_key, rollback_status, rollback_strategy, rollback_owner, " +
                "validation_method, evidence_reference, fail_closed, created_at " +
                "FROM aira_runtime.mvp_rollback_readiness_record " +
                "WHERE release_key = 'AIRA-MVP-RELEASE-READINESS' " +
                "ORDER BY created_at DESC"
        );
    }

    private Map<String, Object> releaseRecord() {
        List<Map<String, Object>> rows = jdbcTemplate.queryForList(
                "SELECT " +
                "release_key, release_name, release_version, release_status, mvp_ready " +
                "FROM aira_runtime.mvp_release_readiness_record " +
                "WHERE release_key = 'AIRA-MVP-RELEASE-READINESS'"
        );

        if (rows.isEmpty()) {
            throw new IllegalStateException("AIRA MVP release readiness record is missing.");
        }

        return rows.get(0);
    }

    private int count(String sql) {
        Integer result = jdbcTemplate.queryForObject(sql, Integer.class);
        return result == null ? 0 : result;
    }
}