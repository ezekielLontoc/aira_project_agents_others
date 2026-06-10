$ErrorActionPreference = "Stop"

Set-Location "D:\ChatGPT Workspace Folder Projects\AIRA Projects\03_DevSecOps_Accelerator"

Write-Host "Building AIRA WAR artifacts for Tomcat 11..." -ForegroundColor Cyan
mvn clean package -DskipTests

Write-Host "AIRA WAR artifacts built." -ForegroundColor Green