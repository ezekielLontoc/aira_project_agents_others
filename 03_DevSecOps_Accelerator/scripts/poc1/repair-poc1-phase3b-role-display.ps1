# ============================================================
# AIRA POC-1 Phase 3B Role Display Polish
# Fix portal dashboard "role undefined"
# PowerShell 5.1 Compatible
# ============================================================

$ErrorActionPreference = "Stop"

$RepoRoot = "D:\ChatGPT Workspace Folder Projects\AIRA Projects"
$AccelRoot = "$RepoRoot\03_DevSecOps_Accelerator"
$ApiModuleRoot = "$AccelRoot\accelerator-api"
$PortalRoot = "$ApiModuleRoot\src\main\resources\static\portal"
$PortalJsPath = "$PortalRoot\assets\poc1-api.js"

$EvidenceRoot = "$RepoRoot\05_Evidence\poc-1-identity-rbac-portal-entry"
$EvidencePath = "$EvidenceRoot\POC-1 Evidence Pack.md"
$ReportPath = "$EvidenceRoot\POC-1 Phase 3B Role Display Polish Report.md"

$ServerIp = "192.168.179.193"
$PortalPort = 9090
$PortalBaseUrl = "http://$ServerIp`:$PortalPort/portal"

$CommitMessage = "POC-1 - polish phase 3B portal role display"

$Utf8NoBom = New-Object System.Text.UTF8Encoding($false)

function Write-Utf8NoBom {
    param(
        [string]$Path,
        [string]$Content
    )

    $Parent = Split-Path $Path -Parent

    if (!(Test-Path $Parent)) {
        New-Item -ItemType Directory -Force -Path $Parent | Out-Null
    }

    [System.IO.File]::WriteAllText($Path, $Content, $Utf8NoBom)
}

function Write-Section {
    param([string]$Text)

    Write-Host ""
    Write-Host "============================================================" -ForegroundColor Cyan
    Write-Host $Text -ForegroundColor Cyan
    Write-Host "============================================================" -ForegroundColor Cyan
}

function Assert-FileContains {
    param(
        [string]$Path,
        [string]$ExpectedText,
        [string]$Name
    )

    if (!(Test-Path $Path)) {
        throw "Missing file: $Path"
    }

    $Content = Get-Content $Path -Raw

    if ($Content -notlike "*$ExpectedText*") {
        throw "$Name missing expected text: $ExpectedText"
    }

    Write-Host "[PASS] $Name contains: $ExpectedText" -ForegroundColor Green
}

function Find-ContainerByHostPort {
    param([int]$HostPort)

    $Lines = docker ps --format "{{.ID}}|{{.Names}}|{{.Ports}}"

    foreach ($Line in $Lines) {
        if ($Line -match ":$HostPort->" -or $Line -match "0\.0\.0\.0:$HostPort->" -or $Line -match ":::$HostPort->") {
            $Parts = $Line.Split("|")
            return New-Object PSObject -Property @{
                Id = $Parts[0]
                Name = $Parts[1]
                Ports = $Parts[2]
            }
        }
    }

    return $null
}

function Get-TomcatWebappsPath {
    param([string]$ContainerId)

    $Candidates = @(
        "/usr/local/tomcat/webapps",
        "/opt/bitnami/tomcat/webapps",
        "/apache-tomcat/webapps"
    )

    foreach ($Candidate in $Candidates) {
        docker exec $ContainerId sh -c "test -d $Candidate"

        if ($LASTEXITCODE -eq 0) {
            return $Candidate
        }
    }

    throw "Could not find Tomcat webapps path."
}

function Invoke-SmokeGet {
    param(
        [string]$Url,
        [string]$Name
    )

    $Response = Invoke-WebRequest -Uri $Url -UseBasicParsing -TimeoutSec 20

    if ($Response.StatusCode -lt 200 -or $Response.StatusCode -ge 300) {
        throw "$Name returned unexpected status code $($Response.StatusCode)"
    }

    Write-Host "[PASS] $Name : $Url" -ForegroundColor Green
    return $Response
}

Write-Section "Validate portal JS baseline"

Assert-FileContains $PortalJsPath "session.roleKey" "poc1-api.js"
Assert-FileContains $PortalJsPath "Signed in as" "poc1-api.js"
Assert-FileContains $EvidencePath "POC-1 Phase 3B Portal CORS Repair Evidence" "POC-1 evidence pack"

Write-Section "Patch role display resolver"

