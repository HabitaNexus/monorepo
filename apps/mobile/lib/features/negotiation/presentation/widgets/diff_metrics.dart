import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/negotiation.dart';
import '../providers/negotiation_providers.dart';

/// Métricas del diff (acuerdo/diff) con filtros Todos / Solo Diff / Acuerdo.
class DiffMetrics extends ConsumerWidget {
  final int agreedCount;
  final int diffCount;

  const DiffMetrics(
      {super.key, required this.agreedCount, required this.diffCount});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final filter = ref.watch(termFilterProvider);
    final total = agreedCount + diffCount;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.difference_outlined,
                    size: 20, color: colors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Métricas del Diff',
                          style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold)),
                      Text('34 términos normados en Ley 7527',
                          style: theme.textTheme.bodySmall?.copyWith(
                              color: colors.onSurfaceVariant)),
                    ],
                  ),
                ),
                const Chip(
                  label: Text('SHA: 8a4b…2f1',
                      style: TextStyle(fontFamily: 'monospace')),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _Stat(
                      label: 'En Acuerdo',
                      value: agreedCount,
                      dotColor: colors.secondary),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _Stat(
                      label: 'Con Diferencias',
                      value: diffCount,
                      dotColor: colors.error),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SegmentedButton<TermFilter>(
              segments: [
                ButtonSegment(
                    value: TermFilter.all, label: Text('Todos ($total)')),
                ButtonSegment(
                    value: TermFilter.diff,
                    label: Text('Solo Diff ($diffCount)')),
                ButtonSegment(
                    value: TermFilter.agreed,
                    label: Text('Acuerdo ($agreedCount)')),
              ],
              selected: {filter},
              onSelectionChanged: (s) =>
                  ref.read(termFilterProvider.notifier).state = s.first,
            ),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final int value;
  final Color dotColor;

  const _Stat(
      {required this.label, required this.value, required this.dotColor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration:
                BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(label, style: theme.textTheme.bodySmall)),
          Text('$value',
              style: theme.textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
