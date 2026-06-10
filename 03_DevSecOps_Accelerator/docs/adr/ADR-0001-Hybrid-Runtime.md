# ADR-0001: Adopt Hybrid AIRA DevSecOps Accelerator Runtime

## Status

Accepted

## Context

AIRA requires an enterprise-grade DevSecOps platform that supports governed APIs, security, evidence, auditability, and AI-native agent execution.

## Decision

Use a hybrid architecture:

- Java / Spring / Tomcat for the governed enterprise platform
- Python or MCP-compatible runtimes for AI agent execution
- PostgreSQL for persistence
- GitHub for source control and CI/CD

## Consequences

Positive:

- Strong enterprise maintainability
- Clear separation between platform and AI execution
- Supports future MCP integration
- Keeps production control inside governed services

Tradeoff:

- Requires integration discipline between platform and agent runtimes
