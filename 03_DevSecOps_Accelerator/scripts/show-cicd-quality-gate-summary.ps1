$ErrorActionPreference = "Stop"

$DbContainer = "aira-postgres17"
$DbName = "aira_platform"
$DbUser = "aira_admin"

$Sql = @"
SELECT
    gate_key,
    gate_category,
    owner,
    status,
    required,
    fail_closed
FROM aira_runtime.cicd_quality_gate_definition
ORDER BY gate_category, gate_key;

SELECT
    run_key,
    run_type,
    branch_name,
    substring(commit_sha from 1 for 12) AS commit_short,
    runtime_environment,
    triggered_by,
    status,
    fail_closed,
    started_at,
    completed_at
FROM aira_runtime.cicd_quality_gate_run
ORDER BY started_at DESC
LIMIT 10;

SELECT
    run_key,
    gate_key,
    gate_category,
    status,
    result_summary,
    created_at
FROM aira_runtime.cicd_quality_gate_result
ORDER BY created_at DESC
LIMIT 40;
"@

$Sql | docker exec -i $DbContainer psql -U $DbUser -d $DbName -v ON_ERROR_STOP=1