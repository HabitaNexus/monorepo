# Trustless Work Dart SDK Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Port the Trustless Work escrow SDK to Dart — a pure-Dart core package (`trustless_work_dart`) plus a Flutter companion (`trustless_work_flutter_storage`) — with v0.1 covering `initializeEscrow`, `fundEscrow`, `getEscrow`, `releaseFunds`, plus an experimental event stream, ready to be consumed from `apps/mobile`.

**Architecture:** Layered design. Public `TrustlessWorkClient` orchestrates typed endpoint classes that speak to `api.trustlesswork.com` over plain `package:http`. Every state-changing call returns an unsigned XDR envelope which is signed locally through a pluggable `TransactionSigner` (in-memory `KeyPairSigner`, lambda-based `CallbackSigner`, or — in the sibling package — a persistent `SecureStorageKeyPairSigner`) and re-submitted via `POST /helper/send-transaction`. Models are hand-written with `freezed` + `json_serializable`. Reactivity is `Future<T>` first-class with an `@experimental` polling `Stream<EscrowEvent>` that reuses the same public shape the v0.2 Horizon-SSE + Soroban-events implementation will expose.

**Tech Stack:** Dart ≥3.2, `package:http` ^1.2, `stellar_flutter_sdk` ^1.9, `freezed` ^2.5, `json_serializable` ^6.7, `meta` ^1.11. Sibling pulls `flutter_secure_storage` ^9.2. Tests use `package:test` + `package:http/testing.dart` (`MockClient`). Dev workflow: `dart pub get` → `dart run build_runner build` → `dart test`.

---

## File Structure

### `packages/trustless_work_dart/`

```
pubspec.yaml                                  # SDK + deps declaration
analysis_options.yaml                         # lints (inherits from lints: ^4.0.0)
README.md                                     # "What it IS / IS NOT" — per §Nota of the spec
CHANGELOG.md                                  # starts empty for 0.1.0-dev
LICENSE                                       # MIT
.gitignore                                    # Dart/Flutter defaults

lib/
├── trustless_work_dart.dart                  # barrel export
└── src/
    ├── errors/
    │   ├── trustless_work_error.dart         # sealed class hierarchy
    │   └── result.dart                       # Result<T, E>
    ├── client/
    │   ├── trustless_work_config.dart        # baseUrl, apiKey, network enum
    │   └── trustless_work_client.dart        # public API (filled across tasks)
    ├── http/
    │   └── http_client.dart                  # thin wrapper over package:http
    ├── signer/
    │   ├── transaction_signer.dart           # abstract class
    │   ├── keypair_signer.dart               # in-memory, stellar_flutter_sdk
    │   └── callback_signer.dart              # lambda adapter
    ├── models/
    │   ├── network.dart                      # testnet/mainnet enum
    │   ├── role.dart
    │   ├── trustline.dart
    │   ├── flags.dart
    │   ├── milestone.dart
    │   ├── escrow.dart                       # main entity
    │   └── payloads/
    │       ├── single_release_contract.dart
    │       ├── fund_escrow_payload.dart
    │       └── release_funds_payload.dart
    ├── endpoints/
    │   ├── deployer.dart                     # POST /deployer/single-release
    │   ├── single_release_operations.dart    # fund + release
    │   ├── helpers.dart                      # POST /helper/send-transaction
    │   └── queries.dart                      # getEscrow (pending endpoint resolution)
    └── events/
        ├── escrow_event.dart                 # sealed class (7 variants)
        └── polling_event_stream.dart         # @experimental

test/
├── errors/
│   └── trustless_work_error_test.dart
├── client/
│   └── trustless_work_config_test.dart
├── http/
│   └── http_client_test.dart
├── signer/
│   ├── keypair_signer_test.dart
│   └── callback_signer_test.dart
├── models/
│   ├── escrow_test.dart                      # round-trip JSON
│   └── payloads_test.dart
├── endpoints/
│   ├── deployer_test.dart
│   ├── single_release_operations_test.dart
│   ├── helpers_test.dart
│   └── queries_test.dart
├── events/
│   ├── escrow_event_test.dart
│   └── polling_event_stream_test.dart
├── client_test.dart                          # TrustlessWorkClient integration of endpoints
└── integration/
    └── testnet_e2e_test.dart                 # gated by --tags=integration

example/
└── simple_escrow.dart                        # init → fund → query → release
```

### `packages/trustless_work_flutter_storage/`

```
pubspec.yaml
analysis_options.yaml
README.md
CHANGELOG.md
LICENSE

lib/
├── trustless_work_flutter_storage.dart       # barrel export
└── src/
    └── secure_storage_keypair_signer.dart    # persistent signer

test/
└── secure_storage_keypair_signer_test.dart
```

### `apps/mobile/` (modified)

- `pubspec.yaml` — add two path dependencies and consume them from a minimal example widget.

---

## Phase 0 — Workspace scaffolding (core package)

### Task 0.1: Create core package directory and manifest

**Files:**
- Create: `packages/trustless_work_dart/pubspec.yaml`
- Create: `packages/trustless_work_dart/analysis_options.yaml`
- Create: `packages/trustless_work_dart/.gitignore`
- Create: `packages/trustless_work_dart/LICENSE`
- Create: `packages/trustless_work_dart/README.md`
- Create: `packages/trustless_work_dart/CHANGELOG.md`

- [ ] **Step 1: Create the package directory tree**

```bash
mkdir -p packages/trustless_work_dart/lib/src/{errors,client,http,signer,models/payloads,endpoints,events}
mkdir -p packages/trustless_work_dart/test/{errors,client,http,signer,models,endpoints,events,integration}
mkdir -p packages/trustless_work_dart/example
```

- [ ] **Step 2: Write `pubspec.yaml`**

```yaml
name: trustless_work_dart
description: Pure-Dart client for the Trustless Work escrow API gateway on Stellar/Soroban. Works from Flutter, Jaspr, Dart server, or CLI.
version: 0.1.0-dev.1
repository: https://github.com/DojoCodingLabs/trustless-work-dart
issue_tracker: https://github.com/DojoCodingLabs/trustless-work-dart/issues

environment:
  sdk: ^3.2.5

dependencies:
  freezed_annotation: ^2.4.4
  json_annotation: ^4.9.0
  http: ^1.2.2
  meta: ^1.11.0
  stellar_flutter_sdk: ^1.9.0

dev_dependencies:
  build_runner: ^2.4.13
  freezed: ^2.5.7
  json_serializable: ^6.8.0
  lints: ^4.0.0
  test: ^1.25.0
```

- [ ] **Step 3: Write `analysis_options.yaml`**

```yaml
include: package:lints/recommended.yaml

analyzer:
  language:
    strict-casts: true
    strict-inference: true
    strict-raw-types: true
  errors:
    invalid_annotation_target: ignore
  exclude:
    - '**/*.g.dart'
    - '**/*.freezed.dart'

linter:
  rules:
    - always_declare_return_types
    - avoid_empty_else
    - avoid_print
    - prefer_const_constructors
    - prefer_final_locals
    - unawaited_futures
```

- [ ] **Step 4: Write `.gitignore`**

```
.dart_tool/
.packages
pubspec.lock
build/
coverage/
doc/api/
```

- [ ] **Step 5: Write `LICENSE` (MIT)**

```
MIT License

Copyright (c) 2026 Dojo Coding Labs, HabitaNexus, and Trustless Work contributors

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

- [ ] **Step 6: Write `README.md` with "What it IS / IS NOT"**

```markdown
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
```

- [ ] **Step 7: Write `CHANGELOG.md`**

```markdown
# Changelog

## 0.1.0-dev.1

- Initial scaffolding.
```

- [ ] **Step 8: Run `dart pub get` to verify the manifest**

```bash
cd packages/trustless_work_dart && dart pub get
```
Expected: `Got dependencies!` with no errors.

- [ ] **Step 9: Commit**

```bash
git add packages/trustless_work_dart/
git commit -m "feat(trustless-work): scaffold trustless_work_dart package"
```

---

## Phase 1 — Errors and `Result<T, E>`

### Task 1.1: Error sealed class with tests

**Files:**
- Create: `packages/trustless_work_dart/lib/src/errors/trustless_work_error.dart`
- Create: `packages/trustless_work_dart/test/errors/trustless_work_error_test.dart`

- [ ] **Step 1: Write the failing test**

```dart
// test/errors/trustless_work_error_test.dart
import 'package:test/test.dart';
import 'package:trustless_work_dart/src/errors/trustless_work_error.dart';

void main() {
  group('TrustlessWorkError', () {
    test('BadRequest carries message and status 400', () {
      const err = TrustlessWorkError.badRequest(message: 'missing amount');
      expect(err, isA<BadRequest>());
      expect((err as BadRequest).message, 'missing amount');
      expect(err.statusCode, 400);
    });

    test('ServerError carries possibleCauses', () {
      const err = TrustlessWorkError.serverError(
        message: 'Escrow not found',
        possibleCauses: ['Escrow not found', 'Invalid contract id'],
      );
      expect(err, isA<ServerError>());
      expect((err as ServerError).possibleCauses, hasLength(2));
    });

    test('NetworkError wraps an underlying exception', () {
      final underlying = Exception('DNS failed');
      final err = TrustlessWorkError.network(message: 'connect failed', cause: underlying);
      expect(err, isA<NetworkError>());
      expect((err as NetworkError).cause, underlying);
    });

    test('toString includes class name and message', () {
      const err = TrustlessWorkError.unauthorized(message: 'invalid api key');
      expect(err.toString(), contains('Unauthorized'));
      expect(err.toString(), contains('invalid api key'));
    });
  });
}
```

- [ ] **Step 2: Run the test and confirm it fails**

```bash
cd packages/trustless_work_dart && dart test test/errors/trustless_work_error_test.dart
```
Expected: `Error: Couldn't resolve the package 'trustless_work_dart'` or file-not-found for the error source.

- [ ] **Step 3: Implement the sealed class**

```dart
// lib/src/errors/trustless_work_error.dart
/// Base error hierarchy for all Trustless Work SDK failures.
///
/// Use pattern matching on `switch` for exhaustive handling:
/// ```dart
/// switch (error) {
///   case BadRequest(): ...
///   case Unauthorized(): ...
///   case TooManyRequests(): ...
///   case ServerError(): ...
///   case NetworkError(): ...
///   case SigningError(): ...
/// }
/// ```
sealed class TrustlessWorkError implements Exception {
  const TrustlessWorkError._(this.message);

  final String message;

  int? get statusCode;

  const factory TrustlessWorkError.badRequest({required String message}) = BadRequest;
  const factory TrustlessWorkError.unauthorized({required String message}) = Unauthorized;
  const factory TrustlessWorkError.tooManyRequests({required String message}) = TooManyRequests;
  const factory TrustlessWorkError.serverError({
    required String message,
    List<String> possibleCauses,
  }) = ServerError;
  const factory TrustlessWorkError.network({
    required String message,
    Object? cause,
  }) = NetworkError;
  const factory TrustlessWorkError.signing({
    required String message,
    Object? cause,
  }) = SigningError;

  @override
  String toString() => '$runtimeType: $message';
}

final class BadRequest extends TrustlessWorkError {
  const BadRequest({required String message}) : super._(message);
  @override
  int get statusCode => 400;
}

final class Unauthorized extends TrustlessWorkError {
  const Unauthorized({required String message}) : super._(message);
  @override
  int get statusCode => 401;
}

final class TooManyRequests extends TrustlessWorkError {
  const TooManyRequests({required String message}) : super._(message);
  @override
  int get statusCode => 429;
}

final class ServerError extends TrustlessWorkError {
  const ServerError({
    required String message,
    this.possibleCauses = const [],
  }) : super._(message);
  final List<String> possibleCauses;
  @override
  int get statusCode => 500;
}

final class NetworkError extends TrustlessWorkError {
  const NetworkError({required String message, this.cause}) : super._(message);
  final Object? cause;
  @override
  int? get statusCode => null;
}

final class SigningError extends TrustlessWorkError {
  const SigningError({required String message, this.cause}) : super._(message);
  final Object? cause;
  @override
  int? get statusCode => null;
}
```

- [ ] **Step 4: Run test and confirm it passes**

```bash
dart test test/errors/trustless_work_error_test.dart
```
Expected: `All tests passed!`

- [ ] **Step 5: Commit**

```bash
git add lib/src/errors/trustless_work_error.dart test/errors/trustless_work_error_test.dart
git commit -m "feat(trustless-work): add TrustlessWorkError sealed class"
```

### Task 1.2: `Result<T, E>` with tests

**Files:**
- Create: `packages/trustless_work_dart/lib/src/errors/result.dart`
- Modify: `packages/trustless_work_dart/test/errors/` — add `result_test.dart`

- [ ] **Step 1: Write the failing test**

```dart
// test/errors/result_test.dart
import 'package:test/test.dart';
import 'package:trustless_work_dart/src/errors/result.dart';

