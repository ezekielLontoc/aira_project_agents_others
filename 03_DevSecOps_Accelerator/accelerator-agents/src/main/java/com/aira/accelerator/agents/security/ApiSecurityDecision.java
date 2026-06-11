package com.aira.accelerator.agents.security;

public record ApiSecurityDecision(
        boolean allowed,
        String decision,
        String reason,
        String principalLabel,
        boolean failClosed
) {
}