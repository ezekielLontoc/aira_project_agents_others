# ============================================================
# AIRA POC-1 Build Phase 3 Portal
# Static dependency-light portal pages
# Served by accelerator-api Tomcat runtime on port 9090
# Identity APIs remain on accelerator-security port 9091
# PowerShell 5.1 Compatible
# ============================================================

$ErrorActionPreference = "Stop"

$RepoRoot = "D:\ChatGPT Workspace Folder Projects\AIRA Projects"
$AccelRoot = "$RepoRoot\03_DevSecOps_Accelerator"
$ApiModuleRoot = "$AccelRoot\accelerator-api"
$PortalRoot = "$ApiModuleRoot\src\main\resources\static\portal"
$PortalAssetsRoot = "$PortalRoot\assets"

$EvidenceRoot = "$RepoRoot\05_Evidence\poc-1-identity-rbac-portal-entry"
$EvidencePath = "$EvidenceRoot\POC-1 Evidence Pack.md"
$Phase3ReportPath = "$EvidenceRoot\POC-1 Phase 3 Portal Validation Report.md"

$ServerIp = "192.168.179.193"
$PortalPort = 9090
$IdentityPort = 9091
$PortalBaseUrl = "http://$ServerIp`:$PortalPort/portal"
$IdentityBaseUrl = "http://$ServerIp`:$IdentityPort"

$CommitMessage = "POC-1 - add phase 3 identity portal pages"

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

function Join-Lines {
    param([string[]]$Lines)
    return ($Lines -join [Environment]::NewLine)
}

function Write-Section {
    param([string]$Text)

    Write-Host ""
    Write-Host "============================================================" -ForegroundColor Cyan
    Write-Host $Text -ForegroundColor Cyan
    Write-Host "============================================================" -ForegroundColor Cyan
}

function Assert-PathExists {
    param(
        [string]$Path,
        [string]$Name
    )

    if (!(Test-Path $Path)) {
        throw "Missing required path for $Name : $Path"
    }

    Write-Host "[PASS] $Name exists" -ForegroundColor Green
}

