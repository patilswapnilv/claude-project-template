#!/usr/bin/env node
// SPDX-License-Identifier: GPL-3.0-only
/**
 * claude-project-template CLI
 * Usage: npx claude-project-template [profile] [--target <path>] [--dry-run] [--yes]
 *
 * Zero external dependencies — pure Node.js stdlib only.
 */

'use strict';

const fs = require('fs');
const path = require('path');
const readline = require('readline');

// ─── ANSI colors ───────────────────────────────────────────────────────────
const c = {
  reset: '\x1b[0m',
  bold: '\x1b[1m',
  red: '\x1b[31m',
  green: '\x1b[32m',
  yellow: '\x1b[33m',
  blue: '\x1b[34m',
  cyan: '\x1b[36m',
};

const ok = (msg) => console.log(`${c.green}✓${c.reset} ${msg}`);
const warn = (msg) => console.log(`${c.yellow}⚠${c.reset} ${msg}`);
const err = (msg) => console.error(`${c.red}✗${c.reset} ${msg}`);
const header = (msg) => console.log(`\n${c.bold}${c.blue}${msg}${c.reset}`);
const info = (msg) => console.log(`  ${msg}`);

// ─── Resolve template root ─────────────────────────────────────────────────
// Works both from npx (installed in node_modules) and local clone
const TEMPLATE_ROOT = path.resolve(__dirname, '..');
const PROFILE_CONFIG_PATH = path.join(TEMPLATE_ROOT, 'config', 'profiles.json');

// ─── Parse CLI args ────────────────────────────────────────────────────────
const args = process.argv.slice(2);
const flags = {
  dryRun: args.includes('--dry-run'),
  yes: args.includes('--yes') || args.includes('-y'),
  help: args.includes('--help') || args.includes('-h'),
  target: null,
  profile: null,
};

for (let i = 0; i < args.length; i++) {
  if (args[i] === '--target' && args[i + 1]) {
    flags.target = path.resolve(args[i + 1]);
    i++;
  } else if (!args[i].startsWith('--') && !args[i].startsWith('-')) {
    // First non-flag arg is the profile
    if (!flags.profile) flags.profile = args[i];
  }
}

// ─── Help ──────────────────────────────────────────────────────────────────
if (flags.help) {
  console.log(`
${c.bold}claude-project-template${c.reset}

Stop re-explaining your stack to Claude every session.

${c.bold}Usage:${c.reset}
  npx claude-project-template                    Interactive setup
  npx claude-project-template nextjs             Skip profile selection
  npx claude-project-template go-service --target ./myapp
  npx claude-project-template --yes              Non-interactive (use defaults)
  npx claude-project-template --dry-run          Preview what would be installed

${c.bold}Profiles:${c.reset}
  nextjs          Next.js 13+ with App Router
  go-service      Go service or CLI
  python-data     Python data pipeline or script
  react-native    React Native mobile app
  fullstack-saas  Fullstack SaaS (multi-concern)
  none            Base only

${c.bold}Options:${c.reset}
  --target <path>   Install to this directory (default: current directory)
  --yes, -y         Non-interactive, accept all defaults
  --dry-run         Show what would happen without doing anything
  --help, -h        Show this help
`);
  process.exit(0);
}

// ─── Available profiles ────────────────────────────────────────────────────
function loadProfiles() {
  try {
    const parsed = JSON.parse(fs.readFileSync(PROFILE_CONFIG_PATH, 'utf8'));
    return Object.entries(parsed).map(([key, profile]) => ({ key, ...profile }));
  } catch (error) {
    err(`Failed to load profile config from ${PROFILE_CONFIG_PATH}: ${error.message}`);
    process.exit(1);
  }
}

const PROFILES = loadProfiles();

// ─── Readline helper ───────────────────────────────────────────────────────
function createRL() {
  return readline.createInterface({ input: process.stdin, output: process.stdout });
}

async function ask(rl, question, defaultVal = '') {
  return new Promise((resolve) => {
    const prompt = defaultVal ? `${c.bold}${question}${c.reset} [${defaultVal}] ` : `${c.bold}${question}${c.reset} `;
    rl.question(prompt, (answer) => resolve(answer.trim() || defaultVal));
  });
}

async function askChoice(rl, question, choices) {
  return new Promise((resolve) => {
    console.log(`\n${c.bold}${question}${c.reset}`);
    choices.forEach((choice, i) => {
      console.log(`  ${c.cyan}${i + 1})${c.reset} ${choice.label}`);
    });
    rl.question(`\n${c.bold}Select [1-${choices.length}]:${c.reset} `, (answer) => {
      const idx = parseInt(answer, 10) - 1;
      if (idx >= 0 && idx < choices.length) {
        resolve(choices[idx]);
      } else {
        warn(`Invalid choice "${answer}", using 1`);
        resolve(choices[0]);
      }
    });
  });
}

