#!/usr/bin/env python3
"""Migra docs/site/content (MkDocs) a website/docs (Docusaurus). Fase 2.
- Copia .md preservando árbol; content/index.md -> docs/index.md (slug /).
- Convierte admonitions pymdownx `!!! type "title"` -> `:::type title ... :::`.
- Activos binarios (.doc/.html/.jpg/.json) -> website/static/<ruta> y links absolutos /monorepo/... .
Idempotente: regenera website/docs y website/static/docs desde cero.
"""
import re, os, shutil, sys
from pathlib import Path

REPO = Path(__file__).resolve().parents[3]
SRC = REPO / 'docs' / 'site' / 'content'
DST = REPO / 'website' / 'docs'
STATIC = REPO / 'website' / 'static' / 'docs'
BASE = '/monorepo/docs'
BIN_EXTS = {'.doc', '.html', '.jpg', '.jpeg', '.png', '.json', '.pdf', '.docx', '.xls'}

ADMON = re.compile(r'^!!! (\w+)(?:\s+"([^"]*)")?\s*$')
MD_BUTTON = re.compile(r'<a\s+href="([^"]+)"[^>]*>(.*?)</a>', re.DOTALL)
LT_DIGIT = re.compile(r'<(?=\d)')

def convert_admonitions(text: str) -> str:
    out, in_block = [], False
    for line in text.splitlines():
        m = ADMON.match(line)
        if m:
            kind, title = m.group(1), m.group(2) or ''
            out.append(f':::{kind} {title}'.rstrip())
            in_block = True
            continue
        if in_block and (line == '' or not line.startswith(' ') and not line.startswith('\t')):
            # fin del bloque: línea no indentada y no vacía... cuidado: las
            # vacías dentro del bloque se conservan; el cierre va antes de la
            # primera línea no indentada no vacía.
            if line.strip() == '':
                out.append(line)
                continue
            out.append(':::')
            in_block = False
        if in_block and (line.startswith('    ') or line.startswith('\t')):
            out.append(line[4:] if line.startswith('    ') else line[1:])
        else:
            out.append(line)
    if in_block:
        out.append(':::')
    return '\n'.join(out) + '\n'

def rewrite_asset_links(text: str, rel_dir: str) -> str:
    def repl(m):
        label, target = m.group(1), m.group(2)
        if re.match(r'https?://|#|mailto:|/|pathname:', target):
            return m.group(0)
        # resolver relativo (con .. normalizados) -> absoluto bajo /monorepo/docs/
        base = Path(rel_dir) if rel_dir else Path('.')
        norm = os.path.normpath(str(base / target)).replace('\\', '/')
        url = f'{BASE}/{norm}'
        # Assets estáticos crudos: servir literal sin procesamiento de rutas
        # (el checker no los cubre; se verifican con serve+cURL, ver tasks.md).
        # pathname:// evita el procesamiento sin relajar el gate de rutas.
        return f'[{label}](pathname://{url})'
    return re.sub(r'\[([^\]]*)\]\(([^)]+\.(?:doc|html|jpg|jpeg|png|json|pdf|docx|xls))\)', repl, text)

def main() -> None:
    shutil.rmtree(DST, ignore_errors=True)
    shutil.rmtree(STATIC, ignore_errors=True)
    n_md = n_bin = 0
    for src in sorted(SRC.rglob('*')):
        rel = src.relative_to(SRC)
        if src.is_dir():
            continue
        if src.suffix.lower() in BIN_EXTS:
            parts = list(rel.parts)
            if parts and parts[0] == 'docs':
                parts = parts[1:]
            dst = STATIC / Path(*parts)
            dst.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(src, dst)
            n_bin += 1
            continue
        if src.suffix.lower() != '.md':
            continue
        text = src.read_text(encoding='utf-8')
        # sanear caracteres de control (rompen el minificador HTML)
        text = re.sub(r'[\x00-\x08\x0b\x0c\x0e-\x1f\x7f]', '', text)
        # docs/site/content/docs/X -> website/docs/X (sin prefijo docs/ duplicado)
        parts = list(rel.parts)
        if parts and parts[0] == 'docs':
            parts = parts[1:]
        rel = Path(*parts) if parts else Path('index.md')
        rel_dir = str(rel.parent).replace('\\', '/')
        rd = '' if rel_dir == '.' else rel_dir
        text = MD_BUTTON.sub(lambda m: f"[{m.group(2).strip()}]({m.group(1)})", text)
        text = rewrite_asset_links(text, rd)
        text = LT_DIGIT.sub('&lt;', text)
        text = convert_admonitions(text)
        if rel.as_posix() == 'index.md':
            dst = DST / 'index.md'
            if not text.startswith('---'):
                text = '---\nslug: /\n---\n\n' + text
        else:
            dst = DST / rel
        dst.parent.mkdir(parents=True, exist_ok=True)
        dst.write_text(text, encoding='utf-8')
        n_md += 1
    print(f'MD={n_md} BIN={n_bin}')

if __name__ == '__main__':
    sys.exit(main())
