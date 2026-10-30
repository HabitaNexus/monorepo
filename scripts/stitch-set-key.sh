#!/bin/bash
# Stitch MCP key helper — la key de Settings (formato AQ...) expira.
# Uso:
#   ./scripts/stitch-set-key.sh <NUEVA_KEY>   # guarda + verifica
#   ./scripts/stitch-set-key.sh --check        # verifica la guardada
# La key vive SOLO en ~/.config/stitch/api_key (600). Nunca se commitea.
set -euo pipefail
KEY_FILE="$HOME/.config/stitch/api_key"

if [ "${1:-}" = "--check" ]; then
  [ -f "$KEY_FILE" ] || { echo "EXPIRED: no hay key guardada"; exit 1; }
  KEY=$(cat "$KEY_FILE")
elif [ -n "${1:-}" ]; then
  KEY="$1"
  mkdir -p "$(dirname "$KEY_FILE")"
  printf '%s' "$KEY" > "$KEY_FILE"
  chmod 600 "$KEY_FILE"
  # Fingerprint SHA256: verifica identidad sin exponer el secreto.
  # (El hash NO reemplaza el guardado: es unidireccional y la API exige el token raw.)
  printf '%s' "$KEY" | sha256sum | awk '{print $1}' > "$KEY_FILE.sha256"
  chmod 600 "$KEY_FILE.sha256"
  echo "guardada en $KEY_FILE (600) | sha256: $(cat "$KEY_FILE.sha256")"
else
  echo "Uso: $0 <STITCH_API_KEY> | $0 --check"; exit 1
fi

RESP=$(curl -s -m 20 -X POST "https://stitch.googleapis.com/mcp" \
  -H "Accept: application/json" -H "Content-Type: application/json" \
  -H "X-Goog-Api-Key: $KEY" \
  -d '{"jsonrpc":"2.0","id":1,"method":"tools/call","params":{"name":"list_projects","arguments":{}}}')

echo "$RESP" | python3 -c "
import json,sys
try:
    d = json.load(sys.stdin)
    txt = d['result']['content'][0]['text']
    n = len(json.loads(txt).get('projects', []))
    print(f'OK: conectado, {n} proyectos')
except Exception:
    print('EXPIRED: regenera en stitch.withgoogle.com/settings y corre este script con la nueva')
    sys.exit(1)
"
