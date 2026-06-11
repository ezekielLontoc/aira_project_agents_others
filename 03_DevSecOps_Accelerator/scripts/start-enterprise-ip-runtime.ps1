$ErrorActionPreference = "Stop"

$AccelRoot = "D:\ChatGPT Workspace Folder Projects\AIRA Projects\03_DevSecOps_Accelerator"

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

$ServerIp = Get-AiraServerIp

$env:AIRA_SERVER_HOST = $ServerIp
$env:AIRA_PORTAL_ALLOWED_ORIGINS = "http://localhost:9090,http://$ServerIp:9090"

if (!$env:AIRA_SECURITY_LOCAL_API_KEY) {
    $env:AIRA_SECURITY_LOCAL_API_KEY = "aira-local-dev-key-change-me"
}

Set-Location $AccelRoot

docker compose -f docker-compose.runtime.yml -f docker-compose.enterprise-ip.yml up -d --build --force-recreate

if ($LASTEXITCODE -ne 0) {
    throw "Enterprise IP runtime startup failed."
}

Write-Host ""
Write-Host "AIRA Enterprise IP runtime started." -ForegroundColor Green
Write-Host "Server IP: $ServerIp" -ForegroundColor Green
Write-Host "Portal: http://$ServerIp:9090/portal/index.html" -ForegroundColor Green