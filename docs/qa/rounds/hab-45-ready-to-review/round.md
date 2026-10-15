# HAB-45 — ready-to-review-mergeable preflight and assurance

Date: 2026-10-14 (America/Costa_Rica). PR: https://github.com/HabitaNexus/monorepo/pull/50

## Scope and authorization

The user explicitly selected HAB-45 / PR #50, authorized preserving this existing
PR with an exception to the protocol's 15-file limit, and prohibited merging.
This is a continuation in the already isolated worktree and branch; no user
worktree or branch was deleted. No deployment or tracker Done transition is authorized.
The PR targets develop per docs/branching.md. The legacy linear-setup.json value
main is stale for feature PRs and was not used to retarget this existing PR.

## Preflight

- GitHub PR open, ready for review, mergeable; previous head CI green.
- Linear HAB-45 already In Review, assigned to David Achoy, Type Feature / Size M / Strategy Worktree.
- Human reviewer requested: lapc506. Repo convention also assigns the PR to lapc506.
- Greptile is configured by linear-setup.json defaults.greptileReview=true. No remote verdict existed at preflight.
- No make-no-mistakes.config.json or assurance.config.json exists; default testing/security/governance required, liveness skip. No coverage delta gate is wired by this repo.
- The inherited GITHUB_TOKEN is invalid. Unsetting it for the command allows the existing Davidachoy keyring session; no global authentication config was changed.

## Implementation verification

Local read-only review found three issues, all corrected and re-reviewed:

1. Restrict token-service ingress to same-namespace backend pods with NetworkPolicy.
2. Publish health watch transitions and close streams during shutdown.
3. Fail the diagnostic whenever token-response checks fail, even on HTTP 200.

Added regressions pass. The Docker context also excludes .env*. Formatting
changes are mechanical and confined to this package to meet the new style gate.

Convention record: typescript@0.1.0, language-only (no framework child).
Pinned tools: ESLint 10.12.0, typescript-eslint 8.71.2, Prettier 3.9.10.

Local results:

- typecheck, lint, format:check, npm run build: PASS.
- npm test: 30 tests / 0 failures; npm-test.junit.xml.
- OpenSpec strict validation and dev/staging Kustomize rendering: PASS.
- npm runtime audit: 0 critical, 2 high package entries for one unpatched advisory; security-audit.json.
- New CI runs the same checks, runtime audit, and docker build. Its current-head verdict must be read from GitHub before aggregate assurance PASS.

## Security disposition

GHSA-86w9-cpqp-85rv is a node-forge signature-verification advisory inherited by
the published SDK. npm publishes node-forge 1.4.0 and reports no available fix.
No signing or signature-verification endpoint is exposed by HAB-45. It is not a
critical PR-gate finding; the auth-only scope remains unchanged. Follow-up HAB-95
is in Backlog, owned by David Achoy, with Bug / S / Explore / Security / Infra labels.
Reevaluate before enabling the signing path in HAB-47. This is not a claim that
the advisory has been fixed or that all dependency findings are zero.

## Remaining boundaries

- No live CNI enforcement or ArgoCD rollout is claimed; verify before deploying real credentials.
- Container publication and deployed Secret configuration remain deployment work.
- Current-head CI and remote Greptile verdict are required before handoff.
- Codex does not register the bundled Claude Stop hooks. A local marker or receipt alone proves no gate; verify GitHub reviews/checks directly.
