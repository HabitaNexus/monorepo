import 'package:flutter/material.dart';
import 'package:habitanexus_ui/habitanexus_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

// ---------------------------------------------------------------------------
// Fixtures — datos fijos solo para el catálogo (sin providers ni red)
// ---------------------------------------------------------------------------

const _spaces = [
  NearbySpace(
    id: '1',
    name: 'WeWork Escazú',
    type: SpaceType.coworking,
    distanceKm: 0.5,
    hasWifi: true,
  ),
  NearbySpace(
    id: '2',
    name: 'Café Avellaneda',
    type: SpaceType.cafe,
    distanceKm: 0.3,
    hasWifi: true,
  ),
  NearbySpace(
    id: '3',
    name: 'Coworking Central',
    type: SpaceType.coworking,
    distanceKm: 1.2,
    hasWifi: true,
  ),
];

// ---------------------------------------------------------------------------
// Stories — un estado por story ([organisms])
// ---------------------------------------------------------------------------

@widgetbook.UseCase(
  name: 'Default',
  type: NearbyCoworkings,
  path: '[organisms]',
)
Widget buildNearbyCoworkingsUseCase(BuildContext context) {
  return NearbyCoworkings(
    spaces: _spaces,
    onViewFullSearch: () {},
  );
}

@widgetbook.UseCase(
  name: 'Loading',
  type: NearbyCoworkings,
  path: '[organisms]',
)
Widget buildNearbyCoworkingsLoadingUseCase(BuildContext context) {
  return const NearbyCoworkings(isLoading: true);
}

@widgetbook.UseCase(
  name: 'Error',
  type: NearbyCoworkings,
  path: '[organisms]',
)
Widget buildNearbyCoworkingsErrorUseCase(BuildContext context) {
  return const NearbyCoworkings(error: 'Sin conexión a internet');
}
