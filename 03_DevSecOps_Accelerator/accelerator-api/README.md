# AIRA Accelerator API

## Purpose

The accelerator-api module is the REST/API boundary for the AIRA DevSecOps Accelerator.

## Port

9090

## Initial Endpoints

| Endpoint | Method | Purpose |
|---|---|---|
| /api/health | GET | Runtime health check |
| /api/agents/request | POST | Agent request placeholder |
| /api/runtime/info | GET | Runtime metadata |

## Runtime

Spring Boot  
Java 26 target workstation  
Tomcat-compatible service strategy

## Governance

No production-impacting action may execute without human approval.
