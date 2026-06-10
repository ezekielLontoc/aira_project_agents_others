package com.aira.accelerator.evidence.controller;

import java.time.Instant;
import java.util.LinkedHashMap;
import java.util.Map;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class RuntimeInfoController {

    @GetMapping("/api/runtime/info")
    public Map<String, Object> runtimeInfo() {
        Map<String, Object> response = new LinkedHashMap<>();
        response.put("runtime", "AIRA DevSecOps Accelerator");
        response.put("module", "accelerator-evidence");
        response.put("version", "0.1.0-SNAPSHOT");
        response.put("port", 9093);
        response.put("approvalRequiredForProduction", true);
        response.put("timestamp", Instant.now().toString());
        return response;
    }
}
