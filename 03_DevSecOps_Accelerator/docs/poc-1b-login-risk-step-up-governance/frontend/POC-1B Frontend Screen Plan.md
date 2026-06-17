# POC-1B Frontend Screen Plan

## Screens

- /portal/security-login-risk-dashboard.html
- /portal/login-incident-review.html
- /portal/account-lock-review.html
- /portal/unlock-approval.html
- /portal/step-up-auth.html
- /portal/login-failure-triage.html

## Role Access

- SECURITY_OFFICER: login risk dashboard, incident review, account lock review, unlock approval.
- INSTITUTION_ADMIN: unlock approval for institution-scoped accounts.
- PLATFORM_ADMIN: full visibility.
- DEVELOPER / VIEWER / AUDITOR: step-up authentication when required.

## UI Acceptance

- Security officer can view suspicious login queue.
- Security officer can review login incident.
- Security officer can view locked account.
- Institution admin can approve or reject unlock request.
- User can complete step-up challenge.
- User is denied when step-up fails.