package com.aira.accelerator.security.identity;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/v1/identity")
public class IdentityController {
    private final IdentityService identityService;

    public IdentityController(IdentityService identityService) {
        this.identityService = identityService;
    }

    @GetMapping("/readiness")
    public ResponseEntity<Map<String, Object>> readiness() {
        return ResponseEntity.ok(identityService.readiness());
    }

    @GetMapping("/microfunctions")
    public ResponseEntity<?> microfunctions() {
        return ResponseEntity.ok(identityService.microfunctions());
    }

    @PostMapping("/signup")
    public ResponseEntity<Map<String, Object>> signup(@RequestBody Map<String, Object> request) {
        return ResponseEntity.ok(identityService.signup(request));
    }

    @PostMapping("/verify-email")
    public ResponseEntity<Map<String, Object>> verifyEmail(@RequestBody Map<String, Object> request) {
        return ResponseEntity.ok(identityService.verifyEmail(request));
    }

    @PostMapping("/login")
    public ResponseEntity<Map<String, Object>> login(@RequestBody Map<String, Object> request) {
        return ResponseEntity.ok(identityService.login(request));
    }

    @PostMapping("/logout")
    public ResponseEntity<Map<String, Object>> logout(
        @RequestHeader(value = "Authorization", required = false) String authorization,
        @RequestHeader(value = "X-AIRA-Identity-Session", required = false) String sessionHeader
    ) {
        String token = IdentitySecurityUtil.bearerToken(authorization, sessionHeader);
        return ResponseEntity.ok(identityService.logout(token));
    }

    @GetMapping("/session")
    public ResponseEntity<Map<String, Object>> session(
        @RequestHeader(value = "Authorization", required = false) String authorization,
        @RequestHeader(value = "X-AIRA-Identity-Session", required = false) String sessionHeader
    ) {
        String token = IdentitySecurityUtil.bearerToken(authorization, sessionHeader);
        return ResponseEntity.ok(identityService.sessionContext(token));
    }

    @GetMapping("/me")
    public ResponseEntity<Map<String, Object>> me(
        @RequestHeader(value = "Authorization", required = false) String authorization,
        @RequestHeader(value = "X-AIRA-Identity-Session", required = false) String sessionHeader
    ) {
        String token = IdentitySecurityUtil.bearerToken(authorization, sessionHeader);
        return ResponseEntity.ok(identityService.sessionContext(token));
    }

    @GetMapping("/landing-context")
    public ResponseEntity<Map<String, Object>> landingContext(
        @RequestHeader(value = "Authorization", required = false) String authorization,
        @RequestHeader(value = "X-AIRA-Identity-Session", required = false) String sessionHeader
    ) {
        String token = IdentitySecurityUtil.bearerToken(authorization, sessionHeader);
        return ResponseEntity.ok(identityService.sessionContext(token));
    }
}