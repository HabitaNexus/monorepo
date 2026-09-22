# Tasks — HAB-20 design system (primera migración)

- [x] OpenSpec proposal + design + spec delta + esta tabla QT4L (PR-A, docs)
- [ ] `SpaceType` + `SpaceTypeIcon` en `packages/habitanexus_ui/lib/src/atoms/`
- [ ] `NearbySpace` en `packages/habitanexus_ui/lib/src/models/`
- [ ] `SpaceCard` en `packages/habitanexus_ui/lib/src/molecules/`
- [ ] `NearbyCoworkings` en `packages/habitanexus_ui/lib/src/organisms/`
- [ ] Barrel `habitanexus_ui.dart` (CPS: secciones Models → Atoms → Molecules → Organisms)
- [ ] Tests widget en `packages/habitanexus_ui/test/` (tabla abajo)
- [ ] Adaptador `NearbyCoworkingsWidget` en mobile (misma API pública)
- [ ] Stories widgetbook solo-package + quitar dep temporal + regenerar catálogo
- [ ] `flutter analyze` + `flutter test` verdes; `prds-check-local --as-ready` EXIT 0

## QA traceability (four layers)

SSOT: `reference/process/qa-traceability-four-layers.md`

| Capa | Artifacto |
| --- | --- |
| 1 — AC normativos | `specs/design-system/spec.md` (este cambio) |
| 2 — QA manual de stage | N/A design system (sin SOP de dominio): revisión visual en widgetbook stories |
| 3 — Automatizada | `packages/habitanexus_ui/test/` (tabla abajo) |
| 4 — Ronda HITL | `docs/qa/rounds/design-system/round.md` |

### Mapeo scenario → verificación

| Scenario de OpenSpec | Test automatizado | Manual (SOP / Kiwi) | Caso HITL ID | Storybook (solo UI) |
| --- | --- | --- | --- | --- |
| Package sin dependencias impuras | `flutter pub deps` en CI (grep) o `(pending UI-00)` | — | UI-00 | — |
| Icono por categoría | `space_type_icon_test.dart::renders icon per SpaceType` | widgetbook atoms | UI-01 | `atoms/SpaceTypeIcon` |
| Lista con datos | `nearby_coworkings_test.dart::renders names and distances` | widgetbook organisms | UI-02 | `organisms/NearbyCoworkings Default` |
| Estado de carga | `nearby_coworkings_test.dart::shows progress when loading` | widgetbook organisms | UI-03 | `organisms/NearbyCoworkings Loading` |
| Estado de error | `nearby_coworkings_test.dart::shows error message` | widgetbook organisms | UI-04 | `organisms/NearbyCoworkings Error` |
| Estado vacío | `nearby_coworkings_test.dart::shows empty message` | widgetbook organisms | UI-05 | `(cubierto por Default con lista vacía)` |
| Catálogo sin dep temporal | `grep habitanexus_mobile apps/widgetbook/pubspec.yaml` vacío | abrir catálogo | UI-06 | — |
| Adaptador delega al organismo | `flutter test apps/mobile` del adapter o `(pending UI-07)` | ficha de propiedad en stage | UI-07 | — |

### Handoff

- [ ] Revisión visual de stories en widgetbook (Default/Loading/Error + átomo)
- [ ] Ronda HITL con `round.md` traceability pegada de esta tabla
