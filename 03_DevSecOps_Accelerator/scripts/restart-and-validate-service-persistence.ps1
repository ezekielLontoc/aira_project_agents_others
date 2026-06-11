$ErrorActionPreference = "Stop"

Set-Location "D:\ChatGPT Workspace Folder Projects\AIRA Projects\03_DevSecOps_Accelerator"

Write-Host "Building AIRA WAR artifacts..." -ForegroundColor Cyan
mvn clean package -DskipTests

Write-Host "Rebuilding and starting Docker runtime..." -ForegroundColor Cyan
docker compose -f docker-compose.runtime.yml up -d --build

Write-Host "Waiting for Tomcat WAR deployments..." -ForegroundColor Yellow
Start-Sleep -Seconds 60

Write-Host "Validating base runtime health..." -ForegroundColor Cyan
powershell -ExecutionPolicy Bypass -File ".\scripts\check-runtime-stack.ps1"

Write-Host "Validating persistence integration..." -ForegroundColor Cyan
powershell -ExecutionPolicy Bypass -File ".\scripts\validate-service-persistence-integration.ps1"

Write-Host "AIRA service persistence integration restart and validation complete." -ForegroundColor Green