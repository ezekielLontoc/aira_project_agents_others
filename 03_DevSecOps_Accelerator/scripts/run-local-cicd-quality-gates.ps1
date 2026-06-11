$ErrorActionPreference = "Stop"

$RepoRoot = "D:\ChatGPT Workspace Folder Projects\AIRA Projects"
$AccelRoot = "$RepoRoot\03_DevSecOps_Accelerator"
$DbContainer = "aira-postgres17"
$DbName = "aira_platform"
$DbUser = "aira_admin"
$ApiKey = "aira-local-dev-key-change-me"
$RunKey = "LOCAL-CICD-" + (Get-Date -Format "yyyyMMddHHmmss")

function Invoke-CheckedCommand {
    param([string]$CommandText)

    Write-Host ""
    Write-Host "Running: $CommandText" -ForegroundColor Cyan
    cmd.exe /c $CommandText

    if ($LASTEXITCODE -ne 0) {
        throw "Command failed with exit code $LASTEXITCODE : $CommandText"
    }
}

function Invoke-JsonEndpoint {
    param(
        [string]$Name,
        [string]$Url,
        [hashtable]$Headers = $null,
        [int]$ExpectedStatusCode = 200
    )

    Write-Host ""
    Write-Host "GET $Url" -ForegroundColor Yellow

    try {
        if ($Headers) {
            $Response = Invoke-WebRequest -Uri $Url -Headers $Headers -TimeoutSec 30 -UseBasicParsing
        }
        else {
            $Response = Invoke-WebRequest -Uri $Url -TimeoutSec 30 -UseBasicParsing
        }

        if ([int]$Response.StatusCode -ne $ExpectedStatusCode) {
            throw "$Name returned HTTP $($Response.StatusCode), expected $ExpectedStatusCode"
        }

        Write-Host "$Name OK ($($Response.StatusCode))" -ForegroundColor Green

        if ($Response.Content) {
            return $Response.Content | ConvertFrom-Json
        }

        return $null
    }
    catch [System.Net.WebException] {
        $HttpResponse = $_.Exception.Response

        if ($HttpResponse -and [int]$HttpResponse.StatusCode -eq $ExpectedStatusCode) {
            Write-Host "$Name OK ($ExpectedStatusCode)" -ForegroundColor Green
            return $null
        }

        throw "$Name failed at $Url : $($_.Exception.Message)"
    }
}

function Invoke-PostgresSql {
    param([string]$Sql)

    $Sql | docker exec -i $DbContainer psql -U $DbUser -d $DbName -v ON_ERROR_STOP=1

    if ($LASTEXITCODE -ne 0) {
        throw "PostgreSQL SQL execution failed."
    }
}

function Add-GateResult {
    param(
        [string]$GateKey,
        [string]$GateName,
        [string]$GateCategory,
        [string]$Status,
        [string]$CommandText,
        [string]$ResultSummary
    )

    $SafeCommand = $CommandText.Replace("'", "''")
    $SafeSummary = $ResultSummary.Replace("'", "''")
    $ResultKey = $RunKey + "-" + $GateKey

    $Sql = @"
INSERT INTO aira_runtime.cicd_quality_gate_result (
    result_key,
    run_key,
    gate_key,
    gate_name,
    gate_category,
    status,
    command_text,
    result_summary,
    evidence_reference,
    fail_closed
)
VALUES (
    '$ResultKey',
    '$RunKey',
    '$GateKey',
    '$GateName',
    '$GateCategory',
    '$Status',
    '$SafeCommand',
    '$SafeSummary',
    '05_Evidence/milestone-13-cicd-quality-gate-foundation/Milestone 13 Evidence Pack.md',
    TRUE
)
ON CONFLICT (result_key) DO UPDATE SET
    status = EXCLUDED.status,
    command_text = EXCLUDED.command_text,
    result_summary = EXCLUDED.result_summary,
    evidence_reference = EXCLUDED.evidence_reference,
    fail_closed = EXCLUDED.fail_closed;
"@

    Invoke-PostgresSql $Sql
}

function Show-ContainerLogs {
    $Containers = @(
        "aira-accelerator-api",
        "aira-accelerator-security",
        "aira-accelerator-governance",
        "aira-accelerator-evidence",
        "aira-accelerator-agents",
        "aira-accelerator-observability"
    )

    foreach ($Container in $Containers) {
        Write-Host ""
        Write-Host "===== $Container logs =====" -ForegroundColor Yellow
        docker logs --tail 120 $Container
    }
}

Set-Location $AccelRoot

Write-Host "Starting AIRA local CI/CD quality gate run: $RunKey" -ForegroundColor Cyan

docker compose -f docker-compose.runtime.yml up -d
Start-Sleep -Seconds 15

