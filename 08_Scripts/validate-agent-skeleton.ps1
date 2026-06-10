# AIRA Agent Validation Script

$AiraRoot = "D:\ChatGPT Workspace Folder Projects\AIRA Projects"
$AgentsRoot = "$AiraRoot\02_Agents"

$Required = @(
    "README.md",
    "config\agent.yaml",
    "contracts\input.schema.json",
    "contracts\output.schema.json",
    "prompts\system-prompt.md"
)

$Agents = Get-ChildItem "$AgentsRoot" -Directory

foreach ($Agent in $Agents) {
    Write-Host "
Checking $($Agent.Name)" -ForegroundColor Cyan

    foreach ($File in $Required) {
        $Path = Join-Path $Agent.FullName $File

        if (Test-Path $Path) {
            Write-Host "PASS $File" -ForegroundColor Green
        } else {
            Write-Host "MISSING $File" -ForegroundColor Red
        }
    }
}
