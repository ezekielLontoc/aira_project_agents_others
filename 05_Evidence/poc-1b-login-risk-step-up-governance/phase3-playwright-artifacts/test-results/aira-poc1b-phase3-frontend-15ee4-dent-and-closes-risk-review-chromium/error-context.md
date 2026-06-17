# Instructions

- Following Playwright test failed.
- Explain why, be concise, respect Playwright best practices.
- Provide a snippet of code with the fix, if possible.

# Test info

- Name: aira-poc1b-phase3-frontend.spec.js >> POC-1B Phase 3 frontend browser validation >> 04 incident review loads incident and closes risk review
- Location: tests\aira-poc1b-phase3-frontend.spec.js:45:3

# Error details

```
Error: expect(locator).not.toHaveValue(expected) failed

Locator:  locator('[data-testid="incident-id-input"]')
Expected: not ""
Received: ""
Timeout:  10000ms

Call log:
  - Expect "not toHaveValue" with timeout 10000ms
  - waiting for locator('[data-testid="incident-id-input"]')
    23 × locator resolved to <input id="incident-id-input" data-testid="incident-id-input" placeholder="incident id from dashboard"/>
       - unexpected value ""

```

```yaml
- textbox "incident id from dashboard"
```

# Test source

```ts
  1   | const { test, expect } = require('@playwright/test');
  2   | 
  3   | const portalBase = process.env.POC1B_PHASE3_PORTAL_BASE || 'http://127.0.0.1:9192';
  4   | const apiBase = process.env.POC1B_PHASE3_API_BASE || 'http://127.0.0.1:9191';
  5   | 
  6   | test.describe.serial('POC-1B Phase 3 frontend browser validation', () => {
  7   |   test('01 frontend screen inventory loads all POC-1B pages', async ({ page }) => {
  8   |     const screens = [
  9   |       ['security-login-risk-dashboard.html', 'security-login-risk-dashboard'],
  10  |       ['login-incident-review.html', 'login-incident-review'],
  11  |       ['login-failure-triage.html', 'login-failure-triage'],
  12  |       ['account-lock-review.html', 'account-lock-review'],
  13  |       ['unlock-approval.html', 'unlock-approval'],
  14  |       ['step-up-auth.html', 'step-up-auth']
  15  |     ];
  16  | 
  17  |     for (const [file, marker] of screens) {
  18  |       await page.goto(`${portalBase}/${file}`);
  19  |       await expect(page.locator(`body[data-screen="${marker}"]`)).toBeVisible();
  20  |       await expect(page.locator('[data-nav="dashboard"]')).toBeVisible();
  21  |     }
  22  |   });
  23  | 
  24  |   test('02 dashboard shows readiness and 40 microfunctions', async ({ page }) => {
  25  |     await page.goto(`${portalBase}/security-login-risk-dashboard.html`);
  26  |     await page.click('[data-testid="load-readiness"]');
  27  |     await expect(page.locator('#readiness-status')).toHaveText('READY');
  28  | 
  29  |     await page.click('[data-testid="load-microfunctions"]');
  30  |     await expect(page.locator('#microfunction-count')).toHaveText('40');
  31  |     await expect(page.locator('#dashboard-output')).toContainText('MF-LOGIN-RISK-001');
  32  |     await expect(page.locator('#dashboard-output')).toContainText('MF-LOGIN-RISK-040');
  33  |   });
  34  | 
  35  |   test('03 dashboard creates risk event with step-up decision and incident', async ({ page }) => {
  36  |     await page.goto(`${portalBase}/security-login-risk-dashboard.html`);
  37  |     await page.click('[data-testid="create-risk-event"]');
  38  | 
  39  |     await expect(page.locator('#risk-event-id')).not.toHaveText('none');
  40  |     await expect(page.locator('#incident-id')).not.toHaveText('none');
  41  |     await expect(page.locator('#dashboard-output')).toContainText('STEP_UP');
  42  |     await expect(page.locator('#dashboard-output')).toContainText('AI-assisted summary');
  43  |   });
  44  | 
  45  |   test('04 incident review loads incident and closes risk review', async ({ page }) => {
  46  |     await page.goto(`${portalBase}/login-incident-review.html`);
  47  | 
> 48  |     await expect(page.locator('[data-testid="incident-id-input"]')).not.toHaveValue('');
      |                                                                         ^ Error: expect(locator).not.toHaveValue(expected) failed
  49  |     await expect(page.locator('[data-testid="risk-event-id-input"]')).not.toHaveValue('');
  50  | 
  51  |     await page.click('[data-testid="load-incident"]');
  52  |     await expect(page.locator('#incident-output')).toContainText('AI-assisted summary');
  53  | 
  54  |     await page.click('[data-testid="review-risk-event"]');
  55  |     await expect(page.locator('#incident-output')).toContainText('reviewed');
  56  |     await expect(page.locator('#incident-output')).toContainText('STEP_UP_REQUIRED');
  57  |   });
  58  | 
  59  |   test('05 login failure triage recommends account lock', async ({ page }) => {
  60  |     await page.goto(`${portalBase}/login-failure-triage.html`);
  61  |     await page.click('[data-testid="create-triage"]');
  62  | 
  63  |     await expect(page.locator('#triage-action')).toHaveText('LOCK_ACCOUNT');
  64  |     await expect(page.locator('#triage-output')).toContainText('BAD_PASSWORD');
  65  |   });
  66  | 
  67  |   test('06 account lock screen locks account and shows locked queue', async ({ page }) => {
  68  |     await page.goto(`${portalBase}/account-lock-review.html`);
  69  |     await page.click('[data-testid="lock-account"]');
  70  | 
  71  |     await expect(page.locator('#lock-status')).toHaveText('LOCKED');
  72  | 
  73  |     await page.click('[data-testid="load-locked-accounts"]');
  74  |     await expect(page.locator('#locked-count')).toHaveText('1');
  75  |     await expect(page.locator('#lock-output')).toContainText('poc1b.phase3.user');
  76  |   });
  77  | 
  78  |   test('07 unlock approval creates request and approves unlock', async ({ page }) => {
  79  |     await page.goto(`${portalBase}/unlock-approval.html`);
  80  | 
  81  |     await page.click('[data-testid="create-unlock-request"]');
  82  |     await expect(page.locator('#unlock-request-id')).not.toHaveText('none');
  83  | 
  84  |     await page.click('[data-testid="approve-unlock"]');
  85  |     await expect(page.locator('#unlock-status')).toHaveText('UNLOCKED');
  86  |     await expect(page.locator('#unlock-output')).toContainText('accountUnlocked');
  87  |   });
  88  | 
  89  |   test('08 step-up screen creates and verifies challenge', async ({ page }) => {
  90  |     await page.goto(`${portalBase}/step-up-auth.html`);
  91  | 
  92  |     await page.click('[data-testid="create-step-up"]');
  93  |     await expect(page.locator('#challenge-id')).not.toHaveText('none');
  94  | 
  95  |     await page.fill('[data-testid="challenge-code"]', '246810');
  96  |     await page.click('[data-testid="verify-step-up"]');
  97  | 
  98  |     await expect(page.locator('#stepup-status')).toHaveText('ALLOW_LOGIN');
  99  |     await expect(page.locator('#stepup-output')).toContainText('VERIFIED');
  100 |   });
  101 | 
  102 |   test('09 backend lists contain browser-generated records', async ({ request }) => {
  103 |     const events = await request.get(`${apiBase}/api/v1/identity/risk/events`);
  104 |     expect(events.ok()).toBeTruthy();
  105 |     const eventJson = await events.json();
  106 |     expect(eventJson.count).toBeGreaterThanOrEqual(1);
  107 | 
  108 |     const incidents = await request.get(`${apiBase}/api/v1/identity/risk/incidents`);
  109 |     expect(incidents.ok()).toBeTruthy();
  110 |     const incidentJson = await incidents.json();
  111 |     expect(incidentJson.count).toBeGreaterThanOrEqual(1);
  112 | 
  113 |     const triage = await request.get(`${apiBase}/api/v1/identity/risk/login-failures`);
  114 |     expect(triage.ok()).toBeTruthy();
  115 |     const triageJson = await triage.json();
  116 |     expect(triageJson.count).toBeGreaterThanOrEqual(1);
  117 | 
  118 |     const decisions = await request.get(`${apiBase}/api/v1/identity/risk/policy-decisions`);
  119 |     expect(decisions.ok()).toBeTruthy();
  120 |     const decisionJson = await decisions.json();
  121 |     expect(decisionJson.count).toBeGreaterThanOrEqual(1);
  122 |   });
  123 | });
```