# developer-agent

## Correct Technical Name

developer-agent

## Status

Accepted as part of AIRA Agent Operating Model v1.0.

## Purpose

Generates, modifies, or reviews code, configuration, API contracts, MicroFunctions, database migration drafts, implementation notes, and test scaffolds.

## Business Function

Software delivery acceleration, implementation support, code quality improvement.

## Technical Function

Creates source code, refactors code, generates configuration, API contracts, database migration drafts, and unit test scaffolds.

## Owner

AIRA Development Lead

## Backup Owner

AIRA Platform Lead

## Classification

Code-generation agent; Runtime/execution agent with strict controls

## Risk Level

High

## Change Authority

May generate branch-based changes only. Cannot merge, approve, deploy, or promote.

## Can Change Code?

Yes, branch only

## Can Approve?

No

## Can Deploy?

No

## Evidence Produced

PR draft, code diff, build log, implementation notes, test evidence

## Required Gate

Development output must pass architecture, security, test, documentation, evidence, and CI/CD gates.

## Full Definition

See:

../_Agent_Governance/definition-sheets/developer-agent.md