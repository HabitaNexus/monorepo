import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trustless_work_dart/trustless_work_dart.dart';

import 'trustless_work_client_provider.dart';

/// Streams [EscrowEvent]s for a given contract id.
///
/// Uses the hybrid Horizon SSE + Soroban events stream under the hood
/// (see `TrustlessWorkClient.escrowEvents`).
///
/// ```dart
/// final eventsAsync = ref.watch(escrowEventsProvider('CABC...'));
/// ```
final escrowEventsProvider = StreamProvider.family<EscrowEvent, String>(
  (ref, contractId) =>
      ref.watch(trustlessWorkClientProvider).escrowEvents(contractId),
);
