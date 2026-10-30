# Proposal — docs-docusaurus-migration (SPIKE, no implementa)

## Contexto verificado (2026-09-28, rama `spike/docs-docusaurus` desde `origin/develop`)

- Sitio público: MkDocs Material (`docs/site/mkdocs.yml`, `language: es`,
  `site_url: https://habitanexus.github.io/monorepo/`), contenido en
  `docs/site/content/` — **23 páginas `.md`**, cuadrantes Diátaxis parciales
  (`docs/{tutorials,how-to,reference,explanation}/` + `index.md`).
- Deploy: `.github/workflows/docs.yml` → `pip install -r docs/site/requirements.txt`
  → `mkdocs build` → `upload-pages-artifact(path: docs/site/site)` → GitHub Pages.
- API ref separada: `docs/api/index.html` (Stoplight Elements vía CDN unpkg) +
  `docs/api/openapi.yaml` (**placeholder OpenAPI 3.1.0, 65 líneas, solo `GET /health`**,
  sin link desde el nav MkDocs).
- Interno: `docs/internal/{tutorials,how-to,reference,explanation}/` casi vacío
  (solo `explanation/infra/` tiene contenido), nunca en nav público.
- Vecinos verificados en disco (no asumidos):
  - `vertivolatam/monorepo/docs/` → MkDocs (Zensical/Material, `docs_dir: content`,
    `site_dir: site`) + `docs/api/{index.html,openapi.yaml,README.md}` (mismo patrón Stoplight).
  - `altrupets/monorepo/docs/` → MkDocs Material (`docs_dir: content`, `site_dir: site`).
  - `chimeranext/website` → Astro 5.18.2 + React + Tailwind (**marketing site, no Starlight**).
  - **Docusaurus no existe en ningún repo hermano.**
- Versiones verificadas vía `npm view` (sin instalar nada): `@docusaurus/core 3.10.2`,
  `docusaurus-plugin-openapi-docs 5.2.0` (peer `@docusaurus/* ^3.10.0`, compatible),
  `redocusaurus 2.5.2`, `@easyops-cn/docusaurus-search-local 0.55.3`.

## Alcance de este spike

Responder con evidencia: ¿migrar `docs/site` (+ `docs/api`) a Docusaurus v3?
Entregables: `proposal.md` (este archivo), `design.md` (arquitectura destino),
`tasks.md` (plan por fases con aceptación verificable). **Ningún cambio de código
fuera de `openspec/changes/docs-docusaurus-migration/`.**

## Alternativas evaluadas

### A. Quedarse en MkDocs Material (recomendada)

Pros:

- Costo cero: 23 páginas, CI verde, search ES nativo, Mermaid ya funciona
  (superfences + `javascripts/mermaid-init.mjs`), theming custom
  (`stylesheets/habitanexus.css`), `language: es`.
- Conocimiento compartido: los dos monorepos vecinos usan el mismo stack
  (misma forma de `mkdocs.yml`, mismos plugins); cualquier mejora se replica.
- El 80% del gap percibido se cierra incrementalmente (ver `design.md` §8).

Contras:

- API ref vive fuera del sitio (Stoplight standalone, sin search unificada).
- Versionado de docs débil (plugin `mike` existe pero no configurado).
- i18n real requiere `mkdocs-static-i18n`; MDX/React no disponibles.

### B. Migrar a Docusaurus v3

Pros:

- Docs + blog + API ref en un solo sitio, con search unificada.
- Versionado e i18n (`es` default + `en`) nativos y probados.
- API ref generada como MDX versionable (`docusaurus-plugin-openapi-docs 5.2.0`,
  compatible con core 3.10.2 verificado) en vez de visor JS externo.
- MDX/React para componentes interactivos futuros (playgrounds, tabs de código).

Contras:

- Migración real: 23 páginas + nav + admonitions pymdownx (`details`, `tabbed`,
  `tasklist`, `arithmatex`, `emoji`) → remark/rehype/MDX; Mermaid vía
  `@docusaurus/theme-mermaid`; pipeline CI pasa de pip a Node.
- Riesgo de URLs: MkDocs usa `use_directory_urls` (URLs con `/` final);
  Docusaurus requiere `trailingSlash` + `@docusaurus/plugin-client-redirects`
  + tabla de mapeo auditada, o se rompen links externos y SEO.
- Isla de conocimiento: nadie en la org opera Docusaurus (vecinos: MkDocs + Astro
  marketing); el costo de ownership recae 100% en este equipo.
- Beneficio hoy marginal: la API es un placeholder (`/health`) y el contenido son
  23 páginas estables en un solo idioma.

### C. Astro (Starlight o custom)

Pros:

- `chimeranext/website` ya es Astro 5 + React + Tailwind: toolchain Node familiar
  a nivel org.

Contras:

- Ese sitio es **marketing, no docs**: no hay Starlight ni content-collections de
  docs reutilizables; el conocimiento transferible real es ~ toolchain, no arquitectura.
- Ecosistema OpenAPI-en-docs menos maduro que Docusaurus (Starlight tiene
  `starlight-openapi`, comunidad menor que `docusaurus-plugin-openapi-docs`).
- Costo de migración equivalente a B con menor retorno probado.

## Recomendación

**NO migrar ahora (veredicto: quedarse en MkDocs).** El costo (migración + redirects
+ ownership en solitario + CI Node) supera al beneficio con 23 páginas, un idioma
y una API placeholder. Re-evaluar solo si se cumple alguna condición de disparo:

1. La API pública se estabiliza y necesita referencia **versionada e integrada**
   con search (hoy: placeholder sin versionar).
2. Se necesita **versionado de docs** (v1/v2 paralelas, p. ej. por breaking changes
   de contrato de alquiler/escrow).
3. Hay compromiso real de **segundo idioma** con contenido traducido (no solo scaffolding).

Mientras tanto, ejecutar las mejoras incrementales MkDocs de `design.md` §8
(S/XS cada una, sin migración).

## Impacto si el spike se rechaza (caso base)

- Cero cambios. Este change se archiva como ADR de decisión.
