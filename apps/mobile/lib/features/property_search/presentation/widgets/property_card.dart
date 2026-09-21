/// Tarjeta de propiedad en resultados de búsqueda (HAB-18).
///
/// Muestra información resumida con opciones de favorito y comparar.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/property.dart';
import '../providers/property_search_providers.dart';

class PropertyCard extends ConsumerWidget {
  final Property property;
  final VoidCallback? onTap;

  const PropertyCard({
    super.key,
    required this.property,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final favorites = ref.watch(favoritesProvider);
    final comparison = ref.watch(comparisonProvider);
    final isFavorite = favorites.contains(property.id);
    final isSelectedForComparison = comparison.contains(property.id);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isSelectedForComparison
            ? BorderSide(color: colors.primary, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Imagen de la propiedad
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: property.imageUrl != null
                    ? Image.network(
                        property.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: colors.surfaceContainerHighest,
                          child: Icon(
                            Icons.home,
                            size: 48,
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      )
                    : Container(
                        color: colors.surfaceContainerHighest,
                        child: Icon(
                          Icons.home,
                          size: 48,
                          color: colors.onSurfaceVariant,
                        ),
                      ),
              ),
            ),

            // Contenido
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título y estado de verificación
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          property.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (property.verificationStatus ==
                          VerificationStatus.verified)
                        Icon(
                          Icons.verified,
                          size: 18,
                          color: Colors.green,
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Dirección
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 14,
                        color: colors.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          property.address,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Precio
                  Text(
                    '${property.formattedPrice}/mes',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Características
                  Row(
                    children: [
                      _FeatureChip(
                        icon: Icons.bed,
                        label: '${property.bedrooms} hab',
                      ),
                      const SizedBox(width: 8),
                      _FeatureChip(
                        icon: Icons.bathtub,
                        label: '${property.bathrooms} baño',
                      ),
                      const SizedBox(width: 8),
                      _FeatureChip(
                        icon: Icons.square_foot,
                        label: '${property.areaM2.round()}m²',
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Mascotas
                  if (property.petPolicy != PetType.none)
                    Row(
                      children: [
                        Icon(
                          Icons.pets,
                          size: 14,
                          color: colors.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          property.petPolicy.label,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 8),

                  // Acciones
                  Row(
                    children: [
                      // Favorito
                      IconButton(
                        icon: Icon(
                          isFavorite ? Icons.star : Icons.star_border,
                          color: isFavorite ? Colors.amber : colors.onSurfaceVariant,
                        ),
                        onPressed: () {
                          ref.read(favoritesProvider.notifier).toggleFavorite(property.id);
                        },
                        tooltip: isFavorite ? 'Quitar de favoritos' : 'Agregar a favoritos',
                      ),

                      // Comparar
                      IconButton(
                        icon: Icon(
                          isSelectedForComparison
                              ? Icons.compare_arrows
                              : Icons.compare_arrows_outlined,
                          color: isSelectedForComparison ? colors.primary : colors.onSurfaceVariant,
                        ),
                        onPressed: () {
                          ref.read(comparisonProvider.notifier).toggleComparison(property.id);
                        },
                        tooltip: isSelectedForComparison
                            ? 'Quitar de comparación'
                            : 'Agregar a comparación',
                      ),

                      const Spacer(),

                      // Tiempo
                      Text(
                        property.timeAgo,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Chip de característica
class _FeatureChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FeatureChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: colors.onSurfaceVariant,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
