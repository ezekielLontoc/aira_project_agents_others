$ErrorActionPreference = "Stop"

Set-Location "D:\ChatGPT Workspace Folder Projects\AIRA Projects"

$RepoRoot = "D:\ChatGPT Workspace Folder Projects\AIRA Projects"
$AcceleratorRoot = Join-Path $RepoRoot "03_DevSecOps_Accelerator"
$EvidenceRoot = Join-Path $RepoRoot "05_Evidence\poc-1b-login-risk-step-up-governance"

$MigrationRootCandidates = @(
    (Join-Path $RepoRoot "src\main\resources\db\migration"),
    (Join-Path $RepoRoot "src\main\resources\db\migrations"),
    (Join-Path $RepoRoot "03_DevSecOps_Accelerator\db\migration"),
    (Join-Path $RepoRoot "03_DevSecOps_Accelerator\database\migration"),
    (Join-Path $RepoRoot "03_DevSecOps_Accelerator\database\flyway\migration"),
    (Join-Path $RepoRoot "03_DevSecOps_Accelerator\flyway\sql")
)

$MigrationRoot = $null

foreach ($Candidate in $MigrationRootCandidates) {
    if (Test-Path $Candidate) {
        $MigrationRoot = $Candidate
        break
    }
}

if ($null -eq $MigrationRoot) {
    $MigrationRoot = Join-Path $AcceleratorRoot "db\migration"
}

$RequiredFiles = @(
    (Join-Path $MigrationRoot "V20__poc1b_login_risk_tables.sql"),
    (Join-Path $MigrationRoot "V21__poc1b_step_up_and_account_lock_tables.sql"),
    (Join-Path $MigrationRoot "V22__poc1b_login_risk_microfunction_seed_data.sql"),
    "03_DevSecOps_Accelerator\policies\identity\poc1b-login-risk-step-up.rego",
    "03_DevSecOps_Accelerator\policies\identity\poc1b-login-risk-step-up_test.rego",
    "03_DevSecOps_Accelerator\workflows\poc1b-account-unlock-approval.bpmn20.xml",
    "05_Evidence\poc-1b-login-risk-step-up-governance\POC-1B Phase 1 Database Migration Evidence.md",
    "05_Evidence\poc-1b-login-risk-step-up-governance\POC-1B Phase 1 OPA Policy Validation Evidence.md",
    "05_Evidence\poc-1b-login-risk-step-up-governance\POC-1B Phase 1 Flowable Workflow Validation Evidence.md",
    "05_Evidence\poc-1b-login-risk-step-up-governance\POC-1B Phase 1 Technical Foundation Summary.md"
)

foreach ($File in $RequiredFiles) {
    if (!(Test-Path $File)) {
        throw "Missing required Phase 1 file: $File"
    }
}

$V22Text = Get-Content (Join-Path $MigrationRoot "V22__poc1b_login_risk_microfunction_seed_data.sql") -Raw

foreach ($Number in 1..40) {
    $Key = "MF-LOGIN-RISK-{0:D3}" -f $Number

    if ($V22Text -notlike "*$Key*") {
        throw "Missing seeded MicroFunction in V22: $Key"
    }
}

$PolicyText = Get-Content "03_DevSecOps_Accelerator\policies\identity\poc1b-login-risk-step-up.rego" -Raw
$PolicyTestText = Get-Content "03_DevSecOps_Accelerator\policies\identity\poc1b-login-risk-step-up_test.rego" -Raw

$PolicyMarkers = @(
    "allow_login",
    "require_step_up",
    "lock_account",
    "require_unlock_approval",
    "ACCOUNT_LOCKED",
    "TOO_MANY_FAILURES",
    "HIGH_RISK_LOGIN"
)

foreach ($Marker in $PolicyMarkers) {
    if ($PolicyText -notlike "*$Marker*") {
        throw "Policy missing marker: $Marker"
    }
}

$PolicyTestMarkers = @(
    "test_low_risk_allows_login",
    "test_medium_high_risk_requires_step_up",
    "test_repeated_failures_lock_account",
    "test_critical_risk_locks_account",
    "test_locked_account_has_deny_reason"
)

foreach ($Marker in $PolicyTestMarkers) {
    if ($PolicyTestText -notlike "*$Marker*") {
        throw "Policy test missing marker: $Marker"
    }
}

$WorkflowPath = "03_DevSecOps_Accelerator\workflows\poc1b-account-unlock-approval.bpmn20.xml"
[xml]$WorkflowXml = Get-Content $WorkflowPath -Raw

$WorkflowText = Get-Content $WorkflowPath -Raw

$WorkflowMarkers = @(
    "poc1bAccountUnlockApproval",
    "Security Officer Review",
    "Unlock Decision",
    "Unlock Approved",
    "Unlock Rejected"
)

foreach ($Marker in $WorkflowMarkers) {
    if ($WorkflowText -notlike "*$Marker*") {
        throw "Workflow missing marker: $Marker"
    }
}

$OpaCommand = Get-Command opa -ErrorAction SilentlyContinue

if ($null -ne $OpaCommand) {
    opa test "03_DevSecOps_Accelerator\policies\identity"
    if ($LASTEXITCODE -ne 0) {
        throw "opa test failed."
    }
    Write-Host "OPA binary available and opa test passed." -ForegroundColor Green
} else {
    Write-Host "OPA binary not found. Static policy validation passed." -ForegroundColor Yellow
}

Write-Host "POC-1B Phase 1 technical foundation validation PASSED." -ForegroundColor Green
Write-Host "MicroFunctions validated in seed SQL: MF-LOGIN-RISK-001 through MF-LOGIN-RISK-040" -ForegroundColor Green