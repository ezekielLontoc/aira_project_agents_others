$ErrorActionPreference = "Stop"

Set-Location "D:\ChatGPT Workspace Folder Projects\AIRA Projects\03_DevSecOps_Accelerator"

Write-Host "Building runtime JARs first..." -ForegroundColor Cyan
mvn clean package -DskipTests

Write-Host "Building Docker images..." -ForegroundColor Cyan
docker compose -f docker-compose.runtime.yml build

Write-Host "Docker images built." -ForegroundColor Green