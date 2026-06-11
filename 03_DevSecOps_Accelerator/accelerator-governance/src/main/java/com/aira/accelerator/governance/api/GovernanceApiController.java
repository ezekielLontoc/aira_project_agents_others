package com.aira.accelerator.governance.api;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class GovernanceApiController {

    private final GovernanceApiService governanceApiService;

    public GovernanceApiController(GovernanceApiService governanceApiService) {
        this.governanceApiService = governanceApiService;
    }

    @GetMapping("/api/v1/governance/control-gates")
    public ResponseEntity<?> listControlGates() {
        return ResponseEntity.ok(governanceApiService.listControlGates());
    }

    @GetMapping("/api/v1/governance/decisions")
    public ResponseEntity<?> listGovernanceDecisions() {
        return ResponseEntity.ok(governanceApiService.listGovernanceDecisions());
    }

    @GetMapping("/api/v1/governance/change-requests")
    public ResponseEntity<?> listChangeRequests() {
        return ResponseEntity.ok(governanceApiService.listChangeRequests());
    }

    @GetMapping("/api/v1/governance/approvals")
    public ResponseEntity<?> listApprovals() {
        return ResponseEntity.ok(governanceApiService.listApprovals());
    }

    @GetMapping("/api/v1/governance/readiness")
    public ResponseEntity<GovernanceReadinessResponse> readiness() {
        GovernanceReadinessResponse response = governanceApiService.readiness();

        if ("UP".equals(response.status())) {
            return ResponseEntity.ok(response);
        }

        return ResponseEntity.status(HttpStatus.SERVICE_UNAVAILABLE).body(response);
    }
}