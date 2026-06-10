package com.aira.accelerator.security.model;

public class SecurityPolicy {

    private String policyId;
    private String name;
    private String description;
    private boolean enabled;

    public SecurityPolicy() {
    }

    public SecurityPolicy(String policyId, String name, String description, boolean enabled) {
        this.policyId = policyId;
        this.name = name;
        this.description = description;
        this.enabled = enabled;
    }

    public String getPolicyId() {
        return policyId;
    }

    public String getName() {
        return name;
    }

    public String getDescription() {
        return description;
    }

    public boolean isEnabled() {
        return enabled;
    }
}