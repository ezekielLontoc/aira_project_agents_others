# Docker Runtime Foundation v1

## Purpose

Defines the Docker-based local runtime foundation for the AIRA DevSecOps Accelerator.

## Runtime Services

| Service | Container | Port |
|---|---|---:|
| PostgreSQL 17 | aira-postgres17 | 5432 |
| accelerator-api | aira-accelerator-api | 9090 |
| accelerator-security | aira-accelerator-security | 9091 |
| accelerator-governance | aira-accelerator-governance | 9092 |
| accelerator-evidence | aira-accelerator-evidence | 9093 |
| accelerator-agents | aira-accelerator-agents | 9094 |
| accelerator-observability | aira-accelerator-observability | 9095 |

## Main Compose File

docker-compose.runtime.yml

## Environment Template

.env.example

## Start Runtime Stack

powershell -ExecutionPolicy Bypass -File "D:\ChatGPT Workspace Folder Projects\AIRA Projects\03_DevSecOps_Accelerator\scripts\start-runtime-stack.ps1"

## Stop Runtime Stack

powershell -ExecutionPolicy Bypass -File "D:\ChatGPT Workspace Folder Projects\AIRA Projects\03_DevSecOps_Accelerator\scripts\stop-runtime-stack.ps1"

## Check Runtime Stack

powershell -ExecutionPolicy Bypass -File "D:\ChatGPT Workspace Folder Projects\AIRA Projects\03_DevSecOps_Accelerator\scripts\check-runtime-stack.ps1"

## Governance

Docker runtime is local foundation infrastructure. Production deployment will require hardened secrets, image scanning, registry governance, and deployment approval.