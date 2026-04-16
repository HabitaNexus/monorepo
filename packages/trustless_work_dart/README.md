# trustless_work_dart

Pure-Dart client for the [Trustless Work](https://trustlesswork.com) escrow API gateway. Works from Flutter mobile, Flutter Web, Jaspr, Dart server, and CLI.

## What it IS

- Typed HTTP client for `api.trustlesswork.com` and `dev.api.trustlesswork.com`.
- XDR signing abstraction via `TransactionSigner` (in-memory `KeyPairSigner`, lambda-based `CallbackSigner`).
- `Future<T>`-first idiomatic Dart API.
- `Stream<EscrowEvent>` marked `@experimental` for reactive UIs (polling-based in v0.1; migrates to Horizon SSE + Soroban events in v0.2 without breaking the public shape).
- Designed for **custody without banking**: the escrow funds live on-chain in USDC on Stellar/Soroban.

## What it IS NOT

- **Not a direct Soroban client.** It speaks to Trustless Work's gateway, not to Soroban RPC or Horizon (except locally via `stellar_flutter_sdk` for XDR signing).
- **Not a wallet with visual UI.** No Freighter/xBull/Lobstr equivalent screens. Your app provides the UX; this package provides the plumbing.
- **Not a state manager.** No Riverpod/BLoC dependency. Wrap the futures however you want.
- **Not 1:1 parity with the React SDK.** Compatibility is at the gateway and entity-naming level, not at SDK-surface level.
- **Not a bank integration.** The point of this package is explicitly to avoid depending on local CR banking for custody — funds live on-chain in USDC.

## Quickstart

```dart
import 'package:trustless_work_dart/trustless_work_dart.dart';
import 'package:stellar_flutter_sdk/stellar_flutter_sdk.dart';

final signer = KeyPairSigner(
  KeyPair.fromSecretSeed('S...'),
  network: Network.TESTNET,
);

final client = TrustlessWorkClient(
  config: const TrustlessWorkConfig.testnet(apiKey: 'your_api_key'),
  signer: signer,
);

final escrow = await client.initializeEscrow(myContract);
final funded = await client.fundEscrow(myFundPayload);
final released = await client.releaseFunds(myReleasePayload);
```

See `example/simple_escrow.dart` for a complete flow.

## License

MIT — see `LICENSE`.
