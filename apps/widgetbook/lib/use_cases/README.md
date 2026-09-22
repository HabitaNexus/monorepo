# Use cases — taxonomía Atomic Design

Los stories se organizan en `atoms/`, `molecules/` y `organisms/`, igual que en el
widgetbook canónico de altrupets (`apps/widgetbook/lib/use_cases/`).

## Estado actual: 4 stories (HAB-20)

`atoms/space_type_icon_use_case.dart` (`SpaceTypeIcon` con knobs de tipo y
tamaño) y `organisms/nearby_coworkings_use_case.dart` (`NearbyCoworkings` en
estados Default/Loading/Error). Todas importan solo `habitanexus_ui` con
fixtures locales — sin providers ni red.

## Convención

Un archivo por widget: `<nivel>/<widget>_use_case.dart`, anotado con
`@widgetbook.UseCase(name: ..., type: ..., path: '[<nivel>]')` y knobs.
Regenerar el catálogo con:

```sh
dart run build_runner build --delete-conflicting-outputs
```
