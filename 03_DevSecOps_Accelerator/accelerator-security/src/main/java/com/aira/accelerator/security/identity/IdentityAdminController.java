package com.aira.accelerator.security.identity;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1/identity/admin")
public class IdentityAdminController {
    private final IdentityService identityService;

    public IdentityAdminController(IdentityService identityService) {
        this.identityService = identityService;
    }

    @GetMapping("/access-requests")
    public ResponseEntity<?> accessRequests(
        @RequestHeader(value = "X-AIRA-Admin-Key", required = false) String adminKey
    ) {
        return ResponseEntity.ok(identityService.accessRequests(adminKey));
    }

    @PostMapping("/access-requests/{requestId}/approve")
    public ResponseEntity<Map<String, Object>> approve(
        @RequestHeader(value = "X-AIRA-Admin-Key", required = false) String adminKey,
        @PathVariable UUID requestId,
        @RequestBody(required = false) Map<String, Object> request
    ) {
        Map<String, Object> safeRequest = request == null ? Map.of() : request;
        return ResponseEntity.ok(identityService.approveAccessRequest(adminKey, requestId, safeRequest));
    }

    @PostMapping("/access-requests/{requestId}/reject")
    public ResponseEntity<Map<String, Object>> reject(
        @RequestHeader(value = "X-AIRA-Admin-Key", required = false) String adminKey,
        @PathVariable UUID requestId,
        @RequestBody(required = false) Map<String, Object> request
    ) {
        Map<String, Object> safeRequest = request == null ? Map.of() : request;
        return ResponseEntity.ok(identityService.rejectAccessRequest(adminKey, requestId, safeRequest));
    }
}