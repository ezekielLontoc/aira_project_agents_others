$ErrorActionPreference = "Continue"

Set-Location "D:\ChatGPT Workspace Folder Projects\AIRA Projects\03_DevSecOps_Accelerator"

docker compose -f docker-compose.runtime.yml logs --tail=200