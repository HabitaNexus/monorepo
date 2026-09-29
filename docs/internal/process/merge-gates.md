# Merge gates (debido proceso) — interno

> Origen: RCA PR #44 — los PRs #35/#36 mergearon `apps/mobile` sin que
> compilara (`demo_data.dart` + `DigitalSignaturePage` referenciados pero
> nunca commiteados). Ningún check lo impidió.

## Estado medido 2026-09-29 (lo que el CI cubre hoy)

| Workflow | Qué valida | Cubre `apps/mobile` | Cubre `apps/backend` |
|---|---|---|---|
| `prds.yml` (`prds-check`) | Metadata del PR (descripción, alcance, traceability) | No (solo texto) | No (solo texto) |
| `trustless-work-dart.yml` | `packages/trustless_work_*`: analyze + test | No | No |
| `docs.yml` | `mkdocs build` del sitio | No | No |

**Conclusión:** ningún workflow compila, analiza ni testea `apps/*`.
El gate `prds-check` (requerido por protección de rama) valida el *formato*
del PR, no el *código*. Un PR en Draft puede pedirse review y mergearse con
la app rota sin que nada falle en rojo.

## Debido proceso propuesto (pendiente de adopción)

1. **Gates por path** (workflows nuevos, requeridos en protección de rama):
   - `apps/mobile/**` → `flutter analyze` (app completa, no subdirectorios)
     + `flutter test` + `flutter build apk --debug`.
   - `apps/backend/**` → `npm ci` + `tsc --noEmit` + `jest` + `nest build`.
   - `packages/**` → lo existente (`trustless-work-dart.yml`).
2. **Salida de Draft:** prohibido pedir review con checks de compilación
   en rojo; el autor ejecuta el equivalente local (`make dev-*-*`) antes.
3. **Merge:** rama al día (`update-branch`) + PRDS verde + gates de
   compilación verdes. Sin bypass `--admin` (ver protocolo merge-advisor).
4. **E2E previo a merge** para cambios cross-capa: `make e2e-local-*`
   (overlay `k8s/overlays/e2e-local`) antes de mergear a `develop`.

## Excepciones

Ninguna permanente. Un bypass requiere justificación escrita en el PR y
aprobación del QA Lead, con follow-up issue creado antes del merge.
