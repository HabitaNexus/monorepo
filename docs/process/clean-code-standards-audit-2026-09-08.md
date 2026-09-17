---
title: Auditoría de estándares de ingeniería (2026-09-08)
owner: Platform Team
status: review
diataxis_type: reference
last_review: 2026-09-08
review_cadence: quarterly
audience: internal
source_of_truth: docs/process/clean-code-standards-audit-2026-09-08.md
---

# Auditoría Clean Code Standards — HabitaNexus — 2026-09-08

Auditoría de adopción de los 6 engineering standards (DSMS, IFS, CPS, PRDS, BrS,
QT4L) sobre el monorepo completo, ejecutada con el comando
`/clean-code-standards-audit` (sub-agentes por área de foco). Solo cambios
incrementales: la deuda estructural se lista como tal y **no** se autoriza
refactor masivo.

## Status by practice

| Práctica | Status | Resumen |
| --- | --- | --- |
| DSMS | ⚠ partial | Feature-first donde existe código real; debt de docs + 2 dirs técnicos a raíz |
| IFS | ⚠ partial | Orden vertical de facto OK; banner `// ---` ausente en 100% de los archivos |
| CPS | ⚠ partial | Entrypoints correctos; barrel principal sin categorizar y 0 feature barrels |
| PRDS | ⚠ partial | Solo 2/9 PRs abiertos cumplen al 100%; 3 superan 5× el límite de tamaño |
| BrS | ⚠ partial | 3 ramas + default OK; `staging` sin protección y `main` con 0 approvals |
| QT4L | ⚠ partial | Sin blockers hoy (no hay deltas activos); 0 `#### Scenario:` en specs vivas |

## Findings by severity

### Blocker

- **PRDS — PR #21** (`feat(mobile): coworking feature-first`): feature con
  migraciones DB declara `Linear: No aplica` (sin ticket) y suma 2680 líneas
  (6.7× el tope). → Crear issue HAB-N y dividir en PR de migraciones + PR de
  feature slice, cada uno ≤400 líneas.
- **PRDS — PR #24** (`feat(properties/HAB-91): NearbyCoworkings`): body sin
  ninguna sección del template y sin `Fixes HAB-91` (auto-link). → Reescribir
  body con Resumen/Linear/Plan de pruebas/Límites/Riesgo/Evidencia.
- **PRDS — PR #22** (`chore(openspec): v1.11`): 2726 líneas (6.8×). → Declarar
  excepción de migración mecánica stateful en el body (test plan CI-only) o
  dividir por spec.
- **BrS — `staging` sin protección**: `gh api .../branches/staging/protection`
  → 404; rulesets `[]`. En el modelo 3-ramas (develop→staging→main) staging debe
  ser "Solo PR (puerto desde develop)". → Ruleset de repo: PR + approvals + status
  checks antes de cablear el overlay GitOps develop→staging.

### Warning

- **IFS — banner obligatorio no adoptado** (`// ---`): única coincidencia en
  `hybrid_event_stream.dart:55` es un subrayado decorativo de doc comment, no un
  banner de sección. → Añadir banners al próximo edit significativo de
  `trustless_work_client.dart` (404L); usar como plantilla visible.
- **IFS — separadores con operador reservado**: `// ===` (preludio de archivo
  según SSOT) usado inline como section separator en `trustless_work_client.dart:204-316`
  y `client_test.dart:206-513`. → Convertir a `// ---` en el próximo edit.
- **IFS — tests/long file**: `client_test.dart` (548L) sobrepasa el umbral ~500
  sin nota de extracción. → Próximos tests de endpoints van a
  `test/endpoints/indexer_queries_test.dart` (267L) existente.
- **IFS — tipos intercalados**: `indexer_query_providers.dart:7,35-39` alterna
  typedefs con providers. → Mover typedefs al tope en el próximo edit.
- **CPS — barrel `trustless_work_dart.dart` sin clasificar**: 36 exports planos
  sin banners de slice ni separación runtime/type-only ni `show`. → Al añadir el
  próximo export, abrir secciones por slice (`client/errors/events/models/
  payloads/signers`) con banners `// ---`.
- **CPS — export-all en 34/36 líneas** del barrel principal: superficie pública
  sin recorte (riesgo de filtrar internos freezed). → Añadir `show` por slice, de
  a una línea.
- **CPS — mobile sin feature barrels**: cross-feature por deep-import
  (`main.dart:3-4`, `payment_usage_example.dart:4`). → Al tocar la próxima page,
  crear `features/{feature}/{feature}.dart`.
- **DSMS — `docs/bounded-contexts.md` inexistente**: referenciado en
  `code-organization-standards.md:55,273` y `pull-request-description-and-scope.md:180`.
  → Crearlo (vocabulario de feature-ids) o quitar enlaces en el próximo edit de docs.
