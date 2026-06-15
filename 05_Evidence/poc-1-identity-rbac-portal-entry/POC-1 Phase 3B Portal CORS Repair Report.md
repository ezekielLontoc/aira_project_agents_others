# POC-1 Phase 3B Portal CORS Repair Report

## Status

PASSED

## Date

2026-06-15 17:56:12 +08:00

## Issue

Browser login from portal returned Failed to fetch.

## Root Cause

The portal is served from http://192.168.179.193:9090 while identity APIs are served from http://192.168.179.193:9091. Browser requests with X-AIRA-API-Key and JSON content require CORS preflight approval.

## Repair

Added IdentityCorsConfig to accelerator-security allowing portal origin http://192.168.179.193:9090 for /api/v1/identity/**.

## Validation

- Maven build passed.
- Security WAR redeployed.
- CORS OPTIONS preflight passed.
- Access-Control-Allow-Origin returned http://192.168.179.193:9090.
- Identity readiness endpoint reachable.

## Next Step

Retry Phase 3B browser flow: signup, verify email, admin approve, login, home route, developer dashboard, logout.