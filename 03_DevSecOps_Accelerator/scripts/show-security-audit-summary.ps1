$ErrorActionPreference = "Stop"

$DbContainer = "aira-postgres17"
$DbName = "aira_platform"
$DbUser = "aira_admin"

$Sql = @"
SELECT
    service_name,
    decision,
    COUNT(*) AS event_count
FROM aira_security.api_security_audit_event
GROUP BY service_name, decision
ORDER BY service_name, decision;

SELECT
    service_name,
    request_path,
    request_method,
    principal_label,
    decision,
    reason,
    created_at
FROM aira_security.api_security_audit_event
ORDER BY created_at DESC
LIMIT 20;
"@

$Sql | docker exec -i $DbContainer psql -U $DbUser -d $DbName -v ON_ERROR_STOP=1