# trustless_work_flutter_storage

Companion to [`trustless_work_dart`](../trustless_work_dart/) that persists a
Stellar `KeyPair` in
[`flutter_secure_storage`](https://pub.dev/packages/flutter_secure_storage)
(Keychain on iOS, Keystore on Android).

## Quickstart

```dart
import 'package:trustless_work_dart/trustless_work_dart.dart';
import 'package:trustless_work_flutter_storage/trustless_work_flutter_storage.dart';

final signer = await SecureStorageKeyPairSigner.loadOrCreate(
  storageKey: 'habitanexus.tw.signer',
  network: Network.testnet,
);

final client = TrustlessWorkClient(
  config: TrustlessWorkConfig.testnet(apiKey: '...'),
  signer: signer,
);
```

## Why a sibling package?

`trustless_work_dart` is pure Dart and runs anywhere — Flutter, Jaspr, Dart
server, or CLI. It intentionally avoids a hard dependency on Flutter. This
companion package owns the Flutter-only concern of persisting the signing
key in platform secure storage.

See `example/` (TBD) for end-to-end usage.

## Key management

The seed is stored as a Stellar secret (`S...`) string under the key you
provide. Losing the secure-storage bucket (uninstall, device reset, Keychain
wipe) means losing the funds — callers are responsible for providing a
recovery flow (e.g. mnemonic export).

## License

MIT — see [LICENSE](LICENSE).