// ─── File operations ───────────────────────────────────────────────────────
function copyDir(src, dest) {
  if (!fs.existsSync(src)) return;
  if (!fs.existsSync(dest)) fs.mkdirSync(dest, { recursive: true });
  for (const entry of fs.readdirSync(src, { withFileTypes: true })) {
    const srcPath = path.join(src, entry.name);
    const destPath = path.join(dest, entry.name);
    if (entry.isDirectory()) {
      copyDir(srcPath, destPath);
    } else {
      fs.copyFileSync(srcPath, destPath);
    }
  }
}

function fillPlaceholders(filePath, replacements) {
  if (!fs.existsSync(filePath)) return;
  let content = fs.readFileSync(filePath, 'utf8');
  for (const [key, val] of Object.entries(replacements)) {
    content = content.replaceAll(key, val);
  }
  fs.writeFileSync(filePath, content);
}

function appendGitignore(targetDir, entry) {
  const gitignorePath = path.join(targetDir, '.gitignore');
  if (fs.existsSync(gitignorePath)) {
    const current = fs.readFileSync(gitignorePath, 'utf8');
    if (!current.includes(entry)) {
      fs.appendFileSync(gitignorePath, `\n# Claude Code personal overrides\n${entry}\n`);
    }
  } else {
    fs.writeFileSync(gitignorePath, `${entry}\n`);
  }
}

function setExecutable(filePath) {
  try {
    fs.chmodSync(filePath, '755');
  } catch {
    // Windows — skip silently
  }
}

