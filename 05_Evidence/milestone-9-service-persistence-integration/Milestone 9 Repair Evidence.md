# Milestone 9 Repair Evidence

## Status

Complete

## Issue

The first Milestone 9 script generated RuntimePersistenceService.java with an invalid Java escape sequence inside the Spring @Value placeholder.

This caused:

illegal escape character

Because Maven failed, target/ROOT.war was not generated for accelerator-api, and Docker could not copy the WAR into the Tomcat image.

The running containers therefore continued serving older WARs that did not include:

/api/persistence/health

This caused HTTP 404 responses.

## Correction

The repair removed the fragile @Value placeholder and hardcoded each service name during file generation.

This avoids Java escaping problems and keeps service identity deterministic.

## Validation Required

- Maven build must succeed.
- All target/ROOT.war files must exist.
- Docker images must rebuild.
- Tomcat containers must restart.
- Base health endpoints must remain UP.
- /api/persistence/health must return UP on all six services.

## Governance Result

Milestone 9 is not accepted until persistence endpoint validation passes on all services.