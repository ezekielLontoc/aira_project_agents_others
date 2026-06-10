# PostgreSQL Foundation v1

## Purpose

Defines the mandatory PostgreSQL 17 foundation for the AIRA DevSecOps Accelerator.

## Mandatory Requirement

| Requirement | Value |
|---|---|
| Database Engine | PostgreSQL |
| Mandatory Version | 17 |
| Default Database | aira_platform |
| Default Port | 5432 |
| Default Local User | aira_admin |

## Schemas

| Schema | Purpose |
|---|---|
| aira_security | Identity, roles, permissions, API keys, audit |
| aira_governance | ADRs, policies, technology register |
| aira_evidence | Evidence packs and compliance artifacts |
| aira_agents | Agent registry and execution records |
| aira_runtime | Service registry and runtime state |
| aira_observability | Platform events and operational data |

## Current Status

PostgreSQL 17 is mandatory for the platform foundation.

Database connection profiles are created but not auto-enabled yet.

## Activation

Use this JVM option when ready:

-Dspring.profiles.active=postgres

## Local Docker Startup

powershell -ExecutionPolicy Bypass -File "D:\ChatGPT Workspace Folder Projects\AIRA Projects\03_DevSecOps_Accelerator\scripts\start-postgres17.ps1"

## Apply SQL Foundation

powershell -ExecutionPolicy Bypass -File "D:\ChatGPT Workspace Folder Projects\AIRA Projects\03_DevSecOps_Accelerator\scripts\apply-postgres17-foundation.ps1"

## Check PostgreSQL 17

powershell -ExecutionPolicy Bypass -File "D:\ChatGPT Workspace Folder Projects\AIRA Projects\03_DevSecOps_Accelerator\scripts\check-postgres17.ps1"