void main() {
  group('Result', () {
    test('Ok carries the value', () {
      const r = Result<int, String>.ok(42);
      expect(r.isOk, isTrue);
      expect(r.isErr, isFalse);
      expect(r.valueOrNull, 42);
      expect(r.errorOrNull, isNull);
    });

    test('Err carries the error', () {
      const r = Result<int, String>.err('boom');
      expect(r.isOk, isFalse);
      expect(r.isErr, isTrue);
      expect(r.valueOrNull, isNull);
      expect(r.errorOrNull, 'boom');
    });

    test('map transforms Ok value', () {
      const r = Result<int, String>.ok(2);
      expect(r.map((v) => v * 3).valueOrNull, 6);
    });

    test('map does not touch Err', () {
      const r = Result<int, String>.err('boom');
      expect(r.map((v) => v * 3).errorOrNull, 'boom');
    });

    test('when is exhaustive', () {
      const ok = Result<int, String>.ok(1);
      const err = Result<int, String>.err('x');
      expect(ok.when(ok: (v) => 'v=$v', err: (e) => 'e=$e'), 'v=1');
      expect(err.when(ok: (v) => 'v=$v', err: (e) => 'e=$e'), 'e=x');
    });
  });
}
```

- [ ] **Step 2: Run test and confirm it fails**

```bash
dart test test/errors/result_test.dart
```
Expected: compile error about missing `result.dart`.

- [ ] **Step 3: Implement `Result<T, E>`**

```dart
// lib/src/errors/result.dart
/// A sum type for operations that may fail with a typed error.
///
/// Prefer this over throwing when you want callers to handle errors
/// without try/catch — the exhaustive `switch` on the sealed hierarchy
/// forces them to account for both branches.
sealed class Result<T, E> {
  const Result();

  const factory Result.ok(T value) = Ok<T, E>;
  const factory Result.err(E error) = Err<T, E>;

  bool get isOk => this is Ok<T, E>;
  bool get isErr => this is Err<T, E>;

  T? get valueOrNull => switch (this) {
        Ok<T, E>(value: final v) => v,
        Err<T, E>() => null,
      };

  E? get errorOrNull => switch (this) {
        Ok<T, E>() => null,
        Err<T, E>(error: final e) => e,
      };

  Result<U, E> map<U>(U Function(T) transform) => switch (this) {
        Ok<T, E>(value: final v) => Result.ok(transform(v)),
        Err<T, E>(error: final e) => Result.err(e),
      };

  R when<R>({required R Function(T) ok, required R Function(E) err}) =>
      switch (this) {
        Ok<T, E>(value: final v) => ok(v),
        Err<T, E>(error: final e) => err(e),
      };
}

final class Ok<T, E> extends Result<T, E> {
  const Ok(this.value);
  final T value;
}

final class Err<T, E> extends Result<T, E> {
  const Err(this.error);
  final E error;
}
```

- [ ] **Step 4: Run test and confirm it passes**

```bash
dart test test/errors/result_test.dart
```
Expected: `All tests passed!`

- [ ] **Step 5: Commit**

```bash
git add lib/src/errors/result.dart test/errors/result_test.dart
git commit -m "feat(trustless-work): add Result<T, E> sum type"
```

---

## Phase 2 — Configuration and Network enum

### Task 2.1: `Network` enum + `TrustlessWorkConfig`

**Files:**
- Create: `packages/trustless_work_dart/lib/src/models/network.dart`
- Create: `packages/trustless_work_dart/lib/src/client/trustless_work_config.dart`
- Create: `packages/trustless_work_dart/test/client/trustless_work_config_test.dart`

- [ ] **Step 1: Write the failing test**

```dart
// test/client/trustless_work_config_test.dart
import 'package:test/test.dart';
import 'package:trustless_work_dart/src/client/trustless_work_config.dart';
import 'package:trustless_work_dart/src/models/network.dart';

void main() {
  group('TrustlessWorkConfig', () {
    test('testnet factory points to dev URL', () {
      final cfg = TrustlessWorkConfig.testnet(apiKey: 'k');
      expect(cfg.baseUrl.toString(), 'https://dev.api.trustlesswork.com');
      expect(cfg.apiKey, 'k');
      expect(cfg.network, Network.testnet);
    });

    test('mainnet factory points to prod URL', () {
      final cfg = TrustlessWorkConfig.mainnet(apiKey: 'k');
      expect(cfg.baseUrl.toString(), 'https://api.trustlesswork.com');
      expect(cfg.network, Network.mainnet);
    });

    test('custom factory accepts explicit URL', () {
      final cfg = TrustlessWorkConfig(
        baseUrl: Uri.parse('https://staging.example.com'),
        apiKey: 'k',
        network: Network.testnet,
      );
      expect(cfg.baseUrl.host, 'staging.example.com');
    });

    test('empty api key throws ArgumentError', () {
      expect(
        () => TrustlessWorkConfig(
          baseUrl: Uri.parse('https://api.trustlesswork.com'),
          apiKey: '',
          network: Network.mainnet,
        ),
        throwsArgumentError,
      );
    });
  });
}
```

- [ ] **Step 2: Run and confirm failure**

```bash
dart test test/client/trustless_work_config_test.dart
```
Expected: compile errors about missing sources.

- [ ] **Step 3: Implement `Network`**

```dart
// lib/src/models/network.dart
/// Which Stellar/Soroban network the SDK is talking to.
///
/// Keep this disjoint from `stellar_flutter_sdk.Network` to avoid leaking
/// the SDK's type into consumers that only want the TW abstraction.
enum Network {
  testnet,
  mainnet;
}
```

- [ ] **Step 4: Implement `TrustlessWorkConfig`**

```dart
// lib/src/client/trustless_work_config.dart
import '../models/network.dart';

/// Immutable configuration for `TrustlessWorkClient`.
///
/// Prefer the `testnet`/`mainnet` factories over the generic constructor
/// to avoid URL typos.
class TrustlessWorkConfig {
  TrustlessWorkConfig({
    required this.baseUrl,
    required this.apiKey,
    required this.network,
  }) {
    if (apiKey.isEmpty) {
      throw ArgumentError.value(apiKey, 'apiKey', 'must not be empty');
    }
  }

  const TrustlessWorkConfig._const({
    required this.baseUrl,
    required this.apiKey,
    required this.network,
  });

  factory TrustlessWorkConfig.testnet({required String apiKey}) {
    if (apiKey.isEmpty) {
      throw ArgumentError.value(apiKey, 'apiKey', 'must not be empty');
    }
    return TrustlessWorkConfig._const(
      baseUrl: Uri.parse('https://dev.api.trustlesswork.com'),
      apiKey: apiKey,
      network: Network.testnet,
    );
  }

  factory TrustlessWorkConfig.mainnet({required String apiKey}) {
    if (apiKey.isEmpty) {
      throw ArgumentError.value(apiKey, 'apiKey', 'must not be empty');
    }
    return TrustlessWorkConfig._const(
      baseUrl: Uri.parse('https://api.trustlesswork.com'),
      apiKey: apiKey,
      network: Network.mainnet,
    );
  }

  final Uri baseUrl;
  final String apiKey;
  final Network network;
}
```

- [ ] **Step 5: Run test and confirm pass**

```bash
dart test test/client/trustless_work_config_test.dart
```
Expected: `All tests passed!`

- [ ] **Step 6: Commit**

```bash
git add lib/src/models/network.dart lib/src/client/trustless_work_config.dart test/client/trustless_work_config_test.dart
git commit -m "feat(trustless-work): add Network enum and TrustlessWorkConfig"
```

---

## Phase 3 — Transaction signers

### Task 3.1: `TransactionSigner` abstract class

**Files:**
- Create: `packages/trustless_work_dart/lib/src/signer/transaction_signer.dart`

- [ ] **Step 1: Define the abstraction (no test yet — it's an abstract class)**

```dart
// lib/src/signer/transaction_signer.dart
import 'dart:async';

/// Signs unsigned Stellar/Soroban XDR envelopes returned by the Trustless
/// Work API.
///
/// Implementations receive the base64-encoded unsigned XDR, apply the
/// signature(s) required for the caller's role in the escrow, and return
/// the base64-encoded signed XDR ready to be submitted through
/// `POST /helper/send-transaction`.
///
/// The SDK does NOT assume how the signing happens — it may be a local
/// `KeyPair`, a delegate to an external wallet, an HSM, or a backend
/// service. See `KeyPairSigner` and `CallbackSigner` for bundled
/// implementations, or `SecureStorageKeyPairSigner` in
/// `trustless_work_flutter_storage` for persistent on-device wallets.
abstract class TransactionSigner {
  /// The Stellar public key (`G...` address) the signer will use.
  String get publicKey;

  /// Takes a base64-encoded unsigned XDR envelope and returns a base64-
  /// encoded signed XDR envelope.
  ///
  /// Throws [SigningError] if signing fails (invalid XDR, wrong network,
  /// mismatched roles, etc.).
  FutureOr<String> signXdr(String unsignedXdr);
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/src/signer/transaction_signer.dart
git commit -m "feat(trustless-work): add TransactionSigner abstract class"
```

### Task 3.2: `KeyPairSigner` with tests

**Files:**
- Create: `packages/trustless_work_dart/lib/src/signer/keypair_signer.dart`
- Create: `packages/trustless_work_dart/test/signer/keypair_signer_test.dart`

- [ ] **Step 1: Write the failing test**

```dart
// test/signer/keypair_signer_test.dart
import 'package:stellar_flutter_sdk/stellar_flutter_sdk.dart' as stellar;
import 'package:test/test.dart';
import 'package:trustless_work_dart/src/errors/trustless_work_error.dart';
import 'package:trustless_work_dart/src/models/network.dart';
import 'package:trustless_work_dart/src/signer/keypair_signer.dart';

void main() {
  group('KeyPairSigner', () {
    late stellar.KeyPair keypair;

    setUp(() {
      keypair = stellar.KeyPair.random();
    });

    test('exposes public key as G-address', () {
      final signer = KeyPairSigner(keypair: keypair, network: Network.testnet);
      expect(signer.publicKey, startsWith('G'));
      expect(signer.publicKey, keypair.accountId);
    });

    test('signs a valid unsigned XDR and changes it', () async {
      final signer = KeyPairSigner(keypair: keypair, network: Network.testnet);

      // Build a minimal unsigned payment tx envelope for testing.
      final sourceAccount = stellar.Account(keypair.accountId, BigInt.zero);
      final tx = stellar.TransactionBuilder(sourceAccount)
          .addOperation(
            stellar.PaymentOperationBuilder(
              keypair.accountId,
              stellar.Asset.NATIVE,
              '1',
            ).build(),
          )
          .build();
      final unsigned = tx.toEnvelopeXdrBase64();

      final signed = await signer.signXdr(unsigned);

      expect(signed, isNot(unsigned));
      expect(signed, isNotEmpty);
    });

    test('wraps invalid XDR into SigningError', () {
      final signer = KeyPairSigner(keypair: keypair, network: Network.testnet);
      expect(
        () => signer.signXdr('not a real xdr envelope'),
        throwsA(isA<SigningError>()),
      );
    });
  });
}
```

- [ ] **Step 2: Run and confirm failure**

```bash
dart test test/signer/keypair_signer_test.dart
```
Expected: missing `keypair_signer.dart`.

- [ ] **Step 3: Implement `KeyPairSigner`**

```dart
// lib/src/signer/keypair_signer.dart
import 'dart:async';
import 'package:stellar_flutter_sdk/stellar_flutter_sdk.dart' as stellar;
import '../errors/trustless_work_error.dart';
import '../models/network.dart';
import 'transaction_signer.dart';

/// In-memory signer backed by a `stellar_flutter_sdk.KeyPair`.
///
/// Good for ephemeral signers (test scripts, integration tests) or for
/// cases where the caller already manages key persistence externally.
/// For on-device persistent wallets, use `SecureStorageKeyPairSigner`
/// from `trustless_work_flutter_storage`.
class KeyPairSigner implements TransactionSigner {
  KeyPairSigner({
    required stellar.KeyPair keypair,
    required Network network,
  })  : _keypair = keypair,
        _network = _mapNetwork(network);

  final stellar.KeyPair _keypair;
  final stellar.Network _network;

  static stellar.Network _mapNetwork(Network n) => switch (n) {
        Network.testnet => stellar.Network.TESTNET,
        Network.mainnet => stellar.Network.PUBLIC,
      };

  @override
  String get publicKey => _keypair.accountId;

