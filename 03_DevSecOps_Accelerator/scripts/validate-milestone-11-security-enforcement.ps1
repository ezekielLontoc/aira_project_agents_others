$ErrorActionPreference = "Stop"

$ApiKey = "aira-local-dev-key-change-me"

function Invoke-Endpoint {
    param(
        [string]$Name,
        [string]$Url,
        [hashtable]$Headers = $null,
        [int]$ExpectedStatusCode = 200
    )

    Write-Host ""
    Write-Host "GET $Url" -ForegroundColor Yellow

    try {
        if ($Headers) {
            $Response = Invoke-WebRequest -Uri $Url -Headers $Headers -TimeoutSec 30 -UseBasicParsing
        }
        else {
            $Response = Invoke-WebRequest -Uri $Url -TimeoutSec 30 -UseBasicParsing
        }

        if ([int]$Response.StatusCode -ne $ExpectedStatusCode) {
            throw "$Name returned HTTP $($Response.StatusCode), expected $ExpectedStatusCode"
        }

        Write-Host "$Name OK ($($Response.StatusCode))" -ForegroundColor Green

        if ($Response.Content) {
            return $Response.Content | ConvertFrom-Json
        }

        return $null
    }
    catch [System.Net.WebException] {
        $HttpResponse = $_.Exception.Response
        if ($HttpResponse -and [int]$HttpResponse.StatusCode -eq $ExpectedStatusCode) {
            Write-Host "$Name OK ($ExpectedStatusCode)" -ForegroundColor Green
            return $null
        }

        throw "$Name failed at $Url : $($_.Exception.Message)"
    }
}

Write-Host "Validating Milestone 11 Security Enforcement..." -ForegroundColor Cyan

# Public endpoints must still work without API key.

$PublicEndpoints = @(
    @{ Name = "accelerator-api base"; Url = "http://localhost:9090/api/health" },
    @{ Name = "accelerator-security base"; Url = "http://localhost:9091/api/v1/security/health" },
    @{ Name = "accelerator-governance base"; Url = "http://localhost:9092/api/health" },
    @{ Name = "accelerator-evidence base"; Url = "http://localhost:9093/api/health" },
    @{ Name = "accelerator-agents base"; Url = "http://localhost:9094/api/health" },
    @{ Name = "accelerator-observability base"; Url = "http://localhost:9095/api/health" },
    @{ Name = "accelerator-governance persistence"; Url = "http://localhost:9092/api/persistence/health" },
    @{ Name = "accelerator-agents persistence"; Url = "http://localhost:9094/api/persistence/health" }
)

foreach ($Endpoint in $PublicEndpoints) {
    $Response = Invoke-Endpoint -Name $Endpoint.Name -Url $Endpoint.Url

    if ($Response -and $Response.status -ne "UP") {
        throw "$($Endpoint.Name) did not return UP"
    }
}

# Protected endpoints without key must fail closed with 401.

Invoke-Endpoint -Name "agents protected without key" -Url "http://localhost:9094/api/v1/agents" -ExpectedStatusCode 401
Invoke-Endpoint -Name "governance protected without key" -Url "http://localhost:9092/api/v1/governance/control-gates" -ExpectedStatusCode 401

# Protected endpoints with wrong key must fail closed with 401.

Invoke-Endpoint -Name "agents protected wrong key" -Url "http://localhost:9094/api/v1/agents" -Headers @{ "X-AIRA-API-Key" = "wrong-key" } -ExpectedStatusCode 401
Invoke-Endpoint -Name "governance protected wrong key" -Url "http://localhost:9092/api/v1/governance/control-gates" -Headers @{ "X-AIRA-API-Key" = "wrong-key" } -ExpectedStatusCode 401

# Protected endpoints with correct key must pass.

$Headers = @{ "X-AIRA-API-Key" = $ApiKey }

$Agents = Invoke-Endpoint -Name "agents protected with key" -Url "http://localhost:9094/api/v1/agents" -Headers $Headers

if ($Agents.Count -lt 8) {
    throw "Expected at least 8 agents"
}

$AgentSummary = Invoke-Endpoint -Name "agent summary protected with key" -Url "http://localhost:9094/api/v1/agents/governance/summary" -Headers $Headers

if ($AgentSummary.status -ne "UP") {
    throw "Agent summary did not return UP"
}

$ControlGates = Invoke-Endpoint -Name "governance control gates protected with key" -Url "http://localhost:9092/api/v1/governance/control-gates" -Headers $Headers

if ($ControlGates.Count -lt 10) {
    throw "Expected at least 10 control gates"
}

$Readiness = Invoke-Endpoint -Name "governance readiness protected with key" -Url "http://localhost:9092/api/v1/governance/readiness" -Headers $Headers

if ($Readiness.status -ne "UP") {
    throw "Governance readiness did not return UP"
}

if ($Readiness.failClosed -ne $true) {
    throw "Governance readiness failClosed is not true"
}

Write-Host ""
Write-Host "Milestone 11 Security Enforcement validation passed." -ForegroundColor Green