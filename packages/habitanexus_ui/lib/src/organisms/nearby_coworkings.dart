import 'package:flutter/material.dart';

import '../models/nearby_space.dart';
import '../molecules/space_card.dart';

// ---------------------------------------------------------------------------
// Organism — bloque "Espacios de trabajo cerca" (puro, sin providers)
// ---------------------------------------------------------------------------

/// Lista horizontal de espacios de trabajo cercanos (`[organisms]`).
///
/// Organismo puro: recibe `spaces`/`isLoading`/`error` por constructor y nunca
/// toca Riverpod. La app conecta su provider mediante un adaptador delgado;
/// widgetbook la monta con fixtures. Paridad visual con la ficha de propiedad.
class NearbyCoworkings extends StatelessWidget {
  /// Espacios a mostrar (se recorta a [maxItems]).
  final List<NearbySpace> spaces;

  /// Máximo visible en la lista horizontal.
  final int maxItems;

  /// Estado de carga (spinner, sin tarjetas).
  final bool isLoading;

  /// Mensaje de error (sin tarjetas).
  final String? error;

  /// Acción del botón "Ver buscador completo" (puede ser null).
  final VoidCallback? onViewFullSearch;

  const NearbyCoworkings({
    super.key,
    this.spaces = const [],
    this.maxItems = 5,
    this.isLoading = false,
    this.error,
    this.onViewFullSearch,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Espacios de trabajo cerca',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: onViewFullSearch,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              child: const Text('Ver buscador completo'),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Content
        _Content(
          spaces: spaces.take(maxItems).toList(),
          isLoading: isLoading,
          error: error,
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Helpers privados — estados de contenido (carga/error/vacío/lista)
// ---------------------------------------------------------------------------

class _Content extends StatelessWidget {
  final List<NearbySpace> spaces;
  final bool isLoading;
  final String? error;

  const _Content({
    required this.spaces,
    required this.isLoading,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SizedBox(
        height: 100,
        child: Center(child: CircularProgressIndicator.adaptive()),
      );
    }
    if (error != null) return _ErrorState(message: error!);
    if (spaces.isEmpty) return const _EmptyState();
    // 136 (no 120): cabe nombre a 2 líneas + fila WiFi hasta textScale 1.3x
    // sin overflow; el Spacer absorbe el aire extra a escala 1.0x.
    return SizedBox(
      height: 136,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: spaces.length,
        itemBuilder: (context, index) => SpaceCard(space: spaces[index]),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;

  const _ErrorState({required this.message});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.errorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: colors.error),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colors.onErrorContainer,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.location_off, color: colors.onSurfaceVariant),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'No se encontraron espacios de trabajo cercanos',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
