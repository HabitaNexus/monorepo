import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/demo_negotiation.dart';
import '../../data/terms_mapping.dart';
import '../../domain/negotiation.dart';
import '../../domain/negotiation_rules.dart';
import '../providers/negotiation_providers.dart';
import 'counter_sheet.dart';
import 'diff_metrics.dart';
import 'escrow_slot.dart';
import 'expediente_header.dart';
import 'legal_notice_slot.dart';
import 'negotiation_action_bar.dart';
import 'rounds_timeline.dart';
import 'term_compare_card.dart';

class NegotiationBody extends ConsumerWidget {
  final NegotiationDetail detail;
  final String? negotiationId;

  const NegotiationBody({super.key, required this.detail, required this.negotiationId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(authRoleProvider);
    final filter = ref.watch(termFilterProvider);
    final comparisons = compareRows(detail, rowSpecs());
    final diffs = comparisons.where((c) => c.isDiff).toList();
    final agreed = comparisons.length - diffs.length;
    final now = DateTime.now();
    final canAct = canActOnRound(detail.state, now);

    final visible = comparisons.where((c) {
      switch (filter) {
        case TermFilter.all:
          return true;
        case TermFilter.diff:
          return c.isDiff;
        case TermFilter.agreed:
          return !c.isDiff;
      }
    }).toList();

    final canonRow = comparisons.firstWhere((c) => c.number == 1);
    final plazoRow = comparisons.firstWhere((c) => c.number == 5);
    final canon = parseMonto(canonRow.current);
    final plazoMeses = parsePlazoMeses(plazoRow.current);

    final partyConfirmed = role == NegotiationParty.tenant
        ? detail.state.tenantConfirmed
        : detail.state.ownerConfirmed;

    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 220),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ExpedienteHeader(detail: detail),
              const SizedBox(height: 12),
              RoundsTimeline(rounds: _roundsFor(detail)),
              const SizedBox(height: 12),
              DiffMetrics(agreedCount: agreed, diffCount: diffs.length),
              const SizedBox(height: 12),
              EscrowSlot(canon: canon),
              const SizedBox(height: 12),
              LegalNoticeSlot(plazoMeses: plazoMeses),
              const SizedBox(height: 12),
              _CompareHeader(baseLabel: _baseLabel(role), currentLabel: _currentLabel(role)),
              const SizedBox(height: 8),
              for (final group in NegotiationTermGroup.values)
                _groupSection(group, visible, role),
            ],
          ),
        ),
        Positioned(
          left: 16,
          right: 16,
          bottom: 12,
          child: NegotiationActionBar(
            detail: detail,
            diffCount: diffs.length,
            canonLabel: '${canonRow.current} / mes',
            canAct: canAct,
            partyConfirmed: partyConfirmed,
            roleLabel: negotiationPartyToApi(role),
            onCounter: () => _onCounter(context, ref, diffs),
            onAccept: () => _onAccept(context, ref),
            onReject: () => _onReject(context, ref),
            onExport: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Exportar PDF disponible próximamente (placeholder).')),
            ),
            onConfirmSummary: () => ref.read(negotiationControllerProvider(negotiationId).notifier).confirmSummary(),
          ),
        ),
      ],
    );
  }

  Widget _groupSection(NegotiationTermGroup group, List<RowComparison> visible, NegotiationParty role) {
    final rows = visible.where((c) => kTermsMapping.firstWhere((m) => m.number == c.number).group == group).toList();
    if (rows.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TermGroupSection(group: group, rows: rows, baseLabel: _baseLabel(role), currentLabel: _currentLabel(role)),
    );
  }

  String _baseLabel(NegotiationParty role) => role == NegotiationParty.tenant ? 'Tu Propuesta' : 'Propuesta';
  String _currentLabel(NegotiationParty role) => role == NegotiationParty.owner ? 'Tu Contrapropuesta' : 'Contrapropuesta';

  List<RoundEntry> _roundsFor(NegotiationDetail detail) {
    if (!detail.fromBackend) return DemoNegotiation.rounds;
    return List.generate(detail.state.round, (i) {
      final n = i + 1;
      final isCurrent = n == detail.state.round;
      return RoundEntry(round: n, authorLabel: isCurrent ? 'R$n • Actual' : 'R$n', dateLabel: isCurrent ? 'En revisión' : 'Registrada', detailLabel: isCurrent ? 'ronda vigente' : 'ver SOP-04', isCurrent: isCurrent);
    });
  }

  Future<void> _onCounter(BuildContext context, WidgetRef ref, List<RowComparison> diffs) async {
    final edited = await showCounterSheet(context: context, diffRows: diffs, nextRoundLabel: 'R${detail.state.round + 1}');
    if (edited == null || edited.isEmpty) return;
    if (!context.mounted) return;
    await ref.read(negotiationControllerProvider(negotiationId).notifier).counter(edited);
    if (!context.mounted) return;
    final err = ref.read(negotiationControllerProvider(negotiationId)).error;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err == null ? 'Contrapropuesta enviada.' : 'No se pudo enviar: $err')));
  }

  Future<void> _onAccept(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Aceptar términos'),
        content: const Text('Aceptas la contrapropuesta vigente. El acuerdo requerirá confirmación bilateral del resumen.'),
        actions: [TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancelar')), FilledButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Aceptar'))],
      ),
    );
    if (ok != true || !context.mounted) return;
    await ref.read(negotiationControllerProvider(negotiationId).notifier).accept();
    if (!context.mounted) return;
    final err = ref.read(negotiationControllerProvider(negotiationId)).error;
    if (err != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No se pudo aceptar: $err')));
      return;
    }
    // Acuerdo aceptado -> Contrato (firma).
    context.go('/contrato');
  }

  Future<void> _onReject(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController();
    final reason = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Desistir de oferta'),
        content: TextField(controller: controller, decoration: const InputDecoration(labelText: 'Motivo (obligatorio)', border: OutlineInputBorder()), maxLines: 2),
        actions: [TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancelar')), FilledButton(onPressed: () => Navigator.of(ctx).pop(controller.text.trim()), child: const Text('Desistir'))],
      ),
    );
    controller.dispose();
    if (reason == null || reason.isEmpty || !context.mounted) return;
    await ref.read(negotiationControllerProvider(negotiationId).notifier).reject(reason);
    if (!context.mounted) return;
    final err = ref.read(negotiationControllerProvider(negotiationId)).error;
    if (err != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No se pudo desistir: $err')));
      return;
    }
    // Desistimiento -> home (barra de navegación).
    context.go('/');
  }
}

class _CompareHeader extends StatelessWidget {
  final String baseLabel;
  final String currentLabel;
  const _CompareHeader({required this.baseLabel, required this.currentLabel});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(children: [
      Row(children: [
        Expanded(child: Text('Términos Comparados', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold))),
        Text('Pull Request View', style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
      ]),
      const SizedBox(height: 8),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(color: theme.colorScheme.surfaceContainerLow, borderRadius: BorderRadius.circular(8)),
        child: Row(children: [
          Expanded(child: Column(children: [Text(baseLabel, style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w600)), Text(DemoNegotiation.tenantLabel, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant))])),
          Expanded(child: Column(children: [Text(currentLabel, style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.secondary, fontWeight: FontWeight.w600)), Text(DemoNegotiation.ownerLabel, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant))])),
        ]),
      ),
    ]);
  }
}
