package com.aira.accelerator.security.dto;

import jakarta.validation.constraints.NotBlank;

public class ApiKeyRequest {

    @NotBlank
    private String owner;

    @NotBlank
    private String purpose;

    public String getOwner() {
        return owner;
    }

    public void setOwner(String owner) {
        this.owner = owner;
    }

    public String getPurpose() {
        return purpose;
    }

    public void setPurpose(String purpose) {
        this.purpose = purpose;
    }
}