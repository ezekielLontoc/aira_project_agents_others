package com.aira.accelerator.security.controller;

import com.aira.accelerator.security.service.SecurityCatalogService;

import java.time.Instant;
import java.util.LinkedHashMap;
import java.util.Map;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class PolicyController {

    private final SecurityCatalogService securityCatalogService;

    public PolicyController(SecurityCatalogService securityCatalogService) {
        this.securityCatalogService = securityCatalogService;
    }

    @GetMapping("/api/v1/policies")
    public Map<String, Object> policies() {
        Map<String, Object> response = new LinkedHashMap<>();
        response.put("status", "OK");
        response.put("policies", securityCatalogService.policies());
        response.put("timestamp", Instant.now().toString());
        return response;
    }

    @GetMapping("/api/v1/roles")
    public Map<String, Object> roles() {
        Map<String, Object> response = new LinkedHashMap<>();
        response.put("status", "OK");
        response.put("roles", securityCatalogService.roles());
        response.put("permissions", securityCatalogService.permissions());
        response.put("timestamp", Instant.now().toString());
        return response;
    }
}