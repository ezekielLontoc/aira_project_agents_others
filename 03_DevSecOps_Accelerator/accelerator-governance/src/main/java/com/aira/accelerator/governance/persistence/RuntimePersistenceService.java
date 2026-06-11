package com.aira.accelerator.governance.persistence;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.time.OffsetDateTime;
import java.util.LinkedHashMap;
import java.util.Map;

import javax.sql.DataSource;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

@Service
public class RuntimePersistenceService {

    private final JdbcTemplate jdbcTemplate;
    private final DataSource dataSource;
    private final String serviceName;

    public RuntimePersistenceService(
            JdbcTemplate jdbcTemplate,
            DataSource dataSource
    ) {
        this.jdbcTemplate = jdbcTemplate;
        this.dataSource = dataSource;
        this.serviceName = "accelerator-governance";
    }

    public PersistenceHealthResponse health() {
        try {
            String databaseProduct = "unknown";
            String databaseVersion = "unknown";

            try (Connection connection = dataSource.getConnection()) {
                DatabaseMetaData metaData = connection.getMetaData();
                databaseProduct = metaData.getDatabaseProductName();
                databaseVersion = metaData.getDatabaseProductVersion();
            }

            Map<String, Integer> counts = new LinkedHashMap<>();
            counts.put("agentDefinitions", count("SELECT COUNT(*) FROM aira_agents.agent_definition"));
            counts.put("controlGates", count("SELECT COUNT(*) FROM aira_governance.control_gate"));
            counts.put("promptVersions", count("SELECT COUNT(*) FROM aira_agents.agent_prompt_version"));
            counts.put("modelVersions", count("SELECT COUNT(*) FROM aira_agents.agent_model_version"));
            counts.put("evidencePacks", count("SELECT COUNT(*) FROM aira_evidence.runtime_evidence_pack"));
            counts.put("evidenceArtifacts", count("SELECT COUNT(*) FROM aira_evidence.evidence_artifact"));
            counts.put("secretControls", count("SELECT COUNT(*) FROM aira_security.secret_control_record"));
            counts.put("persistenceAuditRecords", count("SELECT COUNT(*) FROM aira_runtime.persistence_audit_record"));

            boolean baselineReady =
                    counts.get("agentDefinitions") >= 8
                    && counts.get("controlGates") >= 10
                    && counts.get("promptVersions") >= 8
                    && counts.get("modelVersions") >= 8
                    && counts.get("evidencePacks") >= 1
                    && counts.get("evidenceArtifacts") >= 4
                    && counts.get("secretControls") >= 2
                    && counts.get("persistenceAuditRecords") >= 1;

            if (!baselineReady) {
                return new PersistenceHealthResponse(
                        "BLOCKED",
                        serviceName,
                        "BASELINE_INCOMPLETE",
                        databaseProduct,
                        databaseVersion,
                        counts,
                        true,
                        OffsetDateTime.now()
                );
            }

            return new PersistenceHealthResponse(
                    "UP",
                    serviceName,
                    "UP",
                    databaseProduct,
                    databaseVersion,
                    counts,
                    true,
                    OffsetDateTime.now()
            );
        }
        catch (Exception exception) {
            Map<String, Integer> counts = new LinkedHashMap<>();

            return new PersistenceHealthResponse(
                    "DOWN",
                    serviceName,
                    "DOWN: " + exception.getClass().getSimpleName(),
                    "unknown",
                    "unknown",
                    counts,
                    true,
                    OffsetDateTime.now()
            );
        }
    }

    private int count(String sql) {
        Integer result = jdbcTemplate.queryForObject(sql, Integer.class);
        return result == null ? 0 : result;
    }
}