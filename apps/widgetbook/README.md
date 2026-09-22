# habitanexus_widgetbook

Catálogo de widgets de HabitaNexus con [Widgetbook](https://pub.dev/packages/widgetbook),
con la misma taxonomía Atomic Design que el widgetbook canónico de altrupets:

```
lib/
  main.dart                  # Widgetbook app + tab Showcase del design system
  use_cases/
    atoms/space_type_icon_use_case.dart
    organisms/nearby_coworkings_use_case.dart  # Default/Loading/Error
  showcase/
    design_system_showcase.dart  # ColorScheme M3 desde seed #1A5276
```

## Correr

```sh
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run -d chrome
```

## Estado: primeras stories (HAB-20)

`SpaceTypeIcon` (atom) y `NearbyCoworkings` (organism, estados
Default/Loading/Error) viven en `habitanexus_ui` y sus stories solo importan
el package — sin `habitanexus_mobile`. Pasos naturales:

1. Promover los widgets privados de las pages (`_CoworkingCard`, `_Tag`,
   `_PartnershipBadge`, `_AmenityChip`, `_InfoRow`) a
   `habitanexus_ui` en `src/{atoms,molecules}/`, cada uno naciendo con su story.
2. El theme es un `ColorScheme.fromSeed` mínimo — cuando se incorporen design
   tokens (estilo style-dictionary de altrupets/vertivo), extender el Showcase.

## Convención

Un archivo por widget: `use_cases/<nivel>/<widget>_use_case.dart`, anotado con
`@widgetbook.UseCase(name: ..., type: ..., path: '[<nivel>]')` y knobs para sus
props. Widgets con providers de Riverpod se montan dentro de `ProviderScope`
con overrides y fixtures.
