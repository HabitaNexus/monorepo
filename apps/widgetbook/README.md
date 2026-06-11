# habitanexus_widgetbook

Catálogo de widgets de HabitaNexus con [Widgetbook](https://pub.dev/packages/widgetbook),
con la misma taxonomía Atomic Design que el widgetbook canónico de altrupets:

```
lib/
  main.dart                  # Widgetbook app + tab Showcase del design system
  use_cases/
    atoms/                   # (vacío — ver Gap abajo)
    molecules/               # (vacío)
    organisms/               # (vacío)
  showcase/
    design_system_showcase.dart  # ColorScheme M3 desde seed #1A5276
```

## Correr

```sh
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run -d chrome
```

## Gap: HabitaNexus aún no tiene widgets compartidos commiteados

En `develop` no existe ningún widget público reutilizable: `payments` es solo
lógica y la UI de `coworking` está en curso sin commitear (trae `SpaceTypeIcon`
y `NearbyCoworkingsWidget`; sus stories ya quedaron diseñadas en
`lib/use_cases/README.md`). Pasos naturales:

1. Al commitear la feature coworking, agregar las dos stories diseñadas.
2. Promover los widgets privados de las pages (`_CoworkingCard`, `_Tag`,
   `_PartnershipBadge`, `_AmenityChip`, `_InfoRow`) a
   `lib/core/widgets/{atoms,molecules,organisms}/` (o a un package
   `habitanexus_ui`), cada uno naciendo con su story.
3. El theme es un `ColorScheme.fromSeed` mínimo — cuando se incorporen design
   tokens (estilo style-dictionary de altrupets/vertivo), extender el Showcase.

## Convención

Un archivo por widget: `use_cases/<nivel>/<widget>_use_case.dart`, anotado con
`@widgetbook.UseCase(name: ..., type: ..., path: '[<nivel>]')` y knobs para sus
props. Widgets con providers de Riverpod se montan dentro de `ProviderScope`
con overrides y fixtures.