// ─── Main ──────────────────────────────────────────────────────────────────
async function main() {
  console.log(`\n${c.bold}${c.blue}claude-project-template${c.reset} — Claude Code project setup\n`);

  if (flags.dryRun) {
    warn('DRY RUN — no files will be written\n');
  }

  const rl = flags.yes ? null : createRL();

  // ── Target directory ───────────────────────────────────────────────────
  let targetDir = flags.target || process.cwd();

  if (!flags.yes && !flags.target && rl) {
    const input = await ask(rl, 'Target project directory:', targetDir);
    targetDir = path.resolve(input);
  }

  if (!fs.existsSync(targetDir)) {
    err(`Directory does not exist: ${targetDir}`);
    if (rl) rl.close();
    process.exit(1);
  }

  // ── Guard against overwriting ──────────────────────────────────────────
  const hasExisting = fs.existsSync(path.join(targetDir, 'CLAUDE.md')) ||
                      fs.existsSync(path.join(targetDir, '.claude'));

  if (hasExisting && !flags.yes) {
    warn('CLAUDE.md or .claude/ already exists in target.');
    const answer = await ask(rl, 'Overwrite? (y/N):', 'n');
    if (!['y', 'yes'].includes(answer.toLowerCase())) {
      info('Aborted.');
      rl.close();
      process.exit(0);
    }
  }

  header('Project details');

  // ── Project info ───────────────────────────────────────────────────────
  const projectName = flags.yes
    ? path.basename(targetDir)
    : await ask(rl, 'Project name:', path.basename(targetDir));

  const projectDesc = flags.yes
    ? 'A project using claude-project-template'
    : await ask(rl, 'One-line description:');

  const projectStatus = flags.yes
    ? 'active'
    : await ask(rl, 'Status (active/maintenance/greenfield):', 'active');

  // ── Profile selection ──────────────────────────────────────────────────
  header('Stack profile');

  let selectedProfile;
  if (flags.profile) {
    selectedProfile = PROFILES.find(p => p.key === flags.profile);
    if (!selectedProfile) {
      warn(`Unknown profile "${flags.profile}", falling back to "none"`);
      selectedProfile = PROFILES.find(p => p.key === 'none');
    }
    info(`Using profile: ${selectedProfile.label}`);
  } else if (flags.yes) {
    selectedProfile = PROFILES.find(p => p.key === 'none');
  } else {
    selectedProfile = await askChoice(rl, 'Select your stack:', PROFILES);
  }

  // ── Commands ───────────────────────────────────────────────────────────
  header('Commands');

  const devCmd = flags.yes ? selectedProfile.devCmd : await ask(rl, 'Dev command:', selectedProfile.devCmd);
  const buildCmd = flags.yes ? selectedProfile.buildCmd : await ask(rl, 'Build command:', selectedProfile.buildCmd);
  const testCmd = flags.yes ? selectedProfile.testCmd : await ask(rl, 'Test command:', selectedProfile.testCmd);
  const lintCmd = flags.yes ? selectedProfile.lintCmd : await ask(rl, 'Lint command:', selectedProfile.lintCmd);
  const typecheckCmd = flags.yes ? selectedProfile.typecheckCmd : await ask(rl, 'Typecheck command:', selectedProfile.typecheckCmd);

  if (rl) rl.close();

  // ── Install ────────────────────────────────────────────────────────────
  header('Installing');

  const baseDir = path.join(TEMPLATE_ROOT, 'base');

  if (!flags.dryRun) {
    // Copy .claude/
    copyDir(path.join(baseDir, '.claude'), path.join(targetDir, '.claude'));
    ok('Copied base .claude/');

    // Copy CLAUDE.md
    fs.copyFileSync(path.join(baseDir, 'CLAUDE.md'), path.join(targetDir, 'CLAUDE.md'));
    ok('Copied CLAUDE.md');

    // Copy CLAUDE.local.md.example → CLAUDE.local.md
    fs.copyFileSync(
      path.join(baseDir, 'CLAUDE.local.md.example'),
      path.join(targetDir, 'CLAUDE.local.md')
    );
    ok('Created CLAUDE.local.md (your personal overrides — gitignored)');

    // Merge profile
    const profileDir = path.join(TEMPLATE_ROOT, 'profiles', selectedProfile.key, '.claude');
    if (selectedProfile.key !== 'none' && fs.existsSync(profileDir)) {
      if (fs.existsSync(path.join(profileDir, 'rules'))) {
        copyDir(path.join(profileDir, 'rules'), path.join(targetDir, '.claude', 'rules'));
        ok(`Merged ${selectedProfile.key} rules`);
      }
      if (fs.existsSync(path.join(profileDir, 'skills'))) {
        copyDir(path.join(profileDir, 'skills'), path.join(targetDir, '.claude', 'skills'));
        ok(`Merged ${selectedProfile.key} skills`);
      }
    }

    // Fill CLAUDE.md placeholders
    fillPlaceholders(path.join(targetDir, 'CLAUDE.md'), {
      '{{PROJECT_NAME}}': projectName,
      '{{ONE_LINE_DESCRIPTION}}': projectDesc || 'A software project',
      '{{active | maintenance | greenfield}}': projectStatus,
      '{{DEV_COMMAND}}': devCmd,
      '{{BUILD_COMMAND}}': buildCmd,
      '{{TEST_COMMAND}}': testCmd,
      '{{LINT_COMMAND}}': lintCmd,
      '{{TYPECHECK_COMMAND}}': typecheckCmd,
      '{{LIST_YOUR_STACK_HERE}}': selectedProfile.label,
    });
    ok('Filled placeholders in CLAUDE.md');

    // Fill placeholders in hooks
    const hooksDir = path.join(targetDir, '.claude', 'hooks');
    if (fs.existsSync(hooksDir)) {
      for (const file of fs.readdirSync(hooksDir)) {
        const fp = path.join(hooksDir, file);
        fillPlaceholders(fp, {
          '{{TEST_COMMAND}}': testCmd,
          '{{LINT_COMMAND}}': lintCmd,
        });
        setExecutable(fp);
      }
      ok('Set hook permissions');
    }

    // Fill placeholders in commands
    const commandsDir = path.join(targetDir, '.claude', 'commands');
    if (fs.existsSync(commandsDir)) {
      for (const file of fs.readdirSync(commandsDir)) {
        fillPlaceholders(path.join(commandsDir, file), {
          '{{TEST_COMMAND}}': testCmd,
          '{{LINT_COMMAND}}': lintCmd,
          '{{BUILD_COMMAND}}': buildCmd,
          '{{TYPECHECK_COMMAND}}': typecheckCmd,
        });
      }
    }

    // Update .gitignore
    appendGitignore(targetDir, 'CLAUDE.local.md');
    ok('Added CLAUDE.local.md to .gitignore');

  } else {
    info(`Would install to: ${targetDir}`);
    info(`Profile: ${selectedProfile.label}`);
    info(`Project: ${projectName}`);
    info(`Commands: dev="${devCmd}" test="${testCmd}" lint="${lintCmd}"`);
  }

  // ── Done ───────────────────────────────────────────────────────────────
  header('Done! ✨');
  console.log('');
  console.log(`${c.bold}Next steps:${c.reset}`);
  console.log(`  1. Open ${path.relative(process.cwd(), path.join(targetDir, 'CLAUDE.md'))} and fill in remaining {{PLACEHOLDER}} values`);
  console.log(`  2. Edit CLAUDE.local.md with your personal preferences`);
  console.log(`  3. Review .claude/settings.json — adjust allow/deny list for your stack`);
  console.log(`  4. Run: cp global/CLAUDE.md ~/.claude/CLAUDE.md (your global preferences, do once)`);
  console.log(`  5. Open Claude Code in ${targetDir} and start building`);
  console.log('');
  console.log(`Profile installed: ${selectedProfile.label}`);
  console.log('');
}

main().catch((e) => {
  err(`Unexpected error: ${e.message}`);
  process.exit(1);
});
