import 'package:flutter/material.dart';

import '../../domain/negotiation.dart';
import '../../domain/negotiation_rules.dart';

/// Slot integrable de la calculadora fiduciaria escrow (HAB-28).
///
/// Muestra el desglose con los inputs actuales; la lógica definitiva vive
/// en HAB-28 y este widget ya acepta sus parámetros.
class EscrowSlot extends StatelessWidget {
  final double canon;
  final double depositMonths;
  final double feeRate;

  const EscrowSlot({
    super.key,
    required this.canon,
    this.depositMonths = 1,
    this.feeRate = 0.015,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final EscrowBreakdown b = computeEscrow(
        canon: canon, depositMonths: depositMonths, feeRate: feeRate);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.account_balance_outlined,
                    size: 20, color: colors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Cálculo Fiduciario Escrow',
                          style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold)),
                      Text('Módulo HAB-28 • Banco Custodio BCCR',
                          style: theme.textTheme.labelSmall?.copyWith(
                              color: colors.onSurfaceVariant)),
                    ],
                  ),
                ),
                Chip(
                  label: Text('EN VIVO',
                      style: theme.textTheme.labelSmall?.copyWith(
                          color: colors.primary,
                          fontWeight: FontWeight.bold)),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            const SizedBox(height: 12),
            _line(context, 'Canon mensual propuesto:',
                formatColones(b.canon)),
            _line(context, 'Fianza en garantía (1 mes en Escrow):',
                formatColones(b.deposito)),
            _line(context, 'Comisión fiduciaria neutral (1.5%):',
                formatColones(b.comision)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: colors.surfaceContainerHighest
                    .withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Text('Costo Total de Ingreso:',
                      style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold)),
                  const Spacer(),
                  Text(formatColones(b.total),
                      style: theme.textTheme.titleLarge?.copyWith(
                          color: colors.primary,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.verified_user_outlined,
                    size: 14, color: colors.secondary),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                      'Fondos inmovilizados hasta entrega pericial mediante SOP-04.',
                      style: theme.textTheme.labelSmall?.copyWith(
                          color: colors.onSurfaceVariant)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _line(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
            child: Text(label,
                style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant)),
          ),
          Text(value,
              style: theme.textTheme.bodySmall
                  ?.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