- **DSMS — dirs técnicos a raíz `lib/config/` y `lib/integration/`**: no son
  domain slices (`payment_config.dart`, `app_router.dart`,
  `trustless_work_bootstrap.dart`). → En next edit, mover a `features/payments/`
  y `core/` respectivamente; deprecated para archivos nuevos.
- **DSMS — `features/coworking/` cáscara vacía**: sin archivos tracked y sin capa
  `domain/`. → Poblar bajo `data/domain/presentation` al iniciar coworking o
  borrar dirs vacíos.
- **BrS — `main` protección solo PR**: `required_approving_review_count: 0`, sin
  status checks, `enforce_admins: false`. → Subir a ≥1 approval + status checks.
- **BrS — `docs/branching.md` desincronizado del SSOT**: documenta modelo de 2
  ramas (main+develop) y el repo ya tiene `staging` de primera clase. → Alinear a
  3-ramas y enlazar AGENTS.md al SSOT.
- **BrS — commits históricos no conventional**: `HAB-65: trustless_work_riverpod…`,
  `HAB-62: multiple balance queries` (nuevos sí conforman). → `type(scope): desc
  (HAB-N)` en adelante; backfill opcional.
- **QT4L — specs vivas sin AC**: las 3 specs en `openspec/specs/*/spec.md` son
  prosa (0 hits de `#### Scenario:`/SHALL/GIVEN). → Al editar `rental-flow`
  (mayor leverage), convertir a bloques AC con un `#### Scenario:` por fase.
- **QT4L — capa 4 inexistente**: no existe `docs/qa/`, cero rondas HITL con
  `round.md`. → Materializar `docs/qa/rounds/<domain>-<date>/` y correr primera
  ronda `/bug-squash <rental-flow>` cuando haya scenarios.
- **PRDS — draft workflow**: PRs 18/21/22/24 abiertos (undrafted) aunque grandes/
  incompletos; el SSOT exige draft hasta human OK. → `gh pr ready` solo tras
  completar el template.

### Info

- **BrS — naming de ramas**: `feat/coworking-mobile`, `feat/habitanexus-ui-package`,
  `revert/bootstrap-logging-direct-push` sin la referencia del tracker en el
  nombre. → Prefijar `feat/HAB-N-slug` en ramas nuevas; renombrar es opcional.
- **BrS — `develop` sin protección**: aceptable por diseño ("Abierta, pero PR
  recomendado"); subir umbral al crecer el equipo.
- **IFS/CPS — positivos**: `soroban_event_decoder.dart` (orden + doc why),
  `onvo_payment_provider.dart` (helpers abajo), `hybrid_event_stream.dart`
  (`show` correcto + documentación), entrypoints `lib/{package}.dart` correctos,
  barrels mini exentos por SSOT, `app_router.dart` (18L) exento.
- **CPS — intención declarada**: doc comment "Mutations are intentionally excluded"
  en `trustless_work_riverpod.dart:1-9`.
- **QT4L — SOPs base OK**: 5 SOPs en `docs/site/content/docs/sops/` (capa 2).

## Adoption debt (do not touch today)

- Refactor de `trustless_work_client.dart`/`client_test.dart` solo banners — no
  reorganizar el barrel en bloque.
- Historia de commits legacy sin conventional — no reescribir.
- Dirs vacíos `features/coworking/{data,presentation}` — decidir al iniciar la
  feature, no hoy.
- Sin enforcement por lint: `analysis_options.yaml` usa solo `lints/recommended`/
  `flutter_lints` (sin `directives_ordering`, `sort_pub_directives`). Activarlos
  es follow-up, no parte de este cambio.

## Recommended order

1. **BrS** — proteger `staging` + subir approvals/checks de `main` (bloquea el
   gate GitOps del mercado). Ruleset, no código.
2. **PRDS** — remediar #24 (quick win), luego #21 (crear issue + split) y #22
   (excepción mecánica o split). PRs por debajo del tope − y en draft hasta OK.
3. **QT4L seed** — convertir specs vivas a bloques `#### Scenario:` (empezar por
   `rental-flow`) para que la tabla scenario→verificación tenga inputs.
4. **CPS** — categorizar `trustless_work_dart.dart` al tocar el barrel; primer
   feature barrel en mobile.
5. **DSMS** — crear `docs/bounded-contexts.md`; foldear `config/`/`integration/`
   en siguiente edit.
6. **IFS** — banners `// ---` en los próximos edits; la plantilla la fija
   `trustless_work_client.dart`.
7. **Repetir /clean-code-standards-audit** tras cada PR de remediación para
   actualizar el status.