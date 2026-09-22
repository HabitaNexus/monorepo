# Proposal

## Why

El widgetbook importa `habitanexus_mobile` (dependencia temporal documentada en
`apps/widgetbook/pubspec.yaml`) porque `NearbyCoworkingsWidget` — con su
provider de Riverpod, entidad y repositorio — vive en
`apps/mobile/lib/features/properties/`. Esto viola la regla del package
("presentación pura: nunca Riverpod ni DTOs de API"), acopla el catálogo visual
a la app y bloquea el criterio de aceptación de HAB-20 (Design system: tema
base + componentes atómicos).

## What Changes

- Nueva capability `design-system`: package `habitanexus_ui` como SSOT visual
  con átomos/moléculas/organismos puros y stories que solo importan el package.
- `SpaceTypeIcon` (atom) y `NearbyCoworkings` (organism, con `SpaceCard`
  molecule y modelo puro `NearbySpace`) nuevos en
  `packages/habitanexus_ui/lib/src/`.
- `apps/mobile` conserva un adaptador delgado (`NearbyCoworkingsWidget`, misma
  API pública) que conecta el provider existente al organismo puro — paridad
  visual, sin cambio de comportamiento en la ficha de propiedad.
- `apps/widgetbook` re-apunta sus stories a `habitanexus_ui` y elimina el dep
  temporal `habitanexus_mobile`.

## Capabilities

### New Capabilities

- `design-system`: componentes atómicos puros del design system (átomos,
  moléculas, organismos), stories de widgetbook sin dependencia a la app y
  regla de presentación pura exigible.

### Modified Capabilities

Ninguna (paridad visual estricta; `rental-flow` no cambia).

## Impact

- `packages/habitanexus_ui/`: +4 fuentes (`models`, `atoms`, `molecules`,
  `organisms`), barrel y tests widget. Sin dependencias nuevas.
- `apps/mobile/`: 1 archivo reescrito como adaptador (misma API pública).
- `apps/widgetbook/`: stories re-apuntadas, `pubspec.yaml` sin
  `habitanexus_mobile`, catálogo regenerado.
- Sin migraciones, sin API breaking, sin cambios de deploy.

## Non-goals

- Migrar datasources, providers o páginas completas al package (quedan en la app).
- Nuevos componentes fuera de `SpaceTypeIcon` / `NearbyCoworkings`.
- Cambios visuales: paridad píxel a píxel con la implementación actual.
