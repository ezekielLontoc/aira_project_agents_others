package com.aira.accelerator.security.controller;

import com.aira.accelerator.security.dto.ApiKeyRequest;
import jakarta.validation.Valid;

import java.time.Instant;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class ApiKeyController {

    @PostMapping("/api/v1/api-keys")
    public Map<String, Object> createApiKey(@Valid @RequestBody ApiKeyRequest request) {
        Map<String, Object> response = new LinkedHashMap<>();
        response.put("status", "CREATED_PLACEHOLDER");
        response.put("apiKeyId", "key-" + UUID.randomUUID());
        response.put("owner", request.getOwner());
        response.put("purpose", request.getPurpose());
        response.put("secretReturnedOnce", "aira-placeholder-secret-not-for-production");
        response.put("productionUseAllowed", false);
        response.put("timestamp", Instant.now().toString());
        return response;
    }

    @GetMapping("/api/v1/api-keys")
    public Map<String, Object> listApiKeys() {
        Map<String, Object> response = new LinkedHashMap<>();
        response.put("status", "OK");
        response.put("apiKeys", List.of(
                Map.of(
                        "apiKeyId", "key-local-placeholder",
                        "owner", "AIRA Platform Team",
                        "purpose", "Local scaffold validation",
                        "active", true,
                        "productionUseAllowed", false
                )
        ));
        response.put("timestamp", Instant.now().toString());
        return response;
    }

    @DeleteMapping("/api/v1/api-keys/{id}")
    public Map<String, Object> revokeApiKey(@PathVariable String id) {
        Map<String, Object> response = new LinkedHashMap<>();
        response.put("status", "REVOKED_PLACEHOLDER");
        response.put("apiKeyId", id);
        response.put("timestamp", Instant.now().toString());
        return response;
    }
}