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
