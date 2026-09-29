import 'package:flutter/material.dart';

import '../../data/terms_mapping.dart';
import '../../domain/negotiation.dart';

/// Iconos por grupo (resueltos en presentación; el dominio no conoce iconos).
IconData groupIcon(NegotiationTermGroup group) {
  switch (group) {
    case NegotiationTermGroup.economicos:
      return Icons.payments_outlined;
    case NegotiationTermGroup.plazo:
      return Icons.calendar_month_outlined;
    case NegotiationTermGroup.mascotas:
      return Icons.pets_outlined;
    case NegotiationTermGroup.servicios:
      return Icons.bolt_outlined;
    case NegotiationTermGroup.modificaciones:
      return Icons.handyman_outlined;
    case NegotiationTermGroup.usos:
      return Icons.domain_outlined;
    case NegotiationTermGroup.fijas:
      return Icons.verified_outlined;
  }
}

/// Sección de un grupo con sus tarjetas de comparación lado a lado.
class TermGroupSection extends StatelessWidget {
  final NegotiationTermGroup group;
  final List<RowComparison> rows;
  final String baseLabel;
  final String currentLabel;

  const TermGroupSection({
    super.key,
    required this.group,
    required this.rows,
    required this.baseLabel,
    required this.currentLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final fixedCount =
        rows.where((r) => _mapping(r).isFixed).length;
    final subtitle = group == NegotiationTermGroup.fijas
        ? '$fixedCount fijas SOP'
        : '${rows.length} términos';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: colors.surfaceContainerHighest.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(groupIcon(group), size: 18, color: colors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(group.title,
                    style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold)),
              ),
              Text(subtitle,
                  style: theme.textTheme.labelSmall?.copyWith(
                      color: colors.onSurfaceVariant)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        for (final row in rows) ...[
          TermCompareCard(
            row: row,
            baseLabel: baseLabel,
            currentLabel: currentLabel,
          ),
          const SizedBox(height: 8),
        ],
      ],
    );
  }

  TermMapping _mapping(RowComparison row) => kTermsMapping
      .firstWhere((m) => m.number == row.number);
}

/// Tarjeta lado a lado "Tu Propuesta vs Contrapropuesta" con badge
/// DIFF/ACUERDO. Las cláusulas fijas SOP se muestran a ancho completo.
class TermCompareCard extends StatelessWidget {
  final RowComparison row;
  final String baseLabel;
  final String currentLabel;

  const TermCompareCard({
    super.key,
    required this.row,
    required this.baseLabel,
    required this.currentLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final mapping = kTermsMapping.firstWhere(
      (m) => m.number == row.number,
      orElse: () => TermMapping(
          number: row.number,
          uiLabel: row.apiKey,
          apiKey: row.apiKey,
          group: NegotiationTermGroup.usos),
    );

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text('${mapping.number}. ${mapping.uiLabel}',
                      style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600)),
                ),
                if (mapping.isFixed)
                  Text(mapping.sopRef ?? 'SOP',
                      style: theme.textTheme.labelSmall?.copyWith(
                          color: colors.primary,
                          fontFamily: 'monospace'))
                else
                  _Badge(diff: row.isDiff),
              ],
            ),
            const SizedBox(height: 8),
            if (mapping.isFixed)
              Text(row.current.isEmpty ? row.base : row.current,
                  style: theme.textTheme.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant))
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _Side(
                        label: baseLabel,
                        value: row.base,
                        highlighted: false),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _Side(
                        label: currentLabel,
                        value: row.current,
                        highlighted: row.isDiff),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final bool diff;

  const _Badge({required this.diff});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: diff
            ? colors.surfaceContainerHighest
            : colors.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
              diff
                  ? Icons.change_circle_outlined
                  : Icons.check_circle_outlined,
              size: 13,
              color: colors.secondary),
          const SizedBox(width: 4),
          Text(diff ? 'DIFF' : 'ACUERDO',
              style: theme.textTheme.labelSmall?.copyWith(
                  color: colors.secondary, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _Side extends StatelessWidget {
  final String label;
  final String value;
  final bool highlighted;

  const _Side(
      {required this.label, required this.value, required this.highlighted});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: highlighted
            ? colors.surfaceContainerHigh
            : colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: theme.textTheme.labelSmall?.copyWith(
                  color: highlighted
                      ? colors.secondary
                      : colors.onSurfaceVariant)),
          const SizedBox(height: 2),
          Text(value.isEmpty ? '—' : value,
              style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight:
                      highlighted ? FontWeight.w600 : null,
                  color: highlighted ? colors.primary : null)),
        ],
      ),
    );
  }
}
