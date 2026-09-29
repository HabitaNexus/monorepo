import 'package:flutter/material.dart';

import '../../domain/negotiation.dart';
import '../../domain/negotiation_rules.dart';

/// Barra de acciones sticky: canon final + Contraproponer / Aceptar /
/// Desistir / Exportar PDF. La habilitación deriva del `state` del servidor;
/// en acuerdo muestra la confirmación bilateral; en terminales, un banner.
class NegotiationActionBar extends StatelessWidget {
  final NegotiationDetail detail;
  final int diffCount;
  final String canonLabel;
  final bool canAct;
  final bool partyConfirmed;
  final String roleLabel;
  final VoidCallback? onCounter;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;
  final VoidCallback? onExport;
  final VoidCallback? onConfirmSummary;

  const NegotiationActionBar({
    super.key,
    required this.detail,
    required this.diffCount,
    required this.canonLabel,
    required this.canAct,
    required this.partyConfirmed,
    required this.roleLabel,
    this.onCounter,
    this.onAccept,
    this.onReject,
    this.onExport,
    this.onConfirmSummary,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final status = detail.state.status;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (status == NegotiationStatus.acuerdoAlcanzado) ...[
              _confirmBox(context),
            ] else if (detail.state.isTerminal) ...[
              _terminalBox(context),
            ] else ...[
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Canon acordado final:',
                            style: theme.textTheme.labelSmall?.copyWith(
                                color: colors.onSurfaceVariant)),
                        Text(canonLabel,
                            style: theme.textTheme.titleMedium?.copyWith(
                                color: colors.primary,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('$diffCount diferencias pendientes',
                          style: theme.textTheme.labelSmall?.copyWith(
                              color: colors.secondary,
                              fontWeight: FontWeight.w600)),
                      Text('Aceptas o contrapropones',
                          style: theme.textTheme.labelSmall?.copyWith(
                              color: colors.onSurfaceVariant)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: canAct ? onCounter : null,
                      icon: const Icon(Icons.tune_outlined),
                      label: Text(
                          'Contraproponer R${detail.state.round + 1}'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: canAct ? onAccept : null,
                      icon: const Icon(Icons.verified_outlined),
                      label: const Text('Aceptar Términos'),
                    ),
                  ),
                ],
              ),
              if (!canAct)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                      'Ronda cerrada o plazo vencido: solo el servidor habilita acciones.',
                      style: theme.textTheme.labelSmall?.copyWith(
                          color: colors.onSurfaceVariant),
                      textAlign: TextAlign.center),
                ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: canAct ? onReject : null,
                    icon: const Icon(Icons.cancel_outlined, size: 15),
                    label: const Text('Desistir de oferta'),
                    style: TextButton.styleFrom(
                        foregroundColor: colors.error),
                  ),
                  TextButton.icon(
                    onPressed: onExport,
                    icon: const Icon(Icons.download_outlined, size: 15),
                    label: const Text('Exportar PR PDF'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _confirmBox(BuildContext context) {
    final theme = Theme.of(context);
    final s = detail.state;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Acuerdo alcanzado — confirmación bilateral',
            style: theme.textTheme.titleSmall
                ?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
                child: _confirmChip(context, 'TENANT', s.tenantConfirmed)),
            const SizedBox(width: 8),
            Expanded(
                child: _confirmChip(context, 'OWNER', s.ownerConfirmed)),
          ],
        ),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: partyConfirmed ? null : onConfirmSummary,
          icon: const Icon(Icons.fact_check_outlined),
          label: Text(partyConfirmed
              ? 'Resumen confirmado ($roleLabel)'
              : 'Confirmar resumen ($roleLabel)'),
        ),
      ],
    );
  }

  Widget _confirmChip(
      BuildContext context, String label, bool confirmed) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
              confirmed
                  ? Icons.check_circle
                  : Icons.pending_outlined,
              size: 16,
              color: confirmed ? colors.primary : colors.onSurfaceVariant),
          const SizedBox(width: 6),
          Text(label, style: theme.textTheme.labelMedium),
        ],
      ),
    );
  }

  Widget _terminalBox(BuildContext context) {
    final theme = Theme.of(context);
    final reason = detail.state.reason;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Negociación ${statusLabel(detail.state.status).toLowerCase()}',
            style: theme.textTheme.titleSmall
                ?.copyWith(fontWeight: FontWeight.bold)),
        if (reason != null && reason.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text('Motivo: $reason',
                style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant)),
          ),
        const SizedBox(height: 4),
        Text('Estado terminal: el servidor no acepta más acciones.',
            style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant)),
      ],
    );
  }
}