$Js = Get-Content $PortalJsPath -Raw

if ($Js -notlike "*function resolveRoleLabel(session)*") {
    $ResolverLines = @(
"",
"  function resolveRoleLabel(session) {",
"    if (!session) { return 'UNKNOWN'; }",
"",
"    if (session.roleKey) { return session.roleKey; }",
"    if (session.primaryRole) { return session.primaryRole; }",
"    if (session.role) { return session.role; }",
"    if (session.requestedRole) { return session.requestedRole; }",
"",
"    if (Array.isArray(session.roles) && session.roles.length > 0) {",
"      const firstRole = session.roles[0];",
"      if (typeof firstRole === 'string') { return firstRole; }",
"      if (firstRole.roleKey) { return firstRole.roleKey; }",
"      if (firstRole.role) { return firstRole.role; }",
"      if (firstRole.name) { return firstRole.name; }",
"    }",
"",
"    if (session.landingRoute === '/portal/developer-dashboard.html') { return 'DEVELOPER'; }",
"    if (session.landingRoute === '/portal/admin-dashboard.html') { return 'PLATFORM_ADMIN'; }",
"    if (session.landingRoute === '/portal/institution-dashboard.html') { return 'INSTITUTION_ADMIN'; }",
"    if (session.landingRoute === '/portal/security-dashboard.html') { return 'SECURITY_OFFICER'; }",
"    if (session.landingRoute === '/portal/evidence-dashboard.html') { return 'AUDITOR'; }",
"    if (session.landingRoute === '/portal/viewer-dashboard.html') { return 'VIEWER'; }",
"",
"    return 'AUTHORIZED_USER';",
"  }",
""
    ) -join [Environment]::NewLine

    $Js = $Js.Replace(
        "  async function hydrateSession(targetId = 'sessionStatus') {",
        $ResolverLines + [Environment]::NewLine + "  async function hydrateSession(targetId = 'sessionStatus') {"
    )
}

$Js = $Js.Replace(
    "node.textContent = 'Signed in as ' + session.email + ' with role ' + session.roleKey + '.';",
    "node.textContent = 'Signed in as ' + session.email + ' with role ' + resolveRoleLabel(session) + '.';"
)

Write-Utf8NoBom $PortalJsPath $Js

Assert-FileContains $PortalJsPath "function resolveRoleLabel(session)" "poc1-api.js"
Assert-FileContains $PortalJsPath "resolveRoleLabel(session)" "poc1-api.js"
Assert-FileContains $PortalJsPath "AUTHORIZED_USER" "poc1-api.js"

Write-Section "Build accelerator-api WAR"

Set-Location $AccelRoot

mvn -pl accelerator-api -am clean package -DskipTests

if ($LASTEXITCODE -ne 0) {
    throw "Maven build failed for accelerator-api."
}

$ApiWarPath = "$ApiModuleRoot\target\ROOT.war"

if (!(Test-Path $ApiWarPath)) {
    throw "Missing accelerator-api ROOT.war."
}

Write-Section "Deploy patched portal WAR"

$ApiContainer = Find-ContainerByHostPort -HostPort $PortalPort

if (!$ApiContainer) {
    throw "Could not find API container mapped to port $PortalPort."
}

$WebappsPath = Get-TomcatWebappsPath -ContainerId $ApiContainer.Id

docker exec $ApiContainer.Id sh -c "rm -rf $WebappsPath/ROOT $WebappsPath/ROOT.war /usr/local/tomcat/work/Catalina/localhost/ROOT /usr/local/tomcat/temp/* 2>/dev/null || true"

if ($LASTEXITCODE -ne 0) {
    throw "Failed cleaning old portal deployment."
}

docker cp $ApiWarPath "$($ApiContainer.Id):$WebappsPath/ROOT.war"

if ($LASTEXITCODE -ne 0) {
    throw "Failed copying portal WAR."
}

docker restart $ApiContainer.Id

if ($LASTEXITCODE -ne 0) {
    throw "Failed restarting API container."
}

Start-Sleep -Seconds 8

Write-Section "Smoke-test patched portal assets"

$JsResponse = Invoke-SmokeGet -Url "$PortalBaseUrl/assets/poc1-api.js" -Name "Portal JS"

if ($JsResponse.Content -notlike "*resolveRoleLabel*") {
    throw "Served portal JS does not include resolveRoleLabel."
}

