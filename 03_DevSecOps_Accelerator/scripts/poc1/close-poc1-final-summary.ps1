# ============================================================
# AIRA POC-1 Final Closure Summary
# Closes POC-1 after Phase 3B final browser validation
# PowerShell 5.1 Compatible
# ============================================================

$ErrorActionPreference = "Stop"

$RepoRoot = "D:\ChatGPT Workspace Folder Projects\AIRA Projects"

$EvidenceRoot = "$RepoRoot\05_Evidence\poc-1-identity-rbac-portal-entry"
$EvidencePath = "$EvidenceRoot\POC-1 Evidence Pack.md"
$ClosurePath = "$EvidenceRoot\POC-1 Final Closure Summary.md"

$ArchitectureDocPath = "$RepoRoot\03_DevSecOps_Accelerator\docs\architecture\POC-1-Institution-Aware-Identity-and-RBAC-Portal-Entry.md"
$AdrPath = "$RepoRoot\03_DevSecOps_Accelerator\docs\adr\ADR-0013-POC-1-Institution-Aware-Identity-RBAC-Portal-Entry.md"

$CommitMessage = "POC-1 - add final closure summary"

$ServerIp = "192.168.179.193"
$PortalBaseUrl = "http://$ServerIp`:9090/portal"
$IdentityBaseUrl = "http://$ServerIp`:9091"

$FinalEvidenceCommit = "5612991d898b250fa9e763e4663ac5bb6f699d0d"
$BrowserAccount = "poc1.browser.20260615180057@aira.local"

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

Write-Section "Validate POC-1 evidence prerequisites"

Assert-FileContains $EvidencePath "POC-1 Phase 3B Final Browser Validation Evidence" "POC-1 evidence pack"
Assert-FileContains $EvidencePath "POC-1 Phase 3B Role Display Polish Evidence" "POC-1 evidence pack"
Assert-FileContains $EvidencePath "POC-1 Phase 3B Portal CORS Repair Evidence" "POC-1 evidence pack"
Assert-FileContains $EvidencePath "POC-1 Build Phase 3 Portal Evidence" "POC-1 evidence pack"

Assert-FileContains $ArchitectureDocPath "Institution-Aware Identity" "POC-1 architecture doc"
Assert-FileContains $AdrPath "POC-1" "POC-1 ADR"

Write-Section "Write POC-1 final closure summary"

$ClosureLines = @(
"# POC-1 Final Closure Summary",
"",
"## Status",
"",
"ACCEPTED",
"",
"## Closure Date",
"",
"$(Get-Date -Format "yyyy-MM-dd HH:mm:ss zzz")",
"",
"## POC Name",
"",
"POC-1 - Institution-Aware Identity and RBAC Portal Entry",
"",
"## Final Result",
"",
"POC-1 is complete, validated, evidence-backed, committed, pushed, and accepted for the defined local governed runtime scope.",
"",
"## Final Accepted Commit",
"",
"- Final evidence commit: $FinalEvidenceCommit",
"",
"## Runtime Baseline",
"",
"- Portal runtime: $PortalBaseUrl",
"- Identity runtime: $IdentityBaseUrl",
"- Portal host/IP: $ServerIp",
"- Runtime mode: Local Tomcat and PostgreSQL governed POC runtime",
"",
"## Validated User",
"",
"- Browser account: $BrowserAccount",
"- Institution key: AIRA-DEMO-INSTITUTION",
"- Role: DEVELOPER",
"- Landing route: /portal/developer-dashboard.html",
"",
"## Accepted Capabilities",
"",
"### 1. Institution-Aware Signup",
"",
"- Signup page is served from the portal runtime.",
"- Signup creates an access request against the identity runtime.",
"- Institution key validation supports AIRA-DEMO-INSTITUTION.",
"- Local verification token supports POC-only email verification.",
"",
"### 2. Email Verification",
"",
"- Verification API accepts the local verification token.",
"- Identity progresses into institution approval flow.",
"",
"### 3. Institution Approval",
"",
"- Admin approval endpoint activates the identity.",
"- Role assignment is created during approval.",
"- Approval audit evidence is captured by runtime tables.",
"",
"### 4. Login and Session",
"",
"- Login accepts the verified and approved browser test account.",
"- Runtime returns a session token.",
"- Session token is stored in browser localStorage.",
"- Session endpoint authenticates the active browser session.",
"",
"### 5. RBAC Landing Context",
"",
"- Landing context resolves the authenticated user to /portal/developer-dashboard.html.",
"- Developer dashboard is protected by active session state.",
"- Role display shows DEVELOPER.",
"",
"### 6. Home Router",
"",
"- Home router detects active browser session.",
"- Home router displays the resolved landing route.",
"- Unauthenticated state redirects to login.",
"",
"### 7. Logout",
"",
"- Logout endpoint invalidates the session.",
"- Session after logout returns DENIED.",
"",
"### 8. Evidence Readiness",
"",
"- Evidence pack updated.",
"- Phase 3B final browser validation report created.",
"- Role display polish report created.",
"- CORS repair report created.",
"- Build/runtime validation evidence retained.",
"",
"## Accepted Browser Validation",
"",
"Browser-confirmed final state:",
"",
"- URL: $PortalBaseUrl/developer-dashboard.html",
"- Display: Signed in as $BrowserAccount with role DEVELOPER.",
"- Landing route: /portal/developer-dashboard.html",
"- Developer dashboard rendered successfully.",
"",
"## Accepted Automated Runtime Validation",
"",
"- Portal developer dashboard returned HTTP 2xx.",
"- Portal home router returned HTTP 2xx.",
"- Portal login page returned HTTP 2xx.",
"- Portal signup page returned HTTP 2xx.",
"- Portal JavaScript returned HTTP 2xx.",
"- Portal JavaScript includes resolveRoleLabel.",
"- Identity API login returned a session token.",
"- Identity API session returned authenticated true.",
"- Identity API landing-context returned /portal/developer-dashboard.html.",
"- Identity API logout returned LOGGED_OUT.",
"- Identity API session after logout returned DENIED.",
"",
"## Commits Included In POC-1 Closure Path",
"",
"- bf03ae1 - update complete identity RBAC portal entry markdown",
"- ff75cbf - add identity microfunctions planning baseline",
"- 5f858f9 - add phase 1 identity database and microfunction foundation",
"- c8fe44a - repair phase 2 identity core API build dependency",
"- 58560a3 - fix login timestamp conversion and validate runtime flow",
"- bc3c8ec - add phase 3 identity portal pages",
"- e2165b9 - repair portal CORS for browser identity flow",
"- 72e7440 - polish phase 3B portal role display",
"- 5612991 - finalize phase 3B browser validation evidence",
"",
"## Known Local POC Constraints",
"",
"These items are intentionally outside the POC-1 local validation scope and belong to production hardening:",
"",
"- Real email delivery instead of local-only verification token.",
"- HTTPS and production TLS termination.",
"- Externalized secrets and managed secret rotation.",
"- MFA, password reset, invitation flow, and device trust.",
"- Admin review UI for access requests.",
"- Audit review UI for login and approval trails.",
"- Production-grade deployment topology.",
"",
"## Final Acceptance Statement",
"",
"POC-1 is accepted as a 10/10 local governed runtime build for the defined scope: institution-aware signup, verification, approval, login, session context, RBAC landing, role dashboard, logout, and evidence-backed validation.",
"",
"## Recommended Next Build Phase",
"",
"Proceed to POC-2 from this clean baseline. Recommended POC-2 direction:",
"",
"- Institution Admin Console and Access Governance",
"- access-request review UI",
"- approval/rejection screens",
"- role assignment management",
"- login/approval audit dashboards",
"- evidence export from portal",
"- institution-level visibility controls"
)

