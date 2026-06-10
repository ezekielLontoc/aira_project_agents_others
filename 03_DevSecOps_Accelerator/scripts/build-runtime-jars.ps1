$ErrorActionPreference = "Stop"

Set-Location "D:\ChatGPT Workspace Folder Projects\AIRA Projects\03_DevSecOps_Accelerator"

Write-Host "Building AIRA Maven artifacts..." -ForegroundColor Cyan
mvn clean package -DskipTests

Write-Host "AIRA Maven artifacts built." -ForegroundColor Green