# AIRA Agent Governance

## Status

Accepted

## Operating Baseline

10/10 governed baseline

## Purpose

This folder contains the official AIRA Agent Inventory, Agent Definition Sheets, tools and permissions matrix, workflow model, governance model, sample prompts, evidence contract, control framework, RACI matrix, and prompt/model registry.

## Files

| File | Purpose |
|---|---|
| AIRA_Agent_Inventory_and_Definition_Report.md | Executive report and inventory |
| definition-sheets | One sheet per agent |
| controls/AIRA_Agent_Control_Framework_v1.md | Mandatory controls |
| controls/AIRA_Agent_Operating_Model_v1.md | Agent operating model |
| controls/AIRA_Agent_RACI_Matrix.md | RACI matrix |
| matrices/AIRA_Agent_Tools_and_Permissions_Matrix.md | Tools and permissions |
| matrices/AIRA_Agent_Risk_and_Governance_Matrix.md | Risk and governance |
| workflows/AIRA_Agent_Interaction_Workflow.md | Interaction workflow |
| samples/AIRA_Agent_Sample_Prompts_and_Outputs.md | Sample prompts and outputs |
| evidence-model/AIRA_Agent_Evidence_Contract_v1.md | Evidence contract |
| registries/AIRA_Agent_Prompt_and_Model_Registry_v1.md | Prompt, model, tool, and knowledge-source registry |

## Correct CI/CD Agent Name

Use:

cicd-agent

Do not use:

cicid-agent

## Production Safety Rule

No agent can silently change production systems.

## Gate Rule

No agent can bypass architecture, security, testing, documentation, evidence, CI/CD, approval, or rollback gates.