function Assert-FileContains {
    param(
        [string]$Path,
        [string]$ExpectedText,
        [string]$Name
    )

    if (!(Test-Path $Path)) {
        throw "Missing file for validation: $Path"
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

    try {
        $Response = Invoke-WebRequest -Uri $Url -UseBasicParsing -TimeoutSec 20

        if ($Response.StatusCode -lt 200 -or $Response.StatusCode -ge 300) {
            throw "Unexpected status code: $($Response.StatusCode)"
        }

        Write-Host "[PASS] $Name : $Url" -ForegroundColor Green
        return $Response
    } catch {
        throw "[FAIL] $Name failed: $Url : $($_.Exception.Message)"
    }
}

Write-Section "Validate Phase 3 baseline"

Assert-PathExists $RepoRoot "AIRA repo root"
Assert-PathExists $AccelRoot "Accelerator root"
Assert-PathExists $ApiModuleRoot "accelerator-api module"
Assert-PathExists $EvidencePath "POC-1 evidence pack"

Assert-FileContains $EvidencePath "POC-1 Exact Login Timestamp Runtime Repair Evidence" "POC-1 evidence pack"
Assert-FileContains $EvidencePath "Status: PASSED" "POC-1 evidence pack"

Write-Section "Create portal directories"

New-Item -ItemType Directory -Force -Path $PortalRoot | Out-Null
New-Item -ItemType Directory -Force -Path $PortalAssetsRoot | Out-Null

Write-Section "Write portal CSS"

$CssLines = @(
":root {",
"  --aira-bg: #07111f;",
"  --aira-panel: #0f1f33;",
"  --aira-panel-2: #132842;",
"  --aira-text: #eef6ff;",
"  --aira-muted: #a8bdd4;",
"  --aira-accent: #66e3ff;",
"  --aira-accent-2: #9affc6;",
"  --aira-danger: #ff7b8a;",
"  --aira-warn: #ffd166;",
"  --aira-border: rgba(255,255,255,0.14);",
"}",
"* { box-sizing: border-box; }",
"body {",
"  margin: 0;",
"  font-family: Arial, Helvetica, sans-serif;",
"  background: radial-gradient(circle at top left, #12345a 0, #07111f 42%, #030712 100%);",
"  color: var(--aira-text);",
"  min-height: 100vh;",
"}",
"a { color: var(--aira-accent); text-decoration: none; }",
"a:hover { text-decoration: underline; }",
".aira-shell { min-height: 100vh; display: flex; flex-direction: column; }",
".aira-topbar {",
"  display: flex; align-items: center; justify-content: space-between;",
"  padding: 18px 28px; border-bottom: 1px solid var(--aira-border);",
"  background: rgba(7,17,31,0.86); backdrop-filter: blur(8px);",
"}",
".aira-brand { font-weight: 800; letter-spacing: 0.08em; }",
".aira-brand span { color: var(--aira-accent); }",
".aira-nav { display: flex; gap: 16px; flex-wrap: wrap; }",
".aira-main { width: min(1120px, calc(100% - 32px)); margin: 0 auto; padding: 42px 0; flex: 1; }",
".hero { display: grid; grid-template-columns: 1.1fr 0.9fr; gap: 28px; align-items: center; }",
".card { background: linear-gradient(180deg, rgba(19,40,66,0.96), rgba(15,31,51,0.96)); border: 1px solid var(--aira-border); border-radius: 20px; padding: 26px; box-shadow: 0 18px 60px rgba(0,0,0,0.35); }",
".grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 18px; }",
".grid-2 { display: grid; grid-template-columns: repeat(2, 1fr); gap: 18px; }",
"h1 { font-size: clamp(34px, 5vw, 64px); margin: 0 0 18px; line-height: 1.02; }",
"h2 { margin-top: 0; font-size: 28px; }",
"h3 { margin-bottom: 8px; }",
"p { color: var(--aira-muted); line-height: 1.65; }",
".badge { display: inline-flex; border: 1px solid var(--aira-border); border-radius: 999px; padding: 8px 12px; color: var(--aira-accent-2); background: rgba(154,255,198,0.08); font-size: 13px; }",
".button-row { display: flex; gap: 12px; flex-wrap: wrap; margin-top: 22px; }",
".btn { border: 0; border-radius: 12px; padding: 12px 18px; font-weight: 700; cursor: pointer; display: inline-flex; align-items: center; justify-content: center; }",
".btn-primary { background: linear-gradient(135deg, var(--aira-accent), var(--aira-accent-2)); color: #031018; }",
".btn-secondary { background: rgba(255,255,255,0.08); color: var(--aira-text); border: 1px solid var(--aira-border); }",
".btn-danger { background: rgba(255,123,138,0.16); color: var(--aira-danger); border: 1px solid rgba(255,123,138,0.36); }",
"form { display: grid; gap: 14px; }",
"label { display: grid; gap: 8px; font-weight: 700; color: var(--aira-text); }",
"input, select, textarea { width: 100%; border: 1px solid var(--aira-border); border-radius: 12px; padding: 12px 13px; background: rgba(255,255,255,0.06); color: var(--aira-text); }",
"textarea { min-height: 110px; resize: vertical; }",
"input::placeholder, textarea::placeholder { color: rgba(238,246,255,0.45); }",
".notice { border: 1px solid var(--aira-border); border-radius: 14px; padding: 14px; margin: 16px 0; color: var(--aira-muted); background: rgba(255,255,255,0.06); white-space: pre-wrap; }",
".notice.success { border-color: rgba(154,255,198,0.45); color: var(--aira-accent-2); }",
".notice.error { border-color: rgba(255,123,138,0.45); color: var(--aira-danger); }",
".notice.warn { border-color: rgba(255,209,102,0.45); color: var(--aira-warn); }",
".table { width: 100%; border-collapse: collapse; overflow: hidden; border-radius: 14px; }",
".table th, .table td { text-align: left; padding: 12px; border-bottom: 1px solid var(--aira-border); color: var(--aira-muted); }",
".table th { color: var(--aira-text); background: rgba(255,255,255,0.06); }",
".footer { padding: 20px 28px; border-top: 1px solid var(--aira-border); color: var(--aira-muted); font-size: 13px; }",
".kpi { font-size: 34px; font-weight: 800; color: var(--aira-accent); }",
".small { font-size: 13px; color: var(--aira-muted); }",
".hidden { display: none !important; }",
"@media (max-width: 860px) { .hero, .grid, .grid-2 { grid-template-columns: 1fr; } .aira-topbar { align-items: flex-start; flex-direction: column; gap: 12px; } }"
)

Write-Utf8NoBom "$PortalAssetsRoot\poc1.css" (Join-Lines $CssLines)

Write-Section "Write portal JavaScript"

$JsLines = @(
"const AIRA = (() => {",
"  const identityBaseUrl = localStorage.getItem('aira.identityBaseUrl') || 'http://192.168.179.193:9091';",
"  const apiKey = localStorage.getItem('aira.apiKey') || 'aira-local-dev-key-change-me';",
"",
"  function headers(extra = {}) {",
"    return Object.assign({",
"      'Content-Type': 'application/json',",
"      'X-AIRA-API-Key': apiKey",
"    }, extra);",
"  }",
"",
"  function getSessionToken() {",
"    return localStorage.getItem('aira.sessionToken') || '';",
"  }",
"",
"  function setSessionToken(token) {",
"    if (token) { localStorage.setItem('aira.sessionToken', token); }",
"  }",
"",
"  function clearSession() {",
"    localStorage.removeItem('aira.sessionToken');",
"    localStorage.removeItem('aira.identityContext');",
"  }",
"",
"  function authHeaders() {",
"    const token = getSessionToken();",
"    return headers(token ? { 'Authorization': 'Bearer ' + token } : {});",
"  }",
"",
"  async function request(path, options = {}) {",
"    const response = await fetch(identityBaseUrl + path, options);",
"    const text = await response.text();",
"    let body = {};",
"    try { body = text ? JSON.parse(text) : {}; } catch (e) { body = { raw: text }; }",
"    if (!response.ok) {",
"      const message = body.message || body.error || response.status + ' ' + response.statusText;",
"      throw new Error(message);",
"    }",
"    return body;",
"  }",
"",
"  function show(id, message, mode = '') {",
"    const node = document.getElementById(id);",
"    if (!node) { return; }",
"    node.className = 'notice' + (mode ? ' ' + mode : '');",
"    node.textContent = message;",
"    node.classList.remove('hidden');",
"  }",
"",
"  function value(id) {",
"    const node = document.getElementById(id);",
"    return node ? node.value.trim() : '';",
"  }",
"",
"  function checked(id) {",
"    const node = document.getElementById(id);",
"    return !!(node && node.checked);",
"  }",
"",
"  async function signup(event) {",
"    event.preventDefault();",
"    show('formStatus', 'Submitting request...', 'warn');",
"    try {",
"      const result = await request('/api/v1/identity/signup', {",
"        method: 'POST',",
"        headers: headers(),",
"        body: JSON.stringify({",
"          firstName: value('firstName'),",
"          lastName: value('lastName'),",
"          email: value('email'),",
"          institutionKey: value('institutionKey') || 'AIRA-DEMO-INSTITUTION',",
"          department: value('department'),",
"          jobTitle: value('jobTitle'),",
"          requestedRole: value('requestedRole') || 'DEVELOPER',",
"          requestReason: value('requestReason'),",
"          password: value('password'),",
"          confirmPassword: value('confirmPassword'),",
"          acceptGovernancePolicy: checked('acceptGovernancePolicy'),",
"          acceptTermsOfUse: checked('acceptTermsOfUse')",
"        })",
"      });",
"      localStorage.setItem('aira.lastSignupEmail', value('email'));",
"      if (result.localOnlyVerificationToken) {",
"        localStorage.setItem('aira.localOnlyVerificationToken', result.localOnlyVerificationToken);",
"      }",
"      window.location.href = '/portal/signup-submitted.html';",
"    } catch (error) {",
"      show('formStatus', error.message, 'error');",
"    }",
"  }",
"",
"  async function verifyEmail(event) {",
"    event.preventDefault();",
"    const token = value('token') || localStorage.getItem('aira.localOnlyVerificationToken') || '';",
"    show('verifyStatus', 'Verifying email...', 'warn');",
"    try {",
"      const result = await request('/api/v1/identity/verify-email', {",
"        method: 'POST',",
"        headers: headers(),",
"        body: JSON.stringify({ token })",
"      });",
"      if (result.status === 'VERIFIED') {",
"        show('verifyStatus', 'Email verified. Your request is now pending institution approval.', 'success');",
"        setTimeout(() => { window.location.href = '/portal/pending-approval.html'; }, 900);",
"      } else {",
"        show('verifyStatus', JSON.stringify(result, null, 2), 'warn');",
"      }",
"    } catch (error) {",
"      show('verifyStatus', error.message, 'error');",
"    }",
"  }",
"",
"  async function login(event) {",
"    event.preventDefault();",
"    show('loginStatus', 'Signing in...', 'warn');",
"    try {",
"      const result = await request('/api/v1/identity/login', {",
"        method: 'POST',",
"        headers: headers(),",
"        body: JSON.stringify({",
"          email: value('email'),",
"          password: value('password'),",
"          institutionKey: value('institutionKey') || 'AIRA-DEMO-INSTITUTION'",
"        })",
"      });",
"      setSessionToken(result.sessionToken);",
"      localStorage.setItem('aira.identityContext', JSON.stringify(result));",
"      const landing = await request('/api/v1/identity/landing-context', {",
"        method: 'GET',",
"        headers: authHeaders()",
"      });",
"      window.location.href = landing.landingRoute || '/portal/home.html';",
"    } catch (error) {",
"      show('loginStatus', error.message, 'error');",
"    }",
"  }",
"",
"  async function hydrateSession(targetId = 'sessionStatus') {",
"    try {",
"      const session = await request('/api/v1/identity/session', { method: 'GET', headers: authHeaders() });",
"      if (session.authenticated !== true) {",
"        show(targetId, 'You are not signed in. Redirecting to login...', 'warn');",
"        setTimeout(() => { window.location.href = '/portal/login.html'; }, 800);",
"        return null;",
"      }",
"      localStorage.setItem('aira.identityContext', JSON.stringify(session));",
"      const node = document.getElementById(targetId);",
"      if (node) {",
"        node.className = 'notice success';",
"        node.textContent = 'Signed in as ' + session.email + ' with role ' + session.roleKey + '.';",
"      }",
"      return session;",
"    } catch (error) {",
"      show(targetId, error.message, 'error');",
"      return null;",
"    }",
"  }",
"",
"  async function routeHome() {",
"    const session = await hydrateSession('sessionStatus');",
"    if (!session) { return; }",
"    const landing = await request('/api/v1/identity/landing-context', { method: 'GET', headers: authHeaders() });",
"    const routeNode = document.getElementById('landingRoute');",
"    if (routeNode) { routeNode.textContent = landing.landingRoute || '/portal/home.html'; }",
"    const button = document.getElementById('continueButton');",
"    if (button) { button.href = landing.landingRoute || '/portal/home.html'; }",
"  }",
"",
"  async function logout() {",
"    try {",
"      await request('/api/v1/identity/logout', { method: 'POST', headers: authHeaders() });",
"    } catch (e) {",
"      console.warn(e);",
"    }",
"    clearSession();",
"    window.location.href = '/portal/login.html';",
"  }",
"",
"  function initSignupSubmitted() {",
"    const email = localStorage.getItem('aira.lastSignupEmail') || 'your email';",
"    const token = localStorage.getItem('aira.localOnlyVerificationToken') || '';",
"    const emailNode = document.getElementById('submittedEmail');",
"    const tokenNode = document.getElementById('localToken');",
"    if (emailNode) { emailNode.textContent = email; }",
"    if (tokenNode) { tokenNode.value = token; }",
"  }",
"",
"  function initVerifyPage() {",
"    const token = localStorage.getItem('aira.localOnlyVerificationToken') || '';",
"    const tokenInput = document.getElementById('token');",
"    if (tokenInput && token) { tokenInput.value = token; }",
"  }",
"",
"  function dashboardTitle(roleName) {",
"    hydrateSession('sessionStatus').then(session => {",
"      const node = document.getElementById('dashboardTitle');",
"      if (node && session) { node.textContent = roleName + ' Dashboard - ' + session.email; }",
"    });",
"  }",
"",
"  return {",
"    identityBaseUrl,",
"    signup,",
"    verifyEmail,",
"    login,",
"    logout,",
"    hydrateSession,",
"    routeHome,",
"    initSignupSubmitted,",
"    initVerifyPage,",
"    dashboardTitle",
"  };",
"})();"
)

Write-Utf8NoBom "$PortalAssetsRoot\poc1-api.js" (Join-Lines $JsLines)

Write-Section "Write shared HTML helper pages"

function New-Page {
    param(
        [string]$FileName,
        [string]$Title,
        [string]$BodyHtml,
        [string]$ExtraScript = ""
    )

    $Html = @(
"<!doctype html>",
"<html lang=""en"">",
"<head>",
"  <meta charset=""utf-8"">",
"  <meta name=""viewport"" content=""width=device-width, initial-scale=1"">",
"  <title>$Title</title>",
"  <link rel=""stylesheet"" href=""/portal/assets/poc1.css"">",
"</head>",
"<body>",
"  <div class=""aira-shell"">",
"    <header class=""aira-topbar"">",
"      <div class=""aira-brand"">AIRA <span>POC-1</span></div>",
"      <nav class=""aira-nav"">",
"        <a href=""/portal/landing.html"">Landing</a>",
"        <a href=""/portal/signup.html"">Signup</a>",
"        <a href=""/portal/login.html"">Login</a>",
"        <a href=""/portal/home.html"">Home</a>",
"      </nav>",
"    </header>",
"    <main class=""aira-main"">",
$BodyHtml,
"    </main>",
"    <footer class=""footer"">AIRA POC-1 Institution-Aware Identity and RBAC Portal Entry</footer>",
"  </div>",
"  <script src=""/portal/assets/poc1-api.js""></script>",
$ExtraScript,
"</body>",
"</html>"
    ) -join [Environment]::NewLine

    Write-Utf8NoBom "$PortalRoot\$FileName" $Html
}

$LandingBody = @(
"<section class=""hero"">",
"  <div>",
"    <span class=""badge"">Governed portal entry</span>",
"    <h1>Institution-aware access for AIRA.</h1>",
"    <p>POC-1 validates signup, email verification, institution approval, login, session context, and role-based landing.</p>",
"    <div class=""button-row"">",
"      <a class=""btn btn-primary"" href=""/portal/signup.html"">Request Access</a>",
"      <a class=""btn btn-secondary"" href=""/portal/login.html"">Login</a>",
"    </div>",
"  </div>",
"  <div class=""card"">",
"    <h2>Runtime validated</h2>",
"    <p>This portal connects to the POC-1 identity APIs on the security runtime.</p>",
"    <div class=""grid-2"">",
"      <div><div class=""kpi"">9090</div><p>Portal runtime</p></div>",
"      <div><div class=""kpi"">9091</div><p>Identity runtime</p></div>",
"    </div>",
"  </div>",
"</section>",
"<section class=""grid"" style=""margin-top:24px"">",
"  <div class=""card""><h3>Signup</h3><p>Users request access under an institution context.</p></div>",
"  <div class=""card""><h3>Approval</h3><p>Admins approve access and assign a role.</p></div>",
"  <div class=""card""><h3>RBAC landing</h3><p>Users land on the correct dashboard after login.</p></div>",
"</section>"
) -join [Environment]::NewLine

New-Page -FileName "landing.html" -Title "AIRA POC-1 Landing" -BodyHtml $LandingBody

$SignupBodyHtml = @(
"<section class=""card"">",
"  <span class=""badge"">Request institution access</span>",
"  <h1>Signup</h1>",
"  <p>Create a POC-1 access request. Local validation uses AIRA-DEMO-INSTITUTION.</p>",
"  <div id=""formStatus"" class=""notice hidden""></div>",
"  <form onsubmit=""AIRA.signup(event)"">",
"    <div class=""grid-2"">",
"      <label>First name<input id=""firstName"" required placeholder=""POC1""></label>",
"      <label>Last name<input id=""lastName"" required placeholder=""User""></label>",
"    </div>",
"    <label>Email<input id=""email"" type=""email"" required placeholder=""name@aira.local""></label>",
"    <div class=""grid-2"">",
"      <label>Institution key<input id=""institutionKey"" value=""AIRA-DEMO-INSTITUTION""></label>",
"      <label>Requested role<select id=""requestedRole""><option>DEVELOPER</option><option>VIEWER</option><option>AUDITOR</option><option>SECURITY_OFFICER</option><option>INSTITUTION_ADMIN</option></select></label>",
"    </div>",
"    <div class=""grid-2"">",
"      <label>Department<input id=""department"" value=""AIRA Runtime Validation""></label>",
"      <label>Job title<input id=""jobTitle"" value=""POC-1 Portal User""></label>",
"    </div>",
"    <label>Reason<textarea id=""requestReason"">POC-1 Phase 3 portal validation</textarea></label>",
"    <div class=""grid-2"">",
"      <label>Password<input id=""password"" type=""password"" required value=""AiraLocalDev!2026""></label>",
"      <label>Confirm password<input id=""confirmPassword"" type=""password"" required value=""AiraLocalDev!2026""></label>",
"    </div>",
"    <label><input id=""acceptGovernancePolicy"" type=""checkbox"" checked> I accept the governance policy.</label>",
"    <label><input id=""acceptTermsOfUse"" type=""checkbox"" checked> I accept the terms of use.</label>",
"    <button class=""btn btn-primary"" type=""submit"">Submit Access Request</button>",
"  </form>",
"</section>"
) -join [Environment]::NewLine

New-Page -FileName "signup.html" -Title "AIRA POC-1 Signup" -BodyHtml $SignupBodyHtml

$SignupSubmittedBody = @(
"<section class=""card"">",
"  <span class=""badge"">Signup submitted</span>",
"  <h1>Check verification</h1>",
"  <p>Your signup request was submitted for <strong id=""submittedEmail""></strong>.</p>",
"  <p>For local POC validation only, the backend returns a local-only verification token. Use it on the verification page.</p>",
"  <label>Local-only verification token<input id=""localToken"" readonly></label>",
"  <div class=""button-row"">",
"    <a class=""btn btn-primary"" href=""/portal/verify-email.html"">Verify Email</a>",
"    <a class=""btn btn-secondary"" href=""/portal/login.html"">Go to Login</a>",
"  </div>",
"</section>"
) -join [Environment]::NewLine

New-Page -FileName "signup-submitted.html" -Title "AIRA POC-1 Signup Submitted" -BodyHtml $SignupSubmittedBody -ExtraScript "<script>AIRA.initSignupSubmitted();</script>"

$VerifyBody = @(
"<section class=""card"">",
"  <span class=""badge"">Email verification</span>",
"  <h1>Verify email</h1>",
"  <p>Paste the local-only verification token from signup.</p>",
"  <div id=""verifyStatus"" class=""notice hidden""></div>",
"  <form onsubmit=""AIRA.verifyEmail(event)"">",
"    <label>Verification token<input id=""token"" required></label>",
"    <button class=""btn btn-primary"" type=""submit"">Verify Email</button>",
"  </form>",
"</section>"
) -join [Environment]::NewLine

New-Page -FileName "verify-email.html" -Title "AIRA POC-1 Verify Email" -BodyHtml $VerifyBody -ExtraScript "<script>AIRA.initVerifyPage();</script>"

$PendingBody = @(
"<section class=""card"">",
"  <span class=""badge"">Pending approval</span>",
"  <h1>Institution approval required</h1>",
"  <p>Your email is verified. An institution administrator must approve your access request before login succeeds.</p>",
"  <div class=""notice warn"">Admin approval is performed through the POC-1 admin API during this phase. The admin dashboard is included as a role-based landing target.</div>",
"  <div class=""button-row"">",
"    <a class=""btn btn-secondary"" href=""/portal/login.html"">Try Login</a>",
"    <a class=""btn btn-secondary"" href=""/portal/landing.html"">Back to Landing</a>",
"  </div>",
"</section>"
) -join [Environment]::NewLine

New-Page -FileName "pending-approval.html" -Title "AIRA POC-1 Pending Approval" -BodyHtml $PendingBody

$LoginBody = @(
"<section class=""card"">",
"  <span class=""badge"">Secure login</span>",
"  <h1>Login</h1>",
"  <p>Login after email verification and institution approval.</p>",
"  <div id=""loginStatus"" class=""notice hidden""></div>",
"  <form onsubmit=""AIRA.login(event)"">",
"    <label>Email<input id=""email"" type=""email"" required placeholder=""name@aira.local""></label>",
"    <label>Password<input id=""password"" type=""password"" required value=""AiraLocalDev!2026""></label>",
"    <label>Institution key<input id=""institutionKey"" value=""AIRA-DEMO-INSTITUTION""></label>",
"    <button class=""btn btn-primary"" type=""submit"">Login</button>",
"  </form>",
"</section>"
) -join [Environment]::NewLine

New-Page -FileName "login.html" -Title "AIRA POC-1 Login" -BodyHtml $LoginBody

$HomeBody = @(
"<section class=""card"">",
"  <span class=""badge"">Session router</span>",
"  <h1>Home router</h1>",
"  <div id=""sessionStatus"" class=""notice warn"">Checking session...</div>",
"  <p>Your resolved landing route:</p>",
"  <div class=""notice success"" id=""landingRoute"">Resolving...</div>",
"  <div class=""button-row"">",
"    <a id=""continueButton"" class=""btn btn-primary"" href=""/portal/home.html"">Continue</a>",
"    <button class=""btn btn-danger"" onclick=""AIRA.logout()"">Logout</button>",
"  </div>",
"</section>"
) -join [Environment]::NewLine

New-Page -FileName "home.html" -Title "AIRA POC-1 Home" -BodyHtml $HomeBody -ExtraScript "<script>AIRA.routeHome();</script>"

function New-DashboardPage {
    param(
        [string]$FileName,
        [string]$RoleName,
        [string]$Description
    )

    $Body = @(
"<section class=""card"">",
"  <span class=""badge"">Role dashboard</span>",
"  <h1 id=""dashboardTitle"">$RoleName Dashboard</h1>",
"  <div id=""sessionStatus"" class=""notice warn"">Checking session...</div>",
"  <p>$Description</p>",
"  <section class=""grid"" style=""margin-top:20px"">",
"    <div class=""card""><h3>Identity context</h3><p>Session, institution, and RBAC state are resolved from the runtime identity API.</p></div>",
"    <div class=""card""><h3>Governed access</h3><p>Access depends on active identity, institution approval, and role assignment.</p></div>",
"    <div class=""card""><h3>Evidence-ready</h3><p>Login, session, approval, and microfunction execution are captured as evidence.</p></div>",
"  </section>",
"  <div class=""button-row"">",
"    <a class=""btn btn-secondary"" href=""/portal/home.html"">Home Router</a>",
"    <button class=""btn btn-danger"" onclick=""AIRA.logout()"">Logout</button>",
"  </div>",
"</section>"
    ) -join [Environment]::NewLine

    New-Page -FileName $FileName -Title "AIRA POC-1 $RoleName Dashboard" -BodyHtml $Body -ExtraScript "<script>AIRA.dashboardTitle('$RoleName');</script>"
}

New-DashboardPage -FileName "admin-dashboard.html" -RoleName "Platform Admin" -Description "Manage institution-aware access requests and platform governance."
New-DashboardPage -FileName "institution-dashboard.html" -RoleName "Institution Admin" -Description "Review institution users, approvals, and role assignments."
New-DashboardPage -FileName "developer-dashboard.html" -RoleName "Developer" -Description "Enter the governed developer workspace after identity and RBAC validation."
New-DashboardPage -FileName "security-dashboard.html" -RoleName "Security Officer" -Description "Monitor security posture, access, and policy alignment."
New-DashboardPage -FileName "evidence-dashboard.html" -RoleName "Evidence Auditor" -Description "Review traceability, audit events, and evidence readiness."
New-DashboardPage -FileName "viewer-dashboard.html" -RoleName "Viewer" -Description "Access read-only governed project context."

Write-Section "Validate portal files"

$ExpectedFiles = @(
"landing.html",
"signup.html",
"signup-submitted.html",
"verify-email.html",
"pending-approval.html",
"login.html",
"home.html",
"admin-dashboard.html",
"institution-dashboard.html",
"developer-dashboard.html",
"security-dashboard.html",
"evidence-dashboard.html",
"viewer-dashboard.html",
"assets\poc1.css",
"assets\poc1-api.js"
)

foreach ($File in $ExpectedFiles) {
    Assert-PathExists "$PortalRoot\$File" "portal/$File"
}

Assert-FileContains "$PortalRoot\signup.html" "AIRA.signup" "signup.html"
Assert-FileContains "$PortalRoot\login.html" "AIRA.login" "login.html"
Assert-FileContains "$PortalRoot\home.html" "AIRA.routeHome" "home.html"
Assert-FileContains "$PortalAssetsRoot\poc1-api.js" "/api/v1/identity/signup" "poc1-api.js"
Assert-FileContains "$PortalAssetsRoot\poc1-api.js" "/api/v1/identity/login" "poc1-api.js"
Assert-FileContains "$PortalAssetsRoot\poc1-api.js" "/api/v1/identity/landing-context" "poc1-api.js"

Write-Section "Build accelerator-api WAR"

Set-Location $AccelRoot
mvn -pl accelerator-api -am clean package -DskipTests

if ($LASTEXITCODE -ne 0) {
    throw "Maven build failed for accelerator-api."
}

$ApiWarPath = "$ApiModuleRoot\target\ROOT.war"

Assert-PathExists $ApiWarPath "accelerator-api ROOT.war"

Write-Section "Deploy portal WAR to Tomcat API container"

$ApiContainer = Find-ContainerByHostPort -HostPort $PortalPort

if (!$ApiContainer) {
    throw "Could not find API container mapped to host port $PortalPort."
}

$WebappsPath = Get-TomcatWebappsPath -ContainerId $ApiContainer.Id

Write-Host "[PASS] API container: $($ApiContainer.Name) / $($ApiContainer.Id)" -ForegroundColor Green
Write-Host "[PASS] API webapps path: $WebappsPath" -ForegroundColor Green

docker exec $ApiContainer.Id sh -c "rm -rf $WebappsPath/ROOT $WebappsPath/ROOT.war /usr/local/tomcat/work/Catalina/localhost/ROOT /usr/local/tomcat/temp/* 2>/dev/null || true"

if ($LASTEXITCODE -ne 0) {
    throw "Failed cleaning API ROOT deployment."
}

docker cp $ApiWarPath "$($ApiContainer.Id):$WebappsPath/ROOT.war"

if ($LASTEXITCODE -ne 0) {
    throw "Failed copying API ROOT.war into Tomcat."
}

docker restart $ApiContainer.Id

if ($LASTEXITCODE -ne 0) {
    throw "Failed restarting API Tomcat container."
}

Start-Sleep -Seconds 8

Write-Section "Smoke-test served portal pages"

$SmokePages = @(
"landing.html",
"signup.html",
"signup-submitted.html",
"verify-email.html",
"pending-approval.html",
"login.html",
"home.html",
"developer-dashboard.html",
"admin-dashboard.html",
"institution-dashboard.html",
"security-dashboard.html",
"evidence-dashboard.html",
"viewer-dashboard.html",
"assets/poc1.css",
"assets/poc1-api.js"
)

foreach ($Page in $SmokePages) {
    Invoke-SmokeGet -Url "$PortalBaseUrl/$Page" -Name "GET /portal/$Page" | Out-Null
}

$LandingResponse = Invoke-SmokeGet -Url "$PortalBaseUrl/landing.html" -Name "Landing content validation"
if ($LandingResponse.Content -notlike "*Institution-aware access for AIRA*") {
    throw "Landing page did not contain expected hero text."
}

$JsResponse = Invoke-SmokeGet -Url "$PortalBaseUrl/assets/poc1-api.js" -Name "Portal JS content validation"
if ($JsResponse.Content -notlike "*http://192.168.179.193:9091*") {
    throw "Portal JS did not contain expected identity runtime base URL."
}

Write-Section "Write Phase 3 validation report"

$ReportLines = @(
"# POC-1 Phase 3 Portal Validation Report",
"",
"## Status",
"",
"PASSED",
"",
"## Date",
"",
"$(Get-Date -Format "yyyy-MM-dd HH:mm:ss zzz")",
"",
"## Runtime",
"",
"- Portal base URL: $PortalBaseUrl",
"- Identity base URL: $IdentityBaseUrl",
"- API Tomcat container: $($ApiContainer.Name)",
"- API Tomcat container ID: $($ApiContainer.Id)",
"",
"## Portal Files",
"",
"- landing.html",
"- signup.html",
"- signup-submitted.html",
"- verify-email.html",
"- pending-approval.html",
"- login.html",
"- home.html",
"- admin-dashboard.html",
"- institution-dashboard.html",
"- developer-dashboard.html",
"- security-dashboard.html",
"- evidence-dashboard.html",
"- viewer-dashboard.html",
"- assets/poc1.css",
"- assets/poc1-api.js",
"",
"## Smoke Tests",
"",
"All portal pages and assets returned HTTP 2xx from the server IP runtime.",
"",
"## Identity Runtime Integration",
"",
"- Signup page calls /api/v1/identity/signup.",
"- Verify page calls /api/v1/identity/verify-email.",
"- Login page calls /api/v1/identity/login.",
"- Home router calls /api/v1/identity/session and /api/v1/identity/landing-context.",
"- Dashboards validate active session before showing role context.",
"",
"## Conclusion",
"",
"POC-1 Phase 3 static portal shell is built, deployed, and smoke-tested. Browser flow validation may proceed next."
)

Write-Utf8NoBom $Phase3ReportPath (Join-Lines $ReportLines)

Write-Section "Update evidence pack"

$EvidenceContent = Get-Content $EvidencePath -Raw

$EvidenceAdd = @(
"",
"---",
"",
"## POC-1 Build Phase 3 Portal Evidence",
"",
"Status: PASSED",
"",
"Scope:",
"",
"- Static dependency-light portal pages created under accelerator-api.",
"- Portal assets created under /portal/assets.",
"- accelerator-api WAR rebuilt.",
"- Portal runtime deployed to Tomcat on port 9090.",
"- Portal pages smoke-tested over server IP.",
"",
"Created pages:",
"",
"- /portal/landing.html",
"- /portal/signup.html",
"- /portal/signup-submitted.html",
"- /portal/verify-email.html",
"- /portal/pending-approval.html",
"- /portal/login.html",
"- /portal/home.html",
"- /portal/admin-dashboard.html",
"- /portal/institution-dashboard.html",
"- /portal/developer-dashboard.html",
"- /portal/security-dashboard.html",
"- /portal/evidence-dashboard.html",
"- /portal/viewer-dashboard.html",
"",
"Runtime URLs:",
"",
"- Portal: $PortalBaseUrl/landing.html",
"- Identity runtime: $IdentityBaseUrl",
"",
"Validation report:",
"",
"- 05_Evidence/poc-1-identity-rbac-portal-entry/POC-1 Phase 3 Portal Validation Report.md",
"",
"Next phase:",
"",
"- POC-1 Phase 3B browser flow validation: signup, verify, admin approve, login, home route, developer dashboard, logout."
) -join [Environment]::NewLine

if ($EvidenceContent -notlike "*## POC-1 Build Phase 3 Portal Evidence*") {
    Write-Utf8NoBom $EvidencePath ($EvidenceContent.TrimEnd() + [Environment]::NewLine + $EvidenceAdd + [Environment]::NewLine)
}

Assert-FileContains $Phase3ReportPath "PASSED" "Phase 3 validation report"
Assert-FileContains $Phase3ReportPath "Browser flow validation may proceed next" "Phase 3 validation report"
Assert-FileContains $EvidencePath "POC-1 Build Phase 3 Portal Evidence" "POC-1 evidence pack"

Write-Section "Commit and push Phase 3 portal"

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
    throw "Working tree is not clean after Phase 3 commit."
}

$FinalCommit = git rev-parse --short HEAD
$FinalFullCommit = git rev-parse HEAD

Write-Section "POC-1 BUILD PHASE 3 PORTAL COMPLETE"

Write-Host "POC-1 Phase 3 portal pages have been built, deployed, validated, committed, and pushed." -ForegroundColor Green
Write-Host "Latest commit: $FinalCommit" -ForegroundColor Green
Write-Host "Full commit: $FinalFullCommit" -ForegroundColor Green
Write-Host "Portal landing: $PortalBaseUrl/landing.html" -ForegroundColor Green
Write-Host "Portal login: $PortalBaseUrl/login.html" -ForegroundColor Green
Write-Host "Portal signup: $PortalBaseUrl/signup.html" -ForegroundColor Green
Write-Host "Working tree: CLEAN" -ForegroundColor Green
Write-Host ""
Write-Host "NEXT STEP:" -ForegroundColor Yellow
Write-Host "POC-1 Phase 3B browser flow validation can begin after this output is confirmed." -ForegroundColor Yellow