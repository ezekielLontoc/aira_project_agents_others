#!/usr/bin/env node

const http = require('http');
const crypto = require('crypto');

const args = process.argv.slice(2);
let port = 9191;

for (let i = 0; i < args.length; i += 1) {
  if (args[i] === '--port' && args[i + 1]) {
    port = Number(args[i + 1]);
  }
}

function nowIso() {
  return new Date().toISOString();
}

function id(prefix) {
  return `${prefix}-${Date.now()}-${crypto.randomBytes(4).toString('hex')}`;
}

function sendJson(res, statusCode, body) {
  const json = JSON.stringify(body, null, 2);
  res.writeHead(statusCode, {
    'content-type': 'application/json; charset=utf-8',
    'cache-control': 'no-store',
    'access-control-allow-origin': '*',
    'access-control-allow-methods': 'GET,POST,OPTIONS',
    'access-control-allow-headers': 'content-type,authorization,x-aira-api-key'
  });
  res.end(json);
}

function collectBody(req) {
  return new Promise((resolve, reject) => {
    let raw = '';

    req.on('data', (chunk) => {
      raw += chunk;
      if (raw.length > 1024 * 1024) {
        reject(new Error('Request body too large'));
      }
    });

    req.on('end', () => {
      if (!raw.trim()) {
        resolve({});
        return;
      }

      try {
        resolve(JSON.parse(raw));
      } catch (error) {
        reject(new Error(`Invalid JSON body: ${error.message}`));
      }
    });

    req.on('error', reject);
  });
}

const microfunctions = Array.from({ length: 40 }, (_, index) => {
  const number = String(index + 1).padStart(3, '0');
  return {
    key: `MF-LOGIN-RISK-${number}`,
    domain: 'LOGIN_RISK',
    active: true
  };
});

const store = {
  riskEvents: new Map(),
  triage: new Map(),
  incidents: new Map(),
  locks: new Map(),
  unlockRequests: new Map(),
  stepUpChallenges: new Map(),
  policyDecisions: new Map()
};

function severityForScore(score) {
  if (score >= 90) return 'CRITICAL';
  if (score >= 70) return 'HIGH';
  if (score >= 40) return 'MEDIUM';
  return 'LOW';
}

function policyDecisionFor(input) {
  const riskScore = Number(input.riskScore || input.risk_score || 0);
  const failedAttempts = Number(input.failedAttemptsInWindow || input.failed_attempts_in_window || 0);
  const locked = Boolean(input.locked);

  let decision = 'ALLOW';
  let allowLogin = true;
  let requireStepUp = false;
  let lockAccount = false;
  const denyReasons = [];

  if (locked) {
    decision = 'DENY';
    allowLogin = false;
    denyReasons.push('ACCOUNT_LOCKED');
  } else if (failedAttempts >= 5 || riskScore >= 90) {
    decision = 'LOCK';
    allowLogin = false;
    lockAccount = true;
    if (failedAttempts >= 5) denyReasons.push('TOO_MANY_FAILURES');
    if (riskScore >= 90) denyReasons.push('HIGH_RISK_LOGIN');
  } else if (riskScore >= 70) {
    decision = 'STEP_UP';
    allowLogin = false;
    requireStepUp = true;
  }

  const policyDecision = {
    policyDecisionId: id('policy'),
    policyName: 'poc1b-login-risk-step-up',
    decision,
    allowLogin,
    requireStepUp,
    lockAccount,
    requireUnlockApproval: true,
    denyReasons,
    policyInput: input,
    createdAt: nowIso()
  };

  store.policyDecisions.set(policyDecision.policyDecisionId, policyDecision);
  return policyDecision;
}

function createIncidentFromRiskEvent(riskEvent, recommendedAction) {
  const incident = {
    incidentId: id('incident'),
    riskEventId: riskEvent.riskEventId,
    institutionKey: riskEvent.institutionKey,
    identityId: riskEvent.identityId || null,
    incidentStatus: 'OPEN',
    incidentSeverity: riskEvent.severity,
    aiAssisted: true,
    analysisSummary: `AI-assisted summary: ${riskEvent.severity} login risk detected for ${riskEvent.email || riskEvent.identityId || 'unknown identity'} because ${riskEvent.riskReasons.join(', ') || 'risk signals exceeded policy threshold'}.`,
    recommendedAction,
    evidenceContext: {
      riskScore: riskEvent.riskScore,
      riskReasons: riskEvent.riskReasons,
      sourceIp: riskEvent.sourceIp,
      userAgent: riskEvent.userAgent
    },
    createdAt: nowIso()
  };

  store.incidents.set(incident.incidentId, incident);
  return incident;
}

