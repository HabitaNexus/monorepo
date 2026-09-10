import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/workspace_nearby.dart';
import '../providers/coworking_nearby_provider.dart';

/// Widget que muestra espacios de trabajo cercanos (coworkings y cafés con WiFi)
/// a una propiedad dada.
///
/// Se monta en la ficha de detalle de una propiedad.
/// Muestra máximo 5 resultados ordenados por distancia.
/// Cada tarjeta incluye nombre, categoría y distancia en km.
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Espacios de trabajo cerca',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            TextButton(
              onPressed: widget.onViewFullSearch,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              child: const Text('Ver buscador completo'),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Content
        _buildContent(context, state),
      ],
    );
  }

  Widget _buildContent(BuildContext context, WorkspaceNearbyState state) {
    if (state.isLoading) {
      return const SizedBox(
        height: 100,
        child: Center(child: CircularProgressIndicator.adaptive()),
      );
    }

    if (state.error != null) {
      return _buildErrorWidget(context, state.error!);
    }

    if (state.spaces.isEmpty) {
      return _buildEmptyWidget(context);
    }

    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: state.spaces.length,
        itemBuilder: (context, index) {
          return _buildSpaceCard(context, state.spaces[index]);
        },
      ),
    );
  }

  Widget _buildSpaceCard(BuildContext context, WorkspaceNearby space) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Category icon and name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Category badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: space.category == 'coworking'
                        ? Colors.blue.shade100
                        : Colors.brown.shade100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _getCategoryLabel(space.category),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: space.category == 'coworking'
                          ? Colors.blue.shade700
                          : Colors.brown.shade700,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                // Name
                Text(
                  space.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                // WiFi indicator
                if (space.hasWifi)
                  const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.wifi, size: 12, color: Colors.green),
                      SizedBox(width: 2),
                      Text(
                        'WiFi',
                        style: TextStyle(fontSize: 10, color: Colors.green),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          // Distance
          const SizedBox(height: 4),
          Text(
            '${space.distanceKm.toStringAsFixed(2)} km',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, String error) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade400),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              error,
              style: TextStyle(color: Colors.red.shade700, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.location_off, color: Colors.grey.shade400),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'No se encontraron espacios de trabajo cercanos',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  String _getCategoryLabel(String category) {
    switch (category) {
      case 'coworking':
        return 'Coworking';
      case 'cafe':
        return 'Café';
      default:
        return 'Otro';
    }
  }
}