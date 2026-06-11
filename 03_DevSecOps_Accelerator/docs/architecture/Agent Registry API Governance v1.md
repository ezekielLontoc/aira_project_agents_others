# Agent Registry API Governance v1

## Status

Accepted

## Purpose

Define governance rules for the Agent Registry API and Governance API.

## API Safety Model

Milestone 10 APIs are read-first.

They may:

- Read agent definitions
- Read prompt versions
- Read model versions
- Read tool permissions
- Read control gates
- Read governance decisions
- Read change requests
- Read approval records
- Report readiness

They may not:

- Approve changes
- Deploy changes
- Promote changes
- Modify production systems
- Bypass security gates
- Bypass evidence gates
- Bypass approval gates
- Expose secrets
- Mutate persisted governance state

## Fail-Closed Behavior

Readiness endpoints must return BLOCKED or non-UP if required baseline records are missing.

## Required Baselines

Agent Registry readiness requires:

- At least 8 active agents
- At least 8 approved prompt versions
- At least 8 approved model versions
- failClosed true

Governance readiness requires:

- At least 10 mandatory fail-closed control gates
- At least 8 active agents
- At least 8 approved prompt versions
- At least 8 approved model versions
- At least 1 evidence pack
- At least 2 secret controls
- Architecture gate present
- Security gate present
- Test gate present
- Evidence gate present
- Approval gate present
- failClosed true

## Production Safety

No write endpoint is allowed until the Security Enforcement Foundation is complete.