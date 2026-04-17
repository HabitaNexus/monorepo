# trustless_work_riverpod

Riverpod providers for the [Trustless Work](https://trustlesswork.com) escrow SDK.

## What it IS

- Typed Riverpod providers for read operations: escrow queries, event streams, indexer queries, balance queries.
- Consumer provides the `TrustlessWorkClient` via provider override — fully signer-agnostic and config-agnostic.

## What it IS NOT

- **Not a wallet** — use `trustless_work_flutter_storage` for that.
- **Not a UI toolkit** — you write your own widgets.
- **Not for mutations** — use `ref.read(trustlessWorkClientProvider).fundEscrow(...)` directly.

## Quickstart

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trustless_work_dart/trustless_work_dart.dart';
import 'package:trustless_work_riverpod/trustless_work_riverpod.dart';

void main() {
  final client = TrustlessWorkClient(
    config: TrustlessWorkConfig.testnet(apiKey: 'YOUR_KEY'),
    signer: myTransactionSigner,
  );

  runApp(
    ProviderScope(
      overrides: [
        trustlessWorkClientProvider.overrideWithValue(client),
      ],
      child: const MyApp(),
    ),
  );
}

// In a widget:
class EscrowDetailScreen extends ConsumerWidget {
  const EscrowDetailScreen({super.key, required this.contractId});
  final String contractId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final escrowAsync = ref.watch(escrowProvider(contractId));
    return escrowAsync.when(
      data: (escrow) => Text(escrow.title),
      loading: () => const CircularProgressIndicator(),
      error: (e, st) => Text('Error: $e'),
    );
  }
}
```

## Providers

| Provider | Type | Wrapped method |
|---|---|---|
| `trustlessWorkClientProvider` | `Provider<TrustlessWorkClient>` | Override with your client instance |
| `escrowProvider` | `FutureProvider.family<Escrow, String>` | `getEscrow(contractId)` |
| `multiReleaseEscrowProvider` | `FutureProvider.family<MultiReleaseEscrow, String>` | `getMultiReleaseEscrow(contractId)` |
| `escrowEventsProvider` | `StreamProvider.family<EscrowEvent, String>` | `escrowEvents(contractId)` |
| `escrowsByRoleProvider` | `FutureProvider.family<..., ({IndexerRole role, String user})>` | `getEscrowsFromIndexerByRole(...)` |
| `escrowsBySignerProvider` | `FutureProvider.family<..., String>` | `getEscrowsFromIndexerBySigner(signer)` |
| `escrowsByContractIdsProvider` | `FutureProvider.family<..., ({List<String> contractIds, bool validateOnChain})>` | `getEscrowFromIndexerByContractIds(...)` |
| `escrowBalancesProvider` | `FutureProvider.family<..., List<String>>` | `getMultipleEscrowBalances(addresses)` |

### Note on `escrowBalancesProvider` and `List` equality

`FutureProvider.family` uses `==` to compare keys. Dart `List` uses reference
equality by default, so calling `escrowBalancesProvider(['A', 'B'])` twice
with two different list literals creates **two** provider instances. If you
need deduplication, hold a single list reference or sort + join into a
canonical `String` key and build a thin wrapper.

## Mutations

This package intentionally provides **no mutation providers**. Mutations
(fund, release, dispute, etc.) are one-shot operations best handled
imperatively:

```dart
await ref.read(trustlessWorkClientProvider).fundEscrow(payload);
ref.invalidate(escrowProvider(payload.contractId)); // refresh
```
