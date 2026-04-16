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
