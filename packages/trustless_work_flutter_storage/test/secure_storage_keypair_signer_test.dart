import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stellar_flutter_sdk/stellar_flutter_sdk.dart' as stellar;
import 'package:trustless_work_dart/trustless_work_dart.dart';
import 'package:trustless_work_flutter_storage/trustless_work_flutter_storage.dart';

class _FakeStorage implements FlutterSecureStorage {
  final Map<String, String> _map = {};

  @override
  Future<String?> read({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    WindowsOptions? wOptions,
    MacOsOptions? mOptions,
  }) async =>
      _map[key];

  @override
  Future<void> write({
    required String key,
    required String? value,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    WindowsOptions? wOptions,
    MacOsOptions? mOptions,
  }) async {
    if (value == null) {
      _map.remove(key);
    } else {
      _map[key] = value;
    }
  }

  @override
  Future<void> delete({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    WindowsOptions? wOptions,
    MacOsOptions? mOptions,
  }) async {
    _map.remove(key);
  }

  // Other members throw — we intentionally don't implement them.
  @override
  dynamic noSuchMethod(Invocation invocation) =>
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
