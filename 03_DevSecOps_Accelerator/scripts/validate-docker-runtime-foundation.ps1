$ErrorActionPreference = "Stop"

$AccelRoot = "D:\ChatGPT Workspace Folder Projects\AIRA Projects\03_DevSecOps_Accelerator"

Set-Location $AccelRoot

Write-Host "Validating Docker Runtime Foundation files..." -ForegroundColor Cyan

$Required = @(
    "docker-compose.runtime.yml",
    ".env.example",
    "accelerator-api\Dockerfile",
    "accelerator-security\Dockerfile",
    "accelerator-governance\Dockerfile",
    "accelerator-evidence\Dockerfile",
    "accelerator-agents\Dockerfile",
    "accelerator-observability\Dockerfile",
    "scripts\build-runtime-jars.ps1",
    "scripts\build-docker-images.ps1",
    "scripts\start-runtime-stack.ps1",
    "scripts\stop-runtime-stack.ps1",
    "scripts\restart-runtime-stack.ps1",
    "scripts\check-runtime-stack.ps1",
    "scripts\show-runtime-logs.ps1"
)

foreach ($File in $Required) {
    if (Test-Path $File) {
        Write-Host "PASS $File" -ForegroundColor Green
    } else {
        Write-Host "MISSING $File" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "Checking Docker availability..." -ForegroundColor Cyan

if (Get-Command docker -ErrorAction SilentlyContinue) {
    docker --version
} else {
    Write-Host "Docker command not found. Install/start Docker Desktop before running the full runtime stack." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Checking Docker Compose availability..." -ForegroundColor Cyan

try {
    docker compose version
} catch {
    Write-Host "Docker Compose plugin not available." -ForegroundColor Yellow
}