# AIRA Agent Prompt and Model Registry v1

## Status

Accepted

## Purpose

Defines the required versioning model for AIRA agents, prompts, models, tools, and knowledge sources.

## Registry Fields

| Field | Required |
|---|---|
| Agent name | Yes |
| Agent version | Yes |
| Prompt ID | Yes |
| Prompt version | Yes |
| Model provider | Yes |
| Model name | Yes |
| Model version/date | Yes |
| Tool list | Yes |
| Tool version | Yes |
| Knowledge source list | Yes |
| Knowledge source version | Yes |
| Owner | Yes |
| Backup owner | Yes |
| Risk level | Yes |
| Approval policy | Yes |
| Evidence output | Yes |
| Last reviewed date | Yes |
| Review approver | Yes |

## Initial Agent Versions

| Agent | Agent Version | Prompt Version | Model Policy |
|---|---:|---:|---|
| architecture-agent | 1.0.0 | 1.0.0 | AIRA-approved architecture-capable model |
| developer-agent | 1.0.0 | 1.0.0 | AIRA-approved code-capable model |
| security-agent | 1.0.0 | 1.0.0 | AIRA-approved security-capable model |
| test-agent | 1.0.0 | 1.0.0 | AIRA-approved testing-capable model |
| documentation-agent | 1.0.0 | 1.0.0 | AIRA-approved documentation-capable model |
| evidence-agent | 1.0.0 | 1.0.0 | AIRA-approved evidence-capable model |
| cicd-agent | 1.0.0 | 1.0.0 | AIRA-approved DevSecOps-capable model |
| knowledge-fabric-agent | 1.0.0 | 1.0.0 | AIRA-approved knowledge-capable model |

## Control

No production workflow may use an unregistered prompt, model, tool, or knowledge source.