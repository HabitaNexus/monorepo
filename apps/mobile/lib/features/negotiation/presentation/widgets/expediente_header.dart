import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/demo_negotiation.dart';
import '../../domain/negotiation.dart';
import '../../domain/negotiation_rules.dart';
import '../providers/negotiation_providers.dart';

/// Encabezado del expediente: ronda/turno/deadline + rol demo conmutable.
class ExpedienteHeader extends ConsumerStatefulWidget {
  final NegotiationDetail detail;

  const ExpedienteHeader({super.key, required this.detail});

  @override
  ConsumerState<ExpedienteHeader> createState() => _ExpedienteHeaderState();
}

class _ExpedienteHeaderState extends ConsumerState<ExpedienteHeader> {
  Timer? _ticker;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final role = ref.watch(authRoleProvider);
    final detail = widget.detail;
    final turn = turnLabel(
        state: detail.state, role: role, lastAuthor: detail.lastAuthor);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('EXPEDIENTE HAB-27',
                              style: theme.textTheme.labelSmall?.copyWith(
                                  color: colors.primary,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(width: 6),
                          Text(DemoNegotiation.expediente,
                              style: theme.textTheme.labelSmall?.copyWith(
                                  color: colors.onSurfaceVariant)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(DemoNegotiation.propertyName,
                          style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold)),
                      Text(DemoNegotiation.propertyMeta,
                          style: theme.textTheme.bodySmall?.copyWith(
                              color: colors.onSurfaceVariant)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Chip(
                      label: Text(
                          'Ronda ${detail.state.round} de $kMaxRounds'),
                      backgroundColor:
                          colors.primaryContainer.withValues(alpha: 0.35),
                    ),
                    const SizedBox(height: 4),
                    Text(turn,
                        style: theme.textTheme.labelSmall?.copyWith(
                            color: colors.secondary,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: colors.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.timer_outlined,
                      size: 18, color: colors.primary),
                  const SizedBox(width: 8),
                  const Text('Plazo para responder:'),
                  const Spacer(),
                  Text(
                    formatRemaining(detail.state.deadline, _now),
                    style: theme.textTheme.titleSmall?.copyWith(
                        color: colors.primary,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 4),
                  Text('restantes',
                      style: theme.textTheme.labelSmall?.copyWith(
                          color: colors.onSurfaceVariant)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Rol por login — no elegible. Solo en debug muestra toggle para QA.
            if (kDebugMode) ...[
              Row(
                children: [
                  Text('Rol (debug):',
                      style: theme.textTheme.labelMedium?.copyWith(
                          color: colors.onSurfaceVariant)),
                  const SizedBox(width: 8),
                  SegmentedButton<NegotiationParty>(
                    segments: const [
                      ButtonSegment(
                          value: NegotiationParty.tenant,
                          label: Text('TENANT')),
                      ButtonSegment(
                          value: NegotiationParty.owner,
                          label: Text('OWNER')),
                    ],
                    selected: {role},
                    onSelectionChanged: (s) =>
                        ref.read(demoRoleProvider.notifier).state = s.first,
                  ),
                ],
              ),
            ] else ...[
              Row(
                children: [
                  Icon(
                    role == NegotiationParty.tenant
                        ? Icons.person_outline
                        : Icons.business_outlined,
                    size: 16,
                    color: colors.onSurfaceVariant,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    role == NegotiationParty.tenant
                        ? 'Sesión: Inquilino'
                        : 'Sesión: Propietario',
                    style: theme.textTheme.labelMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: colors.primaryContainer.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      role == NegotiationParty.tenant ? 'TENANT' : 'OWNER',
                      style: theme.textTheme.labelSmall?.copyWith(
                          color: colors.primary, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
            if (!detail.fromBackend)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text('Modo demo local — sin backend.',
                    style: theme.textTheme.labelSmall?.copyWith(
                        color: colors.onSurfaceVariant)),
              ),
          ],
        ),
      ),
    );
  }
}
