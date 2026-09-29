# habitanexus_ui

Brand package HabitaNexus sobre `flutter_shared_ui` (canon `packages/{app}_ui`,
igual que `vertivolatam_ui`, `altrupets_ui`, `aduanext_ui` y `keiko_ui`).

```
lib/
  habitanexus_ui.dart        # barrel: re-exporta shared_ui_core + tokens + tema
  src/
    habitanexus_tokens.dart  # accessor tipado (espejo de VertivoTokens)
    theme/app_theme.dart     # tema M3 (seed #1A5276), movido desde apps/mobile
    atoms/                   # (vacío — ver abajo)
    molecules/               # (vacío)
    organisms/               # (vacío)
assets/
  style_dictionary/tokens.json  # rampa primaria M3 exacta del seed
```

`apps/mobile/lib/core/theme/app_theme.dart` re-exporta el tema desde acá,
así que ningún import existente se rompe.

## Dónde aterrizan los próximos widgets

La UI de coworking en curso (sin commitear) trae `SpaceTypeIcon` (atom) y
`NearbyCoworkingsWidget` (organism): cuando se commitee, esos widgets — y los
privados de sus pages (`_CoworkingCard`, `_Tag`, `_PartnershipBadge`,
`_AmenityChip`, `_InfoRow`) — deben aterrizar en `src/{atoms,molecules,organisms}/`
de este package, exportarse en el barrel y nacer con su story en
`apps/widgetbook/lib/use_cases/` (ya diseñadas en
`apps/widgetbook/lib/use_cases/README.md`).

Regla: presentación pura — widgets con providers de Riverpod o DTOs de API se
quedan en la app y se catalogan con `ProviderScope` + overrides en el widgetbook.
