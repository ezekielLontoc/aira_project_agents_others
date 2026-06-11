$ErrorActionPreference = "Stop"

$AccelRoot = "D:\ChatGPT Workspace Folder Projects\AIRA Projects\03_DevSecOps_Accelerator"
$DbContainer = "aira-postgres17"
$DbName = "aira_platform"
$DbUser = "aira_admin"
$ValidationSql = "$AccelRoot\database\validation\validate_runtime_persistence.sql"

Set-Location $AccelRoot

if (!(Test-Path $ValidationSql)) {
    throw "Missing validation SQL: $ValidationSql"
}

$ContainerStatus = docker ps --filter "name=$DbContainer" --format "{{.Names}}"
if ($ContainerStatus -ne $DbContainer) {
    throw "Required container is not running: $DbContainer"
}

Write-Host "Running runtime persistence validation..." -ForegroundColor Cyan
Get-Content $ValidationSql -Raw | docker exec -i $DbContainer psql -U $DbUser -d $DbName -v ON_ERROR_STOP=1

Write-Host "Runtime persistence validation completed." -ForegroundColor Green