const fs = require('fs');
const path = require('path');

const repoRoot = path.resolve(__dirname, '..', '..');

const localEvidenceRoot = path.join(
  repoRoot,
  '05_Evidence',
  'poc-1-identity-rbac-portal-entry',
  'playwright-heavy-simulation',
);

const validationRoot = process.env.AIRA_VALIDATION_ROOT ||
  'D:\\ChatGPT Workspace Folder Projects\\AIRA GitHub Validation\\aira_project_agents_others';

const validationEvidenceRoot = path.join(
  validationRoot,
  '05_Evidence',
  'poc-1-identity-rbac-portal-entry',
  'playwright-enterprise-validation',
);

function ensureDir(target) {
  if (!fs.existsSync(target)) {
    fs.mkdirSync(target, { recursive: true });
  }
}

function timestampForFile() {
  return new Date().toISOString().replace(/[:.]/g, '-');
}

function writeJson(filePath, payload) {
  ensureDir(path.dirname(filePath));
  fs.writeFileSync(filePath, JSON.stringify(payload, null, 2), 'utf8');
}

function appendMarkdown(filePath, lines) {
  ensureDir(path.dirname(filePath));
  fs.appendFileSync(filePath, `${lines.join('\n')}\n`, 'utf8');
}

function writeEvidence(name, payload) {
  ensureDir(localEvidenceRoot);
  ensureDir(validationEvidenceRoot);

  const fileName = `${timestampForFile()}-${name}.json`;

  const localPath = path.join(localEvidenceRoot, fileName);
  const validationPath = path.join(validationEvidenceRoot, fileName);

  const enrichedPayload = {
    ...payload,
    artifactMirror: {
      localPath,
      validationPath,
      validationRoot,
      generatedAt: new Date().toISOString(),
    },
  };

  writeJson(localPath, enrichedPayload);
  writeJson(validationPath, enrichedPayload);

  return validationPath;
}

function appendMarkdownSummary(name, lines) {
  ensureDir(localEvidenceRoot);
  ensureDir(validationEvidenceRoot);

  const localPath = path.join(localEvidenceRoot, `${name}.md`);
  const validationPath = path.join(validationEvidenceRoot, `${name}.md`);

  appendMarkdown(localPath, lines);
  appendMarkdown(validationPath, lines);

  return validationPath;
}

module.exports = {
  evidenceRoot: localEvidenceRoot,
  validationRoot,
  validationEvidenceRoot,
  writeEvidence,
  appendMarkdownSummary,
};