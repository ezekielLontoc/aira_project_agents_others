$ErrorActionPreference = "Stop"

Set-Location "D:\ChatGPT Workspace Folder Projects\AIRA Projects\03_DevSecOps_Accelerator"

Write-Host "Stopping AIRA Docker Runtime Stack..." -ForegroundColor Cyan
docker compose -f docker-compose.runtime.yml down

Write-Host "AIRA Docker Runtime Stack stopped." -ForegroundColor Green