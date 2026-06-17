$ErrorActionPreference = "Stop"

$RepoRoot = "D:\ChatGPT Workspace Folder Projects\AIRA Projects"
$ValidationRoot = "D:\ChatGPT Workspace Folder Projects\AIRA GitHub Validation\aira_project_agents_others"
$ArtifactRoot = Join-Path $ValidationRoot "playwright-artifacts"
$EvidenceRoot = Join-Path $ValidationRoot "05_Evidence\poc-1-identity-rbac-portal-entry\playwright-enterprise-validation"
$LogsRoot = Join-Path $ValidationRoot "logs\playwright"
$RunStartedAt = Get-Date

Set-Location $RepoRoot

function Ensure-Dir {
    param([string]$Path)

    if (!(Test-Path $Path)) {
        New-Item -ItemType Directory -Force -Path $Path | Out-Null
    }
}

function Write-Utf8NoBom {
    param(
        [string]$Path,
        [string]$Content
    )

    $Parent = Split-Path $Path -Parent

    if (!(Test-Path $Parent)) {
        New-Item -ItemType Directory -Force -Path $Parent | Out-Null
    }

    $Utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($Path, $Content, $Utf8NoBom)
}

Ensure-Dir $ValidationRoot
Ensure-Dir $ArtifactRoot
Ensure-Dir $EvidenceRoot
Ensure-Dir $LogsRoot

$Env:AIRA_VALIDATION_ROOT = $ValidationRoot

# Defaults may be overridden in the shell before this script is called.
if ([string]::IsNullOrWhiteSpace($Env:AIRA_SIM_USERS)) { $Env:AIRA_SIM_USERS = "12" }
if ([string]::IsNullOrWhiteSpace($Env:AIRA_SIM_BATCH_SIZE)) { $Env:AIRA_SIM_BATCH_SIZE = "4" }
if ([string]::IsNullOrWhiteSpace($Env:AIRA_ENTERPRISE_SIM_USERS)) { $Env:AIRA_ENTERPRISE_SIM_USERS = "36" }
if ([string]::IsNullOrWhiteSpace($Env:AIRA_ENTERPRISE_BATCH_SIZE)) { $Env:AIRA_ENTERPRISE_BATCH_SIZE = "6" }
if ([string]::IsNullOrWhiteSpace($Env:AIRA_ENTERPRISE_BROWSER_CYCLES)) { $Env:AIRA_ENTERPRISE_BROWSER_CYCLES = "3" }
if ([string]::IsNullOrWhiteSpace($Env:AIRA_ENTERPRISE_MICROFUNCTION_REPEATS)) { $Env:AIRA_ENTERPRISE_MICROFUNCTION_REPEATS = "5" }
if ([string]::IsNullOrWhiteSpace($Env:AIRA_RANDOM_MICROFUNCTION_ROUNDS)) { $Env:AIRA_RANDOM_MICROFUNCTION_ROUNDS = "12" }
if ([string]::IsNullOrWhiteSpace($Env:AIRA_RANDOM_MICROFUNCTION_PROBES_PER_ROUND)) { $Env:AIRA_RANDOM_MICROFUNCTION_PROBES_PER_ROUND = "18" }

$SummaryPath = Join-Path $EvidenceRoot "POC-1 Playwright Enterprise Validation Run Summary.md"

