#!/usr/bin/env node

const http = require('http');
const fs = require('fs');
const path = require('path');

const args = process.argv.slice(2);
let port = 9192;
let root = process.cwd();

for (let i = 0; i < args.length; i += 1) {
  if (args[i] === '--port' && args[i + 1]) {
    port = Number(args[i + 1]);
  }

  if (args[i] === '--root' && args[i + 1]) {
    root = args[i + 1];
  }
}

const contentTypes = {
  '.html': 'text/html; charset=utf-8',
  '.js': 'application/javascript; charset=utf-8',
  '.css': 'text/css; charset=utf-8',
  '.json': 'application/json; charset=utf-8',
  '.txt': 'text/plain; charset=utf-8'
};

function send(res, statusCode, body, contentType) {
  res.writeHead(statusCode, {
    'content-type': contentType || 'text/plain; charset=utf-8',
    'cache-control': 'no-store',
    'access-control-allow-origin': '*'
  });
  res.end(body);
}

const server = http.createServer((req, res) => {
  try {
    const url = new URL(req.url, `http://${req.headers.host || 'localhost'}`);
    let pathname = decodeURIComponent(url.pathname);

    if (pathname === '/' || pathname === '') {
      pathname = '/security-login-risk-dashboard.html';
    }

    const resolved = path.resolve(root, '.' + pathname);

    if (!resolved.startsWith(path.resolve(root))) {
      send(res, 403, 'Forbidden');
      return;
    }

    if (!fs.existsSync(resolved) || !fs.statSync(resolved).isFile()) {
      send(res, 404, 'Not found');
      return;
    }

    const ext = path.extname(resolved).toLowerCase();
    const content = fs.readFileSync(resolved);
    send(res, 200, content, contentTypes[ext] || 'application/octet-stream');
  } catch (error) {
    send(res, 500, error.message);
  }
});

server.listen(port, '127.0.0.1', () => {
  console.log(`POC-1B portal server listening on http://127.0.0.1:${port}`);
  console.log(`Root: ${root}`);
});