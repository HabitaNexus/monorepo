import 'package:flutter/material.dart';

import '../atoms/space_type_icon.dart';
import '../models/nearby_space.dart';

// ---------------------------------------------------------------------------
// Molecule — tarjeta de un espacio en la lista horizontal
// ---------------------------------------------------------------------------

/// Tarjeta de espacio de trabajo (`[molecules]`).
///
/// Molécula pura: compone [SpaceTypeIcon] + textos del tema. Ancho fijo 140
/// para paridad con la lista horizontal de la ficha de propiedad.
class SpaceCard extends StatelessWidget {
  /// Espacio a mostrar.
  final NearbySpace space;

  const SpaceCard({
    super.key,
    required this.space,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final theme = Theme.of(context).textTheme;
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _CategoryBadge(type: space.type),
                const SizedBox(height: 6),
                Text(
                  space.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                if (space.hasWifi)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.wifi,
                          size: 12, color: colors.primary),
                      const SizedBox(width: 2),
                      Text(
                        'WiFi',
                        style: theme.labelSmall?.copyWith(
                          color: colors.primary,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${space.distanceKm.toStringAsFixed(2)} km',
            style: theme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Helpers privados — badge de categoría (detalle visual bajo el card)
// ---------------------------------------------------------------------------

class _CategoryBadge extends StatelessWidget {
  final SpaceType type;

  const _CategoryBadge({required this.type});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final (label, bg, fg) = switch (type) {
      SpaceType.coworking => (
          'Coworking',
          colors.primaryContainer,
          colors.onPrimaryContainer,
        ),
      SpaceType.cafe => (
          'Café',
          colors.secondaryContainer,
          colors.onSecondaryContainer,
        ),
      SpaceType.other => (
          'Otro',
          colors.surfaceContainerHigh,
          colors.onSurfaceVariant,
        ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: fg,
            ),
      ),
    );
  }
}
