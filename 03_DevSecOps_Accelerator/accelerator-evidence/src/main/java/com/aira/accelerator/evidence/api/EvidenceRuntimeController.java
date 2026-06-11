package com.aira.accelerator.evidence.api;

import java.time.OffsetDateTime;
import java.util.LinkedHashMap;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class EvidenceRuntimeController {

    private final EvidenceRuntimeService evidenceRuntimeService;

    public EvidenceRuntimeController(EvidenceRuntimeService evidenceRuntimeService) {
        this.evidenceRuntimeService = evidenceRuntimeService;
    }

    @GetMapping("/api/v1/evidence/packs")
    public ResponseEntity<?> listEvidencePacks() {
        return ResponseEntity.ok(evidenceRuntimeService.listEvidencePacks());
    }

    @GetMapping("/api/v1/evidence/packs/{evidencePackKey}")
    public ResponseEntity<?> getEvidencePack(@PathVariable String evidencePackKey) {
        return ResponseEntity.ok(evidenceRuntimeService.getEvidencePack(evidencePackKey));
    }

    @GetMapping("/api/v1/evidence/packs/{evidencePackKey}/artifacts")
    public ResponseEntity<?> listArtifactsForPack(@PathVariable String evidencePackKey) {
        return ResponseEntity.ok(evidenceRuntimeService.listArtifactsForPack(evidencePackKey));
    }

    @GetMapping("/api/v1/evidence/artifacts")
    public ResponseEntity<?> listArtifacts() {
        return ResponseEntity.ok(evidenceRuntimeService.listArtifacts());
    }

    @GetMapping("/api/v1/evidence/traceability")
    public ResponseEntity<?> listTraceabilityLinks() {
        return ResponseEntity.ok(evidenceRuntimeService.listTraceabilityLinks());
    }

    @GetMapping("/api/v1/evidence/runtime-audit")
    public ResponseEntity<?> listRuntimeAuditRecords() {
        return ResponseEntity.ok(evidenceRuntimeService.listRuntimeAuditRecords());
    }

    @GetMapping("/api/v1/evidence/security-audit")
    public ResponseEntity<?> listSecurityAuditEvents() {
        return ResponseEntity.ok(evidenceRuntimeService.listSecurityAuditEvents());
    }

    @GetMapping("/api/v1/evidence/readiness")
    public ResponseEntity<EvidenceReadinessResponse> readiness() {
        EvidenceReadinessResponse response = evidenceRuntimeService.readiness();

        if ("UP".equals(response.status())) {
            return ResponseEntity.ok(response);
        }

        return ResponseEntity.status(HttpStatus.SERVICE_UNAVAILABLE).body(response);
    }

    @ExceptionHandler(EvidenceNotFoundException.class)
    public ResponseEntity<Map<String, Object>> handleNotFound(EvidenceNotFoundException exception) {
        Map<String, Object> body = new LinkedHashMap<>();
        body.put("status", "NOT_FOUND");
        body.put("message", exception.getMessage());
        body.put("timestamp", OffsetDateTime.now());
        body.put("failClosed", true);

        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(body);
    }
}