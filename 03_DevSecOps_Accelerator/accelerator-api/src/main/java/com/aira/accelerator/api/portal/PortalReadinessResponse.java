package com.aira.accelerator.api.portal;

import java.time.OffsetDateTime;

public record PortalReadinessResponse(
        String status,
        String portalName,
        String portalUrl,
        String servedByService,
        int portalReadinessRecords,
        int activeAgents,
        int controlGates,
        int evidencePacks,
        int evidenceArtifacts,
        int qualityGateDefinitions,
        int passedQualityGateRuns,
        boolean staticPortalReady,
        boolean apiKeyRequiredForBackend,
        boolean embedsSecret,
        boolean failClosed,
        OffsetDateTime timestamp
) {
}