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

## Assurance triage and QA manifest

Pre-builder testing, security and governance: PASS for bfbd328337179e6a02e72d0b97c6cc29722afcb2.
CI https://github.com/HabitaNexus/monorepo/actions/runs/38688481223 passed typecheck, ESLint, Prettier, all 30 tests, build, runtime audit and Docker image construction. Coverage delta is not measured by this repo. Liveness is SKIP by the default PR profile. The unpatched high advisory is tracked in HAB-95.

The user selected apps/hacienda-sidecar/e2e/test-suite.json with the existing Node runner, screen reporting and this existing Markdown round. The manifest was generated from the testing pillar output and all 10 normative OpenSpec scenarios. Its IDs, references, coverage groups, denormalized fields and counts were validated. The manifest does not execute stage tests. No assurance:e2e-test-runner or preview was run.

| ID | Scenario | Coverage | Runner | Priority |
| --- | --- | --- | --- | --- |
| TC-001 | Successful sandbox handshake | HAPPY PATH | node-test | High |
| TC-002 | Issued IDP username | HAPPY PATH | node-test | High |
| TC-003 | Rejected credentials | ERROR | node-test | High |
| TC-004 | Token near expiry | EDGE CASES | node-test | High |
| TC-005 | Missing password | SECURITY | node-test | High |
| TC-006 | Sandbox configuration | HAPPY PATH | node-test | High |
| TC-007 | Production configuration | HAPPY PATH | node-test | High |
| TC-008 | Unrelated pod requests a token | SECURITY | manual-stage | High |
| TC-009 | Authentication health changes | EDGE CASES | node-test | High |
| TC-010 | Invalid successful HTTP response | ERROR | node-test | High |

Counts: 10 cases; 9 node-test / 1 manual-stage; 4 happy path / 2 error / 2 edge cases / 2 security. Use `jq ".test_cases[] | {id,title,runners:.project.runners}" apps/hacienda-sidecar/e2e/test-suite.json` to inspect the matrix. Stage CNI and ArgoCD evidence remain pending. Remote review and current-head CI must be verified after the manifest push.
