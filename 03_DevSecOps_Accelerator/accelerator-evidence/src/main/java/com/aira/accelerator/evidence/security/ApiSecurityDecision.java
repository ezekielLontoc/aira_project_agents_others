package com.aira.accelerator.evidence.security;

public record ApiSecurityDecision(
        boolean allowed,
        String decision,
        String reason,
        String principalLabel,
        boolean failClosed
) {
}