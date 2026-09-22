import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitanexus_ui/habitanexus_ui.dart';

import '../../domain/entities/workspace_nearby.dart';
import '../providers/coworking_nearby_provider.dart';

// ---------------------------------------------------------------------------
// Adapter — conecta el provider existente al organismo puro del package
// ---------------------------------------------------------------------------
//
// La UI vive en `habitanexus_ui` (HAB-20); acá solo queda el glue de Riverpod:
// observar `coworkingNearbyProvider`, disparar `loadNearby` al montar y mapear
// `WorkspaceNearby` → `NearbySpace`. Misma API pública para no tocar las pages.

/// Widget que muestra espacios de trabajo cercanos (coworkings y cafés con WiFi)
/// a una propiedad dada.
///
/// Se monta en la ficha de detalle de una propiedad.
/// Muestra máximo 5 resultados ordenados por distancia.
/// El botón "Ver buscador completo" abre el buscador con la ubicación preseleccionada.
class NearbyCoworkingsWidget extends ConsumerStatefulWidget {
  final double propertyLatitude;
  final double propertyLongitude;
  final double searchRadius; // en metros
  final VoidCallback? onViewFullSearch;

  const NearbyCoworkingsWidget({
    super.key,
    required this.propertyLatitude,
    required this.propertyLongitude,
    this.searchRadius = 2000,
    this.onViewFullSearch,
  });

  @override
  ConsumerState<NearbyCoworkingsWidget> createState() =>
      _NearbyCoworkingsWidgetState();
}

class _NearbyCoworkingsWidgetState
    extends ConsumerState<NearbyCoworkingsWidget> {
  @override
  void initState() {
    super.initState();
    // Cargar datos cuando el widget se monta
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(coworkingNearbyProvider.notifier).loadNearby(
            latitude: widget.propertyLatitude,
            longitude: widget.propertyLongitude,
            radius: widget.searchRadius,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(coworkingNearbyProvider);
    return NearbyCoworkings(
      spaces: state.spaces.map(_toSpace).toList(),
      isLoading: state.isLoading,
      error: state.error,
      onViewFullSearch: widget.onViewFullSearch,
    );
  }
}

// ---------------------------------------------------------------------------
// Helpers privados — mapeo entidad → view-model puro (detalle bajo el glue)
// ---------------------------------------------------------------------------

NearbySpace _toSpace(WorkspaceNearby e) => NearbySpace(
      id: e.id,
      name: e.name,
      type: _toType(e.category),
      distanceKm: e.distanceKm,
      hasWifi: e.hasWifi,
    );

SpaceType _toType(String category) => switch (category) {
      'coworking' => SpaceType.coworking,
      'cafe' => SpaceType.cafe,
      _ => SpaceType.other,
    };
