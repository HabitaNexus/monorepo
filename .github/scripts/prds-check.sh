#!/usr/bin/env bash
# PRDS enforcement check — validates open PR descriptions against the PRDS
# standard (docs/process/pull-request-description-and-scope.md).
# Reads the GH event payload from GITHUB_EVENT_PATH; emits ::error::/::warning::
# annotations. Exits non-zero on hard violations (blocker findings).

set -uo pipefail

TITLE="$(jq -r '.pull_request.title // ""' "$GITHUB_EVENT_PATH")"
BODY="$(jq -r '.pull_request.body // ""' "$GITHUB_EVENT_PATH")"
IS_DRAFT="$(jq -r '.pull_request.draft // false' "$GITHUB_EVENT_PATH")"
PR_NUMBER="$(jq -r '.pull_request.number // ""' "$GITHUB_EVENT_PATH")"

FAIL=0

announce() {
  local level="$1" msg="$2"
  echo "::$level file=prds-check.sh,line=1,title=PRDS::${msg}"
}

if [[ "$IS_DRAFT" == "true" ]]; then
  announce "notice" "PR #${PR_NUMBER} is draft: PRDS gate skipped (draft rule)."
  exit 0
fi

# --- 1. Title template: type(scope): description (+ HAB-N when a ticket exists)
TITLE_RE='^(feat|fix|docs|chore|refactor|infra|hotfix|test|build|ci|perf|revert)(\([^)]*\))?:[[:space:]].+'
if ! [[ "$TITLE" =~ $TITLE_RE ]]; then
  announce "error" "PR title does not follow 'type(scope): description' — got: '${TITLE}'"
  FAIL=1
fi

# --- 2. Required body sections (PRDS "Resumen/Linear/Plan/Límites/Riesgo/Screenshots")
for section in "## Resumen" "## Linear" "## Plan de pruebas" "## Límites de alcance" "## Riesgo / rollout" "## Screenshots / evidencia"; do
  if ! grep -qF "$section" <<<"$BODY"; then
    announce "error" "PR body is missing required section '${section}'"
    FAIL=1
  fi
done

# --- 3. Feature/fix PRs must carry a Linear ticket (HAB-N) in the body
if [[ "$TITLE" =~ ^(feat|fix) ]]; then
  if ! grep -qiE "HAB-[0-9]+|linear\.app/habitanexus/issue/[A-Z0-9-]+" <<<"$BODY"; then
    announce "error" "feat/fix PR must reference a Linear ticket (Fixes HAB-N or linear.app URL) in the ## Linear section"
    FAIL=1
  fi
fi

# --- 4. Size gate (~400 lines total change; mechanical exceptions allowed if stated)
ADD="-1"; DEL="-1"
ADD="$(jq -r '.pull_request.additions // 0' "$GITHUB_EVENT_PATH")"
DEL="$(jq -r '.pull_request.deletions // 0' "$GITHUB_EVENT_PATH")"
TOTAL=$((ADD + DEL))
if (( TOTAL > 400 )); then
  if grep -qiE "migración mecánica|mechanical move|codegen|lockfile-only|CI green only" <<<"$BODY"; then
    announce "warning" "PR is ${TOTAL} lines (>400) but declares a mechanical exception — OK if the claim is true."
  else
    announce "warning" "PR is ${TOTAL} lines total; PRDS cap is ~400. Split it or declare a mechanical-move exception in the body."
  fi
fi

# --- 5. One-intent sanity (spot: mixed docs + code) — informational only
if grep -qiE "HAB-[0-9]+" <<<"$TITLE" && ! grep -qiE "HAB-[0-9]+" <<<"$BODY"; then
  announce "warning" "Title mentions a Linear ticket (HAB-N) but body does not; add 'Fixes HAB-N' to auto-link."
fi

if (( FAIL > 0 )); then
  echo "::group::PRDS gate failed for PR #${PR_NUMBER}"
  echo "See docs/process/pull-request-description-and-scope.md for the template. Edit the PR body or title to fix."
  echo "::endgroup::"
fi
exit "$FAIL"