# Design

## Contexto

`packages/habitanexus_ui` hoy solo exporta el tema M3. La primera UI migrada es
el bloque "Espacios de trabajo cerca" (`NearbyCoworkingsWidget`), hoy un
`ConsumerStatefulWidget` acoplado a `coworkingNearbyProvider`,
`WorkspaceNearby` (equatable) y `WorkspaceNearbyRepository` en mobile.

## Decisión: capas por pureza, no por archivo

- **Package (puro):** `SpaceType` + `SpaceTypeIcon` (atom),
  `SpaceCard` (molecule), `NearbySpace` (modelo inmutable sin equatable) y
  `NearbyCoworkings` (organism que recibe `spaces/isLoading/error` por
  constructor). Cero imports a `flutter_riverpod` o a la app.
- **App (glue):** `NearbyCoworkingsWidget` se reescribe como adaptador delgado
  `ConsumerWidget`: observa el provider existente, mapea
  `WorkspaceNearby` → `NearbySpace` y delega el render al organismo. La
  `property_detail_page.dart` no cambia (misma API pública).
- **Widgetbook:** stories construyen el organismo puro con fixtures locales
  (`Default`, `Loading`, `Error`) + story del átomo con knobs. Se elimina
  `habitanexus_mobile` del `pubspec.yaml` y se regenera
  `main.directories.g.dart`.

## Alternativas descartadas

- **Mover provider/entidad al package:** obligaría a `flutter_riverpod` +
  `equatable` como deps del design system y rompería su regla fundacional.
- **Dejar el widget en mobile y duplicar en package:** dos implementaciones que
  divergen; viola DSMS (sin árboles paralelos).

## Riesgos

- Paridad visual: mitigado con stories por estado + tests widget que asertan
  textos clave (nombres, distancias, mensajes de error/vacío).
- `main.directories.g.dart` regenerado: churn mecánico, declarado en el PR.
