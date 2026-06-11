package com.aira.accelerator.security.persistence;

import java.time.OffsetDateTime;
import java.util.Map;

public record PersistenceHealthResponse(
        String status,
        String serviceName,
        String databaseStatus,
        String databaseProduct,
        String databaseVersion,
        Map<String, Integer> baselineCounts,
        boolean failClosed,
        OffsetDateTime timestamp
) {
}