# Plan — Rebase de `feat/habitanexus-ui-package` contra `origin/develop` (PR #18)

Fecha: 2026-09-16 (actualizado; plan original de merge 2026-09-10 superado por rebase)
Rama: `feat/habitanexus-ui-package` → base `develop`
PR: #18 — `feat(ui): scaffold del package compartido habitanexus_ui — tema M3` (draft, handoff a Naidelyn bajo HAB-20)

## Objetivo

Dejar PR #18 lineal contra `origin/develop` (sin merges intermedios) y en verde,
listo para que Naidelyn lo retome bajo
[HAB-20](https://linear.app/habitanexus/issue/HAB-20/design-system-tema-base-componentes-atomicos).

## Estrategia

Rebase (no merge): se descartan los commits de merge `c62e3c2` y `841063d`
(su contenido — HAB-91, restore PRDS #29 — ya está en `develop`) y se replican
los 3 commits propios:

1. `45e0ac6 feat(ui): scaffold del package compartido habitanexus_ui` (ex-`586184c`)
2. `dbca5bd docs: guardar plan de merge...` (ex-`263086a`, este archivo)
3. `4686db2 fix(properties): HAB-91...` (ex-`c3e2dc9`)

## Conflicto único (esperado)

`apps/mobile/lib/core/theme/app_theme.dart`: `develop` (vía HAB-91 final, PR #24)
enriqueció el tema local (`surfaceColor`, `scaffoldBackgroundColor`).
Resolución fiel al PR: la app conserva el **re-export** de 2 líneas y el tema
enriquecido se traslada al package (`packages/habitanexus_ui/lib/src/theme/app_theme.dart`).

## Fix adicional del rebase (widgetbook en rojo)

`develop` trae `apps/widgetbook/lib/use_cases/properties/nearby_coworkings_widget_use_case.dart`
(HAB-91, PR #24), que importa `habitanexus_mobile` + `flutter_riverpod`: con el
scaffold (widgetbook→`habitanexus_ui`) no compilaba, y `flutter_riverpod` ni
siquiera es dep de widgetbook en `develop`. Fix mínimo sin migrar UI:

- `apps/widgetbook/pubspec.yaml`: agrega `flutter_riverpod: ^2.4.9` y restaura
  `habitanexus_mobile` (path) como **dep temporal** documentado hasta la
  migración HAB-20 (al migrar los widgets a `src/{atoms,molecules,organisms}/`, eliminarlo).
- Story: agrega imports faltantes de `WorkspaceNearby` y `WorkspaceNearbyRepository`.
- `flutter pub get` + `flutter analyze`: **No issues found!**

## Verificado post-rebase

- `flutter analyze` mobile (properties + tests): 0 errores.
- `flutter analyze` widgetbook: No issues found!
- `flutter test` mobile: ver log `/tmp/opencode/flutter-test-rebase.log`.
- `prds-check-local.sh 18 --as-ready`: EXIT 0 (solo warning de tamaño con excepción mecánica).

## Handoff a Naidelyn (HAB-20)

1. Proposal OpenSpec de HAB-20 (bloqueante por criterio del equipo) + eventual
   spec `design-system` madre.
2. Migración de `NearbyCoworkingsWidget` y `SpaceTypeIcon` al package,
   stories apuntando a `habitanexus_ui`, eliminar dep temporal `habitanexus_mobile`.
3. Marcar ready → verificar `prds-check` → merge.
