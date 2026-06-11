# Milestone 12 Detail Endpoint Repair Evidence

## Status

Complete after validation passes.

## Issue

The endpoint below returned HTTP 500:

/api/v1/evidence/packs/MILESTONE-8-RUNTIME-PERSISTENCE

Spring could not infer the method argument name for the path variable:

Name for argument of type [java.lang.String] not specified, and parameter name information not available via reflection.

## Root Cause

The controller used:

@PathVariable String evidencePackKey

without compiler parameter metadata.

## Fix

The controller now uses explicit path variable names:

@PathVariable("evidencePackKey") String evidencePackKey

Affected endpoints:

- /api/v1/evidence/packs/{evidencePackKey}
- /api/v1/evidence/packs/{evidencePackKey}/artifacts

## Acceptance Criteria

This repair is accepted only when:

- Maven build succeeds.
- All six ROOT.war files exist.
- Docker runtime rebuilds.
- Base health endpoints remain UP.
- Evidence readiness remains UP.
- Evidence detail endpoint returns MILESTONE-8-RUNTIME-PERSISTENCE.
- Evidence pack artifacts endpoint returns at least 4 artifacts.
- Git commit and push complete after validation.