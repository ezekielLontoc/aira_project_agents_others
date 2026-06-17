(function () {
  const defaultApiBase = window.localStorage.getItem('POC1B_API_BASE') || 'http://127.0.0.1:9191';

  window.POC1B = {
    apiBase: defaultApiBase,

    setStatus: function (id, text, className) {
      const el = document.getElementById(id);
      if (!el) return;
      el.textContent = text;
      if (className) {
        el.className = className;
      }
    },

    writeJson: function (id, data) {
      const el = document.getElementById(id);
      if (!el) return;
      el.textContent = JSON.stringify(data, null, 2);
    },

    get: async function (path) {
      const response = await fetch(this.apiBase + path, {
        method: 'GET',
        headers: {
          'accept': 'application/json'
        }
      });

      if (!response.ok) {
        throw new Error('GET ' + path + ' failed with HTTP ' + response.status);
      }

      return response.json();
    },

    post: async function (path, body) {
      const response = await fetch(this.apiBase + path, {
        method: 'POST',
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json'
        },
        body: JSON.stringify(body || {})
      });

      if (!response.ok) {
        const text = await response.text();
        throw new Error('POST ' + path + ' failed with HTTP ' + response.status + ': ' + text);
      }

      return response.json();
    },

    remember: function (key, value) {
      window.localStorage.setItem(key, value);
    },

    recall: function (key) {
      return window.localStorage.getItem(key);
    },

    clearDemoState: function () {
      const keys = [
        'poc1bRiskEventId',
        'poc1bIncidentId',
        'poc1bUnlockRequestId',
        'poc1bStepUpChallengeId'
      ];

      keys.forEach((key) => window.localStorage.removeItem(key));
    },

    navHtml: function () {
      return [
        '<div class="nav">',
        '<a data-nav="dashboard" href="./security-login-risk-dashboard.html">Risk Dashboard</a>',
        '<a data-nav="incident" href="./login-incident-review.html">Incident Review</a>',
        '<a data-nav="triage" href="./login-failure-triage.html">Failure Triage</a>',
        '<a data-nav="lock" href="./account-lock-review.html">Account Lock Review</a>',
        '<a data-nav="unlock" href="./unlock-approval.html">Unlock Approval</a>',
        '<a data-nav="stepup" href="./step-up-auth.html">Step-Up Auth</a>',
        '</div>'
      ].join('');
    },

    injectNav: function () {
      const nav = document.getElementById('poc1b-nav');
      if (nav) {
        nav.innerHTML = this.navHtml();
      }
    }
  };

  document.addEventListener('DOMContentLoaded', function () {
    window.POC1B.injectNav();
  });
})();