import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/coworking_nearby_provider.dart';
import '../widgets/nearby_coworkings_widget.dart';

/// Página de detalle de una propiedad.
///
/// Muestra información de la propiedad y la sección
/// "Espacios de trabajo cerca" con coworkings y cafés con WiFi.
class PropertyDetailPage extends ConsumerStatefulWidget {
  final String propertyId;
  final String propertyName;
  final double latitude;
  final double longitude;
  final String? address;

  const PropertyDetailPage({
    super.key,
    required this.propertyId,
    required this.propertyName,
    required this.latitude,
    required this.longitude,
    this.address,
  });

  @override
  ConsumerState<PropertyDetailPage> createState() =>
      _PropertyDetailPageState();
}

class _PropertyDetailPageState extends ConsumerState<PropertyDetailPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.propertyName),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Property info card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: theme.cardColor,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.propertyName,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (widget.address != null)
                      Row(
                        children: [
                          Icon(Icons.location_on,
                              size: 16, color: Colors.grey.shade600),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              widget.address!,
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 8),
                    Text(
                      'Coordenadas: ${widget.latitude.toStringAsFixed(6)}, ${widget.longitude.toStringAsFixed(6)}',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Nearby coworkings section - uses the provider internally
            NearbyCoworkingsWidget(
              propertyLatitude: widget.latitude,
              propertyLongitude: widget.longitude,
              searchRadius: 2000,
              onViewFullSearch: _openFullSearch,
            ),
          ],
        ),
      ),
    );
  }

  void _openFullSearch() {
    // TODO: Implementar navegación al buscador de coworkings
    // con la ubicación de la propiedad preseleccionada.
    debugPrint(
        'Ver buscador completo - ubicación preseleccionada: '
        '${widget.latitude}, ${widget.longitude}');
  }
}