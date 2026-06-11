package com.aira.accelerator.governance.security;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component
public class ApiSecurityProperties {

    private final String serviceName;
    private final String localDevelopmentApiKey;

    public ApiSecurityProperties(
            @Value("$\{spring.application.name:accelerator-governance}") String serviceName,
            @Value("$\{aira.security.local-api-key:aira-local-dev-key-change-me}") String localDevelopmentApiKey
    ) {
        this.serviceName = serviceName;
        this.localDevelopmentApiKey = localDevelopmentApiKey;
    }

    public String serviceName() {
        return serviceName;
    }

    public String localDevelopmentApiKey() {
        return localDevelopmentApiKey;
    }
}