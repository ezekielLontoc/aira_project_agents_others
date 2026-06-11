$ErrorActionPreference = "Stop"

function Invoke-Endpoint {
    param(
        [string]$Name,
        [string]$Url
    )

    Write-Host ""
    Write-Host "GET $Url" -ForegroundColor Yellow

    try {
        $Response = Invoke-RestMethod -Uri $Url -TimeoutSec 30
        Write-Host "$Name OK" -ForegroundColor Green
        return $Response
    }
    catch {
        throw "$Name failed at $Url : $($_.Exception.Message)"
    }
}

Write-Host "Validating Milestone 10 Agent Registry and Governance APIs..." -ForegroundColor Cyan

# Base endpoints

$BaseEndpoints = @(
    @{ Name = "accelerator-api base"; Url = "http://localhost:9090/api/health" },
    @{ Name = "accelerator-security base"; Url = "http://localhost:9091/api/v1/security/health" },
    @{ Name = "accelerator-governance base"; Url = "http://localhost:9092/api/health" },
    @{ Name = "accelerator-evidence base"; Url = "http://localhost:9093/api/health" },
    @{ Name = "accelerator-agents base"; Url = "http://localhost:9094/api/health" },
    @{ Name = "accelerator-observability base"; Url = "http://localhost:9095/api/health" }
)

foreach ($Endpoint in $BaseEndpoints) {
    $Response = Invoke-Endpoint -Name $Endpoint.Name -Url $Endpoint.Url

    if ($Response.status -ne "UP") {
        throw "$($Endpoint.Name) did not return UP"
    }
}

# Persistence endpoints

$PersistenceEndpoints = @(
    @{ Name = "accelerator-api persistence"; Url = "http://localhost:9090/api/persistence/health" },
    @{ Name = "accelerator-security persistence"; Url = "http://localhost:9091/api/persistence/health" },
    @{ Name = "accelerator-governance persistence"; Url = "http://localhost:9092/api/persistence/health" },
    @{ Name = "accelerator-evidence persistence"; Url = "http://localhost:9093/api/persistence/health" },
    @{ Name = "accelerator-agents persistence"; Url = "http://localhost:9094/api/persistence/health" },
    @{ Name = "accelerator-observability persistence"; Url = "http://localhost:9095/api/persistence/health" }
)

foreach ($Endpoint in $PersistenceEndpoints) {
    $Response = Invoke-Endpoint -Name $Endpoint.Name -Url $Endpoint.Url

    if ($Response.status -ne "UP") {
        throw "$($Endpoint.Name) did not return UP"
    }

    if ($Response.databaseStatus -ne "UP") {
        throw "$($Endpoint.Name) databaseStatus did not return UP"
    }

    if ($Response.failClosed -ne $true) {
        throw "$($Endpoint.Name) failClosed is not true"
    }
}

# Agent Registry APIs

$Agents = Invoke-Endpoint -Name "Agent Registry list" -Url "http://localhost:9094/api/v1/agents"

if ($Agents.Count -lt 8) {
    throw "Agent Registry returned fewer than 8 agents"
}

$ArchitectureAgent = Invoke-Endpoint -Name "Agent Registry detail" -Url "http://localhost:9094/api/v1/agents/architecture-agent"

if ($ArchitectureAgent.agent_name -ne "architecture-agent") {
    throw "Agent Registry detail did not return architecture-agent"
}

$AgentPrompts = Invoke-Endpoint -Name "Agent prompt versions" -Url "http://localhost:9094/api/v1/agents/architecture-agent/prompts"

if ($AgentPrompts.Count -lt 1) {
    throw "Agent prompt versions returned no records"
}

$AgentModels = Invoke-Endpoint -Name "Agent model versions" -Url "http://localhost:9094/api/v1/agents/architecture-agent/models"

if ($AgentModels.Count -lt 1) {
    throw "Agent model versions returned no records"
}

$AgentTools = Invoke-Endpoint -Name "Agent tool permissions" -Url "http://localhost:9094/api/v1/agents/architecture-agent/tools"

# Tool permissions may be empty until tool policy expansion, but endpoint must work.

$AgentSummary = Invoke-Endpoint -Name "Agent governance summary" -Url "http://localhost:9094/api/v1/agents/governance/summary"

if ($AgentSummary.status -ne "UP") {
    throw "Agent governance summary did not return UP"
}

if ($AgentSummary.activeAgents -lt 8) {
    throw "Agent governance summary has fewer than 8 active agents"
}

# Governance APIs

$ControlGates = Invoke-Endpoint -Name "Governance control gates" -Url "http://localhost:9092/api/v1/governance/control-gates"

if ($ControlGates.Count -lt 10) {
    throw "Governance control gates returned fewer than 10 gates"
}

$Decisions = Invoke-Endpoint -Name "Governance decisions" -Url "http://localhost:9092/api/v1/governance/decisions"
$ChangeRequests = Invoke-Endpoint -Name "Governance change requests" -Url "http://localhost:9092/api/v1/governance/change-requests"
$Approvals = Invoke-Endpoint -Name "Governance approvals" -Url "http://localhost:9092/api/v1/governance/approvals"

$Readiness = Invoke-Endpoint -Name "Governance readiness" -Url "http://localhost:9092/api/v1/governance/readiness"

if ($Readiness.status -ne "UP") {
    throw "Governance readiness did not return UP"
}

if ($Readiness.controlGates -lt 10) {
    throw "Governance readiness has fewer than 10 control gates"
}

if ($Readiness.activeAgents -lt 8) {
    throw "Governance readiness has fewer than 8 active agents"
}

if ($Readiness.failClosed -ne $true) {
    throw "Governance readiness failClosed is not true"
}

Write-Host ""
Write-Host "Milestone 10 validation passed." -ForegroundColor Green