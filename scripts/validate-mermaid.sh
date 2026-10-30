#!/usr/bin/env bash
# validate-mermaid.sh — shared Mermaid validator (PCH).
# Usage: bash scripts/validate-mermaid.sh [docs-dir]
set -euo pipefail
DOCS_DIR="${1:-docs}"
WARNINGS=0
MD_FILES=$(grep -rl '```mermaid' "$DOCS_DIR" 2>&1 | grep -v '^grep:' || true)
for file in $MD_FILES; do
  awk '/```mermaid/,/```/' "$file" | while read -r line; do
    if printf '%s\n' "$line" | grep -qE '(^|\[)[^]]*(🛡|🏗|📱|💻|🔒|🚀|📦|⚙|💾|☁|🚪|🎨|👥|🔌|📋|🏛|❌|✅)'; then
      echo "WARNING: emoji in $file: $line"; WARNINGS=$((WARNINGS+1))
    fi
    if printf '%s\n' "$line" | grep -q '|' && ! printf '%s\n' "$line" | grep -qE '^\|.*\|$|subgraph|end|style |linkStyle'; then
      echo "WARNING: unescaped pipe in $file: $line"; WARNINGS=$((WARNINGS+1))
    fi
  done
done
[ "$WARNINGS" -gt 0 ] && echo "Mermaid: $WARNINGS warnings (non-blocking)"
exit 0