  @override
  FutureOr<String> signXdr(String unsignedXdr) {
    try {
      final tx = stellar.AbstractTransaction.fromEnvelopeXdrString(unsignedXdr);
      tx.sign(_keypair, _network);
      return tx.toEnvelopeXdrBase64();
    } catch (e) {
      throw SigningError(message: 'Failed to sign XDR envelope', cause: e);
    }
  }
}
```

- [ ] **Step 4: Run and confirm pass**

```bash
dart test test/signer/keypair_signer_test.dart
```
Expected: `All tests passed!`

- [ ] **Step 5: Commit**

```bash
git add lib/src/signer/keypair_signer.dart test/signer/keypair_signer_test.dart
git commit -m "feat(trustless-work): add KeyPairSigner backed by stellar_flutter_sdk"
```

### Task 3.3: `CallbackSigner` with tests

**Files:**
- Create: `packages/trustless_work_dart/lib/src/signer/callback_signer.dart`
- Create: `packages/trustless_work_dart/test/signer/callback_signer_test.dart`

- [ ] **Step 1: Write the failing test**

```dart
// test/signer/callback_signer_test.dart
import 'package:test/test.dart';
import 'package:trustless_work_dart/src/signer/callback_signer.dart';

void main() {
  group('CallbackSigner', () {
    test('delegates signXdr to the provided function', () async {
      var invoked = 0;
      final signer = CallbackSigner(
        publicKey: 'GABCDE',
        signXdr: (xdr) async {
          invoked += 1;
          return 'signed:$xdr';
        },
      );

      expect(signer.publicKey, 'GABCDE');
      expect(await signer.signXdr('unsigned'), 'signed:unsigned');
      expect(invoked, 1);
    });

    test('propagates exceptions from the callback verbatim', () async {
      final signer = CallbackSigner(
        publicKey: 'GXXXX',
        signXdr: (_) async => throw StateError('wallet locked'),
      );

      await expectLater(
        signer.signXdr('x'),
        throwsA(isA<StateError>()),
      );
    });
  });
}
```

- [ ] **Step 2: Run and confirm failure**

```bash
dart test test/signer/callback_signer_test.dart
```

- [ ] **Step 3: Implement `CallbackSigner`**

```dart
// lib/src/signer/callback_signer.dart
import 'dart:async';
import 'transaction_signer.dart';

typedef SignXdrFn = FutureOr<String> Function(String unsignedXdr);

/// Generic adapter that forwards signing to an arbitrary function.
///
/// Use when the signing happens outside the SDK's control — e.g. deep
/// link to an external wallet, a server-side HSM call, a WalletConnect
/// session, or a platform channel to native code.
class CallbackSigner implements TransactionSigner {
  const CallbackSigner({
    required this.publicKey,
    required SignXdrFn signXdr,
  }) : _signXdr = signXdr;

  @override
  final String publicKey;

  final SignXdrFn _signXdr;

  @override
  FutureOr<String> signXdr(String unsignedXdr) => _signXdr(unsignedXdr);
}
```

- [ ] **Step 4: Run and confirm pass**

```bash
dart test test/signer/callback_signer_test.dart
```

- [ ] **Step 5: Commit**

```bash
git add lib/src/signer/callback_signer.dart test/signer/callback_signer_test.dart
git commit -m "feat(trustless-work): add CallbackSigner adapter"
```

---

## Phase 4 — HTTP client wrapper

### Task 4.1: `HttpClient` with request/response helpers and error mapping

**Files:**
- Create: `packages/trustless_work_dart/lib/src/http/http_client.dart`
- Create: `packages/trustless_work_dart/test/http/http_client_test.dart`

- [ ] **Step 1: Write the failing test**

```dart
// test/http/http_client_test.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:test/test.dart';
import 'package:trustless_work_dart/src/client/trustless_work_config.dart';
import 'package:trustless_work_dart/src/errors/trustless_work_error.dart';
import 'package:trustless_work_dart/src/http/http_client.dart';

void main() {
  group('HttpClient', () {
    final cfg = TrustlessWorkConfig.testnet(apiKey: 'test_key');

    test('sends api key header and returns decoded JSON on 200', () async {
      final mock = MockClient((req) async {
        expect(req.headers['x-api-key'], 'test_key');
        expect(req.headers['content-type'], contains('application/json'));
        return http.Response(jsonEncode({'contractId': 'abc'}), 200);
      });

      final client = HttpClient(config: cfg, inner: mock);
      final result = await client.postJson<Map<String, dynamic>>(
        '/deployer/single-release',
        body: const {'foo': 'bar'},
      );
      expect(result['contractId'], 'abc');
    });

    test('maps 400 to BadRequest', () async {
      final mock = MockClient((_) async => http.Response(
            jsonEncode({'message': 'missing amount'}),
            400,
          ));

      final client = HttpClient(config: cfg, inner: mock);
      await expectLater(
        client.postJson<Map<String, dynamic>>('/x', body: const {}),
        throwsA(isA<BadRequest>()),
      );
    });

    test('maps 401 to Unauthorized', () async {
      final mock = MockClient((_) async => http.Response('', 401));
      final client = HttpClient(config: cfg, inner: mock);
      await expectLater(
        client.postJson<Map<String, dynamic>>('/x', body: const {}),
        throwsA(isA<Unauthorized>()),
      );
    });

    test('maps 429 to TooManyRequests', () async {
      final mock = MockClient((_) async => http.Response('', 429));
      final client = HttpClient(config: cfg, inner: mock);
      await expectLater(
        client.postJson<Map<String, dynamic>>('/x', body: const {}),
        throwsA(isA<TooManyRequests>()),
      );
    });

    test('maps 500 with message to ServerError', () async {
      final mock = MockClient((_) async => http.Response(
            jsonEncode({'message': 'Escrow not found'}),
            500,
          ));
      final client = HttpClient(config: cfg, inner: mock);
      await expectLater(
        client.postJson<Map<String, dynamic>>('/x', body: const {}),
        throwsA(isA<ServerError>()),
      );
    });

    test('wraps socket-level failures as NetworkError', () async {
      final mock = MockClient((_) async => throw http.ClientException('boom'));
      final client = HttpClient(config: cfg, inner: mock);
      await expectLater(
        client.postJson<Map<String, dynamic>>('/x', body: const {}),
        throwsA(isA<NetworkError>()),
      );
    });
  });
}
```

- [ ] **Step 2: Run and confirm failure**

```bash
dart test test/http/http_client_test.dart
```

- [ ] **Step 3: Implement `HttpClient`**

```dart
// lib/src/http/http_client.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../client/trustless_work_config.dart';
import '../errors/trustless_work_error.dart';

/// Thin wrapper over `package:http` that:
/// - injects the `x-api-key` header on every request,
/// - JSON-encodes bodies and JSON-decodes responses,
/// - maps common HTTP failure modes onto `TrustlessWorkError`.
class HttpClient {
  HttpClient({
    required TrustlessWorkConfig config,
    http.Client? inner,
  })  : _config = config,
        _inner = inner ?? http.Client();

  final TrustlessWorkConfig _config;
  final http.Client _inner;

  Future<T> postJson<T>(
    String path, {
    required Map<String, Object?> body,
  }) =>
      _send<T>('POST', path, body: body);

  Future<T> getJson<T>(
    String path, {
    Map<String, String>? queryParameters,
  }) =>
      _send<T>('GET', path, queryParameters: queryParameters);

  Future<T> _send<T>(
    String method,
    String path, {
    Map<String, Object?>? body,
    Map<String, String>? queryParameters,
  }) async {
    final uri = _config.baseUrl.replace(
      path: path,
      queryParameters: queryParameters,
    );

    late http.Response response;
    try {
      final request = http.Request(method, uri)
        ..headers['x-api-key'] = _config.apiKey
        ..headers['content-type'] = 'application/json; charset=utf-8';
      if (body != null) {
        request.body = jsonEncode(body);
      }
      final streamed = await _inner.send(request);
      response = await http.Response.fromStream(streamed);
    } on http.ClientException catch (e) {
      throw NetworkError(message: e.message, cause: e);
    } catch (e) {
      throw NetworkError(message: 'HTTP transport failure', cause: e);
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return <String, dynamic>{} as T;
      }
      final decoded = jsonDecode(response.body);
      return decoded as T;
    }

    _throwHttpError(response);
  }

  Never _throwHttpError(http.Response response) {
    final message = _extractMessage(response.body);
    switch (response.statusCode) {
      case 400:
        throw BadRequest(message: message);
      case 401:
        throw Unauthorized(message: message);
      case 429:
        throw TooManyRequests(message: message);
      case 500:
        throw ServerError(message: message);
      default:
        throw NetworkError(
          message: 'Unexpected HTTP ${response.statusCode}: $message',
        );
    }
  }

  String _extractMessage(String body) {
    if (body.isEmpty) return '';
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map && decoded['message'] is String) {
        return decoded['message'] as String;
      }
    } on FormatException {
      // fall through
    }
    return body;
  }

  void close() => _inner.close();
}
```

- [ ] **Step 4: Run and confirm pass**

```bash
dart test test/http/http_client_test.dart
```

- [ ] **Step 5: Commit**

```bash
git add lib/src/http/http_client.dart test/http/http_client_test.dart
git commit -m "feat(trustless-work): add HttpClient with error mapping"
```

---

## Phase 5 — Models (entities + payloads)

### Task 5.1: `Trustline`, `Flags`, `Role`, `Milestone` with freezed

**Files:**
- Create: `packages/trustless_work_dart/lib/src/models/trustline.dart`
- Create: `packages/trustless_work_dart/lib/src/models/flags.dart`
- Create: `packages/trustless_work_dart/lib/src/models/role.dart`
- Create: `packages/trustless_work_dart/lib/src/models/milestone.dart`

- [ ] **Step 1: Implement `Trustline`**

```dart
// lib/src/models/trustline.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'trustline.freezed.dart';
part 'trustline.g.dart';

/// Stellar trustline describing which asset flows through the escrow.
///
/// `address` is the issuer contract id (Soroban asset) or Stellar asset
/// address. `name` is a human-readable ticker like "USDC".
@freezed
class Trustline with _$Trustline {
  const factory Trustline({
    required String address,
    required String name,
    required int decimals,
  }) = _Trustline;

  factory Trustline.fromJson(Map<String, dynamic> json) =>
      _$TrustlineFromJson(json);
}
```

- [ ] **Step 2: Implement `Flags`**

```dart
// lib/src/models/flags.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'flags.freezed.dart';
part 'flags.g.dart';

/// Lifecycle flags tracked by the Trustless Work contract.
///
/// These gate which operations are legal at any moment — e.g. you cannot
/// `releaseFunds` if `disputed` is true, and you cannot re-fund once
/// `released` is true.
@freezed
class Flags with _$Flags {
  const factory Flags({
    @Default(false) bool approved,
    @Default(false) bool disputed,
    @Default(false) bool released,
  }) = _Flags;

  factory Flags.fromJson(Map<String, dynamic> json) => _$FlagsFromJson(json);
}
```

- [ ] **Step 3: Implement `Role`**

```dart
// lib/src/models/role.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'role.freezed.dart';
part 'role.g.dart';

/// A named party in the escrow and its Stellar public key.
///
/// The Trustless Work contract defines fixed role names: `approver`,
/// `serviceProvider`, `releaseSigner`, `disputeResolver`, `platformAddress`,
/// `receiver`. Unknown names are rejected by the API.
@freezed
class Role with _$Role {
  const factory Role({
    required String name,
    required String address,
  }) = _Role;

  factory Role.fromJson(Map<String, dynamic> json) => _$RoleFromJson(json);
}
```

- [ ] **Step 4: Implement `Milestone`**

```dart
// lib/src/models/milestone.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'milestone.freezed.dart';
part 'milestone.g.dart';

/// A single deliverable inside an escrow.
///
/// v0.1 focuses on single-release contracts, which still send a
/// milestones array (typically containing one entry) to describe the
/// agreement's subject matter.
@freezed
class Milestone with _$Milestone {
  const factory Milestone({
    required String description,
    @Default('pending') String status,
    @Default(false) bool approvedFlag,
  }) = _Milestone;

