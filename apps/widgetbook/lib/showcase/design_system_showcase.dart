import 'package:flutter/material.dart';

/// Showcase del Design System de HabitaNexus — ColorScheme M3 generado
/// desde el seed #1A5276 (ver `core/theme/app_theme.dart`) y tipografía.
class DesignSystemShowcase extends StatelessWidget {
  const DesignSystemShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final roles = <String, Color>{
      'primary': scheme.primary,
      'onPrimary': scheme.onPrimary,
      'primaryContainer': scheme.primaryContainer,
      'secondary': scheme.secondary,
      'secondaryContainer': scheme.secondaryContainer,
      'tertiary': scheme.tertiary,
      'error': scheme.error,
      'surface': scheme.surface,
      'surfaceContainerHighest': scheme.surfaceContainerHighest,
      'outline': scheme.outline,
    };

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'ColorScheme M3 (seed #1A5276)',
          style: textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final entry in roles.entries)
              _ColorSwatchTile(label: entry.key, color: entry.value),
          ],
        ),
        const SizedBox(height: 24),
        Text('Tipografía', style: textTheme.titleLarge),
        const SizedBox(height: 12),
        for (final sample in {
          'Headline Large': textTheme.headlineLarge,
          'Title Large': textTheme.titleLarge,
          'Body Large': textTheme.bodyLarge,
          'Body Medium': textTheme.bodyMedium,
          'Label Small': textTheme.labelSmall,
        }.entries)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(sample.key, style: sample.value),
          ),
      ],
    );
  }
}

class _ColorSwatchTile extends StatelessWidget {
  final String label;
  final Color color;

  const _ColorSwatchTile({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 130,
          height: 64,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Theme.of(context).colorScheme.outline),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.labelMedium),
      ],
    );
  }
}
