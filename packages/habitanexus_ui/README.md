# habitanexus_ui

Package UI compartido de HabitaNexus (canon `packages/{app}_ui`, igual que
`altrupets_ui`, `vertivo_ui`, `aduanext_ui` y `keiko_ui`).

```
lib/
  habitanexus_ui.dart        # barrel export
  src/
    theme/app_theme.dart     # tema M3 (seed #1A5276), movido desde apps/mobile
    atoms/                   # (vacío — ver abajo)
    molecules/               # (vacío)
    organisms/               # (vacío)
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
