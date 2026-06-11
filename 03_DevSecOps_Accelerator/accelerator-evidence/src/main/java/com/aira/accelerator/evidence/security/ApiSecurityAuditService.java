package com.aira.accelerator.evidence.security;

import java.util.UUID;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

@Service
public class ApiSecurityAuditService {

    private final JdbcTemplate jdbcTemplate;

    public ApiSecurityAuditService(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public void record(
            String serviceName,
            String path,
            String method,
            String principalLabel,
            String decision,
            String reason,
            boolean failClosed
    ) {
        try {
            jdbcTemplate.update(
                    "INSERT INTO aira_security.api_security_audit_event " +
                    "(event_key, service_name, request_path, request_method, principal_label, decision, reason, fail_closed) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
                    UUID.randomUUID().toString(),
                    serviceName,
                    path,
                    method,
                    principalLabel,
                    decision,
                    reason,
                    failClosed
            );
        }
        catch (Exception ignored) {
            // Audit write failures must not expose internal details to callers.
        }
    }
}