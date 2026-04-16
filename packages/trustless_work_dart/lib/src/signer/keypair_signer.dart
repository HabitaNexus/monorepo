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