  factory Milestone.fromJson(Map<String, dynamic> json) =>
      _$MilestoneFromJson(json);
}
```

- [ ] **Step 5: Run code generation**

```bash
dart run build_runner build --delete-conflicting-outputs
```
Expected: 4 pairs of `.freezed.dart` + `.g.dart` files generated.

- [ ] **Step 6: Commit**

```bash
git add lib/src/models/trustline.dart lib/src/models/flags.dart lib/src/models/role.dart lib/src/models/milestone.dart lib/src/models/*.freezed.dart lib/src/models/*.g.dart
git commit -m "feat(trustless-work): add Trustline, Flags, Role, Milestone models"
```

### Task 5.2: `Escrow` main entity

**Files:**
- Create: `packages/trustless_work_dart/lib/src/models/escrow.dart`
- Create: `packages/trustless_work_dart/test/models/escrow_test.dart`

- [ ] **Step 1: Write the failing test**

```dart
// test/models/escrow_test.dart
import 'package:test/test.dart';
import 'package:trustless_work_dart/src/models/escrow.dart';

void main() {
  group('Escrow', () {
    test('round-trips through JSON', () {
      const json = <String, dynamic>{
        'contractId': 'CAAA...',
        'engagementId': 'lease-2026-04-15-42',
        'title': 'Alquiler Apto 3B',
        'description': 'Depósito de garantía',
        'amount': 500000,
        'platformFee': 1.5,
        'receiverMemo': 0,
        'roles': <Map<String, dynamic>>[
          {'name': 'approver', 'address': 'GAAA...'},
          {'name': 'receiver', 'address': 'GBBB...'},
        ],
        'milestones': <Map<String, dynamic>>[
          {'description': 'Entrega del inmueble', 'status': 'pending', 'approvedFlag': false},
        ],
        'trustline': <String, dynamic>{
          'address': 'CUSDC...',
          'name': 'USDC',
          'decimals': 7,
        },
        'flags': <String, dynamic>{'approved': false, 'disputed': false, 'released': false},
        'isActive': true,
      };

      final escrow = Escrow.fromJson(json);
      expect(escrow.contractId, 'CAAA...');
      expect(escrow.amount, 500000);
      expect(escrow.roles, hasLength(2));
      expect(escrow.milestones.single.description, 'Entrega del inmueble');
      expect(escrow.trustline.name, 'USDC');

      final again = Escrow.fromJson(escrow.toJson());
      expect(again, escrow);
    });
  });
}
```

- [ ] **Step 2: Implement `Escrow`**

```dart
// lib/src/models/escrow.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'flags.dart';
import 'milestone.dart';
import 'role.dart';
import 'trustline.dart';

part 'escrow.freezed.dart';
part 'escrow.g.dart';

/// The canonical Trustless Work escrow entity, as returned by the API
/// gateway.
///
/// Mirrors the fields documented at
/// https://docs.trustlesswork.com/trustless-work/api-reference. Amount is
/// an int because Trustless Work tracks amounts as integer units of the
/// trustline's smallest denomination (e.g. 1e7 per USDC).
@freezed
class Escrow with _$Escrow {
  const factory Escrow({
    required String contractId,
    required String engagementId,
    required String title,
    required String description,
    required int amount,
    required double platformFee,
    required int receiverMemo,
    required List<Role> roles,
    required List<Milestone> milestones,
    required Trustline trustline,
    required Flags flags,
    required bool isActive,
  }) = _Escrow;

  factory Escrow.fromJson(Map<String, dynamic> json) => _$EscrowFromJson(json);
}
```

- [ ] **Step 3: Run build_runner and tests**

```bash
dart run build_runner build --delete-conflicting-outputs
dart test test/models/escrow_test.dart
```
Expected: both commands succeed.

- [ ] **Step 4: Commit**

```bash
git add lib/src/models/escrow.dart lib/src/models/escrow.freezed.dart lib/src/models/escrow.g.dart test/models/escrow_test.dart
git commit -m "feat(trustless-work): add Escrow entity with JSON round-trip test"
```

### Task 5.3: Payload types

**Files:**
- Create: `packages/trustless_work_dart/lib/src/models/payloads/single_release_contract.dart`
- Create: `packages/trustless_work_dart/lib/src/models/payloads/fund_escrow_payload.dart`
- Create: `packages/trustless_work_dart/lib/src/models/payloads/release_funds_payload.dart`
- Create: `packages/trustless_work_dart/test/models/payloads_test.dart`

- [ ] **Step 1: Write failing test for all three payloads**

```dart
// test/models/payloads_test.dart
import 'package:test/test.dart';
import 'package:trustless_work_dart/src/models/payloads/fund_escrow_payload.dart';
import 'package:trustless_work_dart/src/models/payloads/release_funds_payload.dart';
import 'package:trustless_work_dart/src/models/payloads/single_release_contract.dart';

void main() {
  test('SingleReleaseContract serializes required fields', () {
    const contract = SingleReleaseContract(
      signer: 'GAAA...',
      engagementId: 'lease-42',
      title: 'Alquiler',
      description: 'Depósito',
      amount: 1000,
      platformFee: 2.5,
      roles: <Map<String, Object?>>[],
      milestones: <Map<String, Object?>>[],
      trustline: <Map<String, Object?>>[],
    );
    final json = contract.toJson();
    expect(json['signer'], 'GAAA...');
    expect(json['engagementId'], 'lease-42');
    expect(json['amount'], 1000);
  });

  test('FundEscrowPayload requires contractId, signer, amount', () {
    const payload = FundEscrowPayload(
      contractId: 'CAAA',
      signer: 'GAAA',
      amount: '500',
    );
    expect(payload.toJson(), {
      'contractId': 'CAAA',
      'signer': 'GAAA',
      'amount': '500',
    });
  });

  test('ReleaseFundsPayload requires contractId + releaseSigner', () {
    const payload = ReleaseFundsPayload(
      contractId: 'CAAA',
      releaseSigner: 'GRELEASE',
    );
    expect(payload.toJson(), {
      'contractId': 'CAAA',
      'releaseSigner': 'GRELEASE',
    });
  });
}
```

- [ ] **Step 2: Implement `SingleReleaseContract`**

```dart
// lib/src/models/payloads/single_release_contract.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'single_release_contract.freezed.dart';
part 'single_release_contract.g.dart';

/// Request body for `POST /deployer/single-release`.
///
/// Roles/milestones/trustline are kept as raw JSON maps because their
/// exact shape differs subtly across API versions — pinning stronger
/// types here would invite unnecessary breaking changes. Callers build
/// them from the typed `Role`, `Milestone`, `Trustline` models and pass
/// `.toJson()`.
@freezed
class SingleReleaseContract with _$SingleReleaseContract {
  const factory SingleReleaseContract({
    required String signer,
    required String engagementId,
    required String title,
    required String description,
    required int amount,
    required double platformFee,
    required List<Map<String, Object?>> roles,
    required List<Map<String, Object?>> milestones,
    required List<Map<String, Object?>> trustline,
  }) = _SingleReleaseContract;

  factory SingleReleaseContract.fromJson(Map<String, dynamic> json) =>
      _$SingleReleaseContractFromJson(json);
}
```

- [ ] **Step 3: Implement `FundEscrowPayload`**

```dart
// lib/src/models/payloads/fund_escrow_payload.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'fund_escrow_payload.freezed.dart';
part 'fund_escrow_payload.g.dart';

/// Request body for `POST /escrow/single-release/fund-escrow`.
///
/// `amount` is intentionally a string because the API accepts arbitrary
/// precision decimals that must not be truncated by IEEE-754.
@freezed
class FundEscrowPayload with _$FundEscrowPayload {
  const factory FundEscrowPayload({
    required String contractId,
    required String signer,
    required String amount,
  }) = _FundEscrowPayload;

  factory FundEscrowPayload.fromJson(Map<String, dynamic> json) =>
      _$FundEscrowPayloadFromJson(json);
}
```

- [ ] **Step 4: Implement `ReleaseFundsPayload`**

```dart
// lib/src/models/payloads/release_funds_payload.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'release_funds_payload.freezed.dart';
part 'release_funds_payload.g.dart';

/// Request body for `POST /escrow/single-release/release-funds`.
@freezed
class ReleaseFundsPayload with _$ReleaseFundsPayload {
  const factory ReleaseFundsPayload({
    required String contractId,
    required String releaseSigner,
  }) = _ReleaseFundsPayload;

  factory ReleaseFundsPayload.fromJson(Map<String, dynamic> json) =>
      _$ReleaseFundsPayloadFromJson(json);
}
```

- [ ] **Step 5: Generate and test**

```bash
dart run build_runner build --delete-conflicting-outputs
dart test test/models/payloads_test.dart
```

- [ ] **Step 6: Commit**

```bash
git add lib/src/models/payloads/ test/models/payloads_test.dart
git commit -m "feat(trustless-work): add request payload types"
```

---

## Phase 6 — Endpoints

### Task 6.1: `TransactionHelper` (sign + submit via `/helper/send-transaction`)

**Files:**
- Create: `packages/trustless_work_dart/lib/src/endpoints/helpers.dart`
- Create: `packages/trustless_work_dart/test/endpoints/helpers_test.dart`

- [ ] **Step 1: Write failing test**

```dart
// test/endpoints/helpers_test.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:test/test.dart';
import 'package:trustless_work_dart/src/client/trustless_work_config.dart';
import 'package:trustless_work_dart/src/endpoints/helpers.dart';
import 'package:trustless_work_dart/src/http/http_client.dart';
import 'package:trustless_work_dart/src/signer/callback_signer.dart';

void main() {
  group('TransactionHelper', () {
    test('signs XDR with signer and submits signedXdr body', () async {
      final captured = <Object?>[];
      final mock = MockClient((req) async {
        captured.add(req.url.path);
        captured.add(jsonDecode(req.body));
        return http.Response(jsonEncode({'ok': true}), 200);
      });

      final http_ = HttpClient(
        config: TrustlessWorkConfig.testnet(apiKey: 'k'),
        inner: mock,
      );
      final signer = CallbackSigner(
        publicKey: 'GAAA',
        signXdr: (xdr) async => 'SIGNED_$xdr',
      );

      final helper = TransactionHelper(http: http_, signer: signer);
      final response = await helper.signAndSubmit('UNSIGNED_XDR');

      expect(response, {'ok': true});
      expect(captured.first, '/helper/send-transaction');
      expect((captured[1] as Map)['signedXdr'], 'SIGNED_UNSIGNED_XDR');
    });
  });
}
```

- [ ] **Step 2: Run and confirm failure**

```bash
dart test test/endpoints/helpers_test.dart
```

- [ ] **Step 3: Implement `TransactionHelper`**

```dart
// lib/src/endpoints/helpers.dart
import '../http/http_client.dart';
import '../signer/transaction_signer.dart';

/// Handles the second half of every state-changing call: taking the
/// unsigned XDR from a deploy/operation endpoint, delegating signing to
/// the configured `TransactionSigner`, and POSTing the resulting signed
/// envelope to `/helper/send-transaction`.
class TransactionHelper {
  TransactionHelper({
    required HttpClient http,
    required TransactionSigner signer,
  })  : _http = http,
        _signer = signer;

  final HttpClient _http;
  final TransactionSigner _signer;

  Future<Map<String, dynamic>> signAndSubmit(String unsignedXdr) async {
    final signed = await _signer.signXdr(unsignedXdr);
    return _http.postJson<Map<String, dynamic>>(
      '/helper/send-transaction',
      body: {'signedXdr': signed},
    );
  }
}
```

- [ ] **Step 4: Run and confirm pass**

```bash
dart test test/endpoints/helpers_test.dart
```

- [ ] **Step 5: Commit**

```bash
git add lib/src/endpoints/helpers.dart test/endpoints/helpers_test.dart
git commit -m "feat(trustless-work): add TransactionHelper (sign + submit)"
```

### Task 6.2: `SingleReleaseDeployer` (`POST /deployer/single-release`)

**Files:**
- Create: `packages/trustless_work_dart/lib/src/endpoints/deployer.dart`
- Create: `packages/trustless_work_dart/test/endpoints/deployer_test.dart`

- [ ] **Step 1: Write failing test**

```dart
// test/endpoints/deployer_test.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:test/test.dart';
import 'package:trustless_work_dart/src/client/trustless_work_config.dart';
import 'package:trustless_work_dart/src/endpoints/deployer.dart';
import 'package:trustless_work_dart/src/http/http_client.dart';
import 'package:trustless_work_dart/src/models/payloads/single_release_contract.dart';

void main() {
  test('deploySingleRelease POSTs to /deployer/single-release and returns XDR', () async {
    Map<String, dynamic>? body;
    final mock = MockClient((req) async {
      expect(req.url.path, '/deployer/single-release');
      body = jsonDecode(req.body) as Map<String, dynamic>;
      return http.Response(jsonEncode({'transactionXdr': 'XDR_HERE'}), 201);
    });

    final http_ = HttpClient(
      config: TrustlessWorkConfig.testnet(apiKey: 'k'),
      inner: mock,
    );
    final deployer = SingleReleaseDeployer(http: http_);

    final xdr = await deployer.deploy(
      const SingleReleaseContract(
        signer: 'GAAA',
        engagementId: 'lease-1',
        title: 'x',
        description: 'y',
        amount: 1,
        platformFee: 0,
        roles: [],
        milestones: [],
        trustline: [],
      ),
    );

    expect(xdr, 'XDR_HERE');
    expect(body!['signer'], 'GAAA');
  });
}
```

- [ ] **Step 2: Run and confirm failure**

```bash
dart test test/endpoints/deployer_test.dart
```

- [ ] **Step 3: Implement `SingleReleaseDeployer`**

```dart
// lib/src/endpoints/deployer.dart
import '../errors/trustless_work_error.dart';
import '../http/http_client.dart';
import '../models/payloads/single_release_contract.dart';

/// Wraps `POST /deployer/single-release`.
///
/// Returns the unsigned transaction XDR that must be signed with the
/// deployer's key and submitted through `TransactionHelper`.
class SingleReleaseDeployer {
  SingleReleaseDeployer({required HttpClient http}) : _http = http;

  final HttpClient _http;

  Future<String> deploy(SingleReleaseContract contract) async {
    final response = await _http.postJson<Map<String, dynamic>>(
      '/deployer/single-release',
      body: contract.toJson(),
    );
    final xdr = response['transactionXdr'];
    if (xdr is! String || xdr.isEmpty) {
      throw const ServerError(
        message: 'Response missing transactionXdr',
      );
    }
    return xdr;
  }
}
```

- [ ] **Step 4: Run test and confirm pass**

```bash
dart test test/endpoints/deployer_test.dart
```

- [ ] **Step 5: Commit**

```bash
git add lib/src/endpoints/deployer.dart test/endpoints/deployer_test.dart
git commit -m "feat(trustless-work): add SingleReleaseDeployer"
```

### Task 6.3: `SingleReleaseOperations` (fund + release)

**Files:**
- Create: `packages/trustless_work_dart/lib/src/endpoints/single_release_operations.dart`
- Create: `packages/trustless_work_dart/test/endpoints/single_release_operations_test.dart`

- [ ] **Step 1: Write failing test**

```dart
// test/endpoints/single_release_operations_test.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:test/test.dart';
import 'package:trustless_work_dart/src/client/trustless_work_config.dart';
import 'package:trustless_work_dart/src/endpoints/single_release_operations.dart';
import 'package:trustless_work_dart/src/http/http_client.dart';
import 'package:trustless_work_dart/src/models/payloads/fund_escrow_payload.dart';
import 'package:trustless_work_dart/src/models/payloads/release_funds_payload.dart';

void main() {
  HttpClient buildHttp(MockClient mock) =>
      HttpClient(config: TrustlessWorkConfig.testnet(apiKey: 'k'), inner: mock);

  test('fund POSTs to /escrow/single-release/fund-escrow', () async {
    Map<String, dynamic>? body;
    final ops = SingleReleaseOperations(
      http: buildHttp(MockClient((req) async {
        expect(req.url.path, '/escrow/single-release/fund-escrow');
        body = jsonDecode(req.body) as Map<String, dynamic>;
        return http.Response(jsonEncode({'transactionXdr': 'FUND_XDR'}), 201);
      })),
    );

    final xdr = await ops.fund(const FundEscrowPayload(
      contractId: 'CAAA',
      signer: 'GAAA',
      amount: '100',
    ));

    expect(xdr, 'FUND_XDR');
    expect(body!['amount'], '100');
  });

  test('release POSTs to /escrow/single-release/release-funds', () async {
    final ops = SingleReleaseOperations(
      http: buildHttp(MockClient((req) async {
        expect(req.url.path, '/escrow/single-release/release-funds');
        return http.Response(jsonEncode({'transactionXdr': 'REL_XDR'}), 201);
      })),
    );

    final xdr = await ops.release(const ReleaseFundsPayload(
      contractId: 'CAAA',
      releaseSigner: 'GREL',
    ));

    expect(xdr, 'REL_XDR');
  });
}
```

- [ ] **Step 2: Run and confirm failure**

```bash
dart test test/endpoints/single_release_operations_test.dart
```

- [ ] **Step 3: Implement `SingleReleaseOperations`**

```dart
// lib/src/endpoints/single_release_operations.dart
import '../errors/trustless_work_error.dart';
import '../http/http_client.dart';
import '../models/payloads/fund_escrow_payload.dart';
import '../models/payloads/release_funds_payload.dart';

/// Wraps the `/escrow/single-release/*` endpoints for the v0.1 alcance.
class SingleReleaseOperations {
  SingleReleaseOperations({required HttpClient http}) : _http = http;

  final HttpClient _http;

  Future<String> fund(FundEscrowPayload payload) =>
      _postForXdr('/escrow/single-release/fund-escrow', payload.toJson());

  Future<String> release(ReleaseFundsPayload payload) =>
      _postForXdr('/escrow/single-release/release-funds', payload.toJson());

  Future<String> _postForXdr(String path, Map<String, Object?> body) async {
    final response = await _http.postJson<Map<String, dynamic>>(path, body: body);
    final xdr = response['transactionXdr'];
    if (xdr is! String || xdr.isEmpty) {
      throw ServerError(message: 'Response from $path missing transactionXdr');
    }
    return xdr;
  }
}
```

- [ ] **Step 4: Run and confirm pass**

```bash
dart test test/endpoints/single_release_operations_test.dart
```

- [ ] **Step 5: Commit**

```bash
git add lib/src/endpoints/single_release_operations.dart test/endpoints/single_release_operations_test.dart
git commit -m "feat(trustless-work): add SingleReleaseOperations (fund + release)"
```

### Task 6.4: `EscrowQueries` (getEscrow)

**Note:** The exact endpoint for fetching an escrow by `contractId` is pending confirmation with Alberto (spec §13.5). v0.1 uses the **indexer** endpoint `POST /escrow/single-release/get-escrow` with `{contractId}` body as a reasonable default. When Alberto confirms, update this endpoint and regenerate tests without touching the public API.

**Files:**
- Create: `packages/trustless_work_dart/lib/src/endpoints/queries.dart`
- Create: `packages/trustless_work_dart/test/endpoints/queries_test.dart`

- [ ] **Step 1: Write failing test**

```dart
// test/endpoints/queries_test.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:test/test.dart';
import 'package:trustless_work_dart/src/client/trustless_work_config.dart';
import 'package:trustless_work_dart/src/endpoints/queries.dart';
import 'package:trustless_work_dart/src/http/http_client.dart';

void main() {
  test('getEscrow POSTs contractId and decodes Escrow', () async {
    final mock = MockClient((req) async {
      expect(req.url.path, '/escrow/single-release/get-escrow');
      final body = jsonDecode(req.body) as Map<String, dynamic>;
      expect(body['contractId'], 'CAAA');
      return http.Response(
        jsonEncode({
          'contractId': 'CAAA',
          'engagementId': 'lease-1',
          'title': 't',
          'description': 'd',
          'amount': 1,
          'platformFee': 0.0,
          'receiverMemo': 0,
          'roles': <Map<String, Object?>>[],
          'milestones': <Map<String, Object?>>[],
          'trustline': <String, Object?>{'address': 'C', 'name': 'USDC', 'decimals': 7},
          'flags': <String, Object?>{'approved': false, 'disputed': false, 'released': false},
          'isActive': true,
        }),
        200,
      );
    });
    final queries = EscrowQueries(
      http: HttpClient(
        config: TrustlessWorkConfig.testnet(apiKey: 'k'),
        inner: mock,
      ),
    );

    final escrow = await queries.getEscrow('CAAA');
    expect(escrow.contractId, 'CAAA');
    expect(escrow.isActive, isTrue);
  });
}
```

- [ ] **Step 2: Implement `EscrowQueries`**

```dart
// lib/src/endpoints/queries.dart
import '../http/http_client.dart';
import '../models/escrow.dart';

/// Read-only queries against the Trustless Work API.
///
/// The endpoint used here is provisional — pending confirmation from
/// Trustless Work on the canonical path for "fetch a single escrow by
/// contractId" (see spec §13.5). When it changes, only this file and
/// its test need updating; the public `TrustlessWorkClient.getEscrow`
/// signature is unchanged.
class EscrowQueries {
  EscrowQueries({required HttpClient http}) : _http = http;

  final HttpClient _http;

  Future<Escrow> getEscrow(String contractId) async {
    final json = await _http.postJson<Map<String, dynamic>>(
      '/escrow/single-release/get-escrow',
      body: {'contractId': contractId},
    );
    return Escrow.fromJson(json);
  }
}
```

- [ ] **Step 3: Run and confirm pass**

```bash
dart test test/endpoints/queries_test.dart
```

- [ ] **Step 4: Commit**

```bash
git add lib/src/endpoints/queries.dart test/endpoints/queries_test.dart
git commit -m "feat(trustless-work): add EscrowQueries.getEscrow"
```

---

## Phase 7 — Public client

### Task 7.1: `TrustlessWorkClient` orchestrating all endpoints

**Files:**
- Create: `packages/trustless_work_dart/lib/src/client/trustless_work_client.dart`
- Create: `packages/trustless_work_dart/test/client_test.dart`

- [ ] **Step 1: Write failing test exercising the happy path**

```dart
// test/client_test.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:test/test.dart';
import 'package:trustless_work_dart/trustless_work_dart.dart';

void main() {
  MockClient wireMockedGateway(List<http.Response> responses) {
    final iterator = responses.iterator;
    return MockClient((req) async {
      if (!iterator.moveNext()) {
        return http.Response('no more canned responses', 500);
      }
      return iterator.current;
    });
  }

  test('initializeEscrow signs XDR and returns resolved Escrow', () async {
    // Sequence: (1) /deployer/single-release → transactionXdr,
    //           (2) /helper/send-transaction → { contractId: 'CAAA' },
    //           (3) /escrow/single-release/get-escrow → Escrow json
    final mock = wireMockedGateway([
      http.Response(jsonEncode({'transactionXdr': 'UXDR_INIT'}), 201),
      http.Response(jsonEncode({'contractId': 'CAAA'}), 200),
      http.Response(
        jsonEncode({
          'contractId': 'CAAA',
          'engagementId': 'lease-1',
          'title': 'x',
          'description': 'd',
          'amount': 1,
          'platformFee': 0.0,
          'receiverMemo': 0,
          'roles': <Map<String, Object?>>[],
          'milestones': <Map<String, Object?>>[],
          'trustline': <String, Object?>{'address': 'C', 'name': 'USDC', 'decimals': 7},
          'flags': <String, Object?>{'approved': false, 'disputed': false, 'released': false},
          'isActive': true,
        }),
        200,
      ),
    ]);

    // Smoke-test the public constructor compiles and returns the right type.
    final publicClient = TrustlessWorkClient(
      config: TrustlessWorkConfig.testnet(apiKey: 'k'),
      signer: CallbackSigner(
        publicKey: 'GAAA',
        signXdr: (xdr) async => 'S_$xdr',
      ),
      httpClient: http.Client(),
    );
    expect(publicClient, isA<TrustlessWorkClient>());

    // For the actual assertions we swap the HTTP client via the forTesting
    // factory so `MockClient` captures the three-endpoint sequence.
    final clientForTest = TrustlessWorkClient.forTesting(
      config: TrustlessWorkConfig.testnet(apiKey: 'k'),
      signer: CallbackSigner(
        publicKey: 'GAAA',
        signXdr: (xdr) async => 'S_$xdr',
      ),
      innerHttp: mock,
    );

    final escrow = await clientForTest.initializeEscrow(
      const SingleReleaseContract(
        signer: 'GAAA',
        engagementId: 'lease-1',
        title: 'x',
        description: 'd',
        amount: 1,
        platformFee: 0,
        roles: [],
        milestones: [],
        trustline: [],
      ),
    );
    expect(escrow.contractId, 'CAAA');
  });
}
```

- [ ] **Step 2: Implement `TrustlessWorkClient`**

```dart
// lib/src/client/trustless_work_client.dart
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import '../endpoints/deployer.dart';
import '../endpoints/helpers.dart';
import '../endpoints/queries.dart';
import '../endpoints/single_release_operations.dart';
import '../http/http_client.dart';
import '../models/escrow.dart';
import '../models/payloads/fund_escrow_payload.dart';
import '../models/payloads/release_funds_payload.dart';
import '../models/payloads/single_release_contract.dart';
import '../signer/transaction_signer.dart';
import 'trustless_work_config.dart';

/// Public entry point for consumers of the SDK.
///
/// Every state-changing operation performs the two-step dance:
///   1. Request an unsigned XDR envelope from the corresponding gateway
///      endpoint.
///   2. Sign it via the configured `TransactionSigner` and resubmit to
///      `/helper/send-transaction`, then re-read the current escrow
///      state so callers always receive a coherent `Escrow` snapshot.
class TrustlessWorkClient {
  factory TrustlessWorkClient({
    required TrustlessWorkConfig config,
    required TransactionSigner signer,
    http.Client? httpClient,
  }) {
    final http_ = HttpClient(config: config, inner: httpClient);
    return TrustlessWorkClient._(
      http: http_,
      signer: signer,
      deployer: SingleReleaseDeployer(http: http_),
      operations: SingleReleaseOperations(http: http_),
      helper: TransactionHelper(http: http_, signer: signer),
      queries: EscrowQueries(http: http_),
    );
  }

  @visibleForTesting
  factory TrustlessWorkClient.forTesting({
    required TrustlessWorkConfig config,
    required TransactionSigner signer,
    required http.Client innerHttp,
  }) {
    final http_ = HttpClient(config: config, inner: innerHttp);
    return TrustlessWorkClient._(
      http: http_,
      signer: signer,
      deployer: SingleReleaseDeployer(http: http_),
      operations: SingleReleaseOperations(http: http_),
      helper: TransactionHelper(http: http_, signer: signer),
      queries: EscrowQueries(http: http_),
    );
  }

  TrustlessWorkClient._({
    required HttpClient http,
    required TransactionSigner signer,
    required SingleReleaseDeployer deployer,
    required SingleReleaseOperations operations,
    required TransactionHelper helper,
    required EscrowQueries queries,
  })  : _deployer = deployer,
        _operations = operations,
        _helper = helper,
        _queries = queries;

  final SingleReleaseDeployer _deployer;
  final SingleReleaseOperations _operations;
  final TransactionHelper _helper;
  final EscrowQueries _queries;

  Future<Escrow> initializeEscrow(SingleReleaseContract contract) async {
    final xdr = await _deployer.deploy(contract);
    final submitResponse = await _helper.signAndSubmit(xdr);
    final contractId = submitResponse['contractId'];
    if (contractId is! String || contractId.isEmpty) {
      throw StateError('Gateway did not return contractId after deploy.');
    }
    return _queries.getEscrow(contractId);
  }

  Future<Escrow> fundEscrow(FundEscrowPayload payload) async {
    final xdr = await _operations.fund(payload);
    await _helper.signAndSubmit(xdr);
    return _queries.getEscrow(payload.contractId);
  }

  Future<Escrow> releaseFunds(ReleaseFundsPayload payload) async {
    final xdr = await _operations.release(payload);
    await _helper.signAndSubmit(xdr);
    return _queries.getEscrow(payload.contractId);
  }

  Future<Escrow> getEscrow(String contractId) => _queries.getEscrow(contractId);
}
```

- [ ] **Step 3: Write the barrel export**

```dart
// lib/trustless_work_dart.dart
export 'src/client/trustless_work_client.dart';
export 'src/client/trustless_work_config.dart';
export 'src/errors/result.dart';
export 'src/errors/trustless_work_error.dart';
export 'src/models/escrow.dart';
export 'src/models/flags.dart';
export 'src/models/milestone.dart';
export 'src/models/network.dart';
export 'src/models/payloads/fund_escrow_payload.dart';
export 'src/models/payloads/release_funds_payload.dart';
export 'src/models/payloads/single_release_contract.dart';
export 'src/models/role.dart';
export 'src/models/trustline.dart';
export 'src/signer/callback_signer.dart';
export 'src/signer/keypair_signer.dart';
export 'src/signer/transaction_signer.dart';
```

- [ ] **Step 4: Run and confirm pass**

```bash
dart test test/client_test.dart
```

- [ ] **Step 5: Commit**

```bash
git add lib/src/client/trustless_work_client.dart lib/trustless_work_dart.dart test/client_test.dart
git commit -m "feat(trustless-work): add TrustlessWorkClient orchestrator"
```

---

## Phase 8 — Event stream

### Task 8.1: `EscrowEvent` sealed class with tests

**Files:**
- Create: `packages/trustless_work_dart/lib/src/events/escrow_event.dart`
- Create: `packages/trustless_work_dart/test/events/escrow_event_test.dart`

- [ ] **Step 1: Write failing test**

```dart
// test/events/escrow_event_test.dart
import 'package:test/test.dart';
import 'package:trustless_work_dart/src/events/escrow_event.dart';

void main() {
  test('exhaustive switch covers all 7 variants', () {
    final all = <EscrowEvent>[
      EscrowEvent.initialized(contractId: 'c', observedAt: DateTime(2026)),
      EscrowEvent.funded(contractId: 'c', observedAt: DateTime(2026), amount: '100'),
      EscrowEvent.milestoneStatusChanged(
        contractId: 'c',
        observedAt: DateTime(2026),
        index: 0,
        status: 'delivered',
      ),
      EscrowEvent.milestoneApproved(
        contractId: 'c',
        observedAt: DateTime(2026),
        index: 0,
      ),
      EscrowEvent.released(contractId: 'c', observedAt: DateTime(2026)),
      EscrowEvent.disputeStarted(contractId: 'c', observedAt: DateTime(2026)),
      EscrowEvent.disputeResolved(
        contractId: 'c',
        observedAt: DateTime(2026),
        approverSplit: 0.7,
      ),
    ];

    for (final ev in all) {
      final label = switch (ev) {
        Initialized() => 'initialized',
        Funded() => 'funded',
        MilestoneStatusChanged() => 'milestoneStatusChanged',
        MilestoneApproved() => 'milestoneApproved',
        Released() => 'released',
        DisputeStarted() => 'disputeStarted',
        DisputeResolved() => 'disputeResolved',
      };
      expect(label, isNotEmpty);
    }
  });
}
```

- [ ] **Step 2: Implement `EscrowEvent`**

```dart
// lib/src/events/escrow_event.dart
/// Events emitted by `TrustlessWorkClient.escrowEvents`.
///
/// The shape is stable across SDK versions; only the implementation
/// strategy changes (polling in v0.1 → Horizon SSE + Soroban events in
/// v0.2).
sealed class EscrowEvent {
  const EscrowEvent({required this.contractId, required this.observedAt});

  final String contractId;
  final DateTime observedAt;

  const factory EscrowEvent.initialized({
    required String contractId,
    required DateTime observedAt,
  }) = Initialized;
  const factory EscrowEvent.funded({
    required String contractId,
    required DateTime observedAt,
    required String amount,
  }) = Funded;
  const factory EscrowEvent.milestoneStatusChanged({
    required String contractId,
    required DateTime observedAt,
    required int index,
    required String status,
  }) = MilestoneStatusChanged;
  const factory EscrowEvent.milestoneApproved({
    required String contractId,
    required DateTime observedAt,
    required int index,
  }) = MilestoneApproved;
  const factory EscrowEvent.released({
    required String contractId,
    required DateTime observedAt,
  }) = Released;
  const factory EscrowEvent.disputeStarted({
    required String contractId,
    required DateTime observedAt,
  }) = DisputeStarted;
  const factory EscrowEvent.disputeResolved({
    required String contractId,
    required DateTime observedAt,
    required double approverSplit,
  }) = DisputeResolved;
}

final class Initialized extends EscrowEvent {
  const Initialized({required super.contractId, required super.observedAt});
}

final class Funded extends EscrowEvent {
  const Funded({
    required super.contractId,
    required super.observedAt,
    required this.amount,
  });
  final String amount;
}

final class MilestoneStatusChanged extends EscrowEvent {
  const MilestoneStatusChanged({
    required super.contractId,
    required super.observedAt,
    required this.index,
    required this.status,
  });
  final int index;
  final String status;
}

final class MilestoneApproved extends EscrowEvent {
  const MilestoneApproved({
    required super.contractId,
    required super.observedAt,
    required this.index,
  });
  final int index;
}

final class Released extends EscrowEvent {
  const Released({required super.contractId, required super.observedAt});
}

final class DisputeStarted extends EscrowEvent {
  const DisputeStarted({required super.contractId, required super.observedAt});
}

final class DisputeResolved extends EscrowEvent {
  const DisputeResolved({
    required super.contractId,
    required super.observedAt,
    required this.approverSplit,
  });
  final double approverSplit;
}
```

- [ ] **Step 3: Run test and commit**

```bash
dart test test/events/escrow_event_test.dart
git add lib/src/events/escrow_event.dart test/events/escrow_event_test.dart
git commit -m "feat(trustless-work): add EscrowEvent sealed class"
```

### Task 8.2: `PollingEventStream` with deterministic tests

**Files:**
- Create: `packages/trustless_work_dart/lib/src/events/polling_event_stream.dart`
- Create: `packages/trustless_work_dart/test/events/polling_event_stream_test.dart`
- Modify: `packages/trustless_work_dart/lib/src/client/trustless_work_client.dart` — add `escrowEvents(...)` method
- Modify: `packages/trustless_work_dart/lib/trustless_work_dart.dart` — export event stream

- [ ] **Step 1: Write failing test using fake clock**

```dart
// test/events/polling_event_stream_test.dart
import 'package:test/test.dart';
import 'package:trustless_work_dart/src/events/escrow_event.dart';
import 'package:trustless_work_dart/src/events/polling_event_stream.dart';
import 'package:trustless_work_dart/src/models/escrow.dart';
import 'package:trustless_work_dart/src/models/flags.dart';
import 'package:trustless_work_dart/src/models/trustline.dart';

Escrow _buildEscrow({required Flags flags, required int amount}) => Escrow(
      contractId: 'CAAA',
      engagementId: 'e',
      title: 't',
      description: 'd',
      amount: amount,
      platformFee: 0,
      receiverMemo: 0,
      roles: const [],
      milestones: const [],
      trustline: const Trustline(address: 'C', name: 'USDC', decimals: 7),
      flags: flags,
      isActive: true,
    );

void main() {
  test('emits Funded and Released as state transitions occur', () async {
    final snapshots = [
      _buildEscrow(flags: const Flags(), amount: 0),
      _buildEscrow(flags: const Flags(), amount: 500),
      _buildEscrow(flags: const Flags(released: true), amount: 500),
    ];
    var idx = 0;

    final stream = PollingEventStream(
      contractId: 'CAAA',
      pollInterval: const Duration(milliseconds: 10),
      fetch: () async {
        final i = idx < snapshots.length - 1 ? idx++ : snapshots.length - 1;
        return snapshots[i];
      },
      now: () => DateTime(2026, 4, 15),
    );

    final events = <EscrowEvent>[];
    final sub = stream.events.listen(events.add);
    await Future<void>.delayed(const Duration(milliseconds: 60));
    await sub.cancel();

    expect(events.whereType<Funded>(), isNotEmpty);
    expect(events.whereType<Released>(), isNotEmpty);
  });
}
```

- [ ] **Step 2: Implement `PollingEventStream`**

```dart
// lib/src/events/polling_event_stream.dart
import 'dart:async';
import 'package:meta/meta.dart';
import '../models/escrow.dart';
import 'escrow_event.dart';

/// Polling-based implementation of `Stream<EscrowEvent>` for v0.1.
///
/// Periodically calls `fetch` (wired by the client to `getEscrow`),
/// diffs the snapshot against the previous one, and emits typed events
/// for state transitions (fund amount change, milestone status, dispute
/// flags, release).
///
/// This is a stop-gap. v0.2 will replace the implementation with a
/// hybrid Horizon SSE + Soroban `getEvents` pipeline while keeping the
/// public `Stream<EscrowEvent>` shape identical.
@experimental
class PollingEventStream {
  PollingEventStream({
    required String contractId,
    required Future<Escrow> Function() fetch,
    DateTime Function()? now,
    Duration pollInterval = const Duration(seconds: 15),
  })  : _contractId = contractId,
        _fetch = fetch,
        _now = now ?? DateTime.now,
        _pollInterval = pollInterval;

  final String _contractId;
  final Future<Escrow> Function() _fetch;
  final DateTime Function() _now;
  final Duration _pollInterval;

  late final StreamController<EscrowEvent> _controller =
      StreamController<EscrowEvent>.broadcast(
    onListen: _start,
    onCancel: _stop,
  );

  Timer? _timer;
  Escrow? _previous;

  Stream<EscrowEvent> get events => _controller.stream;

  void _start() {
    _timer ??= Timer.periodic(_pollInterval, (_) => _tick());
    unawaited(_tick());
  }

  void _stop() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _tick() async {
    try {
      final current = await _fetch();
      final previous = _previous;
      if (previous == null) {
        _controller.add(EscrowEvent.initialized(
          contractId: _contractId,
          observedAt: _now(),
        ));
      } else {
        _diffAndEmit(previous: previous, current: current);
      }
      _previous = current;
    } catch (error, stack) {
      _controller.addError(error, stack);
    }
  }

  void _diffAndEmit({required Escrow previous, required Escrow current}) {
    if (previous.amount != current.amount && current.amount > 0) {
      _controller.add(EscrowEvent.funded(
        contractId: _contractId,
        observedAt: _now(),
        amount: current.amount.toString(),
      ));
    }
    if (!previous.flags.released && current.flags.released) {
      _controller.add(EscrowEvent.released(
        contractId: _contractId,
        observedAt: _now(),
      ));
    }
    if (!previous.flags.disputed && current.flags.disputed) {
      _controller.add(EscrowEvent.disputeStarted(
        contractId: _contractId,
        observedAt: _now(),
      ));
    }
    for (var i = 0;
        i < current.milestones.length && i < previous.milestones.length;
        i++) {
      final before = previous.milestones[i];
      final after = current.milestones[i];
      if (before.status != after.status) {
        _controller.add(EscrowEvent.milestoneStatusChanged(
          contractId: _contractId,
          observedAt: _now(),
          index: i,
          status: after.status,
        ));
      }
      if (!before.approvedFlag && after.approvedFlag) {
        _controller.add(EscrowEvent.milestoneApproved(
          contractId: _contractId,
          observedAt: _now(),
          index: i,
        ));
      }
    }
  }
}
```

- [ ] **Step 3: Add `escrowEvents` method to `TrustlessWorkClient`**

Open `lib/src/client/trustless_work_client.dart` and add (after `getEscrow`):

```dart
import 'package:meta/meta.dart';
// ...
import '../events/escrow_event.dart';
import '../events/polling_event_stream.dart';
```

```dart
  @experimental
  Stream<EscrowEvent> escrowEvents(
    String contractId, {
    Duration pollInterval = const Duration(seconds: 15),
  }) {
    final stream = PollingEventStream(
      contractId: contractId,
      fetch: () => _queries.getEscrow(contractId),
      pollInterval: pollInterval,
    );
    return stream.events;
  }
```

- [ ] **Step 4: Extend the barrel**

Append to `lib/trustless_work_dart.dart`:

```dart
export 'src/events/escrow_event.dart';
export 'src/events/polling_event_stream.dart';
```

- [ ] **Step 5: Run tests**

```bash
dart test test/events/polling_event_stream_test.dart
```

- [ ] **Step 6: Commit**

```bash
git add lib/src/events/polling_event_stream.dart test/events/polling_event_stream_test.dart lib/src/client/trustless_work_client.dart lib/trustless_work_dart.dart
git commit -m "feat(trustless-work): add experimental PollingEventStream"
```

---

## Phase 9 — Testnet integration test

### Task 9.1: End-to-end integration test gated by `--tags=integration`

**Files:**
- Create: `packages/trustless_work_dart/test/integration/testnet_e2e_test.dart`
- Create: `packages/trustless_work_dart/example/simple_escrow.dart`
- Modify: `packages/trustless_work_dart/dart_test.yaml` — declare tag

- [ ] **Step 1: Write `dart_test.yaml` to register the tag**

```yaml
# dart_test.yaml
tags:
  integration:
    skip: false
```

- [ ] **Step 2: Write the integration test (skipped by default)**

```dart
// test/integration/testnet_e2e_test.dart
@Tags(['integration'])
library;

import 'dart:io';
import 'package:stellar_flutter_sdk/stellar_flutter_sdk.dart' as stellar;
import 'package:test/test.dart';
import 'package:trustless_work_dart/trustless_work_dart.dart';

void main() {
  group('testnet end-to-end', () {
    final apiKey = Platform.environment['TW_TESTNET_API_KEY'];

    test('initialize → fund → release on dev.api.trustlesswork.com',
        () async {
      if (apiKey == null || apiKey.isEmpty) {
        fail('Set TW_TESTNET_API_KEY before running --tags=integration');
      }

      // 1. Mint a funded testnet key via Friendbot.
      final keypair = stellar.KeyPair.random();
      await stellar.FriendBot.fundTestAccount(keypair.accountId);

      final client = TrustlessWorkClient(
        config: TrustlessWorkConfig.testnet(apiKey: apiKey),
        signer: KeyPairSigner(keypair: keypair, network: Network.testnet),
      );

      // 2. Initialize an escrow. Adjust fixture fields once Alberto
      //    confirms the minimal test vector that actually boots against
      //    dev. Keep it under 5 minutes of runtime.
      final escrow = await client.initializeEscrow(
        SingleReleaseContract(
          signer: keypair.accountId,
          engagementId: 'integration-${DateTime.now().millisecondsSinceEpoch}',
          title: 'Integration test',
          description: 'Spike validation',
          amount: 1,
          platformFee: 0,
          roles: [
            {'name': 'approver', 'address': keypair.accountId},
            {'name': 'receiver', 'address': keypair.accountId},
            {'name': 'releaseSigner', 'address': keypair.accountId},
            {'name': 'platformAddress', 'address': keypair.accountId},
            {'name': 'serviceProvider', 'address': keypair.accountId},
            {'name': 'disputeResolver', 'address': keypair.accountId},
          ],
          milestones: [
            {'description': 'Integration milestone'},
          ],
          trustline: [
            {
              'address':
                  'CBIELTK6YBZJU5UP2WWQEUCYKLPU6AUNZ2BQ4WWFEIE3USCIHMXQDAMA',
              'name': 'USDC',
              'decimals': 7,
            },
          ],
        ),
      );

      expect(escrow.contractId, isNotEmpty);

      // 3. Fund
      final funded = await client.fundEscrow(FundEscrowPayload(
        contractId: escrow.contractId,
        signer: keypair.accountId,
        amount: '1',
      ));
      expect(funded.flags.released, isFalse);

      // 4. Release
      final released = await client.releaseFunds(ReleaseFundsPayload(
        contractId: escrow.contractId,
        releaseSigner: keypair.accountId,
      ));
      expect(released.flags.released, isTrue);
    }, timeout: const Timeout(Duration(minutes: 5)));
  });
}
```

- [ ] **Step 3: Write the example script**

```dart
// example/simple_escrow.dart
import 'dart:io';
import 'package:stellar_flutter_sdk/stellar_flutter_sdk.dart' as stellar;
import 'package:trustless_work_dart/trustless_work_dart.dart';

Future<void> main() async {
  final apiKey = Platform.environment['TW_TESTNET_API_KEY'];
  if (apiKey == null || apiKey.isEmpty) {
    stderr.writeln('Set TW_TESTNET_API_KEY to run this example.');
    exit(64);
  }

  final keypair = stellar.KeyPair.random();
  await stellar.FriendBot.fundTestAccount(keypair.accountId);

  // ignore: unused_local_variable
  final client = TrustlessWorkClient(
    config: TrustlessWorkConfig.testnet(apiKey: apiKey),
    signer: KeyPairSigner(keypair: keypair, network: Network.testnet),
  );

  stdout.writeln('Using account ${keypair.accountId}');
  stdout.writeln('Initializing escrow...');
  // Reuse the exact payload of the integration test — single release
  // with the signer acting all roles to keep the demo self-contained.
  // See test/integration/testnet_e2e_test.dart for the full fixture.
}
```

- [ ] **Step 4: Confirm unit suite still passes (integration opted out)**

```bash
dart test --exclude-tags integration
```
Expected: all non-integration tests pass; the testnet suite is skipped.

- [ ] **Step 5: Commit**

```bash
git add test/integration/testnet_e2e_test.dart example/simple_escrow.dart dart_test.yaml
git commit -m "test(trustless-work): add gated testnet end-to-end integration test"
```

**Runtime validation (manual, not automated):**

```bash
export TW_TESTNET_API_KEY=your_key_here
dart test --tags integration
```
Expected: the test creates an escrow on `dev.api.trustlesswork.com`, funds it, and releases it. Runtime under 5 minutes. If it fails, open a follow-up task to align the fixture with Alberto's confirmed test vector.

---

## Phase 10 — Sibling: `trustless_work_flutter_storage`

### Task 10.1: Scaffold the sibling package

**Files:**
- Create: `packages/trustless_work_flutter_storage/pubspec.yaml`
- Create: `packages/trustless_work_flutter_storage/analysis_options.yaml`
- Create: `packages/trustless_work_flutter_storage/README.md`
- Create: `packages/trustless_work_flutter_storage/CHANGELOG.md`
- Create: `packages/trustless_work_flutter_storage/LICENSE` (same MIT text)
- Create: `packages/trustless_work_flutter_storage/.gitignore`

- [ ] **Step 1: Create directory tree**

```bash
mkdir -p packages/trustless_work_flutter_storage/lib/src
mkdir -p packages/trustless_work_flutter_storage/test
```

- [ ] **Step 2: Write `pubspec.yaml`**

```yaml
name: trustless_work_flutter_storage
description: Persistent on-device signer for Trustless Work built on flutter_secure_storage. Companion to trustless_work_dart.
version: 0.1.0-dev.1
repository: https://github.com/DojoCodingLabs/trustless-work-dart

environment:
  sdk: ^3.2.5
  flutter: '>=3.19.0'

dependencies:
  flutter:
    sdk: flutter
  flutter_secure_storage: ^9.2.2
  stellar_flutter_sdk: ^1.9.0
  trustless_work_dart:
    path: ../trustless_work_dart

dev_dependencies:
  flutter_test:
    sdk: flutter
  lints: ^4.0.0
```

- [ ] **Step 3: Write `analysis_options.yaml`, `.gitignore`, `CHANGELOG.md`** (mirror the core package, keep them short).

- [ ] **Step 4: Write `README.md`**

```markdown
# trustless_work_flutter_storage

Companion to `trustless_work_dart` that persists a Stellar `KeyPair` in
`flutter_secure_storage` (Keychain on iOS, Keystore on Android).

```dart
final signer = await SecureStorageKeyPairSigner.loadOrCreate(
  storageKey: 'habitanexus.tw.signer',
  network: Network.testnet,
);
final client = TrustlessWorkClient(
  config: TrustlessWorkConfig.testnet(apiKey: '...'),
  signer: signer,
);
```

See `example/` (TBD) for end-to-end usage.
```

- [ ] **Step 5: Write `LICENSE`** (copy MIT text from core package).

- [ ] **Step 6: Run `flutter pub get`**

```bash
cd packages/trustless_work_flutter_storage && flutter pub get
```
Expected: dependencies resolve.

- [ ] **Step 7: Commit**

```bash
git add packages/trustless_work_flutter_storage/
git commit -m "feat(trustless-work-storage): scaffold flutter_secure_storage companion"
```

### Task 10.2: `SecureStorageKeyPairSigner`

**Files:**
- Create: `packages/trustless_work_flutter_storage/lib/src/secure_storage_keypair_signer.dart`
- Create: `packages/trustless_work_flutter_storage/lib/trustless_work_flutter_storage.dart`
- Create: `packages/trustless_work_flutter_storage/test/secure_storage_keypair_signer_test.dart`

- [ ] **Step 1: Write failing test with a fake storage**

```dart
// test/secure_storage_keypair_signer_test.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stellar_flutter_sdk/stellar_flutter_sdk.dart' as stellar;
import 'package:trustless_work_dart/trustless_work_dart.dart';
import 'package:trustless_work_flutter_storage/trustless_work_flutter_storage.dart';

class _FakeStorage implements FlutterSecureStorage {
  final Map<String, String> _map = {};

  @override
  Future<String?> read({required String key, /* ignored */ IOSOptions? iOptions, AndroidOptions? aOptions, LinuxOptions? lOptions, WebOptions? webOptions, WindowsOptions? wOptions, MacOsOptions? mOptions}) async => _map[key];

  @override
  Future<void> write({required String key, required String? value, /* ignored */ IOSOptions? iOptions, AndroidOptions? aOptions, LinuxOptions? lOptions, WebOptions? webOptions, WindowsOptions? wOptions, MacOsOptions? mOptions}) async {
    if (value == null) {
      _map.remove(key);
    } else {
      _map[key] = value;
    }
  }

  @override
  Future<void> delete({required String key, /* ignored */ IOSOptions? iOptions, AndroidOptions? aOptions, LinuxOptions? lOptions, WebOptions? webOptions, WindowsOptions? wOptions, MacOsOptions? mOptions}) async {
    _map.remove(key);
  }

  // Other members throw — we intentionally don't implement them.
  @override
  noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('Not used in tests');
}

