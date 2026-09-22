import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// Types — categoría tipada del espacio (API pública del átomo)
// ---------------------------------------------------------------------------

/// Categoría de espacio de trabajo para [SpaceTypeIcon].
enum SpaceType {
  /// Coworking / oficina flexible.
  coworking,

  /// Café con WiFi.
  cafe,

  /// Cualquier otra categoría (fallback visual neutro).
  other,
}

// ---------------------------------------------------------------------------
// Atom — icono de categoría con badge redondeado del tema
// ---------------------------------------------------------------------------

/// Icono de categoría de espacio (`[atoms]`).
///
/// Átomo puro: todo entra por constructor, colores del `ColorScheme` activo.
/// Paridad visual con la ficha de propiedad (badge + icono por categoría).
class SpaceTypeIcon extends StatelessWidget {
  /// Categoría a representar.
  final SpaceType type;

  /// Lado del badge en px (el icono ocupa ~55%).
  final double size;

  const SpaceTypeIcon({
    super.key,
    required this.type,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final (icon, bg, fg) = switch (type) {
      SpaceType.coworking => (
          Icons.work_outline,
          colors.primaryContainer,
          colors.onPrimaryContainer,
        ),
      SpaceType.cafe => (
          Icons.local_cafe_outlined,
          colors.secondaryContainer,
          colors.onSecondaryContainer,
        ),
      SpaceType.other => (
          Icons.place_outlined,
          colors.surfaceContainerHigh,
          colors.onSurfaceVariant,
        ),
    };
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(size / 4),
      ),
      child: Icon(icon, size: size * 0.55, color: fg),
    );
  }
}
