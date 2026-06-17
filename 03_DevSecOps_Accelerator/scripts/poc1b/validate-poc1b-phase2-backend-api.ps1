$ErrorActionPreference = "Stop"

Set-Location "D:\ChatGPT Workspace Folder Projects\AIRA Projects"

$RepoRoot = "D:\ChatGPT Workspace Folder Projects\AIRA Projects"
$ServerPath = Join-Path $RepoRoot "03_DevSecOps_Accelerator\poc1b-runtime\login-risk-api\poc1b-login-risk-api-server.js"
$EvidenceRoot = Join-Path $RepoRoot "05_Evidence\poc-1b-login-risk-step-up-governance"
$RunEvidencePath = Join-Path $EvidenceRoot "POC-1B Phase 2 Backend API Validation Run.json"
$StdoutLogPath = Join-Path $EvidenceRoot "POC-1B Phase 2 Backend API Server stdout.log"
$StderrLogPath = Join-Path $EvidenceRoot "POC-1B Phase 2 Backend API Server stderr.log"

$Port = 9191
$BaseUrl = "http://127.0.0.1:$Port"

$NodeCommand = Get-Command node -ErrorAction SilentlyContinue

if ($null -eq $NodeCommand) {
    throw "Node.js is required for POC-1B Phase 2 validation but node was not found."
}

if (!(Test-Path $ServerPath)) {
    throw "Missing POC-1B API server at $ServerPath"
}

if (Test-Path $RunEvidencePath) {
    Remove-Item $RunEvidencePath -Force
}

if (Test-Path $StdoutLogPath) {
    Remove-Item $StdoutLogPath -Force
}

if (Test-Path $StderrLogPath) {
    Remove-Item $StderrLogPath -Force
}

$ExistingNode = Get-Process node -ErrorAction SilentlyContinue | Where-Object {
    try {
        $_.Path -and $_.Path.ToLower().EndsWith("node.exe")
    } catch {
        $false
    }
}

$ServerProcess = $null

function Invoke-JsonPost {
    param(
        [string]$Url,
        [object]$Body
    )

    $Json = $Body | ConvertTo-Json -Depth 20
    return Invoke-RestMethod -Method Post -Uri $Url -ContentType "application/json" -Body $Json
}

function Assert-True {
    param(
        [bool]$Condition,
        [string]$Message
    )

    if (-not $Condition) {
        throw $Message
    }

    Write-Host "[PASS] $Message" -ForegroundColor Green
}

