import 'package:flutter/material.dart';

import '../../domain/negotiation_rules.dart';

/// Slot integrable del aviso normativo Ley 7527 (HAB-29).
///
/// Visible cuando el plazo pactado es inferior a 3 años; la detección de
/// otras reglas y la redacción definitiva viven en HAB-29.
class LegalNoticeSlot extends StatelessWidget {
  final int? plazoMeses;

  const LegalNoticeSlot({super.key, required this.plazoMeses});

  @override
  Widget build(BuildContext context) {
    if (!shouldShowLegalNotice(plazoMeses)) {
      return const SizedBox.shrink();
    }
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Card(
      color: colors.surfaceContainerHighest.withValues(alpha: 0.6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.gavel_outlined, size: 24, color: colors.secondary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text('Aviso Normativo • Ley 7527',
                            style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold)),
                      ),
                      const Chip(
                        label: Text('HAB-29'),
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  RichText(
                    text: TextSpan(
                      style: theme.textTheme.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant),
                      children: [
                        const TextSpan(
                            text:
                                'El plazo pactado ('),
                        TextSpan(
                            text: '$plazoMeses meses',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold)),
                        const TextSpan(
                            text:
                                ') es inferior al plazo estándar legal de 3 años estipulado en Costa Rica. El sistema anexará automáticamente la cláusula de '),
                        TextSpan(
                            text:
                                'renuncia tácita temporal y prórroga expresa',
                            style: TextStyle(color: colors.secondary)),
                        const TextSpan(
                            text: ' para plena validez registral.'),
                      ],
                    ),
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
