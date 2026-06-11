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

Write-Host "Validating Milestone 12 Evidence and Audit Runtime Foundation..." -ForegroundColor Cyan

# Public base endpoints

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

# Persistence endpoints remain public and UP.

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

# Protected evidence endpoints deny missing and wrong keys.

Invoke-Endpoint -Name "evidence packs without key" -Url "http://localhost:9093/api/v1/evidence/packs" -ExpectedStatusCode 401
Invoke-Endpoint -Name "evidence readiness without key" -Url "http://localhost:9093/api/v1/evidence/readiness" -ExpectedStatusCode 401

Invoke-Endpoint -Name "evidence packs wrong key" -Url "http://localhost:9093/api/v1/evidence/packs" -Headers @{ "X-AIRA-API-Key" = "wrong-key" } -ExpectedStatusCode 401
Invoke-Endpoint -Name "evidence readiness wrong key" -Url "http://localhost:9093/api/v1/evidence/readiness" -Headers @{ "X-AIRA-API-Key" = "wrong-key" } -ExpectedStatusCode 401

# Protected evidence endpoints allow valid key.

$Headers = @{ "X-AIRA-API-Key" = $ApiKey }

$Packs = Invoke-Endpoint -Name "evidence packs with key" -Url "http://localhost:9093/api/v1/evidence/packs" -Headers $Headers

if ($Packs.Count -lt 1) {
    throw "Expected at least 1 evidence pack"
}

$Pack = Invoke-Endpoint -Name "evidence pack detail with key" -Url "http://localhost:9093/api/v1/evidence/packs/MILESTONE-8-RUNTIME-PERSISTENCE" -Headers $Headers

if ($Pack.evidence_pack_key -ne "MILESTONE-8-RUNTIME-PERSISTENCE") {
    throw "Evidence pack detail did not return MILESTONE-8-RUNTIME-PERSISTENCE"
}

$ArtifactsForPack = Invoke-Endpoint -Name "evidence pack artifacts with key" -Url "http://localhost:9093/api/v1/evidence/packs/MILESTONE-8-RUNTIME-PERSISTENCE/artifacts" -Headers $Headers

if ($ArtifactsForPack.Count -lt 4) {
    throw "Expected at least 4 evidence artifacts for MILESTONE-8-RUNTIME-PERSISTENCE"
}

$Artifacts = Invoke-Endpoint -Name "evidence artifacts with key" -Url "http://localhost:9093/api/v1/evidence/artifacts" -Headers $Headers

if ($Artifacts.Count -lt 4) {
    throw "Expected at least 4 evidence artifacts"
}

$Traceability = Invoke-Endpoint -Name "evidence traceability with key" -Url "http://localhost:9093/api/v1/evidence/traceability" -Headers $Headers

if ($Traceability.Count -lt 1) {
    throw "Expected at least 1 traceability link"
}

$RuntimeAudit = Invoke-Endpoint -Name "evidence runtime audit with key" -Url "http://localhost:9093/api/v1/evidence/runtime-audit" -Headers $Headers

if ($RuntimeAudit.Count -lt 1) {
    throw "Expected at least 1 runtime audit record"
}

$SecurityAudit = Invoke-Endpoint -Name "evidence security audit with key" -Url "http://localhost:9093/api/v1/evidence/security-audit" -Headers $Headers

# Security audit can be zero early, but endpoint must return successfully.

$Readiness = Invoke-Endpoint -Name "evidence readiness with key" -Url "http://localhost:9093/api/v1/evidence/readiness" -Headers $Headers

if ($Readiness.status -ne "UP") {
    throw "Evidence readiness did not return UP"
}

if ($Readiness.evidencePacks -lt 1) {
    throw "Evidence readiness has fewer than 1 evidence pack"
}

if ($Readiness.evidenceArtifacts -lt 4) {
    throw "Evidence readiness has fewer than 4 evidence artifacts"
}

if ($Readiness.traceabilityLinks -lt 1) {
    throw "Evidence readiness has fewer than 1 traceability link"
}

if ($Readiness.runtimeAuditRecords -lt 1) {
    throw "Evidence readiness has fewer than 1 runtime audit record"
}

if ($Readiness.activeEvidencePolicies -lt 1) {
    throw "Evidence readiness has fewer than 1 active evidence policy"
}

if ($Readiness.failClosed -ne $true) {
    throw "Evidence readiness failClosed is not true"
}

Write-Host ""
Write-Host "Milestone 12 Evidence and Audit Runtime validation passed." -ForegroundColor Green