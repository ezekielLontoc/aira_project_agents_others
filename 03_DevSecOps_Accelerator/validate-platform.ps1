Set-Location "D:\ChatGPT Workspace Folder Projects\AIRA Projects\03_DevSecOps_Accelerator"

Write-Host "Checking Maven multi-module platform..." -ForegroundColor Cyan

$Required = @(
    "pom.xml",
    "accelerator-api\pom.xml",
    "accelerator-security\pom.xml",
    "accelerator-governance\pom.xml",
    "accelerator-evidence\pom.xml",
    "accelerator-agents\pom.xml",
    "accelerator-observability\pom.xml"
)

foreach ($File in $Required) {
    if (Test-Path $File) {
        Write-Host "PASS $File" -ForegroundColor Green
    } else {
        Write-Host "MISSING $File" -ForegroundColor Red
    }
}