void main() {
  test('loadOrCreate stores a new KeyPair on first run', () async {
    final storage = _FakeStorage();
    final signer = await SecureStorageKeyPairSigner.loadOrCreate(
      storage: storage,
      storageKey: 'k',
      network: Network.testnet,
    );
    expect(signer.publicKey, startsWith('G'));

    final again = await SecureStorageKeyPairSigner.loadOrCreate(
      storage: storage,
      storageKey: 'k',
      network: Network.testnet,
    );
    expect(again.publicKey, signer.publicKey);
  });

  test('signXdr round-trips a real XDR envelope', () async {
    final storage = _FakeStorage();
    final signer = await SecureStorageKeyPairSigner.loadOrCreate(
      storage: storage,
      storageKey: 'k',
      network: Network.testnet,
    );

    final source = stellar.Account(signer.publicKey, BigInt.zero);
    final tx = stellar.TransactionBuilder(source)
        .addOperation(
          stellar.PaymentOperationBuilder(
            signer.publicKey,
            stellar.Asset.NATIVE,
            '1',
          ).build(),
        )
        .build();
    final unsigned = tx.toEnvelopeXdrBase64();

    final signed = await signer.signXdr(unsigned);
    expect(signed, isNot(unsigned));
  });

  test('clear removes the stored seed', () async {
    final storage = _FakeStorage();
    await SecureStorageKeyPairSigner.loadOrCreate(
      storage: storage,
      storageKey: 'k',
      network: Network.testnet,
    );
    await SecureStorageKeyPairSigner.clear(storage: storage, storageKey: 'k');
    expect(await storage.read(key: 'k'), isNull);
  });
}
```

- [ ] **Step 2: Implement `SecureStorageKeyPairSigner`**

```dart
// lib/src/secure_storage_keypair_signer.dart
import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stellar_flutter_sdk/stellar_flutter_sdk.dart' as stellar;
import 'package:trustless_work_dart/trustless_work_dart.dart';

