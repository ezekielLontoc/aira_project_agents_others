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
            EvidenceArtifacts = $Response.baselineCounts.evidenceArtifacts
            SecretControls = $Response.baselineCounts.secretControls
            PersistenceAuditRecords = $Response.baselineCounts.persistenceAuditRecords
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

        if ($Response.baselineCounts.agentDefinitions -lt 8) {
            $Failures += "$($Endpoint.Service) has insufficient agent definitions"
        }

        if ($Response.baselineCounts.controlGates -lt 10) {
            $Failures += "$($Endpoint.Service) has insufficient control gates"
        }

        if ($Response.baselineCounts.promptVersions -lt 8) {
            $Failures += "$($Endpoint.Service) has insufficient prompt versions"
        }

        if ($Response.baselineCounts.modelVersions -lt 8) {
            $Failures += "$($Endpoint.Service) has insufficient model versions"
        }

        if ($Response.baselineCounts.evidencePacks -lt 1) {
            $Failures += "$($Endpoint.Service) has insufficient evidence packs"
        }

        if ($Response.baselineCounts.evidenceArtifacts -lt 4) {
            $Failures += "$($Endpoint.Service) has insufficient evidence artifacts"
        }

        if ($Response.baselineCounts.secretControls -lt 2) {
            $Failures += "$($Endpoint.Service) has insufficient secret controls"
        }

        if ($Response.baselineCounts.persistenceAuditRecords -lt 1) {
            $Failures += "$($Endpoint.Service) has insufficient persistence audit records"
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