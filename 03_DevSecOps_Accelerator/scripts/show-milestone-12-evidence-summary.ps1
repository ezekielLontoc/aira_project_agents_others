$ErrorActionPreference = "Stop"

$Headers = @{ "X-AIRA-API-Key" = "aira-local-dev-key-change-me" }

$Readiness = Invoke-RestMethod -Uri "http://localhost:9093/api/v1/evidence/readiness" -Headers $Headers -TimeoutSec 30
$Packs = Invoke-RestMethod -Uri "http://localhost:9093/api/v1/evidence/packs" -Headers $Headers -TimeoutSec 30
$Artifacts = Invoke-RestMethod -Uri "http://localhost:9093/api/v1/evidence/artifacts" -Headers $Headers -TimeoutSec 30
$Traceability = Invoke-RestMethod -Uri "http://localhost:9093/api/v1/evidence/traceability" -Headers $Headers -TimeoutSec 30
$RuntimeAudit = Invoke-RestMethod -Uri "http://localhost:9093/api/v1/evidence/runtime-audit" -Headers $Headers -TimeoutSec 30

Write-Host ""
Write-Host "Evidence Readiness" -ForegroundColor Cyan
$Readiness | Format-List

Write-Host ""
Write-Host "Evidence Packs" -ForegroundColor Cyan
$Packs | Select-Object evidence_pack_key, evidence_status, created_by, created_at | Format-Table -AutoSize

Write-Host ""
Write-Host "Evidence Artifacts" -ForegroundColor Cyan
$Artifacts | Select-Object evidence_pack_key, artifact_key, artifact_type, risk_level, contains_secret | Format-Table -AutoSize

Write-Host ""
Write-Host "Traceability Links" -ForegroundColor Cyan
$Traceability | Select-Object link_key, evidence_pack_key, source_type, target_type, relationship_type | Format-Table -AutoSize

Write-Host ""
Write-Host "Runtime Audit" -ForegroundColor Cyan
$RuntimeAudit | Select-Object audit_key, action_type, actor, decision, fail_closed | Format-Table -AutoSize