# ============================================================
# AIRA POC-1 Phase 2 Validation
# Identity Core APIs
# PowerShell 5.1 Compatible
# ============================================================

$ErrorActionPreference = "Stop"

$RepoRoot = "D:\ChatGPT Workspace Folder Projects\AIRA Projects"
$AccelRoot = "$RepoRoot\03_DevSecOps_Accelerator"
$SecurityModuleRoot = "$AccelRoot\accelerator-security"
$EvidenceRoot = "$RepoRoot\05_Evidence\poc-1-identity-rbac-portal-entry"
$EvidencePath = "$EvidenceRoot\POC-1 Evidence Pack.md"

function Write-Section {
    param([string]$Text)
    Write-Host ""
    Write-Host "============================================================" -ForegroundColor Cyan
    Write-Host $Text -ForegroundColor Cyan
    Write-Host "============================================================" -ForegroundColor Cyan
}

function Assert-PathExists {
    param([string]$Path, [string]$Name)
    if (!(Test-Path $Path)) { throw "Missing $Name : $Path" }
    Write-Host "[PASS] $Name exists" -ForegroundColor Green
}

function Assert-FileContains {
    param([string]$Path, [string]$ExpectedText, [string]$Name)
    $Content = Get-Content $Path -Raw
    if ($Content -notlike "*$ExpectedText*") { throw "$Name missing expected text: $ExpectedText" }
    Write-Host "[PASS] $Name contains $ExpectedText" -ForegroundColor Green
}

Write-Section "Resolve identity Java files"

$IdentityFiles = Get-ChildItem -Path $SecurityModuleRoot\src\main\java -Recurse -Filter "Identity*.java" -File

$Controller = $IdentityFiles | Where-Object { $_.Name -eq "IdentityController.java" } | Select-Object -First 1
$AdminController = $IdentityFiles | Where-Object { $_.Name -eq "IdentityAdminController.java" } | Select-Object -First 1
$Service = $IdentityFiles | Where-Object { $_.Name -eq "IdentityService.java" } | Select-Object -First 1
$Models = $IdentityFiles | Where-Object { $_.Name -eq "IdentityModels.java" } | Select-Object -First 1
$Util = $IdentityFiles | Where-Object { $_.Name -eq "IdentitySecurityUtil.java" } | Select-Object -First 1

if (!$Controller) { throw "Missing IdentityController.java" }
if (!$AdminController) { throw "Missing IdentityAdminController.java" }
if (!$Service) { throw "Missing IdentityService.java" }
if (!$Models) { throw "Missing IdentityModels.java" }
if (!$Util) { throw "Missing IdentitySecurityUtil.java" }

Write-Host "[PASS] Identity Java files resolved" -ForegroundColor Green

Assert-FileContains $Controller.FullName "/api/v1/identity" "IdentityController"
Assert-FileContains $Controller.FullName "/signup" "IdentityController"
Assert-FileContains $Controller.FullName "/verify-email" "IdentityController"
Assert-FileContains $Controller.FullName "/login" "IdentityController"
Assert-FileContains $Controller.FullName "/logout" "IdentityController"
Assert-FileContains $Controller.FullName "/landing-context" "IdentityController"
Assert-FileContains $AdminController.FullName "/api/v1/identity/admin" "IdentityAdminController"
Assert-FileContains $Service.FullName "BCryptPasswordEncoder" "IdentityService"
Assert-FileContains $Service.FullName "identity_microfunction_execution" "IdentityService"
Assert-FileContains $Service.FullName "localOnlyVerificationToken" "IdentityService"
Assert-FileContains $Util.FullName "sha256" "IdentitySecurityUtil"

Write-Section "Validate evidence pack"

Assert-PathExists $EvidencePath "POC-1 evidence pack"
Assert-FileContains $EvidencePath "POC-1 Build Phase 2 Evidence" "POC-1 evidence pack"

Write-Section "Run Maven build for accelerator-security"

Set-Location $AccelRoot
mvn -pl accelerator-security -am clean package -DskipTests

Write-Section "Validate Git working tree"

Set-Location $RepoRoot
$GitStatus = git status --porcelain

if ($GitStatus) {
    Write-Host $GitStatus -ForegroundColor Yellow
    throw "Working tree has pending changes. Commit/push phase may not have completed."
}

Write-Host "[PASS] Git working tree is clean" -ForegroundColor Green
$Commit = git rev-parse --short HEAD
$FullCommit = git rev-parse HEAD

Write-Section "POC-1 PHASE 2 VALIDATION PASSED"
Write-Host "Latest commit: $Commit" -ForegroundColor Green
Write-Host "Full commit: $FullCommit" -ForegroundColor Green
Write-Host "POC-1 Phase 2 identity core APIs are ready for runtime validation and then portal build." -ForegroundColor Green