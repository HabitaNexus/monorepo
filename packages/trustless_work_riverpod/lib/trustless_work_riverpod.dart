/// Riverpod providers for Trustless Work escrow operations.
///
/// Companion to `package:trustless_work_dart`. Provides typed read-only
/// providers for escrow queries, event streams, indexer queries, and
/// balance queries. Consumers supply a configured `TrustlessWorkClient`
/// via `trustlessWorkClientProvider.overrideWithValue(...)`.
///
/// Mutations (fund, release, dispute, etc.) are intentionally excluded
/// — call them imperatively via `ref.read(trustlessWorkClientProvider)`.
library trustless_work_riverpod;

export 'src/providers/trustless_work_client_provider.dart';
export 'src/providers/escrow_query_providers.dart';
export 'src/providers/escrow_events_provider.dart';
export 'src/providers/indexer_query_providers.dart';
