package com.aira.accelerator.governance.security;

public record ApiSecurityDecision(
        boolean allowed,
        String decision,
        String reason,
        String principalLabel,
        boolean failClosed
) {
}