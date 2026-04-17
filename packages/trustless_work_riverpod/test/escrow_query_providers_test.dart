import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:trustless_work_dart/trustless_work_dart.dart';
import 'package:trustless_work_riverpod/trustless_work_riverpod.dart';

void main() {
  /// Fake single-release escrow JSON payload.
  Map<String, dynamic> fakeEscrowMap({String contractId = 'CAAA'}) =>
      <String, dynamic>{
        'contractId': contractId,
        'engagementId': 'lease-1',
        'title': 'Test Escrow',
        'description': 'A test escrow',
        'amount': 1000,
        'platformFee': 0.0,
        'receiverMemo': 0,
        'roles': <Map<String, dynamic>>[],
        'milestones': <Map<String, dynamic>>[],
        'trustline': <String, dynamic>{
          'address': 'CUSDC',
          'name': 'USDC',
          'decimals': 7,
        },
        'flags': <String, dynamic>{
          'approved': false,
          'disputed': false,
          'released': false,
        },
        'isActive': true,
      };

  /// Fake multi-release escrow JSON payload.
  Map<String, dynamic> fakeMultiReleaseEscrowMap({
    String contractId = 'CMULTI',
  }) =>
      <String, dynamic>{
        'contractId': contractId,
        'engagementId': 'lease-2',
        'title': 'Multi-Release',
        'description': 'A multi-release escrow',
        'platformFee': 0.0,
        'receiverMemo': 0,
        'roles': <Map<String, dynamic>>[],
        'milestones': <Map<String, dynamic>>[],
        'trustline': <String, dynamic>{
          'address': 'CUSDC',
          'name': 'USDC',
          'decimals': 7,
        },
        'flags': <String, dynamic>{
          'approved': false,
          'disputed': false,
          'released': false,
        },
        'isActive': true,
      };

  TrustlessWorkClient buildClient(MockClient mock) =>
      TrustlessWorkClient.forTesting(
        config: TrustlessWorkConfig.testnet(apiKey: 'k'),
        signer: CallbackSigner(
          publicKey: 'GAAA',
          signXdr: (xdr) async => 'S_$xdr',
        ),
        innerHttp: mock,
      );

  group('escrowProvider', () {
    test('fetches single-release escrow by contractId', () async {
      final mock = MockClient((req) async {
        expect(req.method, 'POST');
        expect(req.url.path, '/escrow/single-release/get-escrow');
        expect(jsonDecode(req.body)['contractId'], 'CAAA');
        return http.Response(jsonEncode(fakeEscrowMap()), 200);
      });

      final container = ProviderContainer(
        overrides: [
          trustlessWorkClientProvider.overrideWithValue(buildClient(mock)),
        ],
      );
      addTearDown(container.dispose);

      final future = container.read(escrowProvider('CAAA').future);
      final escrow = await future;

      expect(escrow.contractId, 'CAAA');
      expect(escrow.title, 'Test Escrow');
      expect(escrow.amount, 1000);
    });

    test('different contractIds return different escrows', () async {
      final mock = MockClient((req) async {
        final id = jsonDecode(req.body)['contractId'] as String;
        return http.Response(jsonEncode(fakeEscrowMap(contractId: id)), 200);
      });

      final container = ProviderContainer(
        overrides: [
          trustlessWorkClientProvider.overrideWithValue(buildClient(mock)),
        ],
      );
      addTearDown(container.dispose);

      final escrow1 = await container.read(escrowProvider('C001').future);
      final escrow2 = await container.read(escrowProvider('C002').future);

      expect(escrow1.contractId, 'C001');
      expect(escrow2.contractId, 'C002');
    });
  });

  group('multiReleaseEscrowProvider', () {
    test('fetches multi-release escrow by contractId', () async {
      final mock = MockClient((req) async {
        expect(req.method, 'POST');
        expect(req.url.path, '/escrow/multi-release/get-escrow');
        expect(jsonDecode(req.body)['contractId'], 'CMULTI');
        return http.Response(
          jsonEncode(fakeMultiReleaseEscrowMap()),
          200,
        );
      });

      final container = ProviderContainer(
        overrides: [
          trustlessWorkClientProvider.overrideWithValue(buildClient(mock)),
        ],
      );
      addTearDown(container.dispose);

      final future =
          container.read(multiReleaseEscrowProvider('CMULTI').future);
      final escrow = await future;

      expect(escrow.contractId, 'CMULTI');
      expect(escrow.title, 'Multi-Release');
    });
  });
}
