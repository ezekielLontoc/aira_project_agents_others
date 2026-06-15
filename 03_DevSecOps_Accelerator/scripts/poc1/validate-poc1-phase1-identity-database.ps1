# ============================================================
# AIRA POC-1 Phase 1 Validation
# Identity Database + Microfunction Foundation
# PowerShell 5.1 Compatible
# ============================================================

$ErrorActionPreference = "Stop"

$RepoRoot = "D:\ChatGPT Workspace Folder Projects\AIRA Projects"
$AccelRoot = "$RepoRoot\03_DevSecOps_Accelerator"
$EvidenceRoot = "$RepoRoot\05_Evidence\poc-1-identity-rbac-portal-entry"
$PocDocPath = "$AccelRoot\docs\architecture\POC-1-Institution-Aware-Identity-and-RBAC-Portal-Entry.md"
$AdrPath = "$AccelRoot\docs\adr\ADR-0013-POC-1-Institution-Aware-Identity-RBAC-Portal-Entry.md"
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

Write-Section "Resolve migration directory"

$MigrationCandidates = Get-ChildItem -Path $AccelRoot -Recurse -Directory -ErrorAction SilentlyContinue | Where-Object { $_.FullName -match "\\migration$|\\migrations$|\\db\\migration$|\\db\\migrations$" }
$Selected = $null
$BestCount = -1

foreach ($Dir in $MigrationCandidates) {
    $Count = @(Get-ChildItem -Path $Dir.FullName -Filter "V*.sql" -File -ErrorAction SilentlyContinue).Count
    if ($Count -gt $BestCount) {
        $BestCount = $Count
        $Selected = $Dir.FullName
    }
}

if (!$Selected) { $Selected = "$AccelRoot\migrations" }

$MigrationDir = $Selected
Write-Host "Migration directory: $MigrationDir" -ForegroundColor Green

Write-Section "Validate POC-1 Phase 1 migration files"

$Core = Get-ChildItem -Path $MigrationDir -Filter "V*__poc1_phase1_identity_core_tables.sql" -File -ErrorAction SilentlyContinue | Select-Object -First 1
$Micro = Get-ChildItem -Path $MigrationDir -Filter "V*__poc1_phase1_identity_microfunction_tables.sql" -File -ErrorAction SilentlyContinue | Select-Object -First 1
$Seed = Get-ChildItem -Path $MigrationDir -Filter "V*__poc1_phase1_identity_seed_data.sql" -File -ErrorAction SilentlyContinue | Select-Object -First 1

if (!$Core) { throw "Missing POC-1 core identity migration." }
if (!$Micro) { throw "Missing POC-1 microfunction table migration." }
if (!$Seed) { throw "Missing POC-1 seed data migration." }

Write-Host "[PASS] Core migration: $($Core.Name)" -ForegroundColor Green
Write-Host "[PASS] Microfunction migration: $($Micro.Name)" -ForegroundColor Green
Write-Host "[PASS] Seed migration: $($Seed.Name)" -ForegroundColor Green

Assert-FileContains $Core.FullName "aira_security.platform_identity" "Core migration"
Assert-FileContains $Core.FullName "aira_security.identity_session" "Core migration"
Assert-FileContains $Core.FullName "aira_security.identity_notification_outbox" "Core migration"
Assert-FileContains $Micro.FullName "identity_microfunction_catalog" "Microfunction migration"
Assert-FileContains $Micro.FullName "identity_microfunction_execution" "Microfunction migration"
Assert-FileContains $Seed.FullName "MF-IDENTITY-001" "Seed migration"
Assert-FileContains $Seed.FullName "MF-IDENTITY-058" "Seed migration"
Assert-FileContains $Seed.FullName "AIRA-DEMO-INSTITUTION" "Seed migration"
Assert-FileContains $Seed.FullName "VIEW_APPLICATION_FACTORY" "Seed migration"

Write-Section "Validate POC-1 documentation and evidence"

Assert-PathExists $PocDocPath "POC-1 architecture doc"
Assert-PathExists $AdrPath "POC-1 ADR"
Assert-PathExists $EvidencePath "POC-1 evidence pack"

Assert-FileContains $PocDocPath "31. POC-1 Microfunctions" "POC-1 architecture doc"
Assert-FileContains $PocDocPath "identity_microfunction_catalog" "POC-1 architecture doc"
Assert-FileContains $EvidencePath "Microfunctions Evidence Target" "POC-1 evidence pack"

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

Write-Section "POC-1 PHASE 1 VALIDATION PASSED"
Write-Host "Latest commit: $Commit" -ForegroundColor Green
Write-Host "Full commit: $FullCommit" -ForegroundColor Green
Write-Host "POC-1 Phase 1 database and microfunction foundation is ready." -ForegroundColor Green