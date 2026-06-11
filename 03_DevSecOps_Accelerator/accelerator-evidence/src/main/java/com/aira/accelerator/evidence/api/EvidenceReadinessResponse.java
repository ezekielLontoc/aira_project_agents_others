package com.aira.accelerator.evidence.api;

import java.time.OffsetDateTime;

public record EvidenceReadinessResponse(
        String status,
        int evidencePacks,
        int evidenceArtifacts,
        int traceabilityLinks,
        int runtimeAuditRecords,
        int securityAuditEvents,
        int activeEvidencePolicies,
        boolean evidencePackReady,
        boolean artifactReady,
        boolean traceabilityReady,
        boolean runtimeAuditReady,
        boolean securityPolicyReady,
        boolean failClosed,
        OffsetDateTime timestamp
) {
}