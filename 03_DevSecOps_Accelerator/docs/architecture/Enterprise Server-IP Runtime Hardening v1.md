# Enterprise Server-IP Runtime Hardening v1

## Status

Accepted after validation passes.

## Purpose

This hardening removes hardcoded localhost assumptions from the AIRA runtime and enables server-IP-aware runtime access.

## Server IP

Detected server IP during hardening:

192.168.179.193

## Portal

The portal is available at:

http:///portal/index.html

## Runtime behavior

The portal resolves backend API URLs from the browser host:

- portal loaded from localhost uses localhost APIs
- portal loaded from server IP uses server IP APIs

## CORS

Protected APIs are configured from:

AIRA_PORTAL_ALLOWED_ORIGINS

Current allowed origins:

http://localhost:9090,http://

## Protected APIs

Protected APIs continue to require:

X-AIRA-API-Key

Missing or wrong keys return 401.

## Enterprise runtime compose

Use:

docker compose -f docker-compose.runtime.yml -f docker-compose.enterprise-ip.yml up -d --build --force-recreate

## Validation

Run:

powershell -ExecutionPolicy Bypass -File ".\scripts\validate-enterprise-ip-runtime.ps1"

## Governance

This hardening preserves fail-closed behavior while enabling server-IP runtime access.