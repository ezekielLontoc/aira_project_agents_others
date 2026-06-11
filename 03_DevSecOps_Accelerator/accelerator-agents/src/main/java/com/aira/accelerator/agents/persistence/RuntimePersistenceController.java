package com.aira.accelerator.agents.persistence;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class RuntimePersistenceController {

    private final RuntimePersistenceService runtimePersistenceService;

    public RuntimePersistenceController(RuntimePersistenceService runtimePersistenceService) {
        this.runtimePersistenceService = runtimePersistenceService;
    }

    @GetMapping("/api/persistence/health")
    public ResponseEntity<PersistenceHealthResponse> health() {
        PersistenceHealthResponse response = runtimePersistenceService.health();

        if ("UP".equals(response.status())) {
            return ResponseEntity.ok(response);
        }

        return ResponseEntity.status(HttpStatus.SERVICE_UNAVAILABLE).body(response);
    }
}