function getPath(req) {
  const url = new URL(req.url, `http://${req.headers.host || 'localhost'}`);
  return url.pathname.replace(/\/+$/, '') || '/';
}

async function route(req, res) {
  if (req.method === 'OPTIONS') {
    sendJson(res, 200, { ok: true });
    return;
  }

  const path = getPath(req);
  const body = req.method === 'POST' ? await collectBody(req) : {};

  if (req.method === 'GET' && path === '/health') {
    sendJson(res, 200, { status: 'UP', service: 'poc1b-login-risk-api', timestamp: nowIso() });
    return;
  }

  if (req.method === 'GET' && path === '/api/v1/identity/risk/readiness') {
    sendJson(res, 200, {
      status: 'READY',
      score: '10/10 Phase 2 API Foundation',
      service: 'POC-1B Login Risk API',
      microfunctionCount: microfunctions.length,
      capabilities: [
        'Suspicious Login Risk Review',
        'Login Failure Auto-Triage',
        'Account Lock / Unlock Human Approval',
        'Policy-Based Step-Up Authentication',
        'AI-Assisted Login Incident Analysis'
      ],
      timestamp: nowIso()
    });
    return;
  }

  if (req.method === 'GET' && path === '/api/v1/identity/risk/microfunctions') {
    sendJson(res, 200, { count: microfunctions.length, microfunctions });
    return;
  }

  if (req.method === 'POST' && path === '/api/v1/identity/risk/events') {
    const riskScore = Number(body.riskScore || 0);
    const severity = severityForScore(riskScore);
    const riskReasons = Array.isArray(body.riskReasons) ? body.riskReasons : [];

    const riskEvent = {
      riskEventId: id('risk'),
      institutionKey: body.institutionKey || 'AIRA-DEMO-INSTITUTION',
      identityId: body.identityId || null,
      email: body.email || null,
      eventType: body.eventType || 'LOGIN_ATTEMPT',
      riskScore,
      severity,
      status: riskScore >= 70 ? 'OPEN' : 'CLOSED',
      sourceIp: body.sourceIp || null,
      userAgent: body.userAgent || null,
      deviceFingerprint: body.deviceFingerprint || null,
      riskReasons,
      evidence: body.evidence || {},
      createdAt: nowIso()
    };

    const decision = policyDecisionFor({
      riskScore,
      failedAttemptsInWindow: Number(body.failedAttemptsInWindow || 0),
      locked: Boolean(body.locked)
    });

    const incident = riskScore >= 70
      ? createIncidentFromRiskEvent(riskEvent, decision.decision)
      : null;

    store.riskEvents.set(riskEvent.riskEventId, riskEvent);

    sendJson(res, 201, { riskEvent, policyDecision: decision, incident });
    return;
  }

  if (req.method === 'GET' && path === '/api/v1/identity/risk/events') {
    sendJson(res, 200, { count: store.riskEvents.size, events: Array.from(store.riskEvents.values()) });
    return;
  }

  const eventMatch = path.match(/^\/api\/v1\/identity\/risk\/events\/([^/]+)$/);
  if (req.method === 'GET' && eventMatch) {
    const event = store.riskEvents.get(eventMatch[1]);
    if (!event) {
      sendJson(res, 404, { error: 'RISK_EVENT_NOT_FOUND' });
      return;
    }
    sendJson(res, 200, event);
    return;
  }

  const eventReviewMatch = path.match(/^\/api\/v1\/identity\/risk\/events\/([^/]+)\/review$/);
  if (req.method === 'POST' && eventReviewMatch) {
    const event = store.riskEvents.get(eventReviewMatch[1]);
    if (!event) {
      sendJson(res, 404, { error: 'RISK_EVENT_NOT_FOUND' });
      return;
    }

    event.status = body.status || 'CLOSED';
    event.reviewedBy = body.reviewedBy || 'SECURITY_OFFICER';
    event.reviewDecision = body.reviewDecision || 'REVIEWED';
    event.reviewNotes = body.reviewNotes || '';
    event.reviewedAt = nowIso();

    sendJson(res, 200, { reviewed: true, riskEvent: event });
    return;
  }

  if (req.method === 'POST' && path === '/api/v1/identity/risk/login-failures/triage') {
    const failedAttempts = Number(body.failedAttemptsInWindow || 1);
    const riskScore = Math.min(100, 20 + failedAttempts * 15);
    const recommendedAction = failedAttempts >= 5 ? 'LOCK_ACCOUNT' : riskScore >= 70 ? 'STEP_UP' : 'ALLOW_RETRY';

    const triage = {
      triageId: id('triage'),
      institutionKey: body.institutionKey || 'AIRA-DEMO-INSTITUTION',
      identityId: body.identityId || null,
      email: body.email || null,
      failureCategory: body.failureCategory || 'BAD_PASSWORD',
      severity: severityForScore(riskScore),
      failedAttemptsInWindow: failedAttempts,
      recommendedAction,
      triageSummary: `Login failure triaged as ${recommendedAction} after ${failedAttempts} failed attempt(s).`,
      evidence: body.evidence || {},
      createdAt: nowIso()
    };

    store.triage.set(triage.triageId, triage);
    sendJson(res, 201, { triage });
    return;
  }

  if (req.method === 'GET' && path === '/api/v1/identity/risk/login-failures') {
    sendJson(res, 200, { count: store.triage.size, triage: Array.from(store.triage.values()) });
    return;
  }

  if (req.method === 'GET' && path === '/api/v1/identity/risk/incidents') {
    sendJson(res, 200, { count: store.incidents.size, incidents: Array.from(store.incidents.values()) });
    return;
  }

  const incidentMatch = path.match(/^\/api\/v1\/identity\/risk\/incidents\/([^/]+)$/);
  if (req.method === 'GET' && incidentMatch) {
    const incident = store.incidents.get(incidentMatch[1]);
    if (!incident) {
      sendJson(res, 404, { error: 'INCIDENT_NOT_FOUND' });
      return;
    }
    sendJson(res, 200, incident);
    return;
  }

  const lockMatch = path.match(/^\/api\/v1\/identity\/risk\/accounts\/([^/]+)\/lock$/);
  if (req.method === 'POST' && lockMatch) {
    const identityId = decodeURIComponent(lockMatch[1]);
    const lock = {
      accountLockId: id('lock'),
      institutionKey: body.institutionKey || 'AIRA-DEMO-INSTITUTION',
      identityId,
      email: body.email || null,
      lockStatus: 'LOCKED',
      lockReason: body.lockReason || 'POC1B_POLICY_RISK_THRESHOLD',
      lockSource: body.lockSource || 'POLICY',
      lockedBy: body.lockedBy || 'SYSTEM',
      lockedAt: nowIso(),
      evidence: body.evidence || {}
    };

    store.locks.set(identityId, lock);
    sendJson(res, 201, { locked: true, accountLock: lock });
    return;
  }

  if (req.method === 'GET' && path === '/api/v1/identity/risk/accounts/locked') {
    sendJson(res, 200, { count: store.locks.size, lockedAccounts: Array.from(store.locks.values()) });
    return;
  }

  const unlockRequestMatch = path.match(/^\/api\/v1\/identity\/risk\/accounts\/([^/]+)\/unlock-request$/);
  if (req.method === 'POST' && unlockRequestMatch) {
    const identityId = decodeURIComponent(unlockRequestMatch[1]);
    const lock = store.locks.get(identityId);

    if (!lock) {
      sendJson(res, 404, { error: 'ACCOUNT_LOCK_NOT_FOUND' });
      return;
    }

    const unlockRequest = {
      unlockRequestId: id('unlock'),
      accountLockId: lock.accountLockId,
      institutionKey: lock.institutionKey,
      identityId,
      requestedBy: body.requestedBy || 'SECURITY_OFFICER',
      requestStatus: 'PENDING',
      requestReason: body.requestReason || 'POC1B_UNLOCK_REVIEW',
      workflowInstanceId: id('flowable'),
      approvalRequired: true,
      createdAt: nowIso(),
      evidence: body.evidence || {}
    };

    store.unlockRequests.set(unlockRequest.unlockRequestId, unlockRequest);
    sendJson(res, 201, { unlockRequest });
    return;
  }

  const approveUnlockMatch = path.match(/^\/api\/v1\/identity\/risk\/unlock-requests\/([^/]+)\/approve$/);
  if (req.method === 'POST' && approveUnlockMatch) {
    const unlockRequest = store.unlockRequests.get(approveUnlockMatch[1]);

    if (!unlockRequest) {
      sendJson(res, 404, { error: 'UNLOCK_REQUEST_NOT_FOUND' });
      return;
    }

    unlockRequest.requestStatus = 'APPROVED';
    unlockRequest.approvedBy = body.approvedBy || 'SECURITY_OFFICER';
    unlockRequest.approvedAt = nowIso();
    unlockRequest.decisionNotes = body.decisionNotes || '';

    const lock = store.locks.get(unlockRequest.identityId);
    if (lock) {
      lock.lockStatus = 'UNLOCKED';
      lock.unlockedBy = unlockRequest.approvedBy;
      lock.unlockedAt = nowIso();
      lock.unlockReason = 'APPROVED_UNLOCK_REQUEST';
      store.locks.delete(unlockRequest.identityId);
    }

    sendJson(res, 200, { approved: true, unlockRequest, accountUnlocked: true });
    return;
  }

  const rejectUnlockMatch = path.match(/^\/api\/v1\/identity\/risk\/unlock-requests\/([^/]+)\/reject$/);
  if (req.method === 'POST' && rejectUnlockMatch) {
    const unlockRequest = store.unlockRequests.get(rejectUnlockMatch[1]);

    if (!unlockRequest) {
      sendJson(res, 404, { error: 'UNLOCK_REQUEST_NOT_FOUND' });
      return;
    }

    unlockRequest.requestStatus = 'REJECTED';
    unlockRequest.rejectedBy = body.rejectedBy || 'SECURITY_OFFICER';
    unlockRequest.rejectedAt = nowIso();
    unlockRequest.decisionNotes = body.decisionNotes || '';

    sendJson(res, 200, { rejected: true, unlockRequest, accountRemainsLocked: true });
    return;
  }

  if (req.method === 'POST' && path === '/api/v1/identity/risk/step-up/challenges') {
    const challenge = {
      challengeId: id('stepup'),
      institutionKey: body.institutionKey || 'AIRA-DEMO-INSTITUTION',
      identityId: body.identityId || null,
      email: body.email || null,
      challengeType: body.challengeType || 'LOCAL_CODE',
      challengeStatus: 'PENDING',
      localCode: body.localCode || '123456',
      attempts: 0,
      maxAttempts: 3,
      expiresAt: new Date(Date.now() + 10 * 60 * 1000).toISOString(),
      createdAt: nowIso(),
      evidence: body.evidence || {}
    };

    store.stepUpChallenges.set(challenge.challengeId, challenge);
    sendJson(res, 201, { challenge });
    return;
  }

  const verifyStepUpMatch = path.match(/^\/api\/v1\/identity\/risk\/step-up\/challenges\/([^/]+)\/verify$/);
  if (req.method === 'POST' && verifyStepUpMatch) {
    const challenge = store.stepUpChallenges.get(verifyStepUpMatch[1]);

    if (!challenge) {
      sendJson(res, 404, { error: 'STEP_UP_CHALLENGE_NOT_FOUND' });
      return;
    }

    challenge.attempts += 1;

    if (body.code === challenge.localCode) {
      challenge.challengeStatus = 'VERIFIED';
      challenge.verifiedAt = nowIso();
      sendJson(res, 200, { verified: true, allowLogin: true, challenge });
      return;
    }

    if (challenge.attempts >= challenge.maxAttempts) {
      challenge.challengeStatus = 'DENIED';
      challenge.deniedAt = nowIso();
      sendJson(res, 200, { verified: false, allowLogin: false, denied: true, challenge });
      return;
    }

    sendJson(res, 200, { verified: false, allowLogin: false, challenge });
    return;
  }

  if (req.method === 'GET' && path === '/api/v1/identity/risk/policy-decisions') {
    sendJson(res, 200, { count: store.policyDecisions.size, policyDecisions: Array.from(store.policyDecisions.values()) });
    return;
  }

  sendJson(res, 404, {
    error: 'NOT_FOUND',
    method: req.method,
    path
  });
}

const server = http.createServer((req, res) => {
  route(req, res).catch((error) => {
    sendJson(res, 500, {
      error: 'POC1B_API_ERROR',
      message: error.message
    });
  });
});

server.listen(port, '127.0.0.1', () => {
  console.log(`POC-1B login risk API listening on http://127.0.0.1:${port}`);
});