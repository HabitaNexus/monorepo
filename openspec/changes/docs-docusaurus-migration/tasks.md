# Tasks — docs-docusaurus-migration (plan condicional, NO ejecutar sin re-disparo)

> Fases secuenciales. Cada tarea trae estimación (XS/S/M; nada supera M) y criterios
> de aceptación verificables por comando. Precondición global: alguna condición de
> disparo de `proposal.md` aprobada por humanos.

## Fase 0 — Decisión y baseline (S en total)

- [ ] 0.1 Registrar decisión humana de migrar + condición de disparo cumplida (S).
      AC: issue Linear con label `Human` y el disparo citado; este change desarchivado.
- [ ] 0.2 Baseline de URLs actuales: `cd docs/site && mkdocs build --strict` + crawl
      de `site/` generando `url-inventory.csv` (23 páginas + assets) (S).
      AC: build verde `--strict`; CSV con ≥23 URLs versionado en el change.

## Fase 1 — Scaffold + CI preview (M en total)

- [ ] 1.1 `npm create docusaurus@3 website classic -- --typescript` con `--prefix /tmp`
      para pruebas, luego `website/` definitivo en repo (Node 20, `npm ci` reproducible) (S).
      AC: `npm run build` verde en local; `package-lock.json` commiteado.
- [ ] 1.2 Reescribir `.github/workflows/docs.yml` a Node + deploy preview por PR
      (artefacto, sin tocar el deploy de `main` a Pages) (S).
      AC: PR de prueba genera preview; deploy de producción intacto (MkDocs).
- [ ] 1.3 Config base: `url/baseUrl/trailingSlash/editUrl`, `language es`,
      search-local ES, theme-mermaid, custom.css con paleta actual (S).
      AC: home + 1 página piloto renderizan paleta, search ES y Mermaid.

## Fase 2 — Migración de contenido (M en total)

- [ ] 2.1 Migrar 23 páginas + `_category_.json` por cuadrante + sidebar ordenado (M).
      AC: las 23 URLs piloto existen en `website/build/`; `diff` de texto sin pérdidas
      (salvo sintaxis convertida); `npm run build` sin warnings nuevos.
- [ ] 2.2 Convertir extensiones pymdownx (admonitions, details, tabs, tasklist,
      arithmatex→KaTeX, emoji) con checklist por página (M).
      AC: grep de sintaxis legacy (`!!!`, `pymdownx`, `:material:`) devuelve 0 en `website/docs/`.

## Fase 3 — API ref (S en total)

- [ ] 3.1 Trasladar `docs/api/openapi.yaml` a `website/static/openapi/` + generar
      sección API con `docusaurus-plugin-openapi-docs`; marcar `draft` hasta spec real (S).
      AC: `/docs/api/*` buildea; si el spec sigue siendo placeholder, la sección no
      aparece en sidebar público.
- [ ] 3.2 Retirar `docs/api/index.html` (Stoplight) solo tras 3.1 verde (S).
      AC: sin referencias a `unpkg`/Stoplight en el repo público; `openapi.yaml`
      tiene una sola fuente de verdad.

## Fase 4 — Redirects + preservación de URLs (S en total)

- [ ] 4.1 Tabla `redirects` (`plugin-client-redirects`) 1:1 contra `url-inventory.csv` (S).
      AC: script verifica que cada URL del inventario responde 200 o 301→200 en preview;
      0 URLs huérfanas.
- [ ] 4.2 Auditoría SEO/search: sitemap, `llms.txt` si aplica, search indexa ES (S).
      AC: sitemap contiene las 23 URLs; búsqueda de 5 términos conocidos devuelve la página esperada.

## Fase 5 — Árbol privado + cutover (S en total)

- [ ] 5.1 Gate CI anti-filtración (`docs/internal/` nunca referenciado; scan de secretos) (S).
      AC: job rojo simulado ante fixture con `password:` en `website/docs/` (test del gate).
- [ ] 5.2 Cutover: `main` despliega Docusaurus; se archiva `docs/site/` (tag `mkdocs-final`) (S).
      AC: Pages sirve Docusaurus; `mkdocs build` ya no corre en CI; rollback = revert + re-deploy.

## FUERA de alcance (no hacer en este change)

- Contenido en inglés (solo scaffolding; traducción = change aparte).
- Versionado de docs (`mike`/Docusaurus versions) sin v1 real que versionar.
- Spec OpenAPI real (viene del backend, change aparte).
- Auth/SSO para docs internas (Cloudflare Access u otro = change de infra aparte).
- Migrar `vertivolatam`/`altrupets` a Docusaurus (decisión por repo).
- Blog/changelog de producto más allá de reservar la ruta.