$Summary = @()
$Summary += "# POC-1 Playwright Enterprise Validation Run Summary"
$Summary += ""
$Summary += "Status: RUNNING"
$Summary += ""
$Summary += "Started At: $($RunStartedAt.ToString("o"))"
$Summary += ""
$Summary += "Destination Root: $ValidationRoot"
$Summary += ""
$Summary += "## Simulation Settings"
$Summary += ""
$Summary += "- Baseline simulated users: $Env:AIRA_SIM_USERS"
$Summary += "- Baseline batch/concurrency threads: $Env:AIRA_SIM_BATCH_SIZE"
$Summary += "- Enterprise simulated users: $Env:AIRA_ENTERPRISE_SIM_USERS"
$Summary += "- Enterprise batch/concurrency threads: $Env:AIRA_ENTERPRISE_BATCH_SIZE"
$Summary += "- Enterprise browser cycles: $Env:AIRA_ENTERPRISE_BROWSER_CYCLES"
$Summary += "- Enterprise microfunction repeated reads: $Env:AIRA_ENTERPRISE_MICROFUNCTION_REPEATS"
$Summary += "- Randomized microfunction rounds: $Env:AIRA_RANDOM_MICROFUNCTION_ROUNDS"
$Summary += "- Randomized microfunction probes per round: $Env:AIRA_RANDOM_MICROFUNCTION_PROBES_PER_ROUND"
$Summary += "- Expected ordered microfunction keys: MF-IDENTITY-001 through MF-IDENTITY-058"
$Summary += ""
$Summary += "## Artifact Outputs"
$Summary += ""
$Summary += "- HTML report: $ArtifactRoot\playwright-report"
$Summary += "- Test results, videos, screenshots, traces: $ArtifactRoot\test-results"
$Summary += "- JSON/JUnit reports: $ArtifactRoot\reports"
$Summary += "- Log4js logs: $LogsRoot"
$Summary += "- Evidence JSON/Markdown: $EvidenceRoot"
$Summary += ""

Write-Utf8NoBom $SummaryPath ($Summary -join [Environment]::NewLine)

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "AIRA POC-1 Playwright Enterprise Validation Suite" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "Destination: $ValidationRoot"
Write-Host ""

npm run test:poc1-validation-suite

if ($LASTEXITCODE -ne 0) {
    $FailedAt = Get-Date
    $SummaryFail = Get-Content $SummaryPath -Raw
    $SummaryFail = $SummaryFail.Replace("Status: RUNNING", "Status: FAILED")
    $SummaryFail += [Environment]::NewLine
    $SummaryFail += "Finished At: $($FailedAt.ToString("o"))" + [Environment]::NewLine
    $SummaryFail += "" + [Environment]::NewLine
    $SummaryFail += "Result: FAILED" + [Environment]::NewLine
    Write-Utf8NoBom $SummaryPath $SummaryFail
    throw "Playwright enterprise validation suite failed. Inspect $ArtifactRoot and $EvidenceRoot."
}

$RunFinishedAt = Get-Date

$SummaryPass = Get-Content $SummaryPath -Raw
$SummaryPass = $SummaryPass.Replace("Status: RUNNING", "Status: PASSED")
$SummaryPass += [Environment]::NewLine
$SummaryPass += "Finished At: $($RunFinishedAt.ToString("o"))" + [Environment]::NewLine
$SummaryPass += "" + [Environment]::NewLine
$SummaryPass += "Result: PASSED" + [Environment]::NewLine
$SummaryPass += "" + [Environment]::NewLine
$SummaryPass += "Expected Passing Suites:" + [Environment]::NewLine
$SummaryPass += "" + [Environment]::NewLine
$SummaryPass += "- Baseline heavy gate: 9 tests" + [Environment]::NewLine
$SummaryPass += "- Enterprise heavy gate: 10 tests" + [Environment]::NewLine
$SummaryPass += "- Randomized microfunction gate: 3 tests" + [Environment]::NewLine
$SummaryPass += "- Total expected tests: 22" + [Environment]::NewLine
$SummaryPass += "" + [Environment]::NewLine
$SummaryPass += "Readiness Score: 10/10 if Playwright reports 22 passed." + [Environment]::NewLine

Write-Utf8NoBom $SummaryPath $SummaryPass

Write-Host ""
Write-Host "============================================================" -ForegroundColor Green
Write-Host "AIRA POC-1 Playwright Enterprise Validation Suite PASSED" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Green
Write-Host ""
Write-Host "Validation destination:" -ForegroundColor Cyan
Write-Host $ValidationRoot
Write-Host ""
Write-Host "Summary:" -ForegroundColor Cyan
Write-Host $SummaryPath
Write-Host ""
Write-Host "HTML report:" -ForegroundColor Cyan
Write-Host "$ArtifactRoot\playwright-report"
Write-Host ""
Write-Host "Videos/screenshots/traces:" -ForegroundColor Cyan
Write-Host "$ArtifactRoot\test-results"
Write-Host ""
Write-Host "JSON/JUnit reports:" -ForegroundColor Cyan
Write-Host "$ArtifactRoot\reports"
Write-Host ""
Write-Host "Evidence:" -ForegroundColor Cyan
Write-Host $EvidenceRoot