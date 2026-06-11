# Milestone 7 – Docker Runtime Foundation (Corrected)

## Status

Accepted

## Version

0.3.0

## Date

2026-06-10

## Purpose

Establish the official AIRA local runtime foundation using:

* Apache Tomcat 11
* Docker
* PostgreSQL 17
* Spring Boot WAR applications
* GitHub-based source control

This milestone defines the baseline runtime architecture for all future AIRA platform capabilities.

---

# Architecture Decision

## Previous Approach (Superseded)

Docker containers executing Spring Boot executable JAR files.

Runtime model:

Docker Container
→ Java Runtime
→ Spring Boot Executable JAR
→ Embedded Tomcat

### Outcome

Rejected for AIRA platform standardization because:

* Did not align with enterprise Tomcat runtime strategy
* Introduced executable JAR packaging complexity
* Caused manifest packaging issues
* Reduced runtime consistency with platform architecture

---

## Approved Runtime Model

Docker Container
→ Apache Tomcat 11
→ ROOT.war
→ Spring Boot Application

This becomes the official runtime architecture for AIRA until superseded by a future Architecture Decision Record (ADR).

---

# Runtime Services

| Service                   | Container Name                 | Host Port | Container Port |
| ------------------------- | ------------------------------ | --------: | -------------: |
| PostgreSQL 17             | aira-postgres17                |      5432 |           5432 |
| Accelerator API           | aira-accelerator-api           |      9090 |           8080 |
| Accelerator Security      | aira-accelerator-security      |      9091 |           8080 |
| Accelerator Governance    | aira-accelerator-governance    |      9092 |           8080 |
| Accelerator Evidence      | aira-accelerator-evidence      |      9093 |           8080 |
| Accelerator Agents        | aira-accelerator-agents        |      9094 |           8080 |
| Accelerator Observability | aira-accelerator-observability |      9095 |           8080 |

---

# Runtime Validation

## Docker Runtime

Validated

## PostgreSQL Runtime

Validated

## Tomcat Runtime

Validated

## WAR Deployment

Validated

## Container Networking

Validated

## Port Allocation

Validated

Ports 9090–9095 reserved for AIRA platform services.

---

# Service Health Endpoints

## API

http://localhost:9090/api/health

## Security

http://localhost:9091/api/v1/security/health

## Governance

http://localhost:9092/api/health

## Evidence

http://localhost:9093/api/health

## Agents

http://localhost:9094/api/health

## Observability

http://localhost:9095/api/health

---

# Build Process

## Maven

mvn clean package

Produces:

ROOT.war

for each platform service.

---

# Docker Build

docker compose -f docker-compose.runtime.yml build

---

# Runtime Startup

powershell -ExecutionPolicy Bypass -File ".\scripts\start-runtime-stack.ps1"

---

# Runtime Shutdown

powershell -ExecutionPolicy Bypass -File ".\scripts\stop-runtime-stack.ps1"

---

# Runtime Validation

powershell -ExecutionPolicy Bypass -File ".\scripts\check-runtime-stack.ps1"

---

# Technology Standards

| Technology                    | Classification     |
| ----------------------------- | ------------------ |
| Apache Tomcat 11              | Strategic Standard |
| PostgreSQL 17                 | Strategic Standard |
| Docker                        | Strategic Standard |
| Docker Compose                | Strategic Standard |
| Java 21 Runtime Target        | Strategic Standard |
| Java 26 Developer Workstation | Approved           |
| Spring Boot                   | Strategic Standard |
| Maven                         | Strategic Standard |
| GitHub                        | Strategic Standard |

---

# AIRA Platform Maturity

Current State:

AIRA Platform Foundation

Version: 0.3.0

Status: OPERATIONAL

Maturity: 9.6 / 10

---

# Completion Criteria

Completed:

✓ Docker Runtime Foundation

✓ PostgreSQL Runtime Foundation

✓ Apache Tomcat 11 Runtime

✓ WAR Deployment Model

✓ Service Containerization

✓ Runtime Health Validation

✓ Source Control Integration

✓ Maven Build Automation

---

# Next Milestone

Milestone 8 – Runtime Persistence Foundation

Objectives:

* Flyway migrations
* Governance schemas
* Security schemas
* Audit schemas
* Evidence schemas
* Agent persistence
* Automated database initialization
* Seed data management

Result:

Enterprise-grade persistent runtime platform.
