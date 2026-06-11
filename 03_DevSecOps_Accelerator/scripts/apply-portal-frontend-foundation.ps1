$ErrorActionPreference = "Stop"

$AccelRoot = "D:\ChatGPT Workspace Folder Projects\AIRA Projects\03_DevSecOps_Accelerator"
$DbContainer = "aira-postgres17"
$DbName = "aira_platform"
$DbUser = "aira_admin"

Set-Location $AccelRoot

$ContainerStatus = docker ps --filter "name=$DbContainer" --format "{{.Names}}"

if ($ContainerStatus -ne $DbContainer) {
    Write-Host "PostgreSQL container is not running. Starting runtime stack..." -ForegroundColor Yellow
    docker compose -f docker-compose.runtime.yml up -d
    Start-Sleep -Seconds 20
}

$SqlFiles = @(
    "$AccelRoot\database\migrations\V12__aira_portal_frontend_foundation.sql",
    "$AccelRoot\database\seed\V13__aira_portal_frontend_seed.sql"
)

foreach ($SqlFile in $SqlFiles) {
    if (!(Test-Path $SqlFile)) {
        throw "Missing SQL file: $SqlFile"
    }

    Write-Host "Applying SQL: $SqlFile" -ForegroundColor Cyan
    Get-Content $SqlFile -Raw | docker exec -i $DbContainer psql -U $DbUser -d $DbName -v ON_ERROR_STOP=1

    if ($LASTEXITCODE -ne 0) {
        throw "SQL apply failed: $SqlFile"
    }
}

Write-Host "AIRA Portal Frontend Foundation SQL applied successfully." -ForegroundColor Green