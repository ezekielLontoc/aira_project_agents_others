$ErrorActionPreference = "Stop"

Set-Location "D:\ChatGPT Workspace Folder Projects\AIRA Projects"

$RequiredFiles = @(
    "03_DevSecOps_Accelerator\docs\adr\ADR-0014-POC-1B-Login-Risk-Step-Up-Account-Lock-Governance.md",
    "03_DevSecOps_Accelerator\docs\architecture\POC-1B-Login-Risk-Step-Up-and-Account-Lock-Governance.md",
    "03_DevSecOps_Accelerator\docs\poc-1b-login-risk-step-up-governance\POC-1B Scope and Acceptance Criteria.md",
    "03_DevSecOps_Accelerator\docs\poc-1b-login-risk-step-up-governance\POC-1B MicroFunction Catalog.md",
    "03_DevSecOps_Accelerator\docs\poc-1b-login-risk-step-up-governance\migrations\POC-1B Flyway Migration Plan.md",
    "03_DevSecOps_Accelerator\policies\identity\poc1b-login-risk-step-up.rego",
    "03_DevSecOps_Accelerator\workflows\poc1b-account-unlock-approval.bpmn20.xml",
    "03_DevSecOps_Accelerator\api-contracts\poc-1b\poc1b-login-risk-api-contract.yaml",
    "03_DevSecOps_Accelerator\docs\poc-1b-login-risk-step-up-governance\frontend\POC-1B Frontend Screen Plan.md",
    "03_DevSecOps_Accelerator\docs\poc-1b-login-risk-step-up-governance\tests\POC-1B Test Plan.md",
    "05_Evidence\poc-1b-login-risk-step-up-governance\POC-1B Evidence Pack.md"
)

foreach ($File in $RequiredFiles) {
    if (!(Test-Path $File)) {
        throw "Missing required file: $File"
    }
}

$MfText = Get-Content "03_DevSecOps_Accelerator\docs\poc-1b-login-risk-step-up-governance\POC-1B MicroFunction Catalog.md" -Raw

foreach ($Number in 1..40) {
    $Key = "MF-LOGIN-RISK-{0:D3}" -f $Number

    if ($MfText -notlike "*$Key*") {
        throw "Missing microfunction key: $Key"
    }
}

$EvidenceText = Get-Content "05_Evidence\poc-1b-login-risk-step-up-governance\POC-1B Evidence Pack.md" -Raw

$Markers = @(
    "Suspicious Login Risk Review",
    "Login Failure Auto-Triage",
    "Account Lock / Unlock Human Approval",
    "Policy-Based Step-Up Authentication",
    "AI-Assisted Login Incident Analysis",
    "OPA/Rego policies",
    "Flowable approval workflow",
    "API contracts",
    "Frontend screens",
    "Tests",
    "Evidence",
    "Documentation"
)

foreach ($Marker in $Markers) {
    if ($EvidenceText -notlike "*$Marker*") {
        throw "Evidence pack missing marker: $Marker"
    }
}

Write-Host "POC-1B Phase 0 planning baseline validation PASSED." -ForegroundColor Green
Write-Host "MicroFunctions validated: MF-LOGIN-RISK-001 through MF-LOGIN-RISK-040" -ForegroundColor Green