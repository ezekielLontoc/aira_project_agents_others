Set-Location "D:\ChatGPT Workspace Folder Projects\AIRA Projects\03_DevSecOps_Accelerator"

Write-Host "Starting PostgreSQL 17 using Docker Compose..." -ForegroundColor Cyan
docker compose -f docker-compose.postgres17.yml up -d

Write-Host "PostgreSQL 17 start command completed." -ForegroundColor Green
Write-Host "Expected connection:"
Write-Host "Host: localhost"
Write-Host "Port: 5432"
Write-Host "Database: aira_platform"
Write-Host "Username: aira_admin"