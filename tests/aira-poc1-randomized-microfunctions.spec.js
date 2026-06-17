const { test, expect } = require('@playwright/test');

const {
  config,
  logger,
  emitEvent,
  expectOkResponse,
  getJson,
} = require('./support/aira-runtime');

const {
  writeEvidence,
  appendMarkdownSummary,
} = require('./support/evidence-writer');

test.describe.configure({ mode: 'serial' });

function randomConfig() {
  return {
    rounds: Number(process.env.AIRA_RANDOM_MICROFUNCTION_ROUNDS || 12),
    probesPerRound: Number(process.env.AIRA_RANDOM_MICROFUNCTION_PROBES_PER_ROUND || 18),
  };
}

function shuffle(array) {
  const copy = [...array];

  for (let i = copy.length - 1; i > 0; i -= 1) {
    const j = Math.floor(Math.random() * (i + 1));
    const temp = copy[i];
    copy[i] = copy[j];
    copy[j] = temp;
  }

  return copy;
}

function expectedIdentityKeys() {
  return Array.from({ length: 58 }).map((_, index) => {
    return `MF-IDENTITY-${String(index + 1).padStart(3, '0')}`;
  });
}

function normalizeItems(body) {
  return Array.isArray(body)
    ? body
    : body.microfunctions || body.items || [];
}

function extractKey(item) {
  return item.key || item.microfunctionKey || item.microfunction_key;
}

