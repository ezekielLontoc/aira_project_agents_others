package com.aira.accelerator.governance.controller;

import java.time.Instant;
import java.util.LinkedHashMap;
import java.util.Map;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HealthController {

    @GetMapping("/api/health")
    public Map<String, Object> health() {
        Map<String, Object> response = new LinkedHashMap<>();
        response.put("status", "UP");
        response.put("module", "accelerator-governance");
        response.put("port", 9092);
        response.put("timestamp", Instant.now().toString());
        return response;
    }
}