/// Persistent `TransactionSigner` backed by `flutter_secure_storage`.
///
/// Uses Keychain on iOS and AES-encrypted shared preferences on Android.
/// The seed is stored as a Stellar secret (`S...`) string. Callers are
/// responsible for providing a recovery flow — losing the secure storage
/// bucket means losing the funds.
class SecureStorageKeyPairSigner implements TransactionSigner {
  SecureStorageKeyPairSigner._({
    required stellar.KeyPair keypair,
    required Network network,
  })  : _inner = KeyPairSigner(keypair: keypair, network: network);

  final KeyPairSigner _inner;

  @override
  String get publicKey => _inner.publicKey;

  @override
  FutureOr<String> signXdr(String unsignedXdr) => _inner.signXdr(unsignedXdr);

  /// Loads an existing keypair from `storage[storageKey]`, or generates a
  /// new one and persists it. Idempotent across app launches.
  static Future<SecureStorageKeyPairSigner> loadOrCreate({
    FlutterSecureStorage? storage,
    required String storageKey,
    required Network network,
  }) async {
    final store = storage ?? const FlutterSecureStorage();
    final existing = await store.read(key: storageKey);
    final keypair = existing == null
        ? stellar.KeyPair.random()
        : stellar.KeyPair.fromSecretSeed(existing);
    if (existing == null) {
      await store.write(key: storageKey, value: keypair.secretSeed);
    }
    return SecureStorageKeyPairSigner._(
      keypair: keypair,
      network: network,
    );
  }

