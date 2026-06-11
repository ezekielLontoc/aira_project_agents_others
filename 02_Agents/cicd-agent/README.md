# cicd-agent

## Correct Technical Name

cicd-agent

## Status

Accepted as part of AIRA Agent Operating Model v1.0.

## Purpose

Supports pipeline validation, build execution, test execution, security scanning, deployment checks, release gates, rollback checks, and promotion readiness.

## Business Function

DevSecOps automation, release readiness, quality gates, operational control.

## Technical Function

Validates CI/CD workflows, executes builds/tests/scans, reviews pipeline logs, checks promotion readiness.

## Owner

AIRA DevSecOps Owner

## Backup Owner

AIRA Platform Lead

## Classification

Runtime/execution agent; Control/governance agent

## Risk Level

High/Critical

## Change Authority

May run non-production validation. Deployment or promotion requires explicit human approval.

## Can Change Code?

Limited pipeline config only

## Can Approve?

No

## Can Deploy?

Only with explicit approval

## Evidence Produced

Pipeline logs, scan results, build logs, release gate report, rollback checklist

## Required Gate

CI/CD gate blocks promotion if build, test, scan, evidence, approval, or rollback requirements fail.

## Full Definition

See:

../_Agent_Governance/definition-sheets/cicd-agent.md