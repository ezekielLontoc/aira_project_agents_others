$ErrorActionPreference = "Stop"

Set-Location "D:\ChatGPT Workspace Folder Projects\AIRA Projects\03_DevSecOps_Accelerator"

Write-Host "Building AIRA WAR artifacts first..." -ForegroundColor Cyan
mvn clean package -DskipTests

Write-Host "Building Tomcat 11 Docker images..." -ForegroundColor Cyan
docker compose -f docker-compose.runtime.yml build --no-cache

Write-Host "Docker images built." -ForegroundColor Green