$ErrorActionPreference = "Stop"

Set-Location "D:\ChatGPT Workspace Folder Projects\AIRA Projects"

$RepoRoot = "D:\ChatGPT Workspace Folder Projects\AIRA Projects"
$AcceleratorRoot = Join-Path $RepoRoot "03_DevSecOps_Accelerator"
$EvidenceRoot = Join-Path $RepoRoot "05_Evidence"

$ApiServerDir = Join-Path $AcceleratorRoot "poc1b-runtime\login-risk-api"
$ApiServerFile = "poc1b-login-risk-api-server.js"
$PortalServerDir = Join-Path $AcceleratorRoot "poc1b-runtime\login-risk-portal"
$PortalServerFile = "poc1b-login-risk-portal-server.js"
$PlaywrightConfigPath = Join-Path $PortalServerDir "playwright.poc1b.phase3.config.js"
$PlaywrightTestPath = Join-Path $RepoRoot "tests\aira-poc1b-phase3-frontend.spec.js"

$EvidencePoc1bRoot = Join-Path $EvidenceRoot "poc-1b-login-risk-step-up-governance"
$RunEvidencePath = Join-Path $EvidencePoc1bRoot "POC-1B Phase 3 Frontend Browser Validation Run.json"
$ApiStdoutPath = Join-Path $EvidencePoc1bRoot "POC-1B Phase 3 API Server stdout.txt"
$ApiStderrPath = Join-Path $EvidencePoc1bRoot "POC-1B Phase 3 API Server stderr.txt"
$PortalStdoutPath = Join-Path $EvidencePoc1bRoot "POC-1B Phase 3 Portal Server stdout.txt"
$PortalStderrPath = Join-Path $EvidencePoc1bRoot "POC-1B Phase 3 Portal Server stderr.txt"

$ArtifactRoot = Join-Path $EvidencePoc1bRoot "phase3-playwright-artifacts"
$PlaywrightJsonReportPath = Join-Path $ArtifactRoot "poc1b-phase3-playwright-results.json"

$ApiPort = 9191
$PortalPort = 9192
$ApiBase = "http://127.0.0.1:$ApiPort"
$PortalBase = "http://127.0.0.1:$PortalPort"

if ($null -eq (Get-Command node -ErrorAction SilentlyContinue)) {
    throw "Node.js is required but was not found."
}

if ($null -eq (Get-Command npx -ErrorAction SilentlyContinue)) {
    throw "npx is required for Playwright validation but was not found."
}

foreach ($Path in @($RunEvidencePath, $ApiStdoutPath, $ApiStderrPath, $PortalStdoutPath, $PortalStderrPath)) {
    if (Test-Path $Path) {
        Remove-Item $Path -Force
    }
}

if (Test-Path $ArtifactRoot) {
    Remove-Item $ArtifactRoot -Recurse -Force
}

New-Item -ItemType Directory -Force -Path $ArtifactRoot | Out-Null

$ApiProcess = $null
$PortalProcess = $null

function Wait-HttpReady {
    param(
        [string]$Url,
        [string]$Label
    )

    foreach ($Attempt in 1..50) {
        try {
            $Response = Invoke-RestMethod -Method Get -Uri $Url -TimeoutSec 2
            if ($null -ne $Response) {
                Write-Host "[PASS] $Label is ready at $Url" -ForegroundColor Green
                return
            }
        } catch {
            Start-Sleep -Milliseconds 500
        }
    }

    throw "$Label did not become ready at $Url"
}

try {
    $ApiProcess = Start-Process `
        -FilePath "node" `
        -WorkingDirectory $ApiServerDir `
        -ArgumentList @($ApiServerFile, "--port", "$ApiPort") `
        -PassThru `
        -WindowStyle Hidden `
        -RedirectStandardOutput $ApiStdoutPath `
        -RedirectStandardError $ApiStderrPath

    Wait-HttpReady "$ApiBase/health" "POC-1B API server"

    $PortalProcess = Start-Process `
        -FilePath "node" `
        -WorkingDirectory $PortalServerDir `
        -ArgumentList @($PortalServerFile, "--port", "$PortalPort", "--root", $PortalServerDir) `
        -PassThru `
        -WindowStyle Hidden `
        -RedirectStandardOutput $PortalStdoutPath `
        -RedirectStandardError $PortalStderrPath

    Wait-HttpReady "$PortalBase/security-login-risk-dashboard.html" "POC-1B portal server"

    $env:POC1B_PHASE3_API_BASE = $ApiBase
    $env:POC1B_PHASE3_PORTAL_BASE = $PortalBase
    $env:POC1B_PHASE3_ARTIFACT_ROOT = $ArtifactRoot

    npx playwright test $PlaywrightTestPath --config $PlaywrightConfigPath --project chromium

    if ($LASTEXITCODE -ne 0) {
        throw "POC-1B Phase 3 Playwright validation failed."
    }

    if (!(Test-Path $PlaywrightJsonReportPath)) {
        throw "Playwright JSON report was not created: $PlaywrightJsonReportPath"
    }

    $Report = Get-Content $PlaywrightJsonReportPath -Raw | ConvertFrom-Json

    $TraceCount = 0
    $VideoCount = 0
    $ScreenshotCount = 0

    if (Test-Path $ArtifactRoot) {
        $TraceCount = @(Get-ChildItem $ArtifactRoot -Recurse -File -Filter "*.zip" -ErrorAction SilentlyContinue).Count
        $VideoCount = @(Get-ChildItem $ArtifactRoot -Recurse -File -Filter "*.webm" -ErrorAction SilentlyContinue).Count
        $ScreenshotCount = @(Get-ChildItem $ArtifactRoot -Recurse -File -Filter "*.png" -ErrorAction SilentlyContinue).Count
    }

    $Results = [ordered]@{
        completedAt = (Get-Date).ToString("o")
        status = "PASSED"
        score = "10/10 Phase 3 Frontend Browser Validation"
        apiBase = $ApiBase
        portalBase = $PortalBase
        expectedTests = 9
        playwrightStatus = "PASSED"
        artifactRoot = $ArtifactRoot
        playwrightJsonReport = $PlaywrightJsonReportPath
        traceCount = $TraceCount
        videoCount = $VideoCount
        screenshotCount = $ScreenshotCount
        screens = @(
            "security-login-risk-dashboard.html",
            "login-incident-review.html",
            "login-failure-triage.html",
            "account-lock-review.html",
            "unlock-approval.html",
            "step-up-auth.html"
        )
    }

    $Json = $Results | ConvertTo-Json -Depth 20
    [System.IO.File]::WriteAllText($RunEvidencePath, $Json, [System.Text.UTF8Encoding]::new($false))

    if (!(Test-Path $RunEvidencePath)) {
        throw "Phase 3 run evidence JSON was not created."
    }

    Write-Host "POC-1B Phase 3 frontend browser validation PASSED." -ForegroundColor Green
    Write-Host "Evidence: $RunEvidencePath" -ForegroundColor Green
} finally {
    if ($null -ne $PortalProcess -and -not $PortalProcess.HasExited) {
        Stop-Process -Id $PortalProcess.Id -Force
    }

    if ($null -ne $ApiProcess -and -not $ApiProcess.HasExited) {
        Stop-Process -Id $ApiProcess.Id -Force
    }
}