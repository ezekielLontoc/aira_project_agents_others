package com.aira.accelerator.security.controller;

import java.time.Instant;
import java.util.LinkedHashMap;
import java.util.Map;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class SecurityHealthController {

    @GetMapping("/api/v1/security/health")
    public Map<String, Object> health() {
        Map<String, Object> response = new LinkedHashMap<>();
        response.put("status", "UP");
        response.put("module", "accelerator-security");
        response.put("port", 9091);
        response.put("timestamp", Instant.now().toString());
        return response;
    }
}