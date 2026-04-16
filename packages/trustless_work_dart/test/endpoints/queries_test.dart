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
