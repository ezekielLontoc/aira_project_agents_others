$ErrorActionPreference = "Stop"

$Endpoints = @(
    @{ Service = "accelerator-api"; Port = 9090; Url = "http://localhost:9090/api/persistence/health" },
    @{ Service = "accelerator-security"; Port = 9091; Url = "http://localhost:9091/api/persistence/health" },
    @{ Service = "accelerator-governance"; Port = 9092; Url = "http://localhost:9092/api/persistence/health" },
    @{ Service = "accelerator-evidence"; Port = 9093; Url = "http://localhost:9093/api/persistence/health" },
    @{ Service = "accelerator-agents"; Port = 9094; Url = "http://localhost:9094/api/persistence/health" },
    @{ Service = "accelerator-observability"; Port = 9095; Url = "http://localhost:9095/api/persistence/health" }
)

Write-Host "Validating AIRA service persistence integration..." -ForegroundColor Cyan

$Failures = @()
$Results = @()

foreach ($Endpoint in $Endpoints) {
    Write-Host ""
    Write-Host "GET $($Endpoint.Url)" -ForegroundColor Yellow

    try {
        $Response = Invoke-RestMethod -Uri $Endpoint.Url -TimeoutSec 30

        $Results += [PSCustomObject]@{
            Service = $Endpoint.Service
            Port = $Endpoint.Port
            Status = $Response.status
            DatabaseStatus = $Response.databaseStatus
            AgentDefinitions = $Response.baselineCounts.agentDefinitions
            ControlGates = $Response.baselineCounts.controlGates
            PromptVersions = $Response.baselineCounts.promptVersions
            ModelVersions = $Response.baselineCounts.modelVersions
            EvidencePacks = $Response.baselineCounts.evidencePacks
            FailClosed = $Response.failClosed
        }

        if ($Response.status -ne "UP") {
            $Failures += "$($Endpoint.Service) status is $($Response.status)"
        }

        if ($Response.databaseStatus -ne "UP") {
            $Failures += "$($Endpoint.Service) databaseStatus is $($Response.databaseStatus)"
        }

        if ($Response.failClosed -ne $true) {
            $Failures += "$($Endpoint.Service) failClosed is not true"
        }
    }
    catch {
        $Failures += "$($Endpoint.Service) endpoint failed: $($_.Exception.Message)"
    }
}

Write-Host ""
Write-Host "Persistence Integration Results:" -ForegroundColor Cyan
$Results | Format-Table -AutoSize

if ($Failures.Count -gt 0) {
    Write-Host ""
    Write-Host "Validation failed:" -ForegroundColor Red
    foreach ($Failure in $Failures) {
        Write-Host "- $Failure" -ForegroundColor Red
    }

    throw "AIRA service persistence integration validation failed."
}

Write-Host ""
Write-Host "AIRA service persistence integration validation passed." -ForegroundColor Green