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
  }) : _inner = KeyPairSigner(keypair: keypair, network: network);

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
