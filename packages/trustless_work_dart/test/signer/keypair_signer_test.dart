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