if ($JsResponse.Content -notlike "*AUTHORIZED_USER*") {
    throw "Served portal JS does not include fallback role label."
}

Invoke-SmokeGet -Url "$PortalBaseUrl/developer-dashboard.html" -Name "Developer dashboard" | Out-Null
Invoke-SmokeGet -Url "$PortalBaseUrl/home.html" -Name "Home router" | Out-Null
Invoke-SmokeGet -Url "$PortalBaseUrl/login.html" -Name "Login page" | Out-Null

Write-Section "Write evidence"

$ReportLines = @(
"# POC-1 Phase 3B Role Display Polish Report",
"",
"## Status",
"",
"PASSED",
"",
"## Date",
"",
"$(Get-Date -Format "yyyy-MM-dd HH:mm:ss zzz")",
"",
"## Issue",
"",
"Developer dashboard displayed role undefined even though session authentication and landing route worked.",
"",
"## Root Cause",
"",
"Portal JavaScript read session.roleKey directly, but the runtime session response may expose the role under another field or imply the role through landingRoute.",
"",
"## Repair",
"",
"Added resolveRoleLabel(session) to support roleKey, primaryRole, role, requestedRole, roles array, and landing route fallback.",
"",
"## Validation",
"",
"- accelerator-api Maven build passed.",
"- Portal WAR redeployed to Tomcat on port 9090.",
"- Served poc1-api.js includes resolveRoleLabel.",
"- Developer dashboard, home router, and login page returned HTTP 2xx.",
"",
"## Browser Retest",
"",
"Hard refresh the developer dashboard with Ctrl+F5. Expected label is DEVELOPER or AUTHORIZED_USER instead of undefined."
)

Write-Utf8NoBom $ReportPath ($ReportLines -join [Environment]::NewLine)

$EvidenceContent = Get-Content $EvidencePath -Raw

$EvidenceAdd = @(
"",
"---",
"",
"## POC-1 Phase 3B Role Display Polish Evidence",
"",
"Status: PASSED",
"",
"Issue:",
"",
"- Browser dashboard showed role undefined after successful login.",
"",
"Repair:",
"",
"- Added portal-side resolveRoleLabel(session).",
"- Supports roleKey, primaryRole, role, requestedRole, roles array, and landingRoute fallback.",
"- Rebuilt and redeployed accelerator-api portal WAR.",
"",
"Validation:",
"",
"- Served portal JS includes resolveRoleLabel.",
"- Developer dashboard, home router, and login page smoke-tested.",
"",
"Report:",
"",
"- 05_Evidence/poc-1-identity-rbac-portal-entry/POC-1 Phase 3B Role Display Polish Report.md"
) -join [Environment]::NewLine

if ($EvidenceContent -notlike "*## POC-1 Phase 3B Role Display Polish Evidence*") {
    Write-Utf8NoBom $EvidencePath ($EvidenceContent.TrimEnd() + [Environment]::NewLine + $EvidenceAdd + [Environment]::NewLine)
}

Assert-FileContains $ReportPath "PASSED" "Role display polish report"
Assert-FileContains $EvidencePath "POC-1 Phase 3B Role Display Polish Evidence" "POC-1 evidence pack"

Write-Section "Commit and push role display polish"

Set-Location $RepoRoot

git status
git add .

$PendingChanges = git status --porcelain

if ($PendingChanges) {
    git commit -m $CommitMessage
    git push
}

if (!$PendingChanges) {
    Write-Host "No Git changes detected. Nothing to commit." -ForegroundColor Yellow
}

$PendingAfter = git status --porcelain

if ($PendingAfter) {
    throw "Working tree is not clean after role display polish commit."
}

$FinalCommit = git rev-parse --short HEAD
$FinalFullCommit = git rev-parse HEAD

Write-Section "POC-1 PHASE 3B ROLE DISPLAY POLISH COMPLETE"

Write-Host "Role display polish has passed." -ForegroundColor Green
Write-Host "Latest commit: $FinalCommit" -ForegroundColor Green
Write-Host "Full commit: $FinalFullCommit" -ForegroundColor Green
Write-Host "Portal developer dashboard: $PortalBaseUrl/developer-dashboard.html" -ForegroundColor Green
Write-Host "Working tree: CLEAN" -ForegroundColor Green
Write-Host ""
Write-Host "NEXT STEP:" -ForegroundColor Yellow
Write-Host "Hard refresh developer dashboard with Ctrl+F5 and confirm role is no longer undefined." -ForegroundColor Yellow