const path = require('path');

const repoRoot = path.resolve(__dirname, '..', '..', '..');
const artifactRoot = process.env.POC1B_PHASE3_ARTIFACT_ROOT ||
  path.join(repoRoot, '05_Evidence', 'poc-1b-login-risk-step-up-governance', 'phase3-playwright-artifacts');

module.exports = {
  testDir: path.join(repoRoot, 'tests'),
  testMatch: ['aira-poc1b-phase3-frontend.spec.js'],
  timeout: 60000,
  fullyParallel: false,
  workers: 1,
  expect: {
    timeout: 10000
  },
  outputDir: path.join(artifactRoot, 'test-results'),
  reporter: [
    ['line'],
    ['json', { outputFile: path.join(artifactRoot, 'poc1b-phase3-playwright-results.json') }],
    ['html', { outputFolder: path.join(artifactRoot, 'playwright-report'), open: 'never' }]
  ],
  use: {
    baseURL: process.env.POC1B_PHASE3_PORTAL_BASE || 'http://127.0.0.1:9192',
    trace: 'on',
    screenshot: 'on',
    video: 'on',
    actionTimeout: 15000,
    navigationTimeout: 30000
  },
  projects: [
    {
      name: 'chromium',
      use: {
        browserName: 'chromium'
      }
    }
  ]
};