package com.aira.accelerator.governance.security;

import org.springframework.stereotype.Component;

@Component
public class ApiSecurityProperties {

    public String serviceName() {
        return "accelerator-governance";
    }

    public String localDevelopmentApiKey() {
        String configured = System.getenv("AIRA_SECURITY_LOCAL_API_KEY");

        if (configured == null || configured.isBlank()) {
            return "aira-local-dev-key-change-me";
        }

        return configured;
    }
}