try {
    $ServerProcess = Start-Process -FilePath "node" -ArgumentList @($ServerPath, "--port", "$Port") -PassThru -WindowStyle Hidden -RedirectStandardOutput $StdoutLogPath -RedirectStandardError $StderrLogPath

    $Ready = $false

    foreach ($Attempt in 1..40) {
        try {
            $Health = Invoke-RestMethod -Method Get -Uri "$BaseUrl/health" -TimeoutSec 2
            if ($Health.status -eq "UP") {
                $Ready = $true
                break
            }
        } catch {
            Start-Sleep -Milliseconds 500
        }
    }

    if (-not $Ready) {
        if (Test-Path $StderrLogPath) {
            Write-Host "Server stderr:" -ForegroundColor Red
            Get-Content $StderrLogPath
        }

        throw "POC-1B API server did not become ready on $BaseUrl"
    }

    $CheckResults = New-Object System.Collections.Generic.List[object]

    function Add-Check {
        param([string]$Name)
        $CheckResults.Add([ordered]@{
            name = $Name
            status = "PASSED"
            timestamp = (Get-Date).ToString("o")
        })
    }

    $Readiness = Invoke-RestMethod -Method Get -Uri "$BaseUrl/api/v1/identity/risk/readiness"
    Assert-True ($Readiness.status -eq "READY") "Readiness endpoint returned READY"
    Add-Check "readiness"

    Assert-True ($Readiness.microfunctionCount -eq 40) "Readiness endpoint returned 40 MicroFunctions"
    Add-Check "readiness-microfunction-count"

    $Microfunctions = Invoke-RestMethod -Method Get -Uri "$BaseUrl/api/v1/identity/risk/microfunctions"
    Assert-True ($Microfunctions.count -eq 40) "MicroFunction catalog returned 40 keys"
    Add-Check "microfunction-catalog"

    $RiskCreated = Invoke-JsonPost "$BaseUrl/api/v1/identity/risk/events" @{
        institutionKey = "AIRA-DEMO-INSTITUTION"
        identityId = "poc1b.phase2.user"
        email = "poc1b.phase2.user@aira.local"
        eventType = "LOGIN_ATTEMPT"
        riskScore = 82
        failedAttemptsInWindow = 3
        sourceIp = "10.10.10.42"
        userAgent = "POC1B-Phase2-Test"
        riskReasons = @("NEW_DEVICE", "HIGH_RISK_SCORE")
        evidence = @{
            test = "phase2-risk-event"
        }
    }

    Assert-True ($RiskCreated.riskEvent.riskEventId.Length -gt 0) "Risk event creation returned riskEventId"
    Add-Check "risk-event-created"

    Assert-True ($RiskCreated.policyDecision.decision -eq "STEP_UP") "Risk event produced STEP_UP policy decision"
    Add-Check "step-up-policy-decision"

    Assert-True ($RiskCreated.incident.incidentId.Length -gt 0) "High-risk event generated incident analysis"
    Add-Check "incident-created"

    $RiskEventId = $RiskCreated.riskEvent.riskEventId
    $IncidentId = $RiskCreated.incident.incidentId

    $RiskDetail = Invoke-RestMethod -Method Get -Uri "$BaseUrl/api/v1/identity/risk/events/$RiskEventId"
    Assert-True ($RiskDetail.riskEventId -eq $RiskEventId) "Risk event detail endpoint returned created event"
    Add-Check "risk-event-detail"

    $RiskReviewed = Invoke-JsonPost "$BaseUrl/api/v1/identity/risk/events/$RiskEventId/review" @{
        reviewedBy = "SECURITY_OFFICER"
        reviewDecision = "STEP_UP_REQUIRED"
        reviewNotes = "Validated by POC-1B Phase 2 repair."
        status = "CLOSED"
    }

    Assert-True ($RiskReviewed.reviewed -eq $true) "Risk event review endpoint accepted decision"
    Add-Check "risk-event-review"

    $IncidentDetail = Invoke-RestMethod -Method Get -Uri "$BaseUrl/api/v1/identity/risk/incidents/$IncidentId"
    Assert-True ($IncidentDetail.analysisSummary -like "*AI-assisted summary*") "Incident detail returned AI-assisted summary"
    Add-Check "incident-detail"

    $Triage = Invoke-JsonPost "$BaseUrl/api/v1/identity/risk/login-failures/triage" @{
        institutionKey = "AIRA-DEMO-INSTITUTION"
        identityId = "poc1b.phase2.user"
        email = "poc1b.phase2.user@aira.local"
        failureCategory = "BAD_PASSWORD"
        failedAttemptsInWindow = 5
    }

    Assert-True ($Triage.triage.recommendedAction -eq "LOCK_ACCOUNT") "Login failure triage recommended account lock"
    Add-Check "login-failure-triage"

    $Lock = Invoke-JsonPost "$BaseUrl/api/v1/identity/risk/accounts/poc1b.phase2.user/lock" @{
        institutionKey = "AIRA-DEMO-INSTITUTION"
        email = "poc1b.phase2.user@aira.local"
        lockReason = "POC1B_PHASE2_TEST_LOCK"
        lockSource = "POLICY"
        lockedBy = "SYSTEM"
    }

    Assert-True ($Lock.locked -eq $true) "Account lock endpoint locked account"
    Add-Check "account-lock"

    $LockedAccounts = Invoke-RestMethod -Method Get -Uri "$BaseUrl/api/v1/identity/risk/accounts/locked"
    Assert-True ($LockedAccounts.count -eq 1) "Locked account list returned one locked account"
    Add-Check "locked-account-list"

    $UnlockRequest = Invoke-JsonPost "$BaseUrl/api/v1/identity/risk/accounts/poc1b.phase2.user/unlock-request" @{
        requestedBy = "SECURITY_OFFICER"
        requestReason = "POC1B_PHASE2_UNLOCK_TEST"
    }

    Assert-True ($UnlockRequest.unlockRequest.unlockRequestId.Length -gt 0) "Unlock request endpoint created request"
    Add-Check "unlock-request-created"

    $UnlockRequestId = $UnlockRequest.unlockRequest.unlockRequestId

    $UnlockApproved = Invoke-JsonPost "$BaseUrl/api/v1/identity/risk/unlock-requests/$UnlockRequestId/approve" @{
        approvedBy = "SECURITY_OFFICER"
        decisionNotes = "Approved by POC-1B Phase 2 validation repair."
    }

    Assert-True ($UnlockApproved.approved -eq $true) "Unlock approval endpoint approved request"
    Add-Check "unlock-approved"

    Assert-True ($UnlockApproved.accountUnlocked -eq $true) "Unlock approval unlocked account"
    Add-Check "account-unlocked"

    $LockedAfterUnlock = Invoke-RestMethod -Method Get -Uri "$BaseUrl/api/v1/identity/risk/accounts/locked"
    Assert-True ($LockedAfterUnlock.count -eq 0) "Locked account list empty after approval unlock"
    Add-Check "locked-list-empty-after-unlock"

    $Challenge = Invoke-JsonPost "$BaseUrl/api/v1/identity/risk/step-up/challenges" @{
        institutionKey = "AIRA-DEMO-INSTITUTION"
        identityId = "poc1b.phase2.user"
        email = "poc1b.phase2.user@aira.local"
        challengeType = "LOCAL_CODE"
        localCode = "246810"
    }

    Assert-True ($Challenge.challenge.challengeId.Length -gt 0) "Step-up challenge endpoint created challenge"
    Add-Check "step-up-created"

    $ChallengeId = $Challenge.challenge.challengeId

    $ChallengeVerified = Invoke-JsonPost "$BaseUrl/api/v1/identity/risk/step-up/challenges/$ChallengeId/verify" @{
        code = "246810"
    }

    Assert-True ($ChallengeVerified.verified -eq $true) "Step-up verification succeeded"
    Add-Check "step-up-verified"

    Assert-True ($ChallengeVerified.allowLogin -eq $true) "Step-up verification allowed login"
    Add-Check "step-up-allowed-login"

    $PolicyDecisions = Invoke-RestMethod -Method Get -Uri "$BaseUrl/api/v1/identity/risk/policy-decisions"
    Assert-True ($PolicyDecisions.count -ge 1) "Policy decision list returned at least one decision"
    Add-Check "policy-decisions"

    $Events = Invoke-RestMethod -Method Get -Uri "$BaseUrl/api/v1/identity/risk/events"
    Assert-True ($Events.count -ge 1) "Risk event list returned at least one event"
    Add-Check "risk-event-list"

    $Incidents = Invoke-RestMethod -Method Get -Uri "$BaseUrl/api/v1/identity/risk/incidents"
    Assert-True ($Incidents.count -ge 1) "Incident list returned at least one incident"
    Add-Check "incident-list"

    $TriageList = Invoke-RestMethod -Method Get -Uri "$BaseUrl/api/v1/identity/risk/login-failures"
    Assert-True ($TriageList.count -ge 1) "Login failure list returned at least one triage record"
    Add-Check "login-failure-list"

    $Results = [ordered]@{
        completedAt = (Get-Date).ToString("o")
        status = "PASSED"
        score = "10/10 Phase 2 Backend API Foundation"
        baseUrl = $BaseUrl
        checkCount = $CheckResults.Count
        checks = $CheckResults
        createdRiskEventId = $RiskEventId
        createdIncidentId = $IncidentId
        createdUnlockRequestId = $UnlockRequestId
        createdStepUpChallengeId = $ChallengeId
        microfunctionCount = $Microfunctions.count
        policyDecisionCount = $PolicyDecisions.count
        stdoutLog = $StdoutLogPath
        stderrLog = $StderrLogPath
    }

    $Json = $Results | ConvertTo-Json -Depth 50
    [System.IO.File]::WriteAllText($RunEvidencePath, $Json, [System.Text.UTF8Encoding]::new($false))

    if (!(Test-Path $RunEvidencePath)) {
        throw "Validation run evidence JSON was not created."
    }

    Write-Host "POC-1B Phase 2 backend API validation PASSED." -ForegroundColor Green
    Write-Host "Evidence: $RunEvidencePath" -ForegroundColor Green
} finally {
    if ($null -ne $ServerProcess -and -not $ServerProcess.HasExited) {
        Stop-Process -Id $ServerProcess.Id -Force
    }
}