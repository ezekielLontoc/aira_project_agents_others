$ErrorActionPreference = "Stop"

$AgentSummary = Invoke-RestMethod -Uri "http://localhost:9094/api/v1/agents/governance/summary" -TimeoutSec 30
$GovernanceReadiness = Invoke-RestMethod -Uri "http://localhost:9092/api/v1/governance/readiness" -TimeoutSec 30
$Agents = Invoke-RestMethod -Uri "http://localhost:9094/api/v1/agents" -TimeoutSec 30
$ControlGates = Invoke-RestMethod -Uri "http://localhost:9092/api/v1/governance/control-gates" -TimeoutSec 30

Write-Host ""
Write-Host "Agent Registry Summary" -ForegroundColor Cyan
$AgentSummary | Format-List

Write-Host ""
Write-Host "Governance Readiness" -ForegroundColor Cyan
$GovernanceReadiness | Format-List

Write-Host ""
Write-Host "Agents" -ForegroundColor Cyan
$Agents | Select-Object agent_name, risk_level, owner, status, agent_version | Format-Table -AutoSize

Write-Host ""
Write-Host "Control Gates" -ForegroundColor Cyan
$ControlGates | Select-Object gate_key, gate_category, owner, is_mandatory, fail_closed | Format-Table -AutoSize