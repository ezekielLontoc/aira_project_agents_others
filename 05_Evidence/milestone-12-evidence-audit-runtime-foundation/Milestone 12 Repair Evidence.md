# Milestone 12 Repair Evidence

## Status

Complete after validation passes.

## Issue

Milestone 12 SQL and files were created, but Maven failed before WAR packaging completed.

The failure occurred in:

03_DevSecOps_Accelerator/accelerator-governance/src/main/java/com/aira/accelerator/governance/security/ApiSecurityProperties.java

The Java compiler reported:

illegal escape character

Because the build stopped, accelerator-governance target/ROOT.war was missing. Docker then failed to rebuild the runtime image for accelerator-governance. The newly created accelerator-evidence APIs were not deployed, so /api/v1/evidence/packs returned 404.

## Correction

This repair removes fragile Spring @Value placeholder escaping from all secured modules and uses System.getenv instead.

Corrected modules:

- accelerator-agents
- accelerator-governance
- accelerator-evidence

## Acceptance Criteria

The repair is accepted only when:

- Maven build succeeds.
- All six ROOT.war files exist.
- Docker images rebuild successfully.
- Milestone 11 security validation passes.
- Milestone 12 evidence validation passes.
- Evidence readiness returns UP.
- Git commit and push complete after validation.