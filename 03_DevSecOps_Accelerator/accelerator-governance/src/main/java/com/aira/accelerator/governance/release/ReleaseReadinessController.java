package com.aira.accelerator.governance.release;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class ReleaseReadinessController {

    private final ReleaseReadinessService releaseReadinessService;

    public ReleaseReadinessController(ReleaseReadinessService releaseReadinessService) {
        this.releaseReadinessService = releaseReadinessService;
    }

    @GetMapping("/api/v1/governance/release/readiness")
    public ResponseEntity<ReleaseReadinessResponse> readiness() {
        ReleaseReadinessResponse response = releaseReadinessService.readiness();

        if ("UP".equals(response.status())) {
            return ResponseEntity.ok(response);
        }

        return ResponseEntity.status(HttpStatus.SERVICE_UNAVAILABLE).body(response);
    }

    @GetMapping("/api/v1/governance/release/gates")
    public ResponseEntity<?> releaseGateResults() {
        return ResponseEntity.ok(releaseReadinessService.releaseGateResults());
    }

    @GetMapping("/api/v1/governance/release/operating-model")
    public ResponseEntity<?> operatingModel() {
        return ResponseEntity.ok(releaseReadinessService.operatingModel());
    }

    @GetMapping("/api/v1/governance/release/rollback")
    public ResponseEntity<?> rollbackReadiness() {
        return ResponseEntity.ok(releaseReadinessService.rollbackReadiness());
    }
}