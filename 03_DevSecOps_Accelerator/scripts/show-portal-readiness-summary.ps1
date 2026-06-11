$ErrorActionPreference = "Stop"

$Headers = @{
    "X-AIRA-API-Key" = "aira-local-dev-key-change-me"
    "Origin" = "http://localhost:9090"
}

Write-Host ""
Write-Host "Portal Readiness" -ForegroundColor Cyan
Invoke-RestMethod -Uri "http://localhost:9090/api/v1/portal/readiness" -TimeoutSec 30 | Format-List

Write-Host ""
Write-Host "Agent Summary" -ForegroundColor Cyan
Invoke-RestMethod -Uri "http://localhost:9094/api/v1/agents/governance/summary" -Headers $Headers -TimeoutSec 30 | Format-List

Write-Host ""
Write-Host "Governance Readiness" -ForegroundColor Cyan
Invoke-RestMethod -Uri "http://localhost:9092/api/v1/governance/readiness" -Headers $Headers -TimeoutSec 30 | Format-List

Write-Host ""
Write-Host "Evidence Readiness" -ForegroundColor Cyan
Invoke-RestMethod -Uri "http://localhost:9093/api/v1/evidence/readiness" -Headers $Headers -TimeoutSec 30 | Format-List