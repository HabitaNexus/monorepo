# Spec Delta

## Purpose

El design system (`habitanexus_ui`) es el SSOT visual: componentes puros,
testeados y catalogados en widgetbook sin depender de la app. Este delta cubre
la primera migración (HAB-20): átomo `SpaceTypeIcon` y organismo
`NearbyCoworkings`, con paridad visual estricta respecto a la implementación
actual en mobile.

## ADDED Requirements

### Requirement: Presentación pura del package

El package `habitanexus_ui` SHALL NOT importar `flutter_riverpod`, DTOs de API
ni símbolos de `habitanexus_mobile`; sus widgets reciben todo por constructor.

#### Scenario: Package sin dependencias impuras

- **WHEN** se analiza `packages/habitanexus_ui` (`flutter analyze`, `flutter pub deps`)
- **THEN** no aparece `flutter_riverpod` ni `habitanexus_mobile` en su grafo de dependencias

### Requirement: Átomo SpaceTypeIcon

El sistema SHALL proveer `SpaceTypeIcon({type, size})` que renderice el icono
de la categoría (`coworking`, `cafe`, `other`) a un tamaño configurable.

#### Scenario: Icono por categoría

- **WHEN** se renderiza `SpaceTypeIcon` con cada `SpaceType`
- **THEN** se muestra un `Icon` visible del tamaño pedido para cada categoría

### Requirement: Organismo NearbyCoworkings puro

El sistema SHALL proveer `NearbyCoworkings({spaces, isLoading, error,
onViewFullSearch})` que renderice la lista horizontal (máx. lo recibido),
spinner de carga, mensaje de error o estado vacío, sin providers internos.

#### Scenario: Lista con datos

- **WHEN** se renderiza con 3 espacios
- **THEN** se ven sus nombres y distancias formateadas (`0.50 km`) y el botón
  "Ver buscador completo"

#### Scenario: Estado de carga

- **WHEN** `isLoading` es true
- **THEN** se muestra un indicador de progreso y ninguna tarjeta

#### Scenario: Estado de error

- **WHEN** `error` trae mensaje
- **THEN** se muestra el mensaje y ninguna tarjeta

#### Scenario: Estado vacío

- **WHEN** la lista está vacía sin error ni carga
- **THEN** se muestra el texto de "no se encontraron espacios"

### Requirement: Stories sin dependencia a la app

Las stories de widgetbook SHALL importar únicamente `habitanexus_ui` (más SDK
Flutter) y el `pubspec.yaml` de widgetbook SHALL NOT declarar
`habitanexus_mobile`.

#### Scenario: Catálogo sin dep temporal

- **WHEN** se corre `flutter pub deps` en `apps/widgetbook` y se abre el
  catálogo
- **THEN** no figura `habitanexus_mobile` y las stories `atoms/SpaceTypeIcon`
  y `organisms/NearbyCoworkings` renderizan

### Requirement: Paridad visual en la app

El adaptador `NearbyCoworkingsWidget` de mobile SHALL renderizar lo mismo que
antes para idéntico estado del provider (misma API pública para
`property_detail_page.dart`).

#### Scenario: Adaptador delega al organismo

- **WHEN** el provider entrega 2 espacios
- **THEN** la ficha muestra los mismos nombres, distancias y botón que la
  implementación anterior
