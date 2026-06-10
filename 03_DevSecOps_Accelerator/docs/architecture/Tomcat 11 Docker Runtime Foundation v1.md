# Tomcat 11 Docker Runtime Foundation v1

## Purpose

Defines the corrected AIRA Docker runtime model using Apache Tomcat 11 as the application server.

## Runtime Model

Each AIRA service runs as:

Docker container
Apache Tomcat 11
ROOT.war
Spring Boot WAR application

## Why WAR instead of executable JAR

AIRA's target architecture uses Apache Tomcat 11 as the service runtime.

The earlier Docker runtime used Java executable JARs with embedded Tomcat. That was useful for quick scaffolding, but it did not match the intended AIRA runtime architecture.

The corrected model deploys each service as a WAR into Tomcat 11.

## Java Compatibility

The workstation may use Java 26.

The Maven compiler target is set to Java 21 bytecode because the Tomcat 11 Docker image uses JDK 21. This keeps the container runtime stable while still allowing development from a Java 26 workstation.

## Runtime Services

| Service | Container | Host Port | Container Port |
|---|---|---:|---:|
| PostgreSQL 17 | aira-postgres17 | 5432 | 5432 |
| accelerator-api | aira-accelerator-api | 9090 | 8080 |
| accelerator-security | aira-accelerator-security | 9091 | 8080 |
| accelerator-governance | aira-accelerator-governance | 9092 | 8080 |
| accelerator-evidence | aira-accelerator-evidence | 9093 | 8080 |
| accelerator-agents | aira-accelerator-agents | 9094 | 8080 |
| accelerator-observability | aira-accelerator-observability | 9095 | 8080 |

## Build Command

powershell -ExecutionPolicy Bypass -File "D:\ChatGPT Workspace Folder Projects\AIRA Projects\03_DevSecOps_Accelerator\scripts\build-runtime-wars.ps1"

## Start Command

powershell -ExecutionPolicy Bypass -File "D:\ChatGPT Workspace Folder Projects\AIRA Projects\03_DevSecOps_Accelerator\scripts\start-runtime-stack.ps1"

## Check Command

powershell -ExecutionPolicy Bypass -File "D:\ChatGPT Workspace Folder Projects\AIRA Projects\03_DevSecOps_Accelerator\scripts\check-runtime-stack.ps1"

## Governance

Tomcat 11 WAR deployment is the official AIRA local Docker runtime foundation until superseded by an ADR.