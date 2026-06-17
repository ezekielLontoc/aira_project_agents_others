$ErrorActionPreference = "Stop"

Set-Location "D:\ChatGPT Workspace Folder Projects\AIRA Projects"

$RepoRoot = "D:\ChatGPT Workspace Folder Projects\AIRA Projects"
$ServerPath = Join-Path $RepoRoot "03_DevSecOps_Accelerator\poc1b-runtime\login-risk-api\poc1b-login-risk-api-server.js"
$EvidenceRoot = Join-Path $RepoRoot "05_Evidence\poc-1b-login-risk-step-up-governance"
$RunEvidencePath = Join-Path $EvidenceRoot "POC-1B Phase 2 Backend API Validation Run.json"

$Port = 9191
$BaseUrl = "http://127.0.0.1:$Port"

$NodeCommand = Get-Command node -ErrorAction SilentlyContinue

if ($null -eq $NodeCommand) {
    throw "Node.js is required for POC-1B Phase 2 validation but node was not found."
}

if (!(Test-Path $ServerPath)) {
    throw "Missing POC-1B API server at $ServerPath"
}

$LogPath = Join-Path $EvidenceRoot "POC-1B Phase 2 Backend API Server Log.txt"

if (Test-Path $LogPath) {
    Remove-Item $LogPath -Force
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
    $ServerProcess = Start-Process -FilePath "node" -ArgumentList @($ServerPath, "--port", "$Port") -PassThru -WindowStyle Hidden -RedirectStandardOutput $LogPath -RedirectStandardError $LogPath

    $Ready = $false

    foreach ($Attempt in 1..30) {
        try {
            $Health = Invoke-RestMethod -Method Get -Uri "$BaseUrl/health"
            if ($Health.status -eq "UP") {
                $Ready = $true
                break
            }
        } catch {
            Start-Sleep -Milliseconds 500
        }
    }

    if (-not $Ready) {
        throw "POC-1B API server did not become ready on $BaseUrl"
    }

    $Readiness = Invoke-RestMethod -Method Get -Uri "$BaseUrl/api/v1/identity/risk/readiness"
    Assert-True ($Readiness.status -eq "READY") "Readiness endpoint returned READY"
    Assert-True ($Readiness.microfunctionCount -eq 40) "Readiness endpoint returned 40 MicroFunctions"

    $Microfunctions = Invoke-RestMethod -Method Get -Uri "$BaseUrl/api/v1/identity/risk/microfunctions"
    Assert-True ($Microfunctions.count -eq 40) "MicroFunction catalog returned 40 keys"

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
    Assert-True ($RiskCreated.policyDecision.decision -eq "STEP_UP") "Risk event produced STEP_UP policy decision"
    Assert-True ($RiskCreated.incident.incidentId.Length -gt 0) "High-risk event generated incident analysis"

    $RiskEventId = $RiskCreated.riskEvent.riskEventId
    $IncidentId = $RiskCreated.incident.incidentId

    $RiskDetail = Invoke-RestMethod -Method Get -Uri "$BaseUrl/api/v1/identity/risk/events/$RiskEventId"
    Assert-True ($RiskDetail.riskEventId -eq $RiskEventId) "Risk event detail endpoint returned created event"

    $RiskReviewed = Invoke-JsonPost "$BaseUrl/api/v1/identity/risk/events/$RiskEventId/review" @{
        reviewedBy = "SECURITY_OFFICER"
        reviewDecision = "STEP_UP_REQUIRED"
        reviewNotes = "Validated by POC-1B Phase 2."
        status = "CLOSED"
    }

    Assert-True ($RiskReviewed.reviewed -eq $true) "Risk event review endpoint accepted decision"

    $IncidentDetail = Invoke-RestMethod -Method Get -Uri "$BaseUrl/api/v1/identity/risk/incidents/$IncidentId"
    Assert-True ($IncidentDetail.analysisSummary -like "*AI-assisted summary*") "Incident detail returned AI-assisted summary"

    $Triage = Invoke-JsonPost "$BaseUrl/api/v1/identity/risk/login-failures/triage" @{
        institutionKey = "AIRA-DEMO-INSTITUTION"
        identityId = "poc1b.phase2.user"
        email = "poc1b.phase2.user@aira.local"
        failureCategory = "BAD_PASSWORD"
        failedAttemptsInWindow = 5
    }

    Assert-True ($Triage.triage.recommendedAction -eq "LOCK_ACCOUNT") "Login failure triage recommended account lock"

    $Lock = Invoke-JsonPost "$BaseUrl/api/v1/identity/risk/accounts/poc1b.phase2.user/lock" @{
        institutionKey = "AIRA-DEMO-INSTITUTION"
        email = "poc1b.phase2.user@aira.local"
        lockReason = "POC1B_PHASE2_TEST_LOCK"
        lockSource = "POLICY"
        lockedBy = "SYSTEM"
    }

    Assert-True ($Lock.locked -eq $true) "Account lock endpoint locked account"

    $LockedAccounts = Invoke-RestMethod -Method Get -Uri "$BaseUrl/api/v1/identity/risk/accounts/locked"
    Assert-True ($LockedAccounts.count -eq 1) "Locked account list returned one locked account"

    $UnlockRequest = Invoke-JsonPost "$BaseUrl/api/v1/identity/risk/accounts/poc1b.phase2.user/unlock-request" @{
        requestedBy = "SECURITY_OFFICER"
        requestReason = "POC1B_PHASE2_UNLOCK_TEST"
    }

    Assert-True ($UnlockRequest.unlockRequest.unlockRequestId.Length -gt 0) "Unlock request endpoint created request"

    $UnlockRequestId = $UnlockRequest.unlockRequest.unlockRequestId

    $UnlockApproved = Invoke-JsonPost "$BaseUrl/api/v1/identity/risk/unlock-requests/$UnlockRequestId/approve" @{
        approvedBy = "SECURITY_OFFICER"
        decisionNotes = "Approved by POC-1B Phase 2 validation."
    }

    Assert-True ($UnlockApproved.approved -eq $true) "Unlock approval endpoint approved request"
    Assert-True ($UnlockApproved.accountUnlocked -eq $true) "Unlock approval unlocked account"

    $LockedAfterUnlock = Invoke-RestMethod -Method Get -Uri "$BaseUrl/api/v1/identity/risk/accounts/locked"
    Assert-True ($LockedAfterUnlock.count -eq 0) "Locked account list empty after approval unlock"

    $Challenge = Invoke-JsonPost "$BaseUrl/api/v1/identity/risk/step-up/challenges" @{
        institutionKey = "AIRA-DEMO-INSTITUTION"
        identityId = "poc1b.phase2.user"
        email = "poc1b.phase2.user@aira.local"
        challengeType = "LOCAL_CODE"
        localCode = "246810"
    }

    Assert-True ($Challenge.challenge.challengeId.Length -gt 0) "Step-up challenge endpoint created challenge"

    $ChallengeId = $Challenge.challenge.challengeId

    $ChallengeVerified = Invoke-JsonPost "$BaseUrl/api/v1/identity/risk/step-up/challenges/$ChallengeId/verify" @{
        code = "246810"
    }

    Assert-True ($ChallengeVerified.verified -eq $true) "Step-up verification succeeded"
    Assert-True ($ChallengeVerified.allowLogin -eq $true) "Step-up verification allowed login"

    $PolicyDecisions = Invoke-RestMethod -Method Get -Uri "$BaseUrl/api/v1/identity/risk/policy-decisions"
    Assert-True ($PolicyDecisions.count -ge 1) "Policy decision list returned at least one decision"

    $Events = Invoke-RestMethod -Method Get -Uri "$BaseUrl/api/v1/identity/risk/events"
    Assert-True ($Events.count -ge 1) "Risk event list returned at least one event"

    $Incidents = Invoke-RestMethod -Method Get -Uri "$BaseUrl/api/v1/identity/risk/incidents"
    Assert-True ($Incidents.count -ge 1) "Incident list returned at least one incident"

    $TriageList = Invoke-RestMethod -Method Get -Uri "$BaseUrl/api/v1/identity/risk/login-failures"
    Assert-True ($TriageList.count -ge 1) "Login failure list returned at least one triage record"

    $Results = [ordered]@{
        completedAt = (Get-Date).ToString("o")
        status = "PASSED"
        score = "10/10 Phase 2 Backend API Foundation"
        baseUrl = $BaseUrl
        createdRiskEventId = $RiskEventId
        createdIncidentId = $IncidentId
        createdUnlockRequestId = $UnlockRequestId
        createdStepUpChallengeId = $ChallengeId
        microfunctionCount = $Microfunctions.count
        policyDecisionCount = $PolicyDecisions.count
    }

    $Json = $Results | ConvertTo-Json -Depth 20
    [System.IO.File]::WriteAllText($RunEvidencePath, $Json, [System.Text.UTF8Encoding]::new($false))

    Write-Host "POC-1B Phase 2 backend API validation PASSED." -ForegroundColor Green
    Write-Host "Evidence: $RunEvidencePath" -ForegroundColor Green
} finally {
    if ($null -ne $ServerProcess -and -not $ServerProcess.HasExited) {
        Stop-Process -Id $ServerProcess.Id -Force
    }
}