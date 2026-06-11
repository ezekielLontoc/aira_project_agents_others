$ErrorActionPreference = "Stop"

$Headers = @{
    "X-AIRA-API-Key" = "aira-local-dev-key-change-me"
    "Origin" = "http://localhost:9090"
}

Write-Host ""
Write-Host "MVP Release Readiness" -ForegroundColor Cyan
Invoke-RestMethod -Uri "http://localhost:9092/api/v1/governance/release/readiness" -Headers $Headers -TimeoutSec 30 | Format-List

Write-Host ""
Write-Host "MVP Release Gates" -ForegroundColor Cyan
Invoke-RestMethod -Uri "http://localhost:9092/api/v1/governance/release/gates" -Headers $Headers -TimeoutSec 30 |
    Select-Object gate_key, gate_category, status, fail_closed |
    Format-Table -AutoSize

Write-Host ""
Write-Host "MVP Operating Model" -ForegroundColor Cyan
Invoke-RestMethod -Uri "http://localhost:9092/api/v1/governance/release/operating-model" -Headers $Headers -TimeoutSec 30 |
    Select-Object operating_model_key, model_status, human_approval_required, fail_closed |
    Format-Table -AutoSize

Write-Host ""
Write-Host "MVP Rollback Readiness" -ForegroundColor Cyan
Invoke-RestMethod -Uri "http://localhost:9092/api/v1/governance/release/rollback" -Headers $Headers -TimeoutSec 30 |
    Select-Object rollback_key, rollback_status, rollback_owner, fail_closed |
    Format-Table -AutoSize