# habitanexus_ui

Package UI compartido de HabitaNexus (canon `packages/{app}_ui`, igual que
`altrupets_ui`, `vertivo_ui`, `aduanext_ui` y `keiko_ui`).

```
lib/
  habitanexus_ui.dart        # barrel export
  src/
    theme/app_theme.dart     # tema M3 (seed #1A5276), movido desde apps/mobile
    models/nearby_space.dart # view-model puro del organismo
    atoms/space_type_icon.dart
    molecules/space_card.dart
    organisms/nearby_coworkings.dart
```

`apps/mobile/lib/core/theme/app_theme.dart` re-exporta el tema desde acá,
así que ningún import existente se rompe.

## Widgets migrados (HAB-20)

`SpaceTypeIcon` (atom), `SpaceCard` (molecule) y `NearbyCoworkings` (organism)
viven acá desde la migración HAB-20, con stories en
`apps/widgetbook/lib/use_cases/{atoms,organisms}/`. La app conserva solo el
adaptador con Riverpod (`NearbyCoworkingsWidget` en mobile).

Regla: presentación pura — widgets con providers de Riverpod o DTOs de API se
quedan en la app y se catalogan con `ProviderScope` + overrides en el widgetbook.
