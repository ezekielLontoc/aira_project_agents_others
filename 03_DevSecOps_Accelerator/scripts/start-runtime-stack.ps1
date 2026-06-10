$ErrorActionPreference = "Stop"

Set-Location "D:\ChatGPT Workspace Folder Projects\AIRA Projects\03_DevSecOps_Accelerator"

if (!(Test-Path ".env")) {
    Copy-Item ".env.example" ".env"
    Write-Host "Created local .env from .env.example" -ForegroundColor Yellow
}

Write-Host "Building runtime JARs..." -ForegroundColor Cyan
mvn clean package -DskipTests

Write-Host "Starting AIRA Docker Runtime Stack..." -ForegroundColor Cyan
docker compose -f docker-compose.runtime.yml up -d --build

Write-Host "AIRA Docker Runtime Stack started." -ForegroundColor Green
Write-Host "Health URLs:"
Write-Host "http://localhost:9090/api/health"
Write-Host "http://localhost:9091/api/v1/security/health"
Write-Host "http://localhost:9092/api/health"
Write-Host "http://localhost:9093/api/health"
Write-Host "http://localhost:9094/api/health"
Write-Host "http://localhost:9095/api/health"