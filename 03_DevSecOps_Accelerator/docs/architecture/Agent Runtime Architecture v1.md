# Agent Runtime Architecture v1

## Architecture Decision

AIRA will use a hybrid runtime model.

## Java Layer

Responsible for:

- Platform API
- Security
- Governance
- Audit
- Evidence
- PostgreSQL access
- Tomcat service hosting

## Agent Layer

Responsible for:

- AI task execution
- Agent prompts
- Agent contracts
- Knowledge retrieval
- Multi-agent workflows

## Integration Layer

Responsible for:

- MCP-based tool integration
- Agent-to-platform communication
- Evidence capture
- Runtime logging

## Initial Core Agents

1. Knowledge Fabric Agent
2. Architecture Agent
3. Developer Agent
4. Security Agent
5. Test Agent
6. Documentation Agent
7. Evidence Agent
8. CI/CD Agent

## Execution Rule

No production-impacting agent action may execute without human approval.

## Target Flow

Request
 API
 Governance Check
 Agent Contract
 Agent Execution
 Evidence Capture
 Result
 Audit Log
