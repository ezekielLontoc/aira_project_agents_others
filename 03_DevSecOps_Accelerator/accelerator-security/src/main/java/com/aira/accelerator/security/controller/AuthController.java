package com.aira.accelerator.security.controller;

import com.aira.accelerator.security.dto.AuthTokenRequest;
import com.aira.accelerator.security.service.SecurityCatalogService;
import jakarta.validation.Valid;

import java.time.Instant;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.UUID;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class AuthController {

    private final SecurityCatalogService securityCatalogService;

    public AuthController(SecurityCatalogService securityCatalogService) {
        this.securityCatalogService = securityCatalogService;
    }

    @PostMapping("/api/v1/auth/token")
    public Map<String, Object> issueToken(@Valid @RequestBody AuthTokenRequest request) {
        Map<String, Object> response = new LinkedHashMap<>();
        response.put("status", "ISSUED_PLACEHOLDER");
        response.put("subject", request.getSubject());
        response.put("requestedRole", request.getRequestedRole());
        response.put("tokenType", "AIRA_LOCAL_PLACEHOLDER");
        response.put("token", "aira-local-" + UUID.randomUUID());
        response.put("productionUseAllowed", false);
        response.put("timestamp", Instant.now().toString());
        return response;
    }

    @GetMapping("/api/v1/auth/me")
    public Map<String, Object> me() {
        Map<String, Object> response = new LinkedHashMap<>();
        response.put("status", "OK");
        response.put("user", securityCatalogService.currentUser());
        response.put("timestamp", Instant.now().toString());
        return response;
    }
}