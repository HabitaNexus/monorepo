#!/usr/bin/env bash
# Valida el body de un PR contra prds-check.sh SIN pushear ni esperar al CI.
# Replica lo que hace el workflow PRDS: construye un event payload falso
# con los datos reales del PR (vía `gh api`) y corre el gate sobre él.
#
# Uso:
#   bash .github/scripts/prds-check-local.sh 18            # valida PR #18 tal cual (draft => skip)
#   bash .github/scripts/prds-check-local.sh 18 --as-ready # simula draft=false (lo que correrá al marcar ready)
#
# Requiere: gh (autenticado), jq. Exit code = el del gate (0 = pasa).

set -uo pipefail

PR="${1:-}"
AS_READY=false
[[ "${2:-}" == "--as-ready" ]] && AS_READY=true

if [[ -z "$PR" ]]; then
  echo "Uso: $0 <PR_NUMBER> [--as-ready]" >&2
  exit 2
fi

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
TMP_EVENT="$(mktemp)"
trap 'rm -f "$TMP_EVENT"' EXIT

DATA="$(gh api "repos/HabitaNexus/monorepo/pulls/${PR}" \
  --jq '{title: .title, body: .body, draft: .draft, number: .number, additions: .additions, deletions: .deletions}')"

if [[ "$AS_READY" == true ]]; then
  DATA="$(jq '.draft = false' <<<"$DATA")"
fi

jq -n --argjson pr "$DATA" '{pull_request: $pr}' > "$TMP_EVENT"

GITHUB_EVENT_PATH="$TMP_EVENT" bash "$REPO_ROOT/.github/scripts/prds-check.sh"
