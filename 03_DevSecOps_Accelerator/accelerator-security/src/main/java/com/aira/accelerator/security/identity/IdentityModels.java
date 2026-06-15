package com.aira.accelerator.security.identity;

import java.time.OffsetDateTime;
import java.util.List;
import java.util.Map;

public final class IdentityModels {
    private IdentityModels() {
    }

    public static final String STATUS_UP = "UP";
    public static final String STATUS_DENIED = "DENIED";
    public static final String STATUS_AUTHENTICATED = "AUTHENTICATED";
    public static final String STATUS_CREATED = "CREATED";
    public static final String STATUS_VERIFIED = "VERIFIED";

    public static Map<String, Object> response(String status, String message) {
        return Map.of(
            "status", status,
            "message", message
        );
    }

    public static Map<String, Object> denied(String message) {
        return Map.of(
            "status", STATUS_DENIED,
            "message", message
        );
    }

    public static Map<String, Object> readiness(
        int permissions,
        int rolePermissions,
        int microfunctions
    ) {
        return Map.of(
            "status", STATUS_UP,
            "readinessKey", "AIRA-POC1-PHASE2-IDENTITY-CORE-APIS",
            "identityCoreApiReady", true,
            "failClosed", true,
            "permissions", permissions,
            "rolePermissions", rolePermissions,
            "microfunctions", microfunctions,
            "phase", "POC-1 Build Phase 2",
            "timestamp", OffsetDateTime.now().toString()
        );
    }

    public static Map<String, Object> sessionContext(
        String email,
        String displayName,
        String institutionKey,
        String institutionName,
        List<String> roles,
        List<String> permissions,
        String landingRoute,
        OffsetDateTime expiresAt
    ) {
        return Map.of(
            "authenticated", true,
            "email", email,
            "displayName", displayName,
            "institutionKey", institutionKey,
            "institutionName", institutionName,
            "roles", roles,
            "permissions", permissions,
            "landingRoute", landingRoute,
            "sessionStatus", "ACTIVE",
            "expiresAt", expiresAt.toString()
        );
    }
}