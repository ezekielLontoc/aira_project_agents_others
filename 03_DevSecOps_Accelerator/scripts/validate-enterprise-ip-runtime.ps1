$ErrorActionPreference = "Stop"

$AccelRoot = "D:\ChatGPT Workspace Folder Projects\AIRA Projects\03_DevSecOps_Accelerator"
$ApiKey = "aira-local-dev-key-change-me"

function Get-AiraServerIp {
    $DefaultRoute = Get-NetRoute -DestinationPrefix "0.0.0.0/0" -ErrorAction SilentlyContinue |
        Where-Object { $_.NextHop -ne "0.0.0.0" } |
        Sort-Object RouteMetric, InterfaceMetric |
        Select-Object -First 1

    if ($DefaultRoute) {
        $Candidate = Get-NetIPAddress -AddressFamily IPv4 -InterfaceIndex $DefaultRoute.InterfaceIndex -ErrorAction SilentlyContinue |
            Where-Object {
                $_.IPAddress -ne "127.0.0.1" -and
                $_.IPAddress -notlike "169.254.*"
            } |
            Select-Object -First 1

        if ($Candidate) {
            return $Candidate.IPAddress
        }
    }

    $Fallback = Get-NetIPAddress -AddressFamily IPv4 -ErrorAction SilentlyContinue |
        Where-Object {
            $_.IPAddress -ne "127.0.0.1" -and
            $_.IPAddress -notlike "169.254.*" -and
            $_.PrefixOrigin -ne "WellKnown"
        } |
        Sort-Object InterfaceMetric |
        Select-Object -First 1

    if ($Fallback) {
        return $Fallback.IPAddress
    }

    throw "Unable to determine server IPv4 address."
}

