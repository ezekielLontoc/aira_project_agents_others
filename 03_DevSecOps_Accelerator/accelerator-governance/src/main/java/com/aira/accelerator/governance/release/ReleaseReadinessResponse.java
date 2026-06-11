package com.aira.accelerator.governance.release;

import java.time.OffsetDateTime;

public record ReleaseReadinessResponse(
        String status,
        String releaseKey,
        String releaseName,
        String releaseVersion,
        String releaseStatus,
        boolean mvpReady,
        int activeAgents,
        int controlGates,
        int evidencePacks,
        int evidenceArtifacts,
        int traceabilityLinks,
        int activeSecretControls,
        int qualityGateDefinitions,
        int passedQualityGateRuns,
        int portalReadinessRecords,
        int releaseGateResults,
        int passedReleaseGateResults,
        int operatingModelRecords,
        int rollbackReadinessRecords,
        int acceptanceRecords,
        boolean runtimeReady,
        boolean persistenceReady,
        boolean securityReady,
        boolean agentRegistryReady,
        boolean governanceReady,
        boolean evidenceReady,
        boolean cicdReady,
        boolean portalReady,
        boolean rollbackReady,
        boolean operatingModelReady,
        boolean humanAcceptanceReady,
        boolean failClosed,
        OffsetDateTime timestamp
) {
}