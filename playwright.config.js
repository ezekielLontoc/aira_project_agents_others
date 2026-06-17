const { defineConfig, devices } = require('@playwright/test');
const path = require('path');

const validationRoot = process.env.AIRA_VALIDATION_ROOT ||
  'D:\\ChatGPT Workspace Folder Projects\\AIRA GitHub Validation\\aira_project_agents_others';

const artifactRoot = path.join(validationRoot, 'playwright-artifacts');

module.exports = defineConfig({
  testDir: './tests',
  timeout: 180000,
  expect: {
    timeout: 20000,
  },
  fullyParallel: false,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 1 : 0,
  workers: 1,
  outputDir: path.join(artifactRoot, 'test-results'),
  reporter: [
    ['list'],
    ['html', {
      outputFolder: path.join(artifactRoot, 'playwright-report'),
      open: 'never',
    }],
    ['json', {
      outputFile: path.join(artifactRoot, 'reports', 'poc1-playwright-results.json'),
    }],
    ['junit', {
      outputFile: path.join(artifactRoot, 'reports', 'poc1-playwright-results.xml'),
    }],
  ],
  use: {
    baseURL: 'http://192.168.179.193:9090',
    trace: 'on',
    screenshot: 'on',
    video: 'on',
    actionTimeout: 45000,
    navigationTimeout: 45000,
  },
  projects: [
    {
      name: 'chromium',
      use: {
        ...devices['Desktop Chrome'],
      },
    },
  ],
});