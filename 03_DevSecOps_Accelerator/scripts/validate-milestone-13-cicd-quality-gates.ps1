$ErrorActionPreference = "Stop"

Set-Location "D:\ChatGPT Workspace Folder Projects\AIRA Projects\03_DevSecOps_Accelerator"

Write-Host "Validating Milestone 13 CI/CD Quality Gate Foundation..." -ForegroundColor Cyan

powershell -ExecutionPolicy Bypass -File ".\scripts\run-local-cicd-quality-gates.ps1"

if ($LASTEXITCODE -ne 0) {
    throw "Milestone 13 local CI/CD quality gate runner failed."
}

powershell -ExecutionPolicy Bypass -File ".\scripts\show-cicd-quality-gate-summary.ps1"

if ($LASTEXITCODE -ne 0) {
    throw "Milestone 13 quality gate summary failed."
}

Write-Host ""
Write-Host "Milestone 13 CI/CD Quality Gate Foundation validation passed." -ForegroundColor Green