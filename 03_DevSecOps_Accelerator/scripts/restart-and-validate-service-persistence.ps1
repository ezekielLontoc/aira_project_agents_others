$ErrorActionPreference = "Stop"

function Invoke-CheckedCommand {
    param(
        [string]$CommandText
    )

    Write-Host ""
    Write-Host "Running: $CommandText" -ForegroundColor Cyan

    cmd.exe /c $CommandText

    if ($LASTEXITCODE -ne 0) {
        throw "Command failed with exit code $LASTEXITCODE : $CommandText"
    }
}

Set-Location "D:\ChatGPT Workspace Folder Projects\AIRA Projects\03_DevSecOps_Accelerator"

Write-Host "Building AIRA WAR artifacts..." -ForegroundColor Cyan
Invoke-CheckedCommand "mvn clean package -DskipTests"

Write-Host "Verifying WAR artifacts..." -ForegroundColor Cyan

$WarFiles = @(
    ".\accelerator-api\target\ROOT.war",
    ".\accelerator-security\target\ROOT.war",
    ".\accelerator-governance\target\ROOT.war",
    ".\accelerator-evidence\target\ROOT.war",
    ".\accelerator-agents\target\ROOT.war",
    ".\accelerator-observability\target\ROOT.war"
)

foreach ($WarFile in $WarFiles) {
    if (!(Test-Path $WarFile)) {
        throw "Missing WAR artifact: $WarFile"
    }
}

Write-Host "Rebuilding and starting Docker runtime..." -ForegroundColor Cyan
Invoke-CheckedCommand "docker compose -f docker-compose.runtime.yml up -d --build"

Write-Host "Waiting for Tomcat WAR deployments..." -ForegroundColor Yellow
Start-Sleep -Seconds 75

Write-Host "Validating base runtime health..." -ForegroundColor Cyan
powershell -ExecutionPolicy Bypass -File ".\scripts\check-runtime-stack.ps1"

if ($LASTEXITCODE -ne 0) {
    throw "Base runtime validation failed."
}

Write-Host "Validating persistence integration..." -ForegroundColor Cyan
powershell -ExecutionPolicy Bypass -File ".\scripts\validate-service-persistence-integration.ps1"

if ($LASTEXITCODE -ne 0) {
    throw "Persistence integration validation failed."
}

Write-Host "AIRA service persistence integration restart and validation complete." -ForegroundColor Green