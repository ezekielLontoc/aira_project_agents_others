package com.aira.accelerator.security.identity;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.Base64;

public final class IdentitySecurityUtil {
    private static final SecureRandom SECURE_RANDOM = new SecureRandom();

    private IdentitySecurityUtil() {
    }

    public static String randomToken() {
        byte[] bytes = new byte[32];
        SECURE_RANDOM.nextBytes(bytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
    }

    public static String sha256(String value) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(value.getBytes(StandardCharsets.UTF_8));
            return Base64.getEncoder().encodeToString(hash);
        } catch (Exception ex) {
            throw new IllegalStateException("Unable to compute SHA-256 hash.", ex);
        }
    }

    public static String normalizeEmail(String email) {
        if (email == null) {
            return "";
        }

        return email.trim().toLowerCase();
    }

    public static String emailDomain(String email) {
        String normalized = normalizeEmail(email);
        int at = normalized.lastIndexOf("@");

        if (at < 0 || at == normalized.length() - 1) {
            return "";
        }

        return normalized.substring(at + 1);
    }

    public static String safeString(Object value) {
        if (value == null) {
            return "";
        }

        return value.toString().trim();
    }

    public static boolean safeBoolean(Object value) {
        if (value instanceof Boolean) {
            return (Boolean) value;
        }

        if (value == null) {
            return false;
        }

        return Boolean.parseBoolean(value.toString());
    }

    public static String bearerToken(String authorizationHeader, String alternateHeader) {
        if (authorizationHeader != null && authorizationHeader.startsWith("Bearer ")) {
            return authorizationHeader.substring("Bearer ".length()).trim();
        }

        if (alternateHeader != null && !alternateHeader.isBlank()) {
            return alternateHeader.trim();
        }

        return "";
    }
}