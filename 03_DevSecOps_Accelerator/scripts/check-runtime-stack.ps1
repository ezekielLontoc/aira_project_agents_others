$ErrorActionPreference = "Continue"

$Endpoints = @(
    "http://localhost:9090/api/health",
    "http://localhost:9091/api/v1/security/health",
    "http://localhost:9092/api/health",
    "http://localhost:9093/api/health",
    "http://localhost:9094/api/health",
    "http://localhost:9095/api/health"
)

Write-Host "Checking Docker containers..." -ForegroundColor Cyan
docker ps --filter "name=aira-"

Write-Host ""
Write-Host "Checking runtime endpoints..." -ForegroundColor Cyan

foreach ($Endpoint in $Endpoints) {
    Write-Host ""
    Write-Host "GET $Endpoint" -ForegroundColor Yellow

    try {
        Invoke-RestMethod -Uri $Endpoint -TimeoutSec 10
    }
    catch {
        Write-Host "Endpoint not ready or unavailable: $Endpoint" -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor DarkRed
    }
}