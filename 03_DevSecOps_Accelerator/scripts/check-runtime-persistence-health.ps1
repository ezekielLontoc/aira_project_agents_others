$ErrorActionPreference = "Stop"

$DbContainer = "aira-postgres17"
$DbName = "aira_platform"
$DbUser = "aira_admin"

Write-Host "Checking PostgreSQL container..." -ForegroundColor Cyan

$ContainerStatus = docker ps --filter "name=$DbContainer" --format "{{.Names}}"
if ($ContainerStatus -ne $DbContainer) {
    throw "Required PostgreSQL container is not running: $DbContainer"
}

Write-Host "Checking PostgreSQL readiness..." -ForegroundColor Cyan
docker exec $DbContainer pg_isready -U $DbUser -d $DbName

Write-Host "Checking AIRA persistence baseline counts..." -ForegroundColor Cyan

$Sql = @"
SELECT 'agent_definition' AS item, COUNT(*) AS count FROM aira_agents.agent_definition
UNION ALL
SELECT 'control_gate', COUNT(*) FROM aira_governance.control_gate
UNION ALL
SELECT 'prompt_version', COUNT(*) FROM aira_agents.agent_prompt_version
UNION ALL
SELECT 'model_version', COUNT(*) FROM aira_agents.agent_model_version
UNION ALL
SELECT 'evidence_pack', COUNT(*) FROM aira_evidence.runtime_evidence_pack
UNION ALL
SELECT 'evidence_artifact', COUNT(*) FROM aira_evidence.evidence_artifact
UNION ALL
SELECT 'secret_control', COUNT(*) FROM aira_security.secret_control_record
UNION ALL
SELECT 'persistence_audit', COUNT(*) FROM aira_runtime.persistence_audit_record;
"@

$Sql | docker exec -i $DbContainer psql -U $DbUser -d $DbName -v ON_ERROR_STOP=1

Write-Host "Runtime persistence health check completed." -ForegroundColor Green