package com.aira.accelerator.evidence.api;

import java.time.OffsetDateTime;
import java.util.List;
import java.util.Map;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

@Service
public class EvidenceRuntimeService {

    private final JdbcTemplate jdbcTemplate;

    public EvidenceRuntimeService(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public List<Map<String, Object>> listEvidencePacks() {
        return jdbcTemplate.queryForList(
                "SELECT " +
                "evidence_pack_key, change_key, release_key, title, summary, evidence_status, " +
                "created_by, reviewed_by, accepted_by, accepted_at, created_at " +
                "FROM aira_evidence.runtime_evidence_pack " +
                "ORDER BY created_at DESC"
        );
    }

    public Map<String, Object> getEvidencePack(String evidencePackKey) {
        List<Map<String, Object>> rows = jdbcTemplate.queryForList(
                "SELECT " +
                "evidence_pack_key, change_key, release_key, title, summary, evidence_status, " +
                "created_by, reviewed_by, accepted_by, accepted_at, created_at " +
                "FROM aira_evidence.runtime_evidence_pack " +
                "WHERE evidence_pack_key = ?",
                evidencePackKey
        );

        if (rows.isEmpty()) {
            throw new EvidenceNotFoundException("Evidence pack not found: " + evidencePackKey);
        }

        return rows.get(0);
    }

    public List<Map<String, Object>> listArtifacts() {
        return jdbcTemplate.queryForList(
                "SELECT " +
                "evidence_pack_key, artifact_key, artifact_type, artifact_title, artifact_reference, " +
                "source_system, produced_by_agent, immutable_reference, risk_level, contains_secret, created_at " +
                "FROM aira_evidence.evidence_artifact " +
                "ORDER BY created_at DESC, artifact_key"
        );
    }

    public List<Map<String, Object>> listArtifactsForPack(String evidencePackKey) {
        assertEvidencePackExists(evidencePackKey);

        return jdbcTemplate.queryForList(
                "SELECT " +
                "evidence_pack_key, artifact_key, artifact_type, artifact_title, artifact_reference, " +
                "source_system, produced_by_agent, immutable_reference, risk_level, contains_secret, created_at " +
                "FROM aira_evidence.evidence_artifact " +
                "WHERE evidence_pack_key = ? " +
                "ORDER BY artifact_key",
                evidencePackKey
        );
    }

    public List<Map<String, Object>> listTraceabilityLinks() {
        return jdbcTemplate.queryForList(
                "SELECT " +
                "link_key, evidence_pack_key, source_type, source_reference, target_type, " +
                "target_reference, relationship_type, created_at " +
                "FROM aira_evidence.evidence_traceability_link " +
                "ORDER BY created_at DESC, link_key"
        );
    }

    public List<Map<String, Object>> listRuntimeAuditRecords() {
        return jdbcTemplate.queryForList(
                "SELECT " +
                "audit_key, evidence_pack_key, action_type, action_summary, actor, decision, " +
                "fail_closed, evidence_reference, created_at " +
                "FROM aira_evidence.evidence_runtime_audit_record " +
                "ORDER BY created_at DESC"
        );
    }

    public List<Map<String, Object>> listSecurityAuditEvents() {
        return jdbcTemplate.queryForList(
                "SELECT " +
                "service_name, request_path, request_method, principal_label, decision, reason, " +
                "fail_closed, created_at " +
                "FROM aira_security.api_security_audit_event " +
                "ORDER BY created_at DESC " +
                "LIMIT 100"
        );
    }

    public EvidenceReadinessResponse readiness() {
        int evidencePacks = count("SELECT COUNT(*) FROM aira_evidence.runtime_evidence_pack");
        int evidenceArtifacts = count("SELECT COUNT(*) FROM aira_evidence.evidence_artifact WHERE contains_secret = FALSE");
        int traceabilityLinks = count("SELECT COUNT(*) FROM aira_evidence.evidence_traceability_link");
        int runtimeAuditRecords = count("SELECT COUNT(*) FROM aira_evidence.evidence_runtime_audit_record");
        int securityAuditEvents = count("SELECT COUNT(*) FROM aira_security.api_security_audit_event");
        int activeEvidencePolicies = count("SELECT COUNT(*) FROM aira_security.api_key_access_policy WHERE allowed_service = 'accelerator-evidence' AND status = 'Active' AND fail_closed = TRUE");

        boolean evidencePackReady = evidencePacks >= 1;
        boolean artifactReady = evidenceArtifacts >= 4;
        boolean traceabilityReady = traceabilityLinks >= 1;
        boolean runtimeAuditReady = runtimeAuditRecords >= 1;
        boolean securityPolicyReady = activeEvidencePolicies >= 1;

        boolean ready =
                evidencePackReady
                && artifactReady
                && traceabilityReady
                && runtimeAuditReady
                && securityPolicyReady;

        return new EvidenceReadinessResponse(
                ready ? "UP" : "BLOCKED",
                evidencePacks,
                evidenceArtifacts,
                traceabilityLinks,
                runtimeAuditRecords,
                securityAuditEvents,
                activeEvidencePolicies,
                evidencePackReady,
                artifactReady,
                traceabilityReady,
                runtimeAuditReady,
                securityPolicyReady,
                true,
                OffsetDateTime.now()
        );
    }

    private void assertEvidencePackExists(String evidencePackKey) {
        Integer count = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM aira_evidence.runtime_evidence_pack WHERE evidence_pack_key = ?",
                Integer.class,
                evidencePackKey
        );

        if (count == null || count == 0) {
            throw new EvidenceNotFoundException("Evidence pack not found: " + evidencePackKey);
        }
    }

    private int count(String sql) {
        Integer result = jdbcTemplate.queryForObject(sql, Integer.class);
        return result == null ? 0 : result;
    }
}