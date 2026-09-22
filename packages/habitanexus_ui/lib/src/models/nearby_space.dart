import 'package:flutter/material.dart';

import '../atoms/space_type_icon.dart';

/// ---------------------------------------------------------------------------
/// Types — dato puro de presentación para el organismo `NearbyCoworkings`
/// ---------------------------------------------------------------------------
///
/// View-model inmutable sin dependencias de dominio: el adaptador de la app
/// mapea `WorkspaceNearby` → `NearbySpace`. Así el package nunca importa
/// entidades, DTOs ni providers.

/// Espacio de trabajo cercano (vista).
@immutable
class NearbySpace {
  /// Identificador estable (para keys de lista).
  final String id;

  /// Nombre visible (ej. "WeWork Escazú").
  final String name;

  /// Categoría tipada (define icono y badge vía [SpaceTypeIcon]).
  final SpaceType type;

  /// Distancia en km (se formatea con 2 decimales).
  final double distanceKm;

  /// Muestra el indicador WiFi.
  final bool hasWifi;

  const NearbySpace({
    required this.id,
    required this.name,
    required this.type,
    required this.distanceKm,
    required this.hasWifi,
  });
}
