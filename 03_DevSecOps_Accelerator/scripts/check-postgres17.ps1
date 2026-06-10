$HostName = "localhost"
$Port = 5432
$Database = "aira_platform"
$User = "aira_admin"

Write-Host "Checking PostgreSQL 17 foundation..." -ForegroundColor Cyan

if (Get-Command docker -ErrorAction SilentlyContinue) {
    docker ps --filter "name=aira-postgres17"
}

if (Get-Command psql -ErrorAction SilentlyContinue) {
    Write-Host "psql found. You can test manually with:" -ForegroundColor Green
    Write-Host "psql -h $HostName -p $Port -U $User -d $Database"
} else {
    Write-Host "psql not found in PATH. PostgreSQL client tools may not be installed or not in PATH." -ForegroundColor Yellow
}

Write-Host "Mandatory PostgreSQL version target: 17" -ForegroundColor Cyan