test.describe('AIRA POC-1 Randomized Microfunction Enterprise Simulation', () => {
  const rconfig = randomConfig();

  test.beforeAll(async () => {
    logger.info('============================================================');
    logger.info('AIRA POC-1 Randomized Microfunction Enterprise Simulation starting');
    logger.info(`Identity base URL: ${config.identityBaseUrl}`);
    logger.info(`Random rounds: ${rconfig.rounds}`);
    logger.info(`Probes per round: ${rconfig.probesPerRound}`);
    logger.info('============================================================');

    emitEvent('random_microfunction_suite_start', {
      identityBaseUrl: config.identityBaseUrl,
      rounds: rconfig.rounds,
      probesPerRound: rconfig.probesPerRound,
    });
  });

  test.afterAll(async () => {
    emitEvent('random_microfunction_suite_complete', {
      completedAt: new Date().toISOString(),
    });

    logger.info('AIRA POC-1 Randomized Microfunction Enterprise Simulation complete');
  });

  test('01 ordered MF-IDENTITY-001 through MF-IDENTITY-058 catalog verification', async ({ request }) => {
    const response = await getJson(
      request,
      `${config.identityBaseUrl}/api/v1/identity/microfunctions`,
    );

    await expectOkResponse(response, 'identity microfunction catalog ordered verification');

    const body = await response.json();
    const items = normalizeItems(body);
    const keys = items.map(extractKey).filter(Boolean);

    const expected = expectedIdentityKeys();
    const missing = expected.filter((key) => !keys.includes(key));

    expect(items.length).toBeGreaterThanOrEqual(58);
    expect(missing, `Missing microfunction keys: ${missing.join(', ')}`).toEqual([]);

    for (const expectedKey of expected) {
      expect(keys).toContain(expectedKey);
    }

    const evidencePath = writeEvidence('randomized-mf-ordered-full-catalog-verification', {
      status: 'PASSED',
      mode: 'ORDERED',
      expectedCount: expected.length,
      actualCount: items.length,
      firstExpected: expected[0],
      lastExpected: expected[expected.length - 1],
      missing,
    });

    appendMarkdownSummary('POC-1 Randomized Microfunction Enterprise Summary', [
      '',
      '---',
      '',
      `## Ordered Microfunction Verification - ${new Date().toISOString()}`,
      '',
      'Status: PASSED',
      '',
      `- Expected keys: ${expected.length}`,
      `- Actual catalog count: ${items.length}`,
      `- First key: ${expected[0]}`,
      `- Last key: ${expected[expected.length - 1]}`,
      `- Evidence JSON: ${evidencePath}`,
    ]);

    logger.info(`Ordered microfunction verification evidence written: ${evidencePath}`);
  });

  test('02 randomized microfunction probe matrix validates unique shuffled probes', async ({ request }) => {
    const expected = expectedIdentityKeys();
    const rounds = [];
    const globallySeen = new Set();

    for (let round = 1; round <= rconfig.rounds; round += 1) {
      const response = await getJson(
        request,
        `${config.identityBaseUrl}/api/v1/identity/microfunctions`,
      );

      await expectOkResponse(response, `identity microfunction catalog randomized round ${round}`);

      const body = await response.json();
      const items = normalizeItems(body);
      const keys = items.map(extractKey).filter(Boolean);

      const missing = expected.filter((key) => !keys.includes(key));
      expect(missing, `Round ${round} missing keys: ${missing.join(', ')}`).toEqual([]);

      const shuffled = shuffle(expected);
      const probes = shuffled.slice(0, Math.min(rconfig.probesPerRound, shuffled.length));

      for (const key of probes) {
        expect(keys, `Round ${round} expected randomized key ${key}`).toContain(key);
        globallySeen.add(key);
      }

      rounds.push({
        round,
        catalogCount: items.length,
        probes,
        probeCount: probes.length,
      });

      emitEvent('random_microfunction_round_passed', {
        round,
        probes,
        probeCount: probes.length,
      });

      logger.info(`Random microfunction round ${round}/${rconfig.rounds} passed with ${probes.length} probes`);
    }

    const coveragePercent = Number(((globallySeen.size / expected.length) * 100).toFixed(2));

    expect(globallySeen.size).toBeGreaterThanOrEqual(
      Math.min(expected.length, rconfig.probesPerRound),
    );

    const evidencePath = writeEvidence('randomized-mf-probe-matrix', {
      status: 'PASSED',
      mode: 'RANDOMIZED',
      expectedKeyCount: expected.length,
      rounds: rconfig.rounds,
      probesPerRound: rconfig.probesPerRound,
      totalProbeExecutions: rounds.reduce((sum, item) => sum + item.probeCount, 0),
      uniqueKeysSeen: globallySeen.size,
      coveragePercent,
      rounds,
    });

    appendMarkdownSummary('POC-1 Randomized Microfunction Enterprise Summary', [
      '',
      '---',
      '',
      `## Randomized Microfunction Probe Matrix - ${new Date().toISOString()}`,
      '',
      'Status: PASSED',
      '',
      `- Random rounds: ${rconfig.rounds}`,
      `- Probes per round: ${rconfig.probesPerRound}`,
      `- Total probe executions: ${rounds.reduce((sum, item) => sum + item.probeCount, 0)}`,
      `- Unique MF keys seen: ${globallySeen.size}`,
      `- Coverage percent: ${coveragePercent}`,
      `- Evidence JSON: ${evidencePath}`,
    ]);

    logger.info(`Randomized microfunction probe matrix evidence written: ${evidencePath}`);
  });

  test('03 randomized microfunction full shuffled-order verification validates all keys multiple times', async ({ request }) => {
    const expected = expectedIdentityKeys();
    const rounds = [];

    for (let round = 1; round <= rconfig.rounds; round += 1) {
      const response = await getJson(
        request,
        `${config.identityBaseUrl}/api/v1/identity/microfunctions`,
      );

      await expectOkResponse(response, `identity microfunction full shuffled round ${round}`);

      const body = await response.json();
      const items = normalizeItems(body);
      const keys = items.map(extractKey).filter(Boolean);
      const shuffledFullOrder = shuffle(expected);

      for (const key of shuffledFullOrder) {
        expect(keys, `Full randomized round ${round} expected ${key}`).toContain(key);
      }

      rounds.push({
        round,
        catalogCount: items.length,
        shuffledFirstTen: shuffledFullOrder.slice(0, 10),
        shuffledLastTen: shuffledFullOrder.slice(-10),
        verifiedKeyCount: shuffledFullOrder.length,
      });

      emitEvent('random_microfunction_full_shuffle_round_passed', {
        round,
        verifiedKeyCount: shuffledFullOrder.length,
      });

      logger.info(`Full shuffled microfunction round ${round}/${rconfig.rounds} passed`);
    }

    const totalAssertions = rounds.reduce((sum, item) => sum + item.verifiedKeyCount, 0);

    const evidencePath = writeEvidence('randomized-mf-full-shuffled-order-verification', {
      status: 'PASSED',
      mode: 'FULL_SHUFFLED_ORDER',
      rounds: rconfig.rounds,
      expectedKeyCount: expected.length,
      totalKeyAssertions: totalAssertions,
      rounds,
    });

    appendMarkdownSummary('POC-1 Randomized Microfunction Enterprise Summary', [
      '',
      '---',
      '',
      `## Full Shuffled Microfunction Verification - ${new Date().toISOString()}`,
      '',
      'Status: PASSED',
      '',
      `- Rounds: ${rconfig.rounds}`,
      `- Keys verified each round: ${expected.length}`,
      `- Total key assertions: ${totalAssertions}`,
      `- Evidence JSON: ${evidencePath}`,
    ]);

    logger.info(`Full shuffled microfunction verification evidence written: ${evidencePath}`);
  });
});