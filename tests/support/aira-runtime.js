require('dotenv').config({ path: '.env.poc1' });

const log4js = require('log4js');
const log4jsConfig = require('./log4js.config');

log4js.configure(log4jsConfig);

const logger = log4js.getLogger('poc1-heavy');
const eventLogger = log4js.getLogger('events');

const config = {
  serverIp: process.env.AIRA_SERVER_IP || '192.168.179.193',
  portalPort: Number(process.env.AIRA_PORTAL_PORT || 9090),
  identityPort: Number(process.env.AIRA_IDENTITY_PORT || 9091),
  apiKey: process.env.AIRA_API_KEY || 'aira-local-dev-key-change-me',
  adminKey: process.env.AIRA_ADMIN_KEY || 'aira-local-dev-key-change-me',
  institutionKey: process.env.AIRA_INSTITUTION_KEY || 'AIRA-DEMO-INSTITUTION',
  simUsers: Number(process.env.AIRA_SIM_USERS || 12),
  simBatchSize: Number(process.env.AIRA_SIM_BATCH_SIZE || 4),
  simPassword: process.env.AIRA_SIM_PASSWORD || 'AiraLocalDev!2026',
  browserEmail: process.env.AIRA_BROWSER_EMAIL || 'poc1.browser.20260615180057@aira.local',
  browserPassword: process.env.AIRA_BROWSER_PASSWORD || 'AiraLocalDev!2026',
};

config.portalBaseUrl = `http://${config.serverIp}:${config.portalPort}/portal`;
config.identityBaseUrl = `http://${config.serverIp}:${config.identityPort}`;

function emitEvent(type, payload) {
  eventLogger.info(JSON.stringify({
    timestamp: new Date().toISOString(),
    type,
    ...payload,
  }));
}

function uniqueEmail(prefix = 'poc1.heavy') {
  const now = new Date();
  const stamp = now.toISOString().replace(/[-:.TZ]/g, '');
  const random = Math.random().toString(36).slice(2, 8);
  return `${prefix}.${stamp}.${random}@aira.local`;
}

async function expectOkResponse(response, name) {
  if (!response.ok()) {
    const body = await response.text().catch(() => '');
    throw new Error(`${name} failed. HTTP ${response.status()} ${response.statusText()} Body: ${body}`);
  }
}

async function postJson(request, url, body, headers = {}) {
  const response = await request.post(url, {
    headers: {
      'X-AIRA-API-Key': config.apiKey,
      ...headers,
    },
    data: body,
  });
  return response;
}

async function getJson(request, url, headers = {}) {
  const response = await request.get(url, {
    headers: {
      'X-AIRA-API-Key': config.apiKey,
      ...headers,
    },
  });
  return response;
}

async function signupVerifyApproveLogin(request, options = {}) {
  const email = options.email || uniqueEmail();
  const roleKey = options.roleKey || 'DEVELOPER';
  const password = options.password || config.simPassword;

  logger.info(`Creating identity flow for ${email} role=${roleKey}`);
  emitEvent('identity_flow_start', { email, roleKey });

  const signupResponse = await postJson(
    request,
    `${config.identityBaseUrl}/api/v1/identity/signup`,
    {
      firstName: 'POC1',
      lastName: 'HeavyUser',
      email,
      institutionKey: config.institutionKey,
      department: 'AIRA Heavy Simulation',
      jobTitle: 'POC-1 Heavy Simulation User',
      requestedRole: roleKey,
      requestReason: 'POC-1 heavy simulation validation',
      password,
      confirmPassword: password,
      acceptGovernancePolicy: true,
      acceptTermsOfUse: true,
    },
  );

  await expectOkResponse(signupResponse, `signup ${email}`);
  const signup = await signupResponse.json();

  if (!signup.localOnlyVerificationToken) {
    throw new Error(`signup ${email} did not return localOnlyVerificationToken`);
  }

  emitEvent('signup_passed', { email, roleKey });

  const verifyResponse = await postJson(
    request,
    `${config.identityBaseUrl}/api/v1/identity/verify-email`,
    { token: signup.localOnlyVerificationToken },
  );

  await expectOkResponse(verifyResponse, `verify ${email}`);
  const verify = await verifyResponse.json();

  if (verify.status !== 'VERIFIED') {
    throw new Error(`verify ${email} expected VERIFIED but got ${verify.status}`);
  }

  emitEvent('verify_passed', { email, roleKey });

  const requestsResponse = await getJson(
    request,
    `${config.identityBaseUrl}/api/v1/identity/admin/access-requests`,
    {
      'X-AIRA-Admin-Key': config.adminKey,
    },
  );

  await expectOkResponse(requestsResponse, `admin access requests ${email}`);
  const requests = await requestsResponse.json();

  const accessRequest = Array.isArray(requests)
    ? requests.find((item) => item.normalized_email === email || item.email === email)
    : null;

  if (!accessRequest) {
    throw new Error(`No access request found for ${email}`);
  }

  const requestId = accessRequest.access_request_id || accessRequest.requestId || accessRequest.id;

  if (!requestId) {
    throw new Error(`Access request for ${email} did not expose request ID`);
  }

  const approveResponse = await postJson(
    request,
    `${config.identityBaseUrl}/api/v1/identity/admin/access-requests/${requestId}/approve`,
    { roleKey },
    {
      'X-AIRA-Admin-Key': config.adminKey,
    },
  );

  await expectOkResponse(approveResponse, `approve ${email}`);
  const approve = await approveResponse.json();

  if (approve.status !== 'APPROVED') {
    throw new Error(`approve ${email} expected APPROVED but got ${approve.status}`);
  }

  emitEvent('approve_passed', { email, roleKey });

  const loginResponse = await postJson(
    request,
    `${config.identityBaseUrl}/api/v1/identity/login`,
    {
      email,
      password,
      institutionKey: config.institutionKey,
    },
  );

  await expectOkResponse(loginResponse, `login ${email}`);
  const login = await loginResponse.json();

  if (!login.sessionToken) {
    throw new Error(`login ${email} did not return sessionToken`);
  }

  emitEvent('login_passed', { email, roleKey });

  const authHeaders = {
    Authorization: `Bearer ${login.sessionToken}`,
  };

  const sessionResponse = await getJson(
    request,
    `${config.identityBaseUrl}/api/v1/identity/session`,
    authHeaders,
  );

  await expectOkResponse(sessionResponse, `session ${email}`);
  const session = await sessionResponse.json();

  if (session.authenticated !== true) {
    throw new Error(`session ${email} expected authenticated true`);
  }

  const landingResponse = await getJson(
    request,
    `${config.identityBaseUrl}/api/v1/identity/landing-context`,
    authHeaders,
  );

  await expectOkResponse(landingResponse, `landing context ${email}`);
  const landing = await landingResponse.json();

  if (!landing.landingRoute) {
    throw new Error(`landing context ${email} did not return landingRoute`);
  }

  emitEvent('landing_passed', {
    email,
    roleKey,
    landingRoute: landing.landingRoute,
  });

  const logoutResponse = await postJson(
    request,
    `${config.identityBaseUrl}/api/v1/identity/logout`,
    {},
    authHeaders,
  );

  await expectOkResponse(logoutResponse, `logout ${email}`);
  const logout = await logoutResponse.json();

  if (logout.status !== 'LOGGED_OUT') {
    throw new Error(`logout ${email} expected LOGGED_OUT but got ${logout.status}`);
  }

  const afterLogoutResponse = await getJson(
    request,
    `${config.identityBaseUrl}/api/v1/identity/session`,
    authHeaders,
  );

  await expectOkResponse(afterLogoutResponse, `session after logout ${email}`);
  const afterLogout = await afterLogoutResponse.json();

  if (afterLogout.status !== 'DENIED') {
    throw new Error(`session after logout ${email} expected DENIED but got ${afterLogout.status}`);
  }

  emitEvent('identity_flow_complete', {
    email,
    roleKey,
    landingRoute: landing.landingRoute,
  });

  return {
    email,
    password,
    roleKey,
    requestId,
    session,
    landing,
    logout,
    afterLogout,
  };
}

async function runBatches(items, batchSize, worker) {
  const results = [];

  for (let i = 0; i < items.length; i += batchSize) {
    const batch = items.slice(i, i + batchSize);
    logger.info(`Running batch ${Math.floor(i / batchSize) + 1} with ${batch.length} item(s)`);

    const batchResults = await Promise.all(batch.map((item) => worker(item)));
    results.push(...batchResults);
  }

  return results;
}

module.exports = {
  config,
  logger,
  emitEvent,
  uniqueEmail,
  expectOkResponse,
  postJson,
  getJson,
  signupVerifyApproveLogin,
  runBatches,
};