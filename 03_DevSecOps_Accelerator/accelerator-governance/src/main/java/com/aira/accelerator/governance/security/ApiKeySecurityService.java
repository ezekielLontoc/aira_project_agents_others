package com.aira.accelerator.governance.security;

import java.util.List;
import java.util.Map;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

@Service
public class ApiKeySecurityService {

    private final JdbcTemplate jdbcTemplate;
    private final ApiSecurityProperties apiSecurityProperties;
    private final ApiSecurityAuditService apiSecurityAuditService;

    public ApiKeySecurityService(
            JdbcTemplate jdbcTemplate,
            ApiSecurityProperties apiSecurityProperties,
            ApiSecurityAuditService apiSecurityAuditService
    ) {
        this.jdbcTemplate = jdbcTemplate;
        this.apiSecurityProperties = apiSecurityProperties;
        this.apiSecurityAuditService = apiSecurityAuditService;
    }

    public ApiSecurityDecision validate(String apiKey, String path, String method) {
        String serviceName = apiSecurityProperties.serviceName();

        if (apiKey == null || apiKey.isBlank()) {
            apiSecurityAuditService.record(serviceName, path, method, null, "DENY", "Missing X-AIRA-API-Key header", true);
            return new ApiSecurityDecision(false, "DENY", "Missing X-AIRA-API-Key header", null, true);
        }

        if (!apiKey.equals(apiSecurityProperties.localDevelopmentApiKey())) {
            apiSecurityAuditService.record(serviceName, path, method, "unknown", "DENY", "Invalid API key", true);
            return new ApiSecurityDecision(false, "DENY", "Invalid API key", "unknown", true);
        }

        try {
            List<Map<String, Object>> rows = jdbcTemplate.queryForList(
                    "SELECT api_key_label, allowed_path_prefix, can_read, status, fail_closed " +
                    "FROM aira_security.api_key_access_policy " +
                    "WHERE api_key_id = ? " +
                    "AND allowed_service = ? " +
                    "AND status = 'Active'",
                    apiKey,
                    serviceName
            );

            for (Map<String, Object> row : rows) {
                String prefix = String.valueOf(row.get("allowed_path_prefix"));
                boolean canRead = Boolean.TRUE.equals(row.get("can_read"));

                if (path.startsWith(prefix) && "GET".equalsIgnoreCase(method) && canRead) {
                    String principalLabel = String.valueOf(row.get("api_key_label"));
                    apiSecurityAuditService.record(serviceName, path, method, principalLabel, "ALLOW", "API key policy allowed read access", true);
                    return new ApiSecurityDecision(true, "ALLOW", "API key policy allowed read access", principalLabel, true);
                }
            }

            apiSecurityAuditService.record(serviceName, path, method, "Local Development API Key", "DENY", "No matching active API key access policy", true);
            return new ApiSecurityDecision(false, "DENY", "No matching active API key access policy", "Local Development API Key", true);
        }
        catch (Exception exception) {
            apiSecurityAuditService.record(serviceName, path, method, "unknown", "DENY", "Security validation failed closed", true);
            return new ApiSecurityDecision(false, "DENY", "Security validation failed closed", "unknown", true);
        }
    }
}