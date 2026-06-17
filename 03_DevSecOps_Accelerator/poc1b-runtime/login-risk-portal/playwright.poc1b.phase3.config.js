const path = require('path');

const artifactRoot = process.env.POC1B_PHASE3_ARTIFACT_ROOT || path.join(process.cwd(), '05_Evidence', 'poc-1b-login-risk-step-up-governance', 'phase3-playwright-artifacts');

module.exports = {
  testDir: path.join(process.cwd(), 'tests'),
  timeout: 60000,
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