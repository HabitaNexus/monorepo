import 'package:flutter/material.dart';

import '../../domain/negotiation.dart';

/// Timeline de rondas auditable (R1/R2/R3) según SOP-04.
class RoundsTimeline extends StatelessWidget {
  final List<RoundEntry> rounds;

  const RoundsTimeline({super.key, required this.rounds});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.history_edu, size: 16, color: colors.primary),
            const SizedBox(width: 6),
            Text('REGISTRO DE RONDAS',
                style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600)),
            const Spacer(),
            Row(
              children: [
                Icon(Icons.lock_outline, size: 13, color: colors.secondary),
                const SizedBox(width: 4),
                Text('SOP-04 Blockchain',
                    style: theme.textTheme.labelSmall
                        ?.copyWith(color: colors.secondary)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            for (var i = 0; i < rounds.length; i++) ...[
              Expanded(child: _RoundCard(entry: rounds[i])),
              if (i < rounds.length - 1) const SizedBox(width: 8),
            ],
          ],
        ),
      ],
    );
  }
}

class _RoundCard extends StatelessWidget {
  final RoundEntry entry;

  const _RoundCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Card(
      color: entry.isCurrent
          ? colors.surfaceContainerHigh
          : colors.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(entry.authorLabel,
                      style: theme.textTheme.labelSmall?.copyWith(
                          color: entry.isCurrent
                              ? colors.primary
                              : colors.onSurfaceVariant,
                          fontWeight: entry.isCurrent
                              ? FontWeight.bold
                              : null)),
                ),
                Icon(
                    entry.isCurrent
                        ? Icons.edit_note
                        : Icons.lock_clock_outlined,
                    size: 14,
                    color: entry.isCurrent
                        ? colors.primary
                        : colors.onSurfaceVariant),
              ],
            ),
            const SizedBox(height: 4),
            Text(entry.dateLabel,
                style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600)),
            Text(entry.detailLabel,
                style: theme.textTheme.labelSmall
                    ?.copyWith(color: colors.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}
