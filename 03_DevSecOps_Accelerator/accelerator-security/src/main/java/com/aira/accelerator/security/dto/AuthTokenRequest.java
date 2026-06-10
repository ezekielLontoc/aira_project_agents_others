package com.aira.accelerator.security.dto;

import jakarta.validation.constraints.NotBlank;

public class AuthTokenRequest {

    @NotBlank
    private String subject;

    @NotBlank
    private String requestedRole;

    public String getSubject() {
        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }

    public String getRequestedRole() {
        return requestedRole;
    }

    public void setRequestedRole(String requestedRole) {
        this.requestedRole = requestedRole;
    }
}