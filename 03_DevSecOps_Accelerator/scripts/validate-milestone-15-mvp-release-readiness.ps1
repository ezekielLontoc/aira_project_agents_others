$ErrorActionPreference = "Stop"

$RepoRoot = "D:\ChatGPT Workspace Folder Projects\AIRA Projects"
$AccelRoot = "$RepoRoot\03_DevSecOps_Accelerator"
$ApiKey = "aira-local-dev-key-change-me"

function Invoke-CheckedCommand {
    param([string]$CommandText)

    Write-Host ""
    Write-Host "Running: $CommandText" -ForegroundColor Cyan
    cmd.exe /c $CommandText

    if ($LASTEXITCODE -ne 0) {
        throw "Command failed with exit code $LASTEXITCODE : $CommandText"
    }
}

function Invoke-JsonEndpoint {
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

        if (!$Headers) {
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

function Invoke-TextEndpoint {
    param(
        [string]$Name,
        [string]$Url,
        [string]$ExpectedText
    )

    Write-Host ""
    Write-Host "GET $Url" -ForegroundColor Yellow

    $Response = Invoke-WebRequest -Uri $Url -TimeoutSec 30 -UseBasicParsing

    if ([int]$Response.StatusCode -ne 200) {
        throw "$Name returned HTTP $($Response.StatusCode), expected 200"
    }

    if ($Response.Content -notmatch [Regex]::Escape($ExpectedText)) {
        throw "$Name did not contain expected text: $ExpectedText"
    }

    Write-Host "$Name OK (200)" -ForegroundColor Green
    return $Response
}

Set-Location $AccelRoot

Write-Host "Validating Milestone 15 End-to-End Release Readiness..." -ForegroundColor Cyan

powershell -ExecutionPolicy Bypass -File ".\scripts\apply-mvp-release-readiness-foundation.ps1"

if ($LASTEXITCODE -ne 0) {
    throw "MVP release readiness SQL apply failed."
}

Write-Host ""
Write-Host "Building all AIRA WAR files..." -ForegroundColor Cyan
Invoke-CheckedCommand "mvn clean package -DskipTests"

$WarFiles = @(
    "$AccelRoot\accelerator-api\target\ROOT.war",
    "$AccelRoot\accelerator-security\target\ROOT.war",
    "$AccelRoot\accelerator-governance\target\ROOT.war",
    "$AccelRoot\accelerator-evidence\target\ROOT.war",
    "$AccelRoot\accelerator-agents\target\ROOT.war",
    "$AccelRoot\accelerator-observability\target\ROOT.war"
)

foreach ($WarFile in $WarFiles) {
    if (!(Test-Path $WarFile)) {
        throw "Missing WAR file: $WarFile"
    }

    Write-Host "Found WAR: $WarFile" -ForegroundColor Green
}

Write-Host ""
Write-Host "Rebuilding Docker runtime..." -ForegroundColor Cyan
Invoke-CheckedCommand "docker compose -f docker-compose.runtime.yml up -d --build --force-recreate"

Write-Host ""
Write-Host "Waiting for Tomcat deployments..." -ForegroundColor Yellow
Start-Sleep -Seconds 90

Write-Host ""
Write-Host "Validating base health endpoints..." -ForegroundColor Cyan

$BaseEndpoints = @(
    @{ Name = "accelerator-api base"; Url = "http://localhost:9090/api/health" },
    @{ Name = "accelerator-security base"; Url = "http://localhost:9091/api/v1/security/health" },
    @{ Name = "accelerator-governance base"; Url = "http://localhost:9092/api/health" },
    @{ Name = "accelerator-evidence base"; Url = "http://localhost:9093/api/health" },
    @{ Name = "accelerator-agents base"; Url = "http://localhost:9094/api/health" },
    @{ Name = "accelerator-observability base"; Url = "http://localhost:9095/api/health" }
)

foreach ($Endpoint in $BaseEndpoints) {
    $Response = Invoke-JsonEndpoint -Name $Endpoint.Name -Url $Endpoint.Url

    if ($Response.status -ne "UP") {
        throw "$($Endpoint.Name) did not return UP"
    }
}

Write-Host ""
Write-Host "Validating persistence health endpoints..." -ForegroundColor Cyan

$PersistenceEndpoints = @(
    @{ Name = "accelerator-api persistence"; Url = "http://localhost:9090/api/persistence/health" },
    @{ Name = "accelerator-security persistence"; Url = "http://localhost:9091/api/persistence/health" },
    @{ Name = "accelerator-governance persistence"; Url = "http://localhost:9092/api/persistence/health" },
    @{ Name = "accelerator-evidence persistence"; Url = "http://localhost:9093/api/persistence/health" },
    @{ Name = "accelerator-agents persistence"; Url = "http://localhost:9094/api/persistence/health" },
    @{ Name = "accelerator-observability persistence"; Url = "http://localhost:9095/api/persistence/health" }
)

foreach ($Endpoint in $PersistenceEndpoints) {
    $Response = Invoke-JsonEndpoint -Name $Endpoint.Name -Url $Endpoint.Url

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

Write-Host ""
Write-Host "Validating portal foundation..." -ForegroundColor Cyan

Invoke-TextEndpoint -Name "AIRA Portal page" -Url "http://localhost:9090/portal/index.html" -ExpectedText "AIRA Portal"

$PortalReadiness = Invoke-JsonEndpoint -Name "portal readiness" -Url "http://localhost:9090/api/v1/portal/readiness"

if ($PortalReadiness.status -ne "UP") {
    throw "Portal readiness did not return UP"
}

if ($PortalReadiness.embedsSecret -ne $false) {
    throw "Portal readiness embedsSecret is not false"
}

Write-Host ""
Write-Host "Validating protected API fail-closed behavior..." -ForegroundColor Cyan

Invoke-JsonEndpoint -Name "release readiness without key" -Url "http://localhost:9092/api/v1/governance/release/readiness" -ExpectedStatusCode 401
Invoke-JsonEndpoint -Name "release readiness wrong key" -Url "http://localhost:9092/api/v1/governance/release/readiness" -Headers @{ "X-AIRA-API-Key" = "wrong-key" } -ExpectedStatusCode 401

Invoke-JsonEndpoint -Name "agents without key" -Url "http://localhost:9094/api/v1/agents" -ExpectedStatusCode 401
Invoke-JsonEndpoint -Name "governance without key" -Url "http://localhost:9092/api/v1/governance/readiness" -ExpectedStatusCode 401
Invoke-JsonEndpoint -Name "evidence without key" -Url "http://localhost:9093/api/v1/evidence/readiness" -ExpectedStatusCode 401

Write-Host ""
Write-Host "Validating protected APIs with valid key..." -ForegroundColor Cyan

$Headers = @{
    "X-AIRA-API-Key" = $ApiKey
    "Origin" = "http://localhost:9090"
}

$AgentSummary = Invoke-JsonEndpoint -Name "agent summary" -Url "http://localhost:9094/api/v1/agents/governance/summary" -Headers $Headers

if ($AgentSummary.status -ne "UP") {
    throw "Agent summary did not return UP"
}

$GovernanceReadiness = Invoke-JsonEndpoint -Name "governance readiness" -Url "http://localhost:9092/api/v1/governance/readiness" -Headers $Headers

if ($GovernanceReadiness.status -ne "UP") {
    throw "Governance readiness did not return UP"
}

$EvidenceReadiness = Invoke-JsonEndpoint -Name "evidence readiness" -Url "http://localhost:9093/api/v1/evidence/readiness" -Headers $Headers

if ($EvidenceReadiness.status -ne "UP") {
    throw "Evidence readiness did not return UP"
}

$EvidencePack = Invoke-JsonEndpoint -Name "evidence pack detail" -Url "http://localhost:9093/api/v1/evidence/packs/MILESTONE-8-RUNTIME-PERSISTENCE" -Headers $Headers

if ($EvidencePack.evidence_pack_key -ne "MILESTONE-8-RUNTIME-PERSISTENCE") {
    throw "Evidence pack detail did not return MILESTONE-8-RUNTIME-PERSISTENCE"
}

Write-Host ""
Write-Host "Validating release readiness API..." -ForegroundColor Cyan

$ReleaseReadiness = Invoke-JsonEndpoint -Name "MVP release readiness" -Url "http://localhost:9092/api/v1/governance/release/readiness" -Headers $Headers

if ($ReleaseReadiness.status -ne "UP") {
    throw "Release readiness did not return UP"
}

if ($ReleaseReadiness.releaseKey -ne "AIRA-MVP-RELEASE-READINESS") {
    throw "Release readiness returned wrong release key"
}

if ($ReleaseReadiness.releaseStatus -ne "MVP_READY") {
    throw "Release readiness releaseStatus is not MVP_READY"
}

if ($ReleaseReadiness.mvpReady -ne $true) {
    throw "Release readiness mvpReady is not true"
}

if ($ReleaseReadiness.rollbackReady -ne $true) {
    throw "Release readiness rollbackReady is not true"
}

if ($ReleaseReadiness.operatingModelReady -ne $true) {
    throw "Release readiness operatingModelReady is not true"
}

if ($ReleaseReadiness.humanAcceptanceReady -ne $true) {
    throw "Release readiness humanAcceptanceReady is not true"
}

if ($ReleaseReadiness.failClosed -ne $true) {
    throw "Release readiness failClosed is not true"
}

$ReleaseGates = Invoke-JsonEndpoint -Name "MVP release gates" -Url "http://localhost:9092/api/v1/governance/release/gates" -Headers $Headers

if ($ReleaseGates.Count -lt 10) {
    throw "Release gates returned fewer than 10 records"
}

$OperatingModel = Invoke-JsonEndpoint -Name "MVP operating model" -Url "http://localhost:9092/api/v1/governance/release/operating-model" -Headers $Headers

if ($OperatingModel.Count -lt 1) {
    throw "Operating model endpoint returned no records"
}

$Rollback = Invoke-JsonEndpoint -Name "MVP rollback readiness" -Url "http://localhost:9092/api/v1/governance/release/rollback" -Headers $Headers

if ($Rollback.Count -lt 1) {
    throw "Rollback readiness endpoint returned no records"
}

Write-Host ""
Write-Host "Running Milestone 13 quality gates as final regression check..." -ForegroundColor Cyan

powershell -ExecutionPolicy Bypass -File ".\scripts\validate-milestone-13-cicd-quality-gates.ps1"

if ($LASTEXITCODE -ne 0) {
    throw "Milestone 13 final regression validation failed"
}

Write-Host ""
Write-Host "Milestone 15 End-to-End Release Readiness validation passed." -ForegroundColor Green