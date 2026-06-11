package com.aira.accelerator.agents.registry;

import java.time.OffsetDateTime;

public record AgentRegistrySummaryResponse(
        String status,
        int activeAgents,
        int promptVersions,
        int modelVersions,
        int toolPermissions,
        boolean failClosed,
        OffsetDateTime timestamp
) {
}