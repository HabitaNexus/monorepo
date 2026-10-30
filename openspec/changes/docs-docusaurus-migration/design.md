# Design — docs-docusaurus-migration (arquitectura destino, condicional)

> Solo se implementa si se revierten las condiciones de disparo de `proposal.md`.
> Describe el estado final, no el camino (el camino está en `tasks.md`).

## 1. Stack destino

- `website/` (nuevo, raíz del repo): Docusaurus v3 — `@docusaurus/core 3.10.2`
  (verificado vía `npm view`), React 18/19, MDX 3, Node 20 LTS en CI.
- Lenguaje del sitio: `es` por defecto (`defaultLocale: 'es'`, `locales: ['es']`;
  `'en'` se añade solo con contenido traducido real).
- Preset clásico: `@docusaurus/preset-classic` (docs + blog desactivado o reservado
  para changelog de producto + `pages/` para landing si hiciera falta).

## 2. Árboles de contenido (Diátaxis en ambos)

```text
website/
  docs/                  # PÚBLICO — espejo 1:1 de docs/site/content/docs/
    tutorials/
    how-to/
    reference/
    explanation/
  i18n/en/               # traducciones futuras, solo cuando existan
  static/openapi/        # openapi.yaml fuente (ver §4)
  docusaurus.config.js
  sidebars.js            # autogenerado por carpetas, orden explícito por _category_.json
```

- Las 4 categorías llevan `_category_.json` con `label` y `position` para fijar el
  orden Diátaxis (tutoriales → guías → referencia → explicación).
- Conversión Markdown: admonitions `!!!` → `:::note/:::tip`, `pymdownx.details` →
  `<details>`, `tabbed` → `<Tabs>`, `tasklist` → `- [ ]`, `arithmatex` → KaTeX
  (`remark-math` + `rehype-katex`), `emoji` → unicode directo.
- Mermaid: `@docusaurus/theme-mermaid` (`markdown.mermaid: true`), se elimina
  `javascripts/mermaid-init.mjs`.

## 3. Plugin OpenAPI (decisión)

| Opción | Veredicto |
|---|---|
| `docusaurus-plugin-openapi-docs 5.2.0` + `docusaurus-theme-openapi-docs` | **Elegido**: genera MDX por operación (search-indexable, versionable, i18n), peer `^3.10.0` compatible con core 3.10.2 verificado |
| `redocusaurus 2.5.2` (Redoc) | Descartado como principal: render single-page, operaciones no indexadas en search, peor versionado; aceptable como fallback si el spec usa constructores OpenAPI 3.1 que el plugin no digiera |

- `docs/api/openapi.yaml` se traslada a `website/static/openapi/openapi.yaml` como
  **única fuente de verdad** del spec; el plugin genera `website/docs/api/*` en build
  (o pre-build commiteado, decisión en fase 4).
- `docs/api/index.html` (Stoplight Elements) **se retira**: fin del visor standalone
  y del CDN unpkg como dependencia de la doc pública. El spec placeholder (`/health`)
  NO se migra con bombo: la sección API nace marcada `draft/unlisted` hasta que exista
  superficie real.

## 4. i18n

- `defaultLocale: 'es'`; `localeConfigs.es.label: 'Español'`.
- Inglés: solo scaffolding (`locales: ['es']` + script `crowdin`/manual pendiente);
  activar `'en'` en config únicamente con ≥50% de páginas traducidas (criterio en `tasks.md`).
- Search: `@easyops-cn/docusaurus-search-local 0.55.3` con `language: ['es', 'en']`
  (el search nativo de Docusaurus es solo Algolia/externo; el plugin local replica el
  search offline actual de MkDocs).

## 5. Preservación de URLs de GitHub Pages

- `url: 'https://habitanexus.github.io'`, `baseUrl: '/monorepo/'`,
  `trailingSlash: true` (iguala `use_directory_urls` de MkDocs: `/docs/how-to/.../`).
- `@docusaurus/plugin-client-redirects` con tabla explícita de redirecciones para
  toda URL cuyo slug cambie (p. ej. `index.md` raíz, secciones renombradas).
- `site/` (build MkDocs) sale del repo; el artefacto Pages pasa a `website/build/`
  (workflow `docs.yml` reescrito a Node: `npm ci` + `npm run build` + `upload-pages-artifact`).
- `editUrl` apunta a `edit/main/website/docs/` para mantener "editar esta página".

## 6. Árbol privado `docs/internal/` (nunca en nav público)

Docusaurus no tiene ACL por página: la separación es por **build**, no por config:

- `docs/internal/` **no entra** en `website/docs/` bajo ningún concepto.
- Opción elegida: segundo contenido excluido por construcción —
  `website/` solo publica lo que está bajo `website/docs/` + `static/` auditado;
  `docs/internal/` sigue viviendo fuera del site y se publica (si acaso) en un build
  separado no desplegado a Pages (local o artefacto interno con auth, p. ej.
  Cloudflare Access delante de un bucket privado — fuera del alcance, ver `tasks.md`).
- Gate en CI: job que falla si cualquier `.md` de `website/docs|static|blog` contiene
  secretos/patrones internos (`sauna`: palabras `password|secret|token|192.168.|10.|internal-only`)
  y si algún path de `docs/internal/` aparece referenciado desde `website/`.

## 7. Theming y extras

- Paleta clara/oscura + fuentes Inter/JetBrains Mono portadas de
  `stylesheets/habitanexus.css` a `website/src/css/custom.css` (variables Infima).
- `social` GitHub, `generator: false` equivalente (`hideableSidebar`, footer sin marca).
- Sitemap + `noIndex` en staging/preview.

## 8. Alternativa incremental sin migración (recomendada hoy)

Si el veredicto es no migrar, estos cambios XS/S cierran el gap sin Docusaurus:

1. Enlazar `docs/api/` desde el nav MkDocs (URL absoluta tras publicarla como
   artefacto Pages adicional o subpath) — XS.
2. Activar `mike` para versionado cuando exista v1 real — S.
3. `mkdocs-static-i18n` solo con compromiso de traducción — S.
4. `mkdocs-openapi-plugin`/Redoc embebido para unificar API ref en el sitio — S.
