$ErrorActionPreference = "Stop"

$AccelRoot = "D:\ChatGPT Workspace Folder Projects\AIRA Projects\03_DevSecOps_Accelerator"
$Database = "aira_platform"
$User = "aira_admin"
$HostName = "localhost"
$Port = 5432

Set-Location $AccelRoot

Write-Host "Applying PostgreSQL 17 foundation SQL..." -ForegroundColor Cyan

if (!(Get-Command psql -ErrorAction SilentlyContinue)) {
    Write-Host "psql was not found in PATH. Install PostgreSQL client tools or add psql to PATH." -ForegroundColor Red
    exit 1
}

psql -h $HostName -p $Port -U $User -d $Database -f "$AccelRoot\database\init\00_create_aira_schemas.sql"
psql -h $HostName -p $Port -U $User -d $Database -f "$AccelRoot\database\migrations\V1__aira_platform_foundation.sql"
psql -h $HostName -p $Port -U $User -d $Database -f "$AccelRoot\database\seed\V2__aira_platform_seed.sql"

Write-Host "PostgreSQL 17 foundation SQL applied." -ForegroundColor Green