function Invoke-CheckedCommand {
    param([string]$CommandText)

    Write-Host ""
    Write-Host "Running: $CommandText" -ForegroundColor Yellow
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
            $Response = Invoke-WebRequest -Uri $Url -Headers $Headers -TimeoutSec 60 -UseBasicParsing
        }

        if (!$Headers) {
            $Response = Invoke-WebRequest -Uri $Url -TimeoutSec 60 -UseBasicParsing
        }

        if ([int]$Response.StatusCode -ne $ExpectedStatusCode) {
            throw "$Name returned HTTP $($Response.StatusCode), expected $ExpectedStatusCode"
        }

        Write-Host "[PASS] $Name HTTP $($Response.StatusCode)" -ForegroundColor Green

        if ($Response.Content) {
            return $Response.Content | ConvertFrom-Json
        }

        return $null
    }
    catch [System.Net.WebException] {
        $HttpResponse = $_.Exception.Response

        if ($HttpResponse -and [int]$HttpResponse.StatusCode -eq $ExpectedStatusCode) {
            Write-Host "[PASS] $Name HTTP $ExpectedStatusCode" -ForegroundColor Green
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

    $Response = Invoke-WebRequest -Uri $Url -TimeoutSec 60 -UseBasicParsing

    if ([int]$Response.StatusCode -ne 200) {
        throw "$Name returned HTTP $($Response.StatusCode), expected 200"
    }

    if ($Response.Content -notmatch [Regex]::Escape($ExpectedText)) {
        throw "$Name did not contain expected text: $ExpectedText"
    }

    Write-Host "[PASS] $Name HTTP 200 and contains expected text" -ForegroundColor Green
}

function Invoke-CorsPreflight {
    param(
        [string]$Name,
        [string]$Url,
        [string]$Origin
    )

    Write-Host ""
    Write-Host "OPTIONS $Url" -ForegroundColor Yellow
    Write-Host "Origin: $Origin" -ForegroundColor Yellow

    $Headers = @{
        "Origin" = $Origin
        "Access-Control-Request-Method" = "GET"
        "Access-Control-Request-Headers" = "X-AIRA-API-Key"
    }

    $Response = Invoke-WebRequest -Method Options -Uri $Url -Headers $Headers -TimeoutSec 60 -UseBasicParsing

    if ([int]$Response.StatusCode -lt 200 -or [int]$Response.StatusCode -gt 299) {
        throw "$Name returned HTTP $($Response.StatusCode), expected 2xx"
    }

    Write-Host "[PASS] $Name CORS preflight HTTP $($Response.StatusCode)" -ForegroundColor Green
}

$ServerIp = Get-AiraServerIp
$ServerOrigin = "http://$ServerIp:9090"

$env:AIRA_SERVER_HOST = $ServerIp
$env:AIRA_PORTAL_ALLOWED_ORIGINS = "http://localhost:9090,http://$ServerIp:9090"
$env:AIRA_SECURITY_LOCAL_API_KEY = $ApiKey

Set-Location $AccelRoot

Write-Host ""
Write-Host "Enterprise Server-IP validation starting..." -ForegroundColor Cyan
Write-Host "Server IP: $ServerIp" -ForegroundColor Cyan
Write-Host "Server origin: $ServerOrigin" -ForegroundColor Cyan

Invoke-CheckedCommand "mvn clean package -DskipTests"
Invoke-CheckedCommand "docker compose -f docker-compose.runtime.yml -f docker-compose.enterprise-ip.yml up -d --build --force-recreate"

Write-Host ""
Write-Host "Waiting for Tomcat deployments..." -ForegroundColor Yellow
Start-Sleep -Seconds 90

$LocalBase = "http://localhost"
$ServerBase = "http://$ServerIp"

$BaseEndpoints = @(
    @{ Name = "api localhost"; Url = "$LocalBase`:9090/api/health" },
    @{ Name = "api server-ip"; Url = "$ServerBase`:9090/api/health" },
    @{ Name = "security localhost"; Url = "$LocalBase`:9091/api/v1/security/health" },
    @{ Name = "security server-ip"; Url = "$ServerBase`:9091/api/v1/security/health" },
    @{ Name = "governance localhost"; Url = "$LocalBase`:9092/api/health" },
    @{ Name = "governance server-ip"; Url = "$ServerBase`:9092/api/health" },
    @{ Name = "evidence localhost"; Url = "$LocalBase`:9093/api/health" },
    @{ Name = "evidence server-ip"; Url = "$ServerBase`:9093/api/health" },
    @{ Name = "agents localhost"; Url = "$LocalBase`:9094/api/health" },
    @{ Name = "agents server-ip"; Url = "$ServerBase`:9094/api/health" },
    @{ Name = "observability localhost"; Url = "$LocalBase`:9095/api/health" },
    @{ Name = "observability server-ip"; Url = "$ServerBase`:9095/api/health" }
)

foreach ($Endpoint in $BaseEndpoints) {
    $Response = Invoke-JsonEndpoint -Name $Endpoint.Name -Url $Endpoint.Url

    if ($Response.status -ne "UP") {
        throw "$($Endpoint.Name) did not return UP"
    }
}

Invoke-TextEndpoint -Name "Portal localhost" -Url "$LocalBase`:9090/portal/index.html" -ExpectedText "Enterprise Server-IP Runtime Baseline"
Invoke-TextEndpoint -Name "Portal server-ip" -Url "$ServerBase`:9090/portal/index.html" -ExpectedText "Enterprise Server-IP Runtime Baseline"

$PortalLocal = Invoke-JsonEndpoint -Name "Portal readiness localhost" -Url "$LocalBase`:9090/api/v1/portal/readiness"
$PortalIp = Invoke-JsonEndpoint -Name "Portal readiness server-ip" -Url "$ServerBase`:9090/api/v1/portal/readiness"

if ($PortalLocal.status -ne "UP") {
    throw "Portal localhost readiness did not return UP"
}

if ($PortalIp.status -ne "UP") {
    throw "Portal server-IP readiness did not return UP"
}

if ($PortalIp.portalUrl -notmatch [Regex]::Escape($ServerIp)) {
    throw "Portal readiness did not return server-IP portalUrl"
}

Invoke-CorsPreflight -Name "Agents CORS server origin" -Url "$ServerBase`:9094/api/v1/agents/governance/summary" -Origin $ServerOrigin
Invoke-CorsPreflight -Name "Governance CORS server origin" -Url "$ServerBase`:9092/api/v1/governance/readiness" -Origin $ServerOrigin
Invoke-CorsPreflight -Name "Evidence CORS server origin" -Url "$ServerBase`:9093/api/v1/evidence/readiness" -Origin $ServerOrigin

Invoke-JsonEndpoint -Name "agents without key server-ip" -Url "$ServerBase`:9094/api/v1/agents" -ExpectedStatusCode 401
Invoke-JsonEndpoint -Name "governance without key server-ip" -Url "$ServerBase`:9092/api/v1/governance/readiness" -ExpectedStatusCode 401
Invoke-JsonEndpoint -Name "evidence without key server-ip" -Url "$ServerBase`:9093/api/v1/evidence/readiness" -ExpectedStatusCode 401
Invoke-JsonEndpoint -Name "release without key server-ip" -Url "$ServerBase`:9092/api/v1/governance/release/readiness" -ExpectedStatusCode 401

$Headers = @{
    "X-AIRA-API-Key" = $ApiKey
    "Origin" = $ServerOrigin
}

$AgentSummary = Invoke-JsonEndpoint -Name "Agent summary server-ip" -Url "$ServerBase`:9094/api/v1/agents/governance/summary" -Headers $Headers
$GovernanceReadiness = Invoke-JsonEndpoint -Name "Governance readiness server-ip" -Url "$ServerBase`:9092/api/v1/governance/readiness" -Headers $Headers
$EvidenceReadiness = Invoke-JsonEndpoint -Name "Evidence readiness server-ip" -Url "$ServerBase`:9093/api/v1/evidence/readiness" -Headers $Headers
$ReleaseReadiness = Invoke-JsonEndpoint -Name "Release readiness server-ip" -Url "$ServerBase`:9092/api/v1/governance/release/readiness" -Headers $Headers

if ($AgentSummary.status -ne "UP") {
    throw "Agent summary server-ip did not return UP"
}

if ($GovernanceReadiness.status -ne "UP") {
    throw "Governance readiness server-ip did not return UP"
}

if ($EvidenceReadiness.status -ne "UP") {
    throw "Evidence readiness server-ip did not return UP"
}

if ($ReleaseReadiness.status -ne "UP") {
    throw "Release readiness server-ip did not return UP"
}

if ($ReleaseReadiness.mvpReady -ne $true) {
    throw "Release readiness mvpReady is not true"
}

if ($ReleaseReadiness.failClosed -ne $true) {
    throw "Release readiness failClosed is not true"
}

Write-Host ""
Write-Host "Enterprise Server-IP Runtime validation PASSED." -ForegroundColor Green
Write-Host "Portal: http://$ServerIp`:9090/portal/index.html" -ForegroundColor Green
Write-Host "Release readiness: http://$ServerIp`:9092/api/v1/governance/release/readiness" -ForegroundColor Green