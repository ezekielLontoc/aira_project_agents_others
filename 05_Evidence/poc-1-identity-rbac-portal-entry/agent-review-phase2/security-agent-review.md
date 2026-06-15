# POC-1 Phase 2 Security-Agent Review

## Status

Accepted with fail-closed controls.

## Required Controls

- Passwords must be hashed using BCrypt.
- Session tokens must be random.
- Session token hash must be stored in database, not raw token.
- Verification token hash must be stored in database, not raw token.
- Login denial must be audited.
- Signup must not activate full access.
- Verified email must move to pending institution approval.
- Login must be blocked until identity is ACTIVE and approved.
- Missing session must be denied.
- Expired session must be denied.
- Logout must revoke session.

## Local POC Behavior

POC-1 may return a local-only verification token from signup for development validation because SMTP is not yet implemented.

## Production Hardening Later

- Replace local-only verification token output with email provider.
- Move browser session storage to secure HTTP-only cookies.
- Add CSRF protection.
- Add MFA.
- Add stricter rate limiting.

## Phase 2 Security Result

Phase 2 is acceptable only if backend identity APIs remain fail-closed and evidence/audit behavior is preserved.