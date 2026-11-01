#!/usr/bin/env node
/**
 * check-codeowners-rot.mjs — CODEOWNERS rot detector (vendorized, lightweight).
 *
 * A CODEOWNERS rule whose pattern matches ZERO tracked files owns nobody, yet
 * still LOOKS like coverage. GitHub never warns on an unmatched pattern — it is
 * silently inert. So a rule that has rotted (e.g. a removed or renamed path, or
 * a typo'd pattern) is invisible by construction.
 *
 * This script is the GATE implementation of the `codeowners-rotation` convention
 * (shared/references/conventions/platform/codeowners-rotation). It matches patterns
 * against the tracked file list via `git ls-files` + a glob match, and flags
 * rules that own nothing. Deeper matching (e.g. a git check-ignore sandbox for
 * large repos) is a reviewed enhancement, not a baseline requirement (R4).
 *
 * Exit: 0 if every CODEOWNERS rule matches >=1 tracked file; 1 if any dead
 * rule is found (blocking, per the parent workflow — an advisory rot check is
 * the failure mode it exists to prevent).
 */

import { execFileSync } from 'node:child_process';
import { readFileSync, existsSync } from 'node:fs';

const REPO_ROOT = process.cwd();
const CO_PATH = findCodeowners(REPO_ROOT);

function findCodeowners(root) {
  for (const p of ['.github/CODEOWNERS', 'CODEOWNERS']) {
    if (existsSync(`${root}/${p}`)) return `${root}/${p}`;
  }
  return null;
}

function trackedFiles(root) {
  const out = execFileSync('git', ['-C', root, 'ls-files'], { encoding: 'utf8' });
  return out.split('\n').filter(Boolean);
}

// Minimal wildmatch: supports `*` (any chars except /), `**` (any incl /),
// `?` (single char), and trailing `/` (directory). Delegate hard cases to the
// full reference checker; this covers the common dead-rule classes (typo'd
// path, unused pattern, wrong-case).
function globToRe(pattern) {
  let p = pattern.trim();
  if (!p || p.startsWith('#') || p.startsWith('!')) return null;
  const dirOnly = p.endsWith('/');
  if (dirOnly) p = p.slice(0, -1);
  // Normalize: leading slash means anchored to root.
  const anchored = p.startsWith('/');
  if (anchored) p = p.slice(1);
  let re = p
    .replace(/[.+^${}()|[\]\\]/g, '\\$&')
    .replace(/\*\*/g, '\u0000')
    .replace(/\*/g, '[^/]*')
    .replace(/\u0000/g, '.*')
    .replace(/\?/g, '.');
  if (dirOnly) {
    // Directory pattern matches the dir prefix of any path.
    return new RegExp(`^${re}(/|$)`);
  }
  if (anchored) {
    return new RegExp(`^${re}$`);
  }
  return new RegExp(`(^|/)${re}$`);
}

function main() {
  if (!CO_PATH) {
    console.log('CODEOWNERS rot: no CODEOWNERS file found — skip.');
    process.exit(0);
  }
  const files = trackedFiles(REPO_ROOT);
  const raw = readFileSync(CO_PATH, 'utf8');
  const dead = [];
  for (const line of raw.split('\n')) {
    const trimmed = line.trim();
    if (!trimmed || trimmed.startsWith('#')) continue;
    // Split pattern from owners (first token is the pattern).
    const pattern = trimmed.split(/\s+/)[0];
    const re = globToRe(pattern);
    if (!re) continue;
    const matches = files.filter((f) => re.test(f));
    if (matches.length === 0) {
      dead.push({ pattern, line: trimmed });
    }
  }
  if (dead.length) {
    console.error('CODEOWNERS rot: dead rules (own 0 tracked files):');
    for (const d of dead) console.error(`  ${d.pattern}  ←  ${d.line}`);
    console.error(`Total: ${dead.length}`);
    process.exit(1);
  }
  console.log(`CODEOWNERS rot: OK — ${raw.split('\n').filter((l) => l.trim() && !l.trim().startsWith('#')).length} rules all own >=1 tracked file.`);
}

main();
