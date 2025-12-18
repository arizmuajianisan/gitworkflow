#!/usr/bin/env node

'use strict';

const { spawnSync } = require('node:child_process');
const fs = require('node:fs');
const path = require('node:path');

function fileExists(p) {
  try {
    fs.accessSync(p, fs.constants.F_OK);
    return true;
  } catch {
    return false;
  }
}

function run(cmd, args, options) {
  const res = spawnSync(cmd, args, {
    stdio: 'inherit',
    shell: false,
    ...options,
  });

  if (res.error) {
    throw res.error;
  }

  process.exitCode = typeof res.status === 'number' ? res.status : 1;
}

function main() {
  const pkgRoot = path.resolve(__dirname, '..');
  const bashScript = path.join(pkgRoot, 'scripts', 'gitworkflow.sh');

  // Debug logging
  console.error('[DEBUG] pkgRoot:', pkgRoot);
  console.error('[DEBUG] bashScript:', bashScript);
  console.error('[DEBUG] File exists:', fileExists(bashScript));

  if (!fileExists(bashScript)) {
    console.error('[ERROR] Missing scripts/gitworkflow.sh in installed package.');
    console.error('Reinstall or report this issue to the package maintainer.');
    process.exit(1);
  }

  const argv = process.argv.slice(2);

  // Prefer an explicit bash executable if available.
  // On Windows, users typically have Git Bash (bash.exe) or WSL.
  // We try bash first; if missing, show a helpful message.
  const bashCmd = process.platform === 'win32' ? 'bash.exe' : 'bash';

  // Convert Windows path to Unix-style path for bash on Windows
  const bashScriptPath = process.platform === 'win32' 
    ? bashScript.replace(/\\/g, '/').replace(/^([A-Z]):/, (_, drive) => `/${drive.toLowerCase()}`)
    : bashScript;

  try {
    run(bashCmd, [bashScriptPath, ...argv], { cwd: process.cwd() });
  } catch (err) {
    const msg = err && err.message ? err.message : String(err);

    if (process.platform === 'win32') {
      console.error('[ERROR] Unable to execute bash.');
      console.error('This tool requires a bash environment on Windows (Git Bash, MSYS2, or WSL).');
      console.error('Install Git for Windows and ensure bash.exe is in PATH, then retry.');
      console.error('Details:', msg);
    } else {
      console.error('[ERROR] Unable to execute bash:', msg);
    }
    process.exit(1);
  }
}

main();
