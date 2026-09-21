import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/app_bottom_nav.dart';
import '../providers/negotiation_providers.dart';
import '../widgets/negotiation_body.dart';

/// Pantalla de negociación: propuestas y contrapropuestas (HAB-27).
///
/// Sin `negotiationId` muestra la demo local del diseño Stitch; con id
/// carga del backend HAB-26. La UI nunca decide estado: turno y botones
/// derivan del `state` del servidor.
class NegotiationDetailPage extends ConsumerStatefulWidget {
  final String? negotiationId;

  const NegotiationDetailPage({super.key, this.negotiationId});

  @override
  ConsumerState<NegotiationDetailPage> createState() =>
      _NegotiationDetailPageState();
}

class _NegotiationDetailPageState
    extends ConsumerState<NegotiationDetailPage> {
  @override
  Widget build(BuildContext context) {
    final async =
        ref.watch(negotiationControllerProvider(widget.negotiationId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Negociación'),
        actions: [
          IconButton(
            tooltip: 'Ir a firma digital',
            icon: const Icon(Icons.draw_outlined),
            onPressed: () => context.push('/contrato'),
          ),
        ],
      ),
      body: async.when(
        loading: () =>
            const Center(child: CircularProgressIndicator()),
        error: (e, _) => _ErrorView(
          message: e.toString(),
          onRetry: () => ref
              .read(negotiationControllerProvider(widget.negotiationId)
                  .notifier)
              .refresh(),
        ),
        data: (detail) => NegotiationBody(
          detail: detail,
          negotiationId: widget.negotiationId,
        ),
      ),
      bottomNavigationBar: const AppBottomNav(current: AppNavTab.pactos),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_outlined,
                size: 48, color: theme.colorScheme.error),
            const SizedBox(height: 12),
            Text('No se pudo cargar la negociación',
                style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(message,
                style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant),
                textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_outlined),
              label: const Text('Reintentar'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => context.go('/negociacion'),
              child: const Text('Abrir demo local'),
            ),
          ],
        ),
      ),
    );
  }
}