Write-Utf8NoBom $ClosurePath ($ClosureLines -join [Environment]::NewLine)

Assert-FileContains $ClosurePath "ACCEPTED" "POC-1 closure summary"
Assert-FileContains $ClosurePath "role DEVELOPER" "POC-1 closure summary"
Assert-FileContains $ClosurePath "5612991d898b250fa9e763e4663ac5bb6f699d0d" "POC-1 closure summary"
Assert-FileContains $ClosurePath "Recommended Next Build Phase" "POC-1 closure summary"

Write-Section "Update evidence pack with closure entry"

$EvidenceContent = Get-Content $EvidencePath -Raw

$EvidenceAdd = @(
"",
"---",
"",
"## POC-1 Final Closure Evidence",
"",
"Status: ACCEPTED",
"",
"Closure summary:",
"",
"- 05_Evidence/poc-1-identity-rbac-portal-entry/POC-1 Final Closure Summary.md",
"",
"Final accepted result:",
"",
"- POC-1 is complete for the defined local governed runtime scope.",
"- Browser flow validated successfully.",
"- Role displayed as DEVELOPER.",
"- Runtime identity login/session/landing/logout flow passed.",
"- Final evidence commit: $FinalEvidenceCommit.",
"",
"Recommended next build phase:",
"",
"- POC-2 - Institution Admin Console and Access Governance."
) -join [Environment]::NewLine

if ($EvidenceContent -notlike "*## POC-1 Final Closure Evidence*") {
    Write-Utf8NoBom $EvidencePath ($EvidenceContent.TrimEnd() + [Environment]::NewLine + $EvidenceAdd + [Environment]::NewLine)
}

Assert-FileContains $EvidencePath "POC-1 Final Closure Evidence" "POC-1 evidence pack"
Assert-FileContains $EvidencePath "POC-2 - Institution Admin Console and Access Governance" "POC-1 evidence pack"

Write-Section "Commit and push POC-1 closure"

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
    throw "Working tree is not clean after POC-1 final closure commit."
}

$FinalCommit = git rev-parse --short HEAD
$FinalFullCommit = git rev-parse HEAD

Write-Section "POC-1 FINAL CLOSURE COMPLETE"

Write-Host "POC-1 final closure summary has passed." -ForegroundColor Green
Write-Host "Latest commit: $FinalCommit" -ForegroundColor Green
Write-Host "Full commit: $FinalFullCommit" -ForegroundColor Green
Write-Host "Closure summary: $ClosurePath" -ForegroundColor Green
Write-Host "Recommended next build phase: POC-2 - Institution Admin Console and Access Governance" -ForegroundColor Green
Write-Host "Working tree: CLEAN" -ForegroundColor Green