$ErrorActionPreference = "Stop"

$ApiKey = "aira-local-dev-key-change-me"
$ServerIp = "192.168.179.193"
$ServerBase = "http://$($ServerIp)"
$Headers = @{
    "X-AIRA-API-Key" = $ApiKey
    "Origin" = "http://$($ServerIp):9090"
}

$Readiness = Invoke-RestMethod -Uri "$ServerBase:9094/api/v1/application-factory/readiness" -Headers $Headers
$Capabilities = Invoke-RestMethod -Uri "$ServerBase:9094/api/v1/application-factory/capabilities" -Headers $Headers
$Templates = Invoke-RestMethod -Uri "$ServerBase:9094/api/v1/application-factory/templates" -Headers $Headers
$Generators = Invoke-RestMethod -Uri "$ServerBase:9094/api/v1/application-factory/generators" -Headers $Headers
$Steps = Invoke-RestMethod -Uri "$ServerBase:9094/api/v1/application-factory/orchestration-steps" -Headers $Headers
$Gates = Invoke-RestMethod -Uri "$ServerBase:9094/api/v1/application-factory/acceptance-gates" -Headers $Headers
$Profiles = Invoke-RestMethod -Uri "$ServerBase:9094/api/v1/application-factory/production-profiles" -Headers $Headers

Write-Host ""
Write-Host "AIRA Enterprise Application Factory Summary" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "Status: $($Readiness.status)"
Write-Host "Readiness Key: $($Readiness.readinessKey)"
Write-Host "Application Factory Ready: $($Readiness.applicationFactoryReady)"
Write-Host "Fail Closed: $($Readiness.failClosed)"
Write-Host "Capabilities: $($Capabilities.Count)"
Write-Host "Templates: $($Templates.Count)"
Write-Host "Generators: $($Generators.Count)"
Write-Host "Orchestration Steps: $($Steps.Count)"
Write-Host "Acceptance Gates: $($Gates.Count)"
Write-Host "Production Profiles: $($Profiles.Count)"
Write-Host "Factory Readiness URL: $ServerBase:9094/api/v1/application-factory/readiness"
Write-Host "Portal: $ServerBase:9090/portal/index.html"