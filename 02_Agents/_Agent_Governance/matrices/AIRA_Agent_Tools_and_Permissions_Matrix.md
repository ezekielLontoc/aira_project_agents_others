# AIRA Agent Tools and Permissions Matrix

| Agent | Source Code | DB Schema | Flyway Migrations | API Contracts | CI/CD Pipelines | Security Scan Results | Test Reports | Production Config | Secrets | Deployment Scripts | Obsidian Vault | LLM Wiki | Runtime Logs | Monitoring Dashboards | Evidence Repository |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| architecture-agent | Read | Read | Read | Read | Read | Read | Read | No | No | No | Read | Read | Read | Read | Read |
| developer-agent | Write branch | Draft | Draft | Draft | Read | Read | Write | No | No | No | Read | Read | Read | Read | Read |
| security-agent | Read | Read | Read | Read | Read | Read | Read | No | No | No | Read | Read | Read | Read | Read |
| test-agent | Read | Read | Read | Read | Read | Read | Write | No | No | No | Read | Read | Read | Read | Read |
| documentation-agent | Read | Read | Read | Read | Read | Read | Read | No | No | No | Write docs | Write docs | Read | Read | Read |
| evidence-agent | Read | Read | Read | Read | Read | Read | Read | No | No | No | Read | Read | Read | Read | Write evidence |
| cicd-agent | Read | Read | Read | Read | Draft/execute non-prod | Read | Read | No | No | Approval only | Read | Read | Read | Read | Read |
| knowledge-fabric-agent | Read | Read | Read | Read | Read | Read | Read | No | No | No | Write docs | Write index | Read | Read | Read/index |
