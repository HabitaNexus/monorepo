import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trustless_work_dart/trustless_work_dart.dart';

import 'trustless_work_client_provider.dart';

/// Fetches a single-release [Escrow] by contract id.
///
/// ```dart
/// final escrowAsync = ref.watch(escrowProvider('CABC...'));
/// ```
final escrowProvider = FutureProvider.family<Escrow, String>(
  (ref, contractId) =>
      ref.watch(trustlessWorkClientProvider).getEscrow(contractId),
);

/// Fetches a [MultiReleaseEscrow] by contract id.
///
/// ```dart
/// final escrowAsync = ref.watch(multiReleaseEscrowProvider('CABC...'));
/// ```
final multiReleaseEscrowProvider =
    FutureProvider.family<MultiReleaseEscrow, String>(
  (ref, contractId) =>
      ref.watch(trustlessWorkClientProvider).getMultiReleaseEscrow(contractId),
);
