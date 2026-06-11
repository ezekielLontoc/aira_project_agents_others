$ErrorActionPreference = "Stop"

$Endpoints = @(
    @{ Service = "accelerator-api"; Url = "http://localhost:9090/api/persistence/health" },
    @{ Service = "accelerator-security"; Url = "http://localhost:9091/api/persistence/health" },
    @{ Service = "accelerator-governance"; Url = "http://localhost:9092/api/persistence/health" },
    @{ Service = "accelerator-evidence"; Url = "http://localhost:9093/api/persistence/health" },
    @{ Service = "accelerator-agents"; Url = "http://localhost:9094/api/persistence/health" },
    @{ Service = "accelerator-observability"; Url = "http://localhost:9095/api/persistence/health" }
)

$Summary = @()

foreach ($Endpoint in $Endpoints) {
    $Response = Invoke-RestMethod -Uri $Endpoint.Url -TimeoutSec 20

    $Summary += [PSCustomObject]@{
        Service = $Endpoint.Service
        Status = $Response.status
        DatabaseStatus = $Response.databaseStatus
        DatabaseProduct = $Response.databaseProduct
        AgentDefinitions = $Response.baselineCounts.agentDefinitions
        ControlGates = $Response.baselineCounts.controlGates
        EvidencePacks = $Response.baselineCounts.evidencePacks
        FailClosed = $Response.failClosed
    }
}

$Summary | Format-Table -AutoSize