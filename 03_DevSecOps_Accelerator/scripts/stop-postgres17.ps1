Set-Location "D:\ChatGPT Workspace Folder Projects\AIRA Projects\03_DevSecOps_Accelerator"

Write-Host "Stopping PostgreSQL 17 Docker Compose service..." -ForegroundColor Cyan
docker compose -f docker-compose.postgres17.yml down

Write-Host "PostgreSQL 17 stopped." -ForegroundColor Green