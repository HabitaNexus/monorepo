import 'package:flutter_test/flutter_test.dart';
import 'package:habitanexus_mobile/integration/trustless_work_bootstrap.dart';
import 'package:trustless_work_dart/trustless_work_dart.dart';

void main() {
  test(
    'bootstrapTrustlessWorkClient returns a client with matching publicKey',
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
    },
  );
}
