const path = require('path');

const repoRoot = path.resolve(__dirname, '..', '..');

const validationRoot = process.env.AIRA_VALIDATION_ROOT ||
  'D:\\ChatGPT Workspace Folder Projects\\AIRA GitHub Validation\\aira_project_agents_others';

const localLogsRoot = path.join(repoRoot, 'logs', 'playwright');
const validationLogsRoot = path.join(validationRoot, 'logs', 'playwright');

module.exports = {
  appenders: {
    console: {
      type: 'stdout',
      layout: {
        type: 'pattern',
        pattern: '%[[%d{yyyy-MM-dd hh:mm:ss.SSS}] [%p] %c -%] %m',
      },
    },
    poc1HeavyLocal: {
      type: 'dateFile',
      filename: path.join(localLogsRoot, 'poc1-heavy-simulation.log'),
      pattern: '.yyyy-MM-dd',
      keepFileExt: true,
      compress: false,
      numBackups: 14,
      layout: {
        type: 'pattern',
        pattern: '[%d{yyyy-MM-dd hh:mm:ss.SSS}] [%p] %c - %m',
      },
    },
    poc1HeavyValidation: {
      type: 'dateFile',
      filename: path.join(validationLogsRoot, 'poc1-heavy-simulation.log'),
      pattern: '.yyyy-MM-dd',
      keepFileExt: true,
      compress: false,
      numBackups: 14,
      layout: {
        type: 'pattern',
        pattern: '[%d{yyyy-MM-dd hh:mm:ss.SSS}] [%p] %c - %m',
      },
    },
    poc1JsonLocal: {
      type: 'file',
      filename: path.join(localLogsRoot, 'poc1-heavy-simulation-events.jsonl'),
      maxLogSize: 10 * 1024 * 1024,
      backups: 5,
      compress: false,
      layout: {
        type: 'messagePassThrough',
      },
    },
    poc1JsonValidation: {
      type: 'file',
      filename: path.join(validationLogsRoot, 'poc1-heavy-simulation-events.jsonl'),
      maxLogSize: 10 * 1024 * 1024,
      backups: 5,
      compress: false,
      layout: {
        type: 'messagePassThrough',
      },
    },
  },
  categories: {
    default: {
      appenders: ['console', 'poc1HeavyLocal', 'poc1HeavyValidation'],
      level: 'info',
    },
    events: {
      appenders: ['poc1JsonLocal', 'poc1JsonValidation'],
      level: 'info',
    },
  },
};