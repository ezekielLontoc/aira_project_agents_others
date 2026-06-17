const { test, expect } = require('@playwright/test');

const portalBase = process.env.POC1B_PHASE3_PORTAL_BASE || 'http://127.0.0.1:9192';
const apiBase = process.env.POC1B_PHASE3_API_BASE || 'http://127.0.0.1:9191';

test.describe.serial('POC-1B Phase 3 frontend browser validation', () => {
  test('01 frontend screen inventory loads all POC-1B pages', async ({ page }) => {
    const screens = [
      ['security-login-risk-dashboard.html', 'security-login-risk-dashboard'],
      ['login-incident-review.html', 'login-incident-review'],
      ['login-failure-triage.html', 'login-failure-triage'],
      ['account-lock-review.html', 'account-lock-review'],
      ['unlock-approval.html', 'unlock-approval'],
      ['step-up-auth.html', 'step-up-auth']
    ];

    for (const [file, marker] of screens) {
      await page.goto(`${portalBase}/${file}`);
      await expect(page.locator(`body[data-screen="${marker}"]`)).toBeVisible();
      await expect(page.locator('[data-nav="dashboard"]')).toBeVisible();
    }
  });

  test('02 dashboard shows readiness and 40 microfunctions', async ({ page }) => {
    await page.goto(`${portalBase}/security-login-risk-dashboard.html`);
    await page.click('[data-testid="load-readiness"]');
    await expect(page.locator('#readiness-status')).toHaveText('READY');

    await page.click('[data-testid="load-microfunctions"]');
    await expect(page.locator('#microfunction-count')).toHaveText('40');
    await expect(page.locator('#dashboard-output')).toContainText('MF-LOGIN-RISK-001');
    await expect(page.locator('#dashboard-output')).toContainText('MF-LOGIN-RISK-040');
  });

  test('03 dashboard creates risk event with step-up decision and incident', async ({ page }) => {
    await page.goto(`${portalBase}/security-login-risk-dashboard.html`);
    await page.click('[data-testid="create-risk-event"]');

    await expect(page.locator('#risk-event-id')).not.toHaveText('none');
    await expect(page.locator('#incident-id')).not.toHaveText('none');
    await expect(page.locator('#dashboard-output')).toContainText('STEP_UP');
    await expect(page.locator('#dashboard-output')).toContainText('AI-assisted summary');
  });

  test('04 incident review loads incident and closes risk review', async ({ page }) => {
    await page.goto(`${portalBase}/login-incident-review.html`);

    await expect(page.locator('[data-testid="incident-id-input"]')).not.toHaveValue('');
    await expect(page.locator('[data-testid="risk-event-id-input"]')).not.toHaveValue('');

    await page.click('[data-testid="load-incident"]');
    await expect(page.locator('#incident-output')).toContainText('AI-assisted summary');

    await page.click('[data-testid="review-risk-event"]');
    await expect(page.locator('#incident-output')).toContainText('reviewed');
    await expect(page.locator('#incident-output')).toContainText('STEP_UP_REQUIRED');
  });

  test('05 login failure triage recommends account lock', async ({ page }) => {
    await page.goto(`${portalBase}/login-failure-triage.html`);
    await page.click('[data-testid="create-triage"]');

    await expect(page.locator('#triage-action')).toHaveText('LOCK_ACCOUNT');
    await expect(page.locator('#triage-output')).toContainText('BAD_PASSWORD');
  });

  test('06 account lock screen locks account and shows locked queue', async ({ page }) => {
    await page.goto(`${portalBase}/account-lock-review.html`);
    await page.click('[data-testid="lock-account"]');

    await expect(page.locator('#lock-status')).toHaveText('LOCKED');

    await page.click('[data-testid="load-locked-accounts"]');
    await expect(page.locator('#locked-count')).toHaveText('1');
    await expect(page.locator('#lock-output')).toContainText('poc1b.phase3.user');
  });

  test('07 unlock approval creates request and approves unlock', async ({ page }) => {
    await page.goto(`${portalBase}/unlock-approval.html`);

    await page.click('[data-testid="create-unlock-request"]');
    await expect(page.locator('#unlock-request-id')).not.toHaveText('none');

    await page.click('[data-testid="approve-unlock"]');
    await expect(page.locator('#unlock-status')).toHaveText('UNLOCKED');
    await expect(page.locator('#unlock-output')).toContainText('accountUnlocked');
  });

  test('08 step-up screen creates and verifies challenge', async ({ page }) => {
    await page.goto(`${portalBase}/step-up-auth.html`);

    await page.click('[data-testid="create-step-up"]');
    await expect(page.locator('#challenge-id')).not.toHaveText('none');

    await page.fill('[data-testid="challenge-code"]', '246810');
    await page.click('[data-testid="verify-step-up"]');

    await expect(page.locator('#stepup-status')).toHaveText('ALLOW_LOGIN');
    await expect(page.locator('#stepup-output')).toContainText('VERIFIED');
  });

  test('09 backend lists contain browser-generated records', async ({ request }) => {
    const events = await request.get(`${apiBase}/api/v1/identity/risk/events`);
    expect(events.ok()).toBeTruthy();
    const eventJson = await events.json();
    expect(eventJson.count).toBeGreaterThanOrEqual(1);

    const incidents = await request.get(`${apiBase}/api/v1/identity/risk/incidents`);
    expect(incidents.ok()).toBeTruthy();
    const incidentJson = await incidents.json();
    expect(incidentJson.count).toBeGreaterThanOrEqual(1);

    const triage = await request.get(`${apiBase}/api/v1/identity/risk/login-failures`);
    expect(triage.ok()).toBeTruthy();
    const triageJson = await triage.json();
    expect(triageJson.count).toBeGreaterThanOrEqual(1);

    const decisions = await request.get(`${apiBase}/api/v1/identity/risk/policy-decisions`);
    expect(decisions.ok()).toBeTruthy();
    const decisionJson = await decisions.json();
    expect(decisionJson.count).toBeGreaterThanOrEqual(1);
  });
});