powershell -ExecutionPolicy Bypass -File ".\scripts\apply-cicd-quality-gate-foundation.ps1"

$BranchName = "local"
$CommitSha = "local"

try {
    $BranchName = git rev-parse --abbrev-ref HEAD
    $CommitSha = git rev-parse HEAD
}
catch {
    $BranchName = "unknown"
    $CommitSha = "unknown"
}

$StartSql = @"
INSERT INTO aira_runtime.cicd_quality_gate_run (
    run_key,
    run_type,
    branch_name,
    commit_sha,
    runtime_environment,
    triggered_by,
    status,
    fail_closed,
    evidence_reference
)
VALUES (
    '$RunKey',
    'Local',
    '$BranchName',
    '$CommitSha',
    'Docker Desktop Tomcat 11 PostgreSQL 17',
    'cicd-agent',
    'Started',
    TRUE,
    '05_Evidence/milestone-13-cicd-quality-gate-foundation/Milestone 13 Evidence Pack.md'
)
ON CONFLICT (run_key) DO UPDATE SET
    status = 'Started',
    started_at = NOW(),
    completed_at = NULL;
"@

Invoke-PostgresSql $StartSql

try {
    Write-Host ""
    Write-Host "Gate: Source Structure" -ForegroundColor Cyan

    $RequiredPaths = @(
        "$AccelRoot\pom.xml",
        "$AccelRoot\docker-compose.runtime.yml",
        "$AccelRoot\accelerator-api",
        "$AccelRoot\accelerator-security",
        "$AccelRoot\accelerator-governance",
        "$AccelRoot\accelerator-evidence",
        "$AccelRoot\accelerator-agents",
        "$AccelRoot\accelerator-observability",
        "$RepoRoot\.github\workflows\aira-cicd-quality-gates.yml"
    )

    foreach ($Path in $RequiredPaths) {
        if (!(Test-Path $Path)) {
            throw "Missing required path: $Path"
        }
    }

    Add-GateResult "SOURCE_STRUCTURE_GATE" "Source Structure Gate" "Source" "Passed" "Test-Path required paths" "Required source, module, runtime, and workflow paths exist."

    Write-Host ""
    Write-Host "Gate: Maven Build" -ForegroundColor Cyan
    Invoke-CheckedCommand "mvn clean package -DskipTests"
    Add-GateResult "MAVEN_BUILD_GATE" "Maven Build Gate" "Build" "Passed" "mvn clean package -DskipTests" "Maven reactor build succeeded."

    Write-Host ""
    Write-Host "Gate: WAR Artifact" -ForegroundColor Cyan

    $WarFiles = @(
        "$AccelRoot\accelerator-api\target\ROOT.war",
        "$AccelRoot\accelerator-security\target\ROOT.war",
        "$AccelRoot\accelerator-governance\target\ROOT.war",
        "$AccelRoot\accelerator-evidence\target\ROOT.war",
        "$AccelRoot\accelerator-agents\target\ROOT.war",
        "$AccelRoot\accelerator-observability\target\ROOT.war"
    )

    foreach ($WarFile in $WarFiles) {
        if (!(Test-Path $WarFile)) {
            throw "Missing WAR file: $WarFile"
        }

        Write-Host "Found WAR: $WarFile" -ForegroundColor Green
    }

    Add-GateResult "WAR_ARTIFACT_GATE" "WAR Artifact Gate" "Package" "Passed" "Test-Path target/ROOT.war" "All six Tomcat ROOT.war artifacts exist."

    Write-Host ""
    Write-Host "Gate: Docker Build and Runtime" -ForegroundColor Cyan
    Invoke-CheckedCommand "docker compose -f docker-compose.runtime.yml up -d --build --force-recreate"
    Add-GateResult "DOCKER_BUILD_GATE" "Docker Build Gate" "Container" "Passed" "docker compose -f docker-compose.runtime.yml up -d --build --force-recreate" "Docker images built successfully."
    Add-GateResult "DOCKER_RUNTIME_GATE" "Docker Runtime Gate" "Runtime" "Passed" "docker compose runtime startup" "Docker runtime stack started."

    Write-Host ""
    Write-Host "Waiting for Tomcat deployments..." -ForegroundColor Yellow
    Start-Sleep -Seconds 90

    Write-Host ""
    Write-Host "Gate: Base Health" -ForegroundColor Cyan

    $BaseEndpoints = @(
        @{ Name = "accelerator-api base"; Url = "http://localhost:9090/api/health" },
        @{ Name = "accelerator-security base"; Url = "http://localhost:9091/api/v1/security/health" },
        @{ Name = "accelerator-governance base"; Url = "http://localhost:9092/api/health" },
        @{ Name = "accelerator-evidence base"; Url = "http://localhost:9093/api/health" },
        @{ Name = "accelerator-agents base"; Url = "http://localhost:9094/api/health" },
        @{ Name = "accelerator-observability base"; Url = "http://localhost:9095/api/health" }
    )

    foreach ($Endpoint in $BaseEndpoints) {
        $Response = Invoke-JsonEndpoint -Name $Endpoint.Name -Url $Endpoint.Url

        if ($Response.status -ne "UP") {
            throw "$($Endpoint.Name) did not return UP"
        }
    }

    Add-GateResult "BASE_HEALTH_GATE" "Base Health Gate" "Runtime Health" "Passed" "GET base health endpoints" "All base health endpoints returned UP."

    Write-Host ""
    Write-Host "Gate: Persistence Health" -ForegroundColor Cyan

    $PersistenceEndpoints = @(
        @{ Name = "accelerator-api persistence"; Url = "http://localhost:9090/api/persistence/health" },
        @{ Name = "accelerator-security persistence"; Url = "http://localhost:9091/api/persistence/health" },
        @{ Name = "accelerator-governance persistence"; Url = "http://localhost:9092/api/persistence/health" },
        @{ Name = "accelerator-evidence persistence"; Url = "http://localhost:9093/api/persistence/health" },
        @{ Name = "accelerator-agents persistence"; Url = "http://localhost:9094/api/persistence/health" },
        @{ Name = "accelerator-observability persistence"; Url = "http://localhost:9095/api/persistence/health" }
    )

    foreach ($Endpoint in $PersistenceEndpoints) {
        $Response = Invoke-JsonEndpoint -Name $Endpoint.Name -Url $Endpoint.Url

        if ($Response.status -ne "UP") {
            throw "$($Endpoint.Name) did not return UP"
        }

        if ($Response.databaseStatus -ne "UP") {
            throw "$($Endpoint.Name) databaseStatus did not return UP"
        }

        if ($Response.failClosed -ne $true) {
            throw "$($Endpoint.Name) failClosed is not true"
        }
    }

    Add-GateResult "PERSISTENCE_HEALTH_GATE" "Persistence Health Gate" "Persistence" "Passed" "GET persistence health endpoints" "All persistence health endpoints returned UP and failClosed true."

    Write-Host ""
    Write-Host "Gate: Security Enforcement" -ForegroundColor Cyan

    Invoke-JsonEndpoint -Name "agents without key" -Url "http://localhost:9094/api/v1/agents" -ExpectedStatusCode 401
    Invoke-JsonEndpoint -Name "agents wrong key" -Url "http://localhost:9094/api/v1/agents" -Headers @{ "X-AIRA-API-Key" = "wrong-key" } -ExpectedStatusCode 401
    Invoke-JsonEndpoint -Name "governance without key" -Url "http://localhost:9092/api/v1/governance/readiness" -ExpectedStatusCode 401
    Invoke-JsonEndpoint -Name "evidence without key" -Url "http://localhost:9093/api/v1/evidence/readiness" -ExpectedStatusCode 401

    $Headers = @{ "X-AIRA-API-Key" = $ApiKey }

    $Agents = Invoke-JsonEndpoint -Name "agents with key" -Url "http://localhost:9094/api/v1/agents" -Headers $Headers
    if ($Agents.Count -lt 8) {
        throw "Agents endpoint returned fewer than 8 agents."
    }

    Add-GateResult "SECURITY_ENFORCEMENT_GATE" "Security Enforcement Gate" "Security" "Passed" "Protected endpoints with and without X-AIRA-API-Key" "Protected APIs deny missing or wrong keys and allow the local development API key."

    Write-Host ""
    Write-Host "Gate: Agent Registry" -ForegroundColor Cyan

    $AgentSummary = Invoke-JsonEndpoint -Name "agent registry summary" -Url "http://localhost:9094/api/v1/agents/governance/summary" -Headers $Headers

    if ($AgentSummary.status -ne "UP") {
        throw "Agent Registry summary did not return UP."
    }

    if ($AgentSummary.activeAgents -lt 8) {
        throw "Agent Registry summary returned fewer than 8 active agents."
    }

    Add-GateResult "AGENT_REGISTRY_GATE" "Agent Registry Gate" "Agents" "Passed" "GET /api/v1/agents/governance/summary" "Agent Registry summary returned UP with at least 8 active agents."

    Write-Host ""
    Write-Host "Gate: Governance Readiness" -ForegroundColor Cyan

    $GovernanceReadiness = Invoke-JsonEndpoint -Name "governance readiness" -Url "http://localhost:9092/api/v1/governance/readiness" -Headers $Headers

    if ($GovernanceReadiness.status -ne "UP") {
        throw "Governance readiness did not return UP."
    }

    if ($GovernanceReadiness.failClosed -ne $true) {
        throw "Governance readiness failClosed is not true."
    }

    Add-GateResult "GOVERNANCE_READINESS_GATE" "Governance Readiness Gate" "Governance" "Passed" "GET /api/v1/governance/readiness" "Governance readiness returned UP and failClosed true."

    Write-Host ""
    Write-Host "Gate: Evidence Readiness" -ForegroundColor Cyan

    $EvidenceReadiness = Invoke-JsonEndpoint -Name "evidence readiness" -Url "http://localhost:9093/api/v1/evidence/readiness" -Headers $Headers

    if ($EvidenceReadiness.status -ne "UP") {
        throw "Evidence readiness did not return UP."
    }

    if ($EvidenceReadiness.failClosed -ne $true) {
        throw "Evidence readiness failClosed is not true."
    }

    Add-GateResult "EVIDENCE_READINESS_GATE" "Evidence Readiness Gate" "Evidence" "Passed" "GET /api/v1/evidence/readiness" "Evidence readiness returned UP and failClosed true."

    Write-Host ""
    Write-Host "Gate: Evidence Detail" -ForegroundColor Cyan

    $Pack = Invoke-JsonEndpoint -Name "evidence pack detail" -Url "http://localhost:9093/api/v1/evidence/packs/MILESTONE-8-RUNTIME-PERSISTENCE" -Headers $Headers

    if ($Pack.evidence_pack_key -ne "MILESTONE-8-RUNTIME-PERSISTENCE") {
        throw "Evidence pack detail did not return MILESTONE-8-RUNTIME-PERSISTENCE."
    }

    $Artifacts = Invoke-JsonEndpoint -Name "evidence pack artifacts" -Url "http://localhost:9093/api/v1/evidence/packs/MILESTONE-8-RUNTIME-PERSISTENCE/artifacts" -Headers $Headers

    if ($Artifacts.Count -lt 4) {
        throw "Evidence pack artifacts returned fewer than 4 records."
    }

    Add-GateResult "EVIDENCE_DETAIL_GATE" "Evidence Detail Gate" "Evidence" "Passed" "GET evidence pack detail and artifacts" "Evidence detail endpoint and artifacts endpoint returned expected records."

    Write-Host ""
    Write-Host "Gate: GitHub Actions Workflow" -ForegroundColor Cyan

    $WorkflowPath = "$RepoRoot\.github\workflows\aira-cicd-quality-gates.yml"

    if (!(Test-Path $WorkflowPath)) {
        throw "Missing GitHub Actions workflow: $WorkflowPath"
    }

    Add-GateResult "GITHUB_ACTIONS_GATE" "GitHub Actions Gate" "CI/CD" "Passed" "Test-Path .github/workflows/aira-cicd-quality-gates.yml" "GitHub Actions workflow exists."

    $CompleteSql = @"
UPDATE aira_runtime.cicd_quality_gate_run
SET status = 'Passed',
    completed_at = NOW()
WHERE run_key = '$RunKey';
"@

    Invoke-PostgresSql $CompleteSql

    Write-Host ""
    Write-Host "AIRA local CI/CD quality gate run passed: $RunKey" -ForegroundColor Green
}
catch {
    $FailureMessage = $_.Exception.Message.Replace("'", "''")

    try {
        $FailSql = @"
UPDATE aira_runtime.cicd_quality_gate_run
SET status = 'Failed',
    completed_at = NOW()
WHERE run_key = '$RunKey';

INSERT INTO aira_runtime.cicd_quality_gate_result (
    result_key,
    run_key,
    gate_key,
    gate_name,
    gate_category,
    status,
    command_text,
    result_summary,
    evidence_reference,
    fail_closed
)
VALUES (
    '$RunKey-FAILED',
    '$RunKey',
    'FAILED_GATE',
    'Failed Quality Gate',
    'Failure',
    'Failed',
    'run-local-cicd-quality-gates.ps1',
    '$FailureMessage',
    '05_Evidence/milestone-13-cicd-quality-gate-foundation/Milestone 13 Evidence Pack.md',
    TRUE
)
ON CONFLICT (result_key) DO UPDATE SET
    status = EXCLUDED.status,
    result_summary = EXCLUDED.result_summary;
"@
        Invoke-PostgresSql $FailSql
    }
    catch {
        Write-Host "Unable to write failed gate result." -ForegroundColor Red
    }

    Write-Host ""
    Write-Host "AIRA local CI/CD quality gate run failed: $RunKey" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Show-ContainerLogs
    throw
}