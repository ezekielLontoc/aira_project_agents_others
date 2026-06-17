const { test, expect, request: playwrightRequest } = require('@playwright/test');

const {
  config,
  logger,
  emitEvent,
  expectOkResponse,
  postJson,
  getJson,
  signupVerifyApproveLogin,
  runBatches,
} = require('./support/aira-runtime');

const {
  writeEvidence,
  appendMarkdownSummary,
} = require('./support/evidence-writer');

test.describe.configure({ mode: 'serial' });

test.describe('AIRA POC-1 Heavy Simulation Suite', () => {
  test.beforeAll(async () => {
    logger.info('============================================================');
    logger.info('AIRA POC-1 Heavy Simulation Suite starting');
    logger.info(`Portal base URL: ${config.portalBaseUrl}`);
    logger.info(`Identity base URL: ${config.identityBaseUrl}`);
    logger.info(`Simulation users: ${config.simUsers}`);
    logger.info(`Batch size: ${config.simBatchSize}`);
    logger.info('============================================================');

    emitEvent('suite_start', {
      portalBaseUrl: config.portalBaseUrl,
      identityBaseUrl: config.identityBaseUrl,
      simUsers: config.simUsers,
      simBatchSize: config.simBatchSize,
    });
  });

  test.afterAll(async () => {
    emitEvent('suite_complete', {
      completedAt: new Date().toISOString(),
    });

    logger.info('AIRA POC-1 Heavy Simulation Suite complete');
  });

  test('01 runtime smoke: portal pages and portal JS are reachable', async ({ page }) => {
    const urls = [
      `${config.portalBaseUrl}/index.html`,
      `${config.portalBaseUrl}/landing.html`,
      `${config.portalBaseUrl}/signup.html`,
      `${config.portalBaseUrl}/login.html`,
      `${config.portalBaseUrl}/home.html`,
      `${config.portalBaseUrl}/developer-dashboard.html`,
      `${config.portalBaseUrl}/admin-dashboard.html`,
      `${config.portalBaseUrl}/institution-dashboard.html`,
      `${config.portalBaseUrl}/security-dashboard.html`,
      `${config.portalBaseUrl}/evidence-dashboard.html`,
      `${config.portalBaseUrl}/viewer-dashboard.html`,
      `${config.portalBaseUrl}/assets/poc1-api.js`,
    ];

    const results = [];

    for (const url of urls) {
      const response = await page.goto(url, { waitUntil: 'domcontentloaded' });
      expect(response, `response exists for ${url}`).toBeTruthy();
      expect(response.ok(), `HTTP 2xx for ${url}`).toBeTruthy();

      const titleOrUrl = await page.title().catch(() => '');
      results.push({
        url,
        status: response.status(),
        title: titleOrUrl,
      });

      logger.info(`Portal smoke OK: ${url} status=${response.status()}`);
    }

    const evidencePath = writeEvidence('runtime-smoke', {
      status: 'PASSED',
      results,
    });

    logger.info(`Runtime smoke evidence written: ${evidencePath}`);
  });

  test('02 identity readiness and microfunction catalog are healthy', async ({ request }) => {
    const readinessResponse = await getJson(
      request,
      `${config.identityBaseUrl}/api/v1/identity/readiness`,
    );

    await expectOkResponse(readinessResponse, 'identity readiness');
    const readiness = await readinessResponse.json();

    const microResponse = await getJson(
      request,
      `${config.identityBaseUrl}/api/v1/identity/microfunctions`,
    );

    await expectOkResponse(microResponse, 'identity microfunctions');
    const microfunctions = await microResponse.json();

    const microfunctionArray = Array.isArray(microfunctions)
      ? microfunctions
      : microfunctions.microfunctions || microfunctions.items || [];

    expect(microfunctionArray.length).toBeGreaterThanOrEqual(58);

    const keys = microfunctionArray
      .map((item) => item.key || item.microfunctionKey || item.microfunction_key)
      .filter(Boolean);

    expect(keys).toContain('MF-IDENTITY-001');
    expect(keys).toContain('MF-IDENTITY-058');

    const evidencePath = writeEvidence('identity-readiness-microfunctions', {
      status: 'PASSED',
      readiness,
      microfunctionCount: microfunctionArray.length,
      firstKey: keys[0],
      lastKey: keys[keys.length - 1],
    });

    logger.info(`Identity readiness and microfunction evidence written: ${evidencePath}`);
  });

  test('03 CORS preflight allows portal-to-identity protected calls', async ({ request }) => {
    const response = await request.fetch(`${config.identityBaseUrl}/api/v1/identity/login`, {
      method: 'OPTIONS',
      headers: {
        Origin: config.portalBaseUrl.replace('/portal', ''),
        'Access-Control-Request-Method': 'POST',
        'Access-Control-Request-Headers': 'content-type,x-aira-api-key',
      },
    });

    expect(response.ok()).toBeTruthy();

    const headers = response.headers();
    const allowOrigin = headers['access-control-allow-origin'];

    expect(allowOrigin).toBe(config.portalBaseUrl.replace('/portal', ''));

    const evidencePath = writeEvidence('cors-preflight', {
      status: 'PASSED',
      allowOrigin,
      statusCode: response.status(),
    });

    logger.info(`CORS evidence written: ${evidencePath}`);
  });

  test('04 negative path: bad password is denied', async ({ request }) => {
    const response = await postJson(
      request,
      `${config.identityBaseUrl}/api/v1/identity/login`,
      {
        email: config.browserEmail,
        password: 'DefinitelyWrongPassword!2026',
        institutionKey: config.institutionKey,
      },
    );

    const httpStatus = response.status();
    const bodyText = await response.text().catch(() => '');

    let body = {};
    try {
      body = bodyText ? JSON.parse(bodyText) : {};
    } catch {
      body = {};
    }

    const statusText = String(
      body.status ||
      body.result ||
      body.code ||
      body.error ||
      body.message ||
      ''
    ).toUpperCase();

    const deniedByHttp = httpStatus >= 400;
    const deniedByBody =
      !body.sessionToken &&
      (
        statusText.includes('DENIED') ||
        statusText.includes('INVALID') ||
        statusText.includes('FAILED') ||
        statusText.includes('BAD') ||
        statusText.includes('UNAUTHORIZED') ||
        statusText.includes('CREDENTIAL')
      );

    expect(
      deniedByHttp || deniedByBody,
      `Bad password must fail closed. HTTP=${httpStatus} Body=${bodyText}`
    ).toBeTruthy();

    expect(
      body.sessionToken,
      `Bad password must not return a session token. HTTP=${httpStatus} Body=${bodyText}`
    ).toBeFalsy();

    const evidencePath = writeEvidence('negative-bad-password', {
      status: 'PASSED',
      denialMode: deniedByHttp ? 'HTTP_DENIAL' : 'BODY_LEVEL_DENIAL',
      httpStatus,
      body,
      bodyPreview: bodyText.slice(0, 1000),
      sessionTokenReturned: Boolean(body.sessionToken),
    });

    logger.info(`Negative bad password evidence written: ${evidencePath}`);
  });

  test('05 negative path: missing API key is denied or not authorized', async ({ request }) => {
    const response = await request.get(`${config.identityBaseUrl}/api/v1/identity/session`, {
      headers: {},
    });

    const httpStatus = response.status();
    const bodyText = await response.text().catch(() => '');

    let body = {};
    try {
      body = bodyText ? JSON.parse(bodyText) : {};
    } catch {
      body = {};
    }

    const statusText = String(
      body.status ||
      body.result ||
      body.code ||
      body.error ||
      body.message ||
      ''
    ).toUpperCase();

    const deniedByHttp = httpStatus >= 400;
    const deniedByBody =
      body.authenticated !== true &&
      !body.sessionToken &&
      (
        statusText.includes('DENIED') ||
        statusText.includes('INVALID') ||
        statusText.includes('FAILED') ||
        statusText.includes('BAD') ||
        statusText.includes('UNAUTHORIZED') ||
        statusText.includes('MISSING') ||
        statusText.includes('API') ||
        statusText.includes('SESSION') ||
        statusText.includes('TOKEN')
      );

    const deniedByUnauthenticatedShape =
      httpStatus === 200 &&
      body.authenticated !== true &&
      !body.sessionToken;

    expect(
      deniedByHttp || deniedByBody || deniedByUnauthenticatedShape,
      `Missing API key must fail closed or remain unauthenticated. HTTP=${httpStatus} Body=${bodyText}`
    ).toBeTruthy();

    expect(
      body.authenticated,
      `Missing API key must not authenticate. HTTP=${httpStatus} Body=${bodyText}`
    ).not.toBe(true);

    expect(
      body.sessionToken,
      `Missing API key must not return a session token. HTTP=${httpStatus} Body=${bodyText}`
    ).toBeFalsy();

    const evidencePath = writeEvidence('negative-missing-api-key', {
      status: 'PASSED',
      denialMode: deniedByHttp ? 'HTTP_DENIAL' : 'BODY_OR_UNAUTHENTICATED_DENIAL',
      httpStatus,
      body,
      bodyPreview: bodyText.slice(0, 1000),
      authenticatedReturned: body.authenticated,
      sessionTokenReturned: Boolean(body.sessionToken),
    });

    logger.info(`Negative missing API key evidence written: ${evidencePath}`);
  });

  test('06 full identity flow simulation across controlled batches', async () => {
    const api = await playwrightRequest.newContext();

    const userSpecs = Array.from({ length: config.simUsers }).map((_, index) => ({
      index,
      roleKey: 'DEVELOPER',
    }));

    const startedAt = Date.now();

    const results = await runBatches(
      userSpecs,
      config.simBatchSize,
      async (spec) => signupVerifyApproveLogin(api, {
        roleKey: spec.roleKey,
      }),
    );

    await api.dispose();

    const durationMs = Date.now() - startedAt;

    expect(results.length).toBe(config.simUsers);

    for (const result of results) {
      expect(result.landing.landingRoute).toBe('/portal/developer-dashboard.html');
      expect(result.afterLogout.status).toBe('DENIED');
    }

    const evidencePath = writeEvidence('controlled-batch-identity-flow', {
      status: 'PASSED',
      simUsers: config.simUsers,
      simBatchSize: config.simBatchSize,
      durationMs,
      results: results.map((item) => ({
        email: item.email,
        roleKey: item.roleKey,
        landingRoute: item.landing.landingRoute,
        afterLogoutStatus: item.afterLogout.status,
      })),
    });

    appendMarkdownSummary('POC-1 Heavy Simulation Summary', [
      '',
      '---',
      '',
      `## Controlled Batch Identity Flow - ${new Date().toISOString()}`,
      '',
      'Status: PASSED',
      '',
      `- Simulated users: ${config.simUsers}`,
      `- Batch size: ${config.simBatchSize}`,
      `- Duration ms: ${durationMs}`,
      '- Flow: signup -> verify -> approve -> login -> session -> landing -> logout -> denied after logout',
      '- Expected landing route: /portal/developer-dashboard.html',
      '',
      `Evidence JSON: ${evidencePath}`,
    ]);

    logger.info(`Controlled batch identity flow evidence written: ${evidencePath}`);
  });

  test('07 browser journey: validated browser account reaches developer dashboard', async ({ page }) => {
    await page.goto(`${config.portalBaseUrl}/login.html`, { waitUntil: 'domcontentloaded' });

    await page.getByLabel('Email').fill(config.browserEmail);
    await page.getByLabel('Password').fill(config.browserPassword);
    await page.getByLabel('Institution key').fill(config.institutionKey);

    await page.getByRole('button', { name: /login/i }).click();

    await page.waitForURL('**/portal/developer-dashboard.html', {
      timeout: 15000,
    });

    await expect(page.getByText(`Developer Dashboard - ${config.browserEmail}`)).toBeVisible();
    await expect(page.getByText(`Signed in as ${config.browserEmail} with role DEVELOPER.`)).toBeVisible();

    const localStorageToken = await page.evaluate(() => window.localStorage.getItem('aira.sessionToken'));
    expect(localStorageToken).toBeTruthy();

    const evidencePath = writeEvidence('browser-journey-developer-dashboard', {
      status: 'PASSED',
      url: page.url(),
      email: config.browserEmail,
      expectedRole: 'DEVELOPER',
      sessionTokenPresent: Boolean(localStorageToken),
    });

    logger.info(`Browser journey evidence written: ${evidencePath}`);
  });

  test('08 browser journey: home router resolves developer dashboard', async ({ page }) => {
    await page.goto(`${config.portalBaseUrl}/login.html`, { waitUntil: 'domcontentloaded' });

    await page.getByLabel('Email').fill(config.browserEmail);
    await page.getByLabel('Password').fill(config.browserPassword);
    await page.getByLabel('Institution key').fill(config.institutionKey);

    await page.getByRole('button', { name: /login/i }).click();

    await page.waitForURL('**/portal/developer-dashboard.html', {
      timeout: 15000,
    });

    await page.goto(`${config.portalBaseUrl}/home.html`, { waitUntil: 'domcontentloaded' });

    await expect(page.getByText(`Signed in as ${config.browserEmail} with role DEVELOPER.`)).toBeVisible();
    await expect(page.getByText('/portal/developer-dashboard.html')).toBeVisible();

    const evidencePath = writeEvidence('browser-home-router', {
      status: 'PASSED',
      url: page.url(),
      email: config.browserEmail,
      expectedRoute: '/portal/developer-dashboard.html',
    });

    logger.info(`Home router evidence written: ${evidencePath}`);
  });

  test('09 browser logout: session clears and home redirects/denies', async ({ page }) => {
    await page.goto(`${config.portalBaseUrl}/login.html`, { waitUntil: 'domcontentloaded' });

    await page.getByLabel('Email').fill(config.browserEmail);
    await page.getByLabel('Password').fill(config.browserPassword);
    await page.getByLabel('Institution key').fill(config.institutionKey);

    await page.getByRole('button', { name: /login/i }).click();

    await page.waitForURL('**/portal/developer-dashboard.html', {
      timeout: 15000,
    });

    await page.getByRole('button', { name: /logout/i }).click();

    await page.waitForURL('**/portal/login.html', {
      timeout: 15000,
    });

    const localStorageToken = await page.evaluate(() => window.localStorage.getItem('aira.sessionToken'));
    expect(localStorageToken).toBeFalsy();

    await page.goto(`${config.portalBaseUrl}/home.html`, { waitUntil: 'domcontentloaded' });
    await expect(page.getByText(/You are not signed in/i)).toBeVisible();

    const evidencePath = writeEvidence('browser-logout-denied-home', {
      status: 'PASSED',
      url: page.url(),
      email: config.browserEmail,
      sessionTokenPresentAfterLogout: Boolean(localStorageToken),
    });

    logger.info(`Logout browser evidence written: ${evidencePath}`);
  });
});