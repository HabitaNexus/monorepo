# HabitaNexus — API Reference (Stoplight Elements)

Visor interactivo de la especificación OpenAPI de HabitaNexus, renderizado con
[Stoplight Elements](https://docs.stoplight.io/docs/elements/d6a8ba3f3c186-stoplight-elements).

## Ver localmente

Desde la raíz del repo, levanta un servidor estático sobre `docs/api/`:

```bash
# Opción A — Python
python3 -m http.server -d docs/api 8080

# Opción B — Node (sin instalación si ya tienes npx)
npx serve docs/api
```

Luego abre `http://localhost:8080/` (o la URL que imprima `serve`).

## Archivos

- `index.html` — Página de entrada. Carga Stoplight Elements desde unpkg (CDN, sin
  dependencias npm) y apunta a `./openapi.yaml`.
- `openapi.yaml` — **Placeholder** OpenAPI 3.1 con un único endpoint `/health`.
  Reemplazar cuando aterrice la primera tarea de API pública de HabitaNexus
  (listados de propiedades, flujo de escrow con Trustless Work, o el endpoint
  que venga primero).
- `README.md` — Este archivo.

## Regeneración del spec (futuro)

El spec real se debería generar desde las rutas reales del backend. Pipeline
sugerido cuando el backend publique su primera API estable:

- **Si el backend es Serverpod (Dart):** exportar el OpenAPI desde los endpoints
  con una herramienta de introspección (por ejemplo, `serverpod generate` + script
  que extraiga las firmas).
- **Si se añade un gateway REST/GraphQL separado:** generar con la herramienta
  nativa de ese stack (NestJS + `@nestjs/swagger`, Fastify + `@fastify/swagger`,
  etc.).

Hasta entonces, editar `openapi.yaml` a mano conforme se estabilice la superficie.

## Publicación online (opcional, futuro)

`docs/api/` es una página estática autocontenida; se puede publicar en cualquier
CDN o como artefacto adicional de GitHub Pages, independiente del sitio MkDocs
que vive en `docs/site/`. Si se quiere enlazar desde el sitio MkDocs, agregar
una entrada a `docs/site/mkdocs.yml` bajo `nav:` apuntando a una URL absoluta
(una vez publicado) — fuera del alcance de esta integración inicial.

## Referencias

- Docs oficiales de Stoplight Elements: <https://docs.stoplight.io/docs/elements/d6a8ba3f3c186-stoplight-elements>
- Repositorio: <https://github.com/stoplightio/elements>
