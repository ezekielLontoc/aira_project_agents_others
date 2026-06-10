package com.aira.accelerator.security.service;

import com.aira.accelerator.security.model.AiraPermission;
import com.aira.accelerator.security.model.AiraRole;
import com.aira.accelerator.security.model.SecurityPolicy;
import org.springframework.stereotype.Service;

import java.util.Arrays;
import java.util.List;
import java.util.Map;

@Service
public class SecurityCatalogService {

    public List<String> roles() {
        return Arrays.stream(AiraRole.values()).map(Enum::name).toList();
    }

    public List<String> permissions() {
        return Arrays.stream(AiraPermission.values()).map(Enum::name).toList();
    }

    public List<SecurityPolicy> policies() {
        return List.of(
                new SecurityPolicy("POL-SEC-001", "Human Approval Required", "Production-impacting actions require explicit human approval.", true),
                new SecurityPolicy("POL-SEC-002", "Evidence Required", "Security-sensitive actions must generate traceable evidence.", true),
                new SecurityPolicy("POL-SEC-003", "API Key Governance", "API keys must have owner, purpose, and rotation metadata.", true)
        );
    }

    public Map<String, Object> currentUser() {
        return Map.of(
                "subject", "local-aira-operator",
                "roles", List.of("PLATFORM_ADMIN", "SECURITY_ADMIN"),
                "permissions", permissions(),
                "mode", "LOCAL_SCAFFOLD"
        );
    }
}