# Use cases — taxonomía Atomic Design

Los stories se organizan en `atoms/`, `molecules/` y `organisms/`, igual que en el
widgetbook canónico de altrupets (`apps/widgetbook/lib/use_cases/`).

## Estado actual: 0 stories (gap honesto)

En `develop` no hay todavía ningún widget público reutilizable: la feature
`payments` es solo lógica (datasources, repositorios, use cases) y la UI de
`coworking` está en curso sin commitear. **No se inventaron componentes.**

## Stories listas para cuando se commitee la feature coworking

La feature en curso trae `SpaceTypeIcon` (atom) y `NearbyCoworkingsWidget`
(organism). Sus stories quedan diseñadas así — crear el archivo y regenerar:

```dart
// atoms/space_type_icon_use_case.dart
@widgetbook.UseCase(name: 'Default', type: SpaceTypeIcon, path: '[atoms]')
Widget buildSpaceTypeIconUseCase(BuildContext context) {
  return SpaceTypeIcon(
    type: context.knobs.object.dropdown(
      label: 'Tipo de espacio',
      options: SpaceType.values,
      labelBuilder: (type) => type.name,
    ),
    size: context.knobs.double.slider(
      label: 'Size', initialValue: 40, min: 16, max: 96,
    ),
  );
}
```

Para `NearbyCoworkingsWidget` (ConsumerWidget): montar dentro de
`ProviderScope(overrides: [coworkingNearbyProvider.overrideWith(...)])` con
fixtures de `CoworkingSpace`.

## Convención

Un archivo por widget: `<nivel>/<widget>_use_case.dart`, anotado con
`@widgetbook.UseCase(name: ..., type: ..., path: '[<nivel>]')` y knobs.
Regenerar el catálogo con:

```sh
dart run build_runner build --delete-conflicting-outputs
```
