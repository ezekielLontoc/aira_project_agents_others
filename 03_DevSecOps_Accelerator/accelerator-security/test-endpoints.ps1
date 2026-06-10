$BaseUrl = "http://localhost:9091"

Write-Host "Testing accelerator-security endpoints..." -ForegroundColor Cyan

Invoke-RestMethod "$BaseUrl/api/v1/security/health"
Invoke-RestMethod "$BaseUrl/api/v1/auth/me"
Invoke-RestMethod "$BaseUrl/api/v1/policies"
Invoke-RestMethod "$BaseUrl/api/v1/roles"

$TokenBody = @{
    subject = "local-aira-operator"
    requestedRole = "PLATFORM_ADMIN"
} | ConvertTo-Json

Invoke-RestMethod -Method Post -Uri "$BaseUrl/api/v1/auth/token" -ContentType "application/json" -Body $TokenBody

$KeyBody = @{
    owner = "AIRA Platform Team"
    purpose = "Local scaffold validation"
} | ConvertTo-Json

Invoke-RestMethod -Method Post -Uri "$BaseUrl/api/v1/api-keys" -ContentType "application/json" -Body $KeyBody
Invoke-RestMethod "$BaseUrl/api/v1/api-keys"