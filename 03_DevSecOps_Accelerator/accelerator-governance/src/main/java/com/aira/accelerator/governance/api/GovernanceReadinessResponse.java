package com.aira.accelerator.governance.api;

import java.time.OffsetDateTime;

public record GovernanceReadinessResponse(
        String status,
        int controlGates,
        int activeAgents,
        int approvedPromptVersions,
        int approvedModelVersions,
        int evidencePacks,
        int secretControls,
        boolean architectureGateReady,
        boolean securityGateReady,
        boolean testGateReady,
        boolean evidenceGateReady,
        boolean approvalGateReady,
        boolean failClosed,
        OffsetDateTime timestamp
) {
}