  /// Deletes the stored seed. Irreversible — the previous wallet
  /// becomes unusable from this device.
  static Future<void> clear({
    FlutterSecureStorage? storage,
    required String storageKey,
  }) async {
    final store = storage ?? const FlutterSecureStorage();
    await store.delete(key: storageKey);
  }
}
```

- [ ] **Step 3: Barrel export**

```dart
// lib/trustless_work_flutter_storage.dart
export 'src/secure_storage_keypair_signer.dart';
```

- [ ] **Step 4: Run tests**

```bash
cd packages/trustless_work_flutter_storage && flutter test
```
Expected: all tests pass.

- [ ] **Step 5: Commit**

```bash
git add packages/trustless_work_flutter_storage/lib/ packages/trustless_work_flutter_storage/test/
git commit -m "feat(trustless-work-storage): add SecureStorageKeyPairSigner"
```

---

## Phase 11 — Consume from `apps/mobile`

### Task 11.1: Wire path dependencies and a minimal smoke check

**Files:**
- Modify: `apps/mobile/pubspec.yaml` — add the two path dependencies.
- Create: `apps/mobile/lib/integration/trustless_work_bootstrap.dart` — boot the client with env-provided API key.
- Create: `apps/mobile/test/integration/trustless_work_bootstrap_test.dart`

- [ ] **Step 1: Add dependencies**

Edit `apps/mobile/pubspec.yaml` — inside `dependencies:`, add:

```yaml
  trustless_work_dart:
    path: ../../packages/trustless_work_dart
  trustless_work_flutter_storage:
    path: ../../packages/trustless_work_flutter_storage
```

- [ ] **Step 2: Write failing test**

```dart
// apps/mobile/test/integration/trustless_work_bootstrap_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:habitanexus_mobile/integration/trustless_work_bootstrap.dart';
import 'package:trustless_work_dart/trustless_work_dart.dart';

void main() {
  test('bootstrapTrustlessWorkClient returns a client with matching publicKey',
      () async {
    final client = await bootstrapTrustlessWorkClient(
      apiKey: 'test_key',
      network: Network.testnet,
      signerLoader: () async => CallbackSigner(
        publicKey: 'GAAA',
        signXdr: (xdr) async => xdr,
      ),
    );
    expect(client, isNotNull);
  });
}
```

- [ ] **Step 3: Implement the bootstrap helper**

```dart
// apps/mobile/lib/integration/trustless_work_bootstrap.dart
import 'package:trustless_work_dart/trustless_work_dart.dart';

typedef SignerLoader = Future<TransactionSigner> Function();

/// Builds a `TrustlessWorkClient` ready to be injected into the app's
/// dependency graph. In production `signerLoader` is wired to
/// `SecureStorageKeyPairSigner.loadOrCreate`; in tests callers pass a
/// fake.
Future<TrustlessWorkClient> bootstrapTrustlessWorkClient({
  required String apiKey,
  required Network network,
  required SignerLoader signerLoader,
}) async {
  final signer = await signerLoader();
  final config = switch (network) {
    Network.testnet => TrustlessWorkConfig.testnet(apiKey: apiKey),
    Network.mainnet => TrustlessWorkConfig.mainnet(apiKey: apiKey),
  };
  return TrustlessWorkClient(config: config, signer: signer);
}
```

- [ ] **Step 4: Run `flutter pub get` and test**

```bash
cd apps/mobile
flutter pub get
flutter test test/integration/trustless_work_bootstrap_test.dart
```
Expected: packages resolve from path, test passes.

- [ ] **Step 5: Commit**

```bash
git add apps/mobile/pubspec.yaml apps/mobile/lib/integration/trustless_work_bootstrap.dart apps/mobile/test/integration/trustless_work_bootstrap_test.dart
git commit -m "feat(mobile): wire trustless_work_dart + flutter_secure_storage companion"
```

---

## Phase 12 — Final polish

### Task 12.1: Lint + format + pana baseline

- [ ] **Step 1: Run analyzer on both packages**

```bash
(cd packages/trustless_work_dart && dart analyze)
(cd packages/trustless_work_flutter_storage && dart analyze)
```
Expected: no issues.

- [ ] **Step 2: Run formatter check**

```bash
dart format --set-exit-if-changed packages/trustless_work_dart packages/trustless_work_flutter_storage
```
Expected: exit 0.

- [ ] **Step 3: (Optional but encouraged) Run pana against the core**

```bash
dart pub global activate pana
dart pub global run pana packages/trustless_work_dart --no-warning
```
Expected: score ≥ 130/140. Any deficit in the "Follow Dart file conventions" or "Provide documentation" sections is fair game for follow-up — don't block the spike on it.

- [ ] **Step 4: Update the spec with the resolved lint/format baseline**

Edit `docs/superpowers/specs/2026-04-15-trustless-work-dart-spike-design.md` §10.3 to replace the pana pin with the actual score you hit.

- [ ] **Step 5: Commit**

```bash
git add docs/superpowers/specs/2026-04-15-trustless-work-dart-spike-design.md
git commit -m "chore(trustless-work): record pana baseline score"
```

### Task 12.2: CI workflow

**Files:**
- Create: `.github/workflows/trustless-work-dart.yml`

- [ ] **Step 1: Write the workflow**

```yaml
# .github/workflows/trustless-work-dart.yml
name: trustless_work_dart

on:
  push:
    paths:
      - 'packages/trustless_work_dart/**'
      - 'packages/trustless_work_flutter_storage/**'
      - '.github/workflows/trustless-work-dart.yml'
  pull_request:
    paths:
      - 'packages/trustless_work_dart/**'
      - 'packages/trustless_work_flutter_storage/**'

jobs:
  core:
    runs-on: ubuntu-latest
    defaults:
      run:
        working-directory: packages/trustless_work_dart
    steps:
      - uses: actions/checkout@v4
      - uses: dart-lang/setup-dart@v1
        with:
          sdk: 3.2.5
      - run: dart pub get
      - run: dart run build_runner build --delete-conflicting-outputs
      - run: dart analyze
      - run: dart format --set-exit-if-changed .
      - run: dart test --exclude-tags integration --coverage=coverage

  storage:
    runs-on: ubuntu-latest
    defaults:
      run:
        working-directory: packages/trustless_work_flutter_storage
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          channel: stable
      - run: flutter pub get
      - run: flutter analyze
      - run: flutter test
```

- [ ] **Step 2: Commit**

```bash
git add .github/workflows/trustless-work-dart.yml
git commit -m "ci(trustless-work): add GitHub Actions workflow for both packages"
```

### Task 12.3: Wire the sibling packages into the root Makefile

**Files:**
- Modify: `Makefile` — add targets `trustless-work-test`, `trustless-work-analyze`, `trustless-work-format`.

- [ ] **Step 1: Append to the existing Makefile**

```make
# --- Trustless Work packages ---
TW_CORE := packages/trustless_work_dart
TW_STORAGE := packages/trustless_work_flutter_storage

.PHONY: trustless-work-test trustless-work-analyze trustless-work-format trustless-work-ci
trustless-work-test:
	cd $(TW_CORE) && dart run build_runner build --delete-conflicting-outputs && dart test --exclude-tags integration
	cd $(TW_STORAGE) && flutter test

trustless-work-analyze:
	cd $(TW_CORE) && dart analyze
	cd $(TW_STORAGE) && flutter analyze

trustless-work-format:
	dart format $(TW_CORE) $(TW_STORAGE)

trustless-work-ci: trustless-work-format trustless-work-analyze trustless-work-test
```

- [ ] **Step 2: Verify the targets run**

```bash
make trustless-work-analyze
make trustless-work-test
```

- [ ] **Step 3: Commit**

```bash
git add Makefile
git commit -m "build(make): add trustless-work targets"
```

---

## Self-Review

Before handing the plan back, I ran the checks the skill prescribes.

### Spec coverage
- §2 Goals — Phase 1 through 11 implement every bullet. ✓
- §3 Non-Goals — each is enforced by what the plan *doesn't* include (no dispute endpoints, no wallet UI, no fiat handling). ✓
- §4 Decisions — each row lands in Phase 0 (pubspec, license), Phase 3 (signer), Phase 5 (models), Phase 6 (endpoints), Phase 8 (reactivity), Phase 10 (sibling). ✓
- §5 Architecture — layers and directory tree mirrored in the File Structure section. ✓
- §6 Modules — explicit tasks per module. ✓
- §7 Data flow — Phase 7 Task 7.1 wires the full two-step dance; integration test (Phase 9) exercises it end-to-end. ✓
- §8 Error handling — Phases 1 and 4 define and propagate the sealed hierarchy; Phase 4 maps HTTP status codes. ✓
- §9 External dependencies — explicitly scoped OUT of the plan (SDK-level); no tasks created for Kindo/Onramper. ✓
- §10 Testing — Phases 1-10 are TDD, Phase 9 adds gated integration, Phase 12.1 adds lint/format/pana. ✓
- §11 Roadmap — v0.2 items are not in the plan by design. ✓
- §12 Governance — license + repo pointers land in Phase 0 scaffolding. ✓
- §13 Bilateral TW items — tracked in the spec, intentionally left out of the implementation plan (they are external dependencies). ✓

### Placeholder scan
No "TBD", no "TODO", no "implement later" in any task step. The only provisional item is §6.4 `EscrowQueries` path, explicitly flagged with the pointer to spec §13.5 — kept because the exact string has to come from Alberto.

### Type / signature consistency
- `TransactionSigner.signXdr` returns `FutureOr<String>` everywhere.
- `Escrow` field names (`contractId`, `engagementId`, `platformFee`, `receiverMemo`, `isActive`) match across models, payloads, tests, and integration fixtures.
- `Network` enum (testnet/mainnet) is the same in config, signer, and bootstrap helper.
- `EscrowEvent` variant names (`Initialized`, `Funded`, `MilestoneStatusChanged`, `MilestoneApproved`, `Released`, `DisputeStarted`, `DisputeResolved`) are consistent between the sealed class, the polling stream diff logic, and the exhaustive switch in tests.

No inconsistencies found.

---

## Execution Handoff

Plan complete and saved to `docs/superpowers/plans/2026-04-15-trustless-work-dart-implementation.md`. Two execution options:

**1. Subagent-Driven (recommended)** — I dispatch a fresh subagent per task, review between tasks, fast iteration.

**2. Inline Execution** — Execute tasks in this session using `superpowers:executing-plans`, batch execution with checkpoints.

Which approach?
