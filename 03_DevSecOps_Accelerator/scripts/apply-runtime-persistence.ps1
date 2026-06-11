$ErrorActionPreference = "Stop"

$AccelRoot = "D:\ChatGPT Workspace Folder Projects\AIRA Projects\03_DevSecOps_Accelerator"
$DbContainer = "aira-postgres17"
$DbName = "aira_platform"
$DbUser = "aira_admin"

Set-Location $AccelRoot

Write-Host "Checking Docker..." -ForegroundColor Cyan
docker version | Out-Null

$ContainerStatus = docker ps --filter "name=$DbContainer" --format "{{.Names}}"
if ($ContainerStatus -ne $DbContainer) {
    Write-Host "PostgreSQL container is not running. Starting runtime stack..." -ForegroundColor Yellow
    docker compose -f docker-compose.runtime.yml up -d
    Start-Sleep -Seconds 20
}

$ContainerStatus = docker ps --filter "name=$DbContainer" --format "{{.Names}}"
if ($ContainerStatus -ne $DbContainer) {
    throw "Required container is not running: $DbContainer"
}

$SqlFiles = @(
    "$AccelRoot\database\migrations\V3__aira_runtime_persistence_foundation.sql",
    "$AccelRoot\database\migrations\V4__aira_runtime_persistence_indexes.sql",
    "$AccelRoot\database\seed\V5__aira_runtime_persistence_seed.sql"
)

foreach ($SqlFile in $SqlFiles) {
    if (!(Test-Path $SqlFile)) {
        throw "Missing SQL file: $SqlFile"
    }

    Write-Host "Applying SQL: $SqlFile" -ForegroundColor Cyan
    Get-Content $SqlFile -Raw | docker exec -i $DbContainer psql -U $DbUser -d $DbName -v ON_ERROR_STOP=1
}

Write-Host "Runtime persistence SQL applied successfully." -ForegroundColor Green