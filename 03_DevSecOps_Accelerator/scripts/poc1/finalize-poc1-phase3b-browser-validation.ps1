# ============================================================
# AIRA POC-1 Phase 3B Final Browser Validation Evidence
# Records browser-confirmed end-to-end flow evidence
# PowerShell 5.1 Compatible
# ============================================================

$ErrorActionPreference = "Stop"

$RepoRoot = "D:\ChatGPT Workspace Folder Projects\AIRA Projects"
$AccelRoot = "$RepoRoot\03_DevSecOps_Accelerator"

$EvidenceRoot = "$RepoRoot\05_Evidence\poc-1-identity-rbac-portal-entry"
$EvidencePath = "$EvidenceRoot\POC-1 Evidence Pack.md"
$FinalReportPath = "$EvidenceRoot\POC-1 Phase 3B Final Browser Validation Report.md"

$ServerIp = "192.168.179.193"
$PortalPort = 9090
$IdentityPort = 9091

$PortalBaseUrl = "http://$ServerIp`:$PortalPort/portal"
$IdentityBaseUrl = "http://$ServerIp`:$IdentityPort"

$ApiKey = "aira-local-dev-key-change-me"
$BrowserEmail = "poc1.browser.20260615180057@aira.local"
$BrowserPassword = "AiraLocalDev!2026"
$InstitutionKey = "AIRA-DEMO-INSTITUTION"

$CommitMessage = "POC-1 - finalize phase 3B browser validation evidence"

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

function Invoke-JsonRequest {
    param(
        [string]$Method,
        [string]$Uri,
        [object]$Body = $null,
        [hashtable]$Headers = $null,
        [string]$Name = "HTTP request"
    )

    $Params = @{
        Method = $Method
        Uri = $Uri
        UseBasicParsing = $true
        TimeoutSec = 30
    }

    if ($Headers) {
        $Params.Headers = $Headers
    }

    if ($null -ne $Body) {
        $Params.ContentType = "application/json"
        $Params.Body = ($Body | ConvertTo-Json -Depth 30)
    }

    try {
        $Response = Invoke-RestMethod @Params
        Write-Host "[PASS] $Name" -ForegroundColor Green
        return $Response
    } catch {
        throw "[FAIL] $Name failed at $Uri : $($_.Exception.Message)"
    }
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

Write-Section "Validate existing evidence baseline"

Assert-FileContains $EvidencePath "POC-1 Build Phase 3 Portal Evidence" "POC-1 evidence pack"
Assert-FileContains $EvidencePath "POC-1 Phase 3B Portal CORS Repair Evidence" "POC-1 evidence pack"
Assert-FileContains $EvidencePath "POC-1 Phase 3B Role Display Polish Evidence" "POC-1 evidence pack"

Write-Section "Validate portal runtime pages"

$DeveloperDashboard = Invoke-SmokeGet -Url "$PortalBaseUrl/developer-dashboard.html" -Name "Developer dashboard"
$HomeRouter = Invoke-SmokeGet -Url "$PortalBaseUrl/home.html" -Name "Home router"
$LoginPage = Invoke-SmokeGet -Url "$PortalBaseUrl/login.html" -Name "Login page"
$SignupPage = Invoke-SmokeGet -Url "$PortalBaseUrl/signup.html" -Name "Signup page"
$PortalJs = Invoke-SmokeGet -Url "$PortalBaseUrl/assets/poc1-api.js" -Name "Portal JS"

if ($DeveloperDashboard.Content -notlike "*Developer Dashboard*") {
    throw "Developer dashboard did not include expected title."
}

if ($PortalJs.Content -notlike "*resolveRoleLabel*") {
    throw "Portal JS does not include role display resolver."
}

if ($PortalJs.Content -notlike "*landing-context*") {
    throw "Portal JS does not include landing-context integration."
}

Write-Section "Validate identity runtime with browser account"

$Login = Invoke-JsonRequest `
    -Method "POST" `
    -Uri "$IdentityBaseUrl/api/v1/identity/login" `
    -Headers @{ "X-AIRA-API-Key" = $ApiKey } `
    -Name "Identity API login for browser account" `
    -Body @{
        email = $BrowserEmail
        password = $BrowserPassword
        institutionKey = $InstitutionKey
    }

$SessionToken = $Login.sessionToken

if (!$SessionToken) {
    throw "Identity API login did not return sessionToken."
}

$SessionHeaders = @{
    "X-AIRA-API-Key" = $ApiKey
    "Authorization" = "Bearer $SessionToken"
}

$Session = Invoke-JsonRequest `
    -Method "GET" `
    -Uri "$IdentityBaseUrl/api/v1/identity/session" `
    -Headers $SessionHeaders `
    -Name "Identity API session"

if ($Session.authenticated -ne $true) {
    throw "Session did not return authenticated true."
}

$Landing = Invoke-JsonRequest `
    -Method "GET" `
    -Uri "$IdentityBaseUrl/api/v1/identity/landing-context" `
    -Headers $SessionHeaders `
    -Name "Identity API landing context"

if ($Landing.landingRoute -ne "/portal/developer-dashboard.html") {
    throw "Landing route mismatch. Actual: $($Landing.landingRoute)"
}

$Logout = Invoke-JsonRequest `
    -Method "POST" `
    -Uri "$IdentityBaseUrl/api/v1/identity/logout" `
    -Headers $SessionHeaders `
    -Name "Identity API logout"

if ($Logout.status -ne "LOGGED_OUT") {
    throw "Logout did not return LOGGED_OUT."
}

$AfterLogout = Invoke-JsonRequest `
    -Method "GET" `
    -Uri "$IdentityBaseUrl/api/v1/identity/session" `
    -Headers $SessionHeaders `
    -Name "Identity API session after logout"

if ($AfterLogout.status -ne "DENIED") {
    throw "Session after logout did not return DENIED."
}

Write-Section "Write final Phase 3B browser validation report"

$ReportLines = @(
"# POC-1 Phase 3B Final Browser Validation Report",
"",
"## Status",
"",
"PASSED",
"",
"## Date",
"",
"$(Get-Date -Format "yyyy-MM-dd HH:mm:ss zzz")",
"",
"## Browser-Confirmed Result",
"",
"User confirmed the browser reached the Developer Dashboard successfully and displayed the corrected role label.",
"",
"Confirmed dashboard state:",
"",
"- URL: $PortalBaseUrl/developer-dashboard.html",
"- User: $BrowserEmail",
"- Display: Signed in as $BrowserEmail with role DEVELOPER.",
"- Landing route: /portal/developer-dashboard.html",
"",
"## Validated Browser Flow",
"",
"- Portal login completed.",
"- Browser session token persisted.",
"- Home router authenticated the session.",
"- Landing context resolved to /portal/developer-dashboard.html.",
"- Developer dashboard loaded.",
"- Role label displayed DEVELOPER instead of undefined.",
"",
"## Automated Runtime Recheck",
"",
"- Developer dashboard returned HTTP 2xx.",
"- Home router returned HTTP 2xx.",
"- Login page returned HTTP 2xx.",
"- Signup page returned HTTP 2xx.",
"- Portal JS returned HTTP 2xx.",
"- Portal JS includes resolveRoleLabel.",
"- Portal JS includes landing-context integration.",
"- Identity API login returned sessionToken.",
"- Identity API session returned authenticated true.",
"- Identity API landing-context returned /portal/developer-dashboard.html.",
"- Identity API logout returned LOGGED_OUT.",
"- Identity API session after logout returned DENIED.",
"",
"## Runtime URLs",
"",
"- Portal base URL: $PortalBaseUrl",
"- Identity base URL: $IdentityBaseUrl",
"",
"## Test Account",
"",
"- Email: $BrowserEmail",
"- Institution key: $InstitutionKey",
"- Expected role: DEVELOPER",
"",
"## Conclusion",
"",
"POC-1 Phase 3B browser flow validation is accepted. POC-1 identity and portal entry are now validated end-to-end through browser and runtime APIs."
)

Write-Utf8NoBom $FinalReportPath ($ReportLines -join [Environment]::NewLine)

Write-Section "Update evidence pack"

$EvidenceContent = Get-Content $EvidencePath -Raw

$EvidenceAdd = @(
"",
"---",
"",
"## POC-1 Phase 3B Final Browser Validation Evidence",
"",
"Status: PASSED",
"",
"Browser-confirmed result:",
"",
"- User reached /portal/developer-dashboard.html.",
"- User displayed: $BrowserEmail.",
"- Role displayed: DEVELOPER.",
"- Home router resolved landing route to /portal/developer-dashboard.html.",
"",
"Automated runtime recheck:",
"",
"- Portal pages returned HTTP 2xx.",
"- Portal JS includes resolveRoleLabel.",
"- Identity API login/session/landing/logout flow passed.",
"- Session after logout returned DENIED.",
"",
"Final report:",
"",
"- 05_Evidence/poc-1-identity-rbac-portal-entry/POC-1 Phase 3B Final Browser Validation Report.md",
"",
"Accepted result:",
"",
"- POC-1 Phase 3B browser flow validation is accepted."
) -join [Environment]::NewLine

if ($EvidenceContent -notlike "*## POC-1 Phase 3B Final Browser Validation Evidence*") {
    Write-Utf8NoBom $EvidencePath ($EvidenceContent.TrimEnd() + [Environment]::NewLine + $EvidenceAdd + [Environment]::NewLine)
}

Assert-FileContains $FinalReportPath "PASSED" "Final Phase 3B browser validation report"
Assert-FileContains $FinalReportPath "role DEVELOPER" "Final Phase 3B browser validation report"
Assert-FileContains $FinalReportPath "/portal/developer-dashboard.html" "Final Phase 3B browser validation report"
Assert-FileContains $EvidencePath "POC-1 Phase 3B Final Browser Validation Evidence" "POC-1 evidence pack"

Write-Section "Commit and push final Phase 3B evidence"

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
    throw "Working tree is not clean after final Phase 3B evidence commit."
}

$FinalCommit = git rev-parse --short HEAD
$FinalFullCommit = git rev-parse HEAD

Write-Section "POC-1 PHASE 3B FINAL BROWSER VALIDATION COMPLETE"

Write-Host "POC-1 Phase 3B final browser validation evidence has passed." -ForegroundColor Green
Write-Host "Latest commit: $FinalCommit" -ForegroundColor Green
Write-Host "Full commit: $FinalFullCommit" -ForegroundColor Green
Write-Host "Portal developer dashboard: $PortalBaseUrl/developer-dashboard.html" -ForegroundColor Green
Write-Host "Browser account: $BrowserEmail" -ForegroundColor Green
Write-Host "Role display: DEVELOPER" -ForegroundColor Green
Write-Host "Working tree: CLEAN" -ForegroundColor Green
Write-Host ""
Write-Host "NEXT STEP:" -ForegroundColor Yellow
Write-Host "POC-1 can now move to final closure summary or the next build phase." -ForegroundColor Yellow