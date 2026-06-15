# POC-1 Phase 2 Architecture-Agent Review

## Status

Accepted for backend identity core API implementation.

## Scope

- Identity backend APIs only.
- No portal pages in Phase 2.
- Identity services must use POC-1 Phase 1 database tables.
- Microfunctions remain source-of-truth for workflow decomposition.

## Architectural Decision

Phase 2 implements identity core APIs in accelerator-security under the identity package.

Identity APIs are allowed to be public only where required for signup, verification, and login. Session, me, landing context, and admin routes require a valid governed session or local development admin key.

## Constraints

- Do not bypass fail-closed controls.
- Do not implement portal UI yet.
- Do not store raw tokens.
- Do not return password hashes.
- Do not expose detailed denial reasons to users.

## Phase 2 Acceptance

- Maven build succeeds.
- Identity controllers compile.
- Identity services compile.
- Validation script passes.
- Evidence pack updated.
- GitHub push succeeds.