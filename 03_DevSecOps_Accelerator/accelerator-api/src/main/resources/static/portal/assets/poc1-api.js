const AIRA = (() => {
  const identityBaseUrl = localStorage.getItem('aira.identityBaseUrl') || 'http://192.168.179.193:9091';
  const apiKey = localStorage.getItem('aira.apiKey') || 'aira-local-dev-key-change-me';

  function headers(extra = {}) {
    return Object.assign({
      'Content-Type': 'application/json',
      'X-AIRA-API-Key': apiKey
    }, extra);
  }

  function getSessionToken() {
    return localStorage.getItem('aira.sessionToken') || '';
  }

  function setSessionToken(token) {
    if (token) { localStorage.setItem('aira.sessionToken', token); }
  }

  function clearSession() {
    localStorage.removeItem('aira.sessionToken');
    localStorage.removeItem('aira.identityContext');
  }

  function authHeaders() {
    const token = getSessionToken();
    return headers(token ? { 'Authorization': 'Bearer ' + token } : {});
  }

  async function request(path, options = {}) {
    const response = await fetch(identityBaseUrl + path, options);
    const text = await response.text();
    let body = {};
    try { body = text ? JSON.parse(text) : {}; } catch (e) { body = { raw: text }; }
    if (!response.ok) {
      const message = body.message || body.error || response.status + ' ' + response.statusText;
      throw new Error(message);
    }
    return body;
  }

  function show(id, message, mode = '') {
    const node = document.getElementById(id);
    if (!node) { return; }
    node.className = 'notice' + (mode ? ' ' + mode : '');
    node.textContent = message;
    node.classList.remove('hidden');
  }

  function value(id) {
    const node = document.getElementById(id);
    return node ? node.value.trim() : '';
  }

  function checked(id) {
    const node = document.getElementById(id);
    return !!(node && node.checked);
  }

  async function signup(event) {
    event.preventDefault();
    show('formStatus', 'Submitting request...', 'warn');
    try {
      const result = await request('/api/v1/identity/signup', {
        method: 'POST',
        headers: headers(),
        body: JSON.stringify({
          firstName: value('firstName'),
          lastName: value('lastName'),
          email: value('email'),
          institutionKey: value('institutionKey') || 'AIRA-DEMO-INSTITUTION',
          department: value('department'),
          jobTitle: value('jobTitle'),
          requestedRole: value('requestedRole') || 'DEVELOPER',
          requestReason: value('requestReason'),
          password: value('password'),
          confirmPassword: value('confirmPassword'),
          acceptGovernancePolicy: checked('acceptGovernancePolicy'),
          acceptTermsOfUse: checked('acceptTermsOfUse')
        })
      });
      localStorage.setItem('aira.lastSignupEmail', value('email'));
      if (result.localOnlyVerificationToken) {
        localStorage.setItem('aira.localOnlyVerificationToken', result.localOnlyVerificationToken);
      }
      window.location.href = '/portal/signup-submitted.html';
    } catch (error) {
      show('formStatus', error.message, 'error');
    }
  }

  async function verifyEmail(event) {
    event.preventDefault();
    const token = value('token') || localStorage.getItem('aira.localOnlyVerificationToken') || '';
    show('verifyStatus', 'Verifying email...', 'warn');
    try {
      const result = await request('/api/v1/identity/verify-email', {
        method: 'POST',
        headers: headers(),
        body: JSON.stringify({ token })
      });
      if (result.status === 'VERIFIED') {
        show('verifyStatus', 'Email verified. Your request is now pending institution approval.', 'success');
        setTimeout(() => { window.location.href = '/portal/pending-approval.html'; }, 900);
      } else {
        show('verifyStatus', JSON.stringify(result, null, 2), 'warn');
      }
    } catch (error) {
      show('verifyStatus', error.message, 'error');
    }
  }

  async function login(event) {
    event.preventDefault();
    show('loginStatus', 'Signing in...', 'warn');
    try {
      const result = await request('/api/v1/identity/login', {
        method: 'POST',
        headers: headers(),
        body: JSON.stringify({
          email: value('email'),
          password: value('password'),
          institutionKey: value('institutionKey') || 'AIRA-DEMO-INSTITUTION'
        })
      });
      setSessionToken(result.sessionToken);
      localStorage.setItem('aira.identityContext', JSON.stringify(result));
      const landing = await request('/api/v1/identity/landing-context', {
        method: 'GET',
        headers: authHeaders()
      });
      window.location.href = landing.landingRoute || '/portal/home.html';
    } catch (error) {
      show('loginStatus', error.message, 'error');
    }
  }

  async function hydrateSession(targetId = 'sessionStatus') {
    try {
      const session = await request('/api/v1/identity/session', { method: 'GET', headers: authHeaders() });
      if (session.authenticated !== true) {
        show(targetId, 'You are not signed in. Redirecting to login...', 'warn');
        setTimeout(() => { window.location.href = '/portal/login.html'; }, 800);
        return null;
      }
      localStorage.setItem('aira.identityContext', JSON.stringify(session));
      const node = document.getElementById(targetId);
      if (node) {
        node.className = 'notice success';
        node.textContent = 'Signed in as ' + session.email + ' with role ' + session.roleKey + '.';
      }
      return session;
    } catch (error) {
      show(targetId, error.message, 'error');
      return null;
    }
  }

  async function routeHome() {
    const session = await hydrateSession('sessionStatus');
    if (!session) { return; }
    const landing = await request('/api/v1/identity/landing-context', { method: 'GET', headers: authHeaders() });
    const routeNode = document.getElementById('landingRoute');
    if (routeNode) { routeNode.textContent = landing.landingRoute || '/portal/home.html'; }
    const button = document.getElementById('continueButton');
    if (button) { button.href = landing.landingRoute || '/portal/home.html'; }
  }

  async function logout() {
    try {
      await request('/api/v1/identity/logout', { method: 'POST', headers: authHeaders() });
    } catch (e) {
      console.warn(e);
    }
    clearSession();
    window.location.href = '/portal/login.html';
  }

  function initSignupSubmitted() {
    const email = localStorage.getItem('aira.lastSignupEmail') || 'your email';
    const token = localStorage.getItem('aira.localOnlyVerificationToken') || '';
    const emailNode = document.getElementById('submittedEmail');
    const tokenNode = document.getElementById('localToken');
    if (emailNode) { emailNode.textContent = email; }
    if (tokenNode) { tokenNode.value = token; }
  }

  function initVerifyPage() {
    const token = localStorage.getItem('aira.localOnlyVerificationToken') || '';
    const tokenInput = document.getElementById('token');
    if (tokenInput && token) { tokenInput.value = token; }
  }

  function dashboardTitle(roleName) {
    hydrateSession('sessionStatus').then(session => {
      const node = document.getElementById('dashboardTitle');
      if (node && session) { node.textContent = roleName + ' Dashboard - ' + session.email; }
    });
  }

  return {
    identityBaseUrl,
    signup,
    verifyEmail,
    login,
    logout,
    hydrateSession,
    routeHome,
    initSignupSubmitted,
    initVerifyPage,
    dashboardTitle
  };
})();