import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:trustless_work_dart/trustless_work_dart.dart';
import 'package:trustless_work_riverpod/trustless_work_riverpod.dart';

void main() {
  Map<String, dynamic> fakeIndexerRow({
    String contractId = 'CAAA',
    String signer = 'GAAA',
  }) =>
      <String, dynamic>{
        'contractId': contractId,
        'signer': signer,
        'type': 'single-release',
        'engagementId': 'lease-1',
        'title': 't',
        'description': 'd',
        'milestones': <Map<String, dynamic>>[],
        'platformFee': 0,
        'receiverMemo': 0,
        'roles': <String, dynamic>{'approver': 'GAPP'},
        'trustline': <String, dynamic>{'address': 'C', 'name': 'USDC'},
        'isActive': true,
        'flags': <String, dynamic>{
          'disputed': false,
          'released': false,
          'resolved': false,
        },
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

  group('escrowsByRoleProvider', () {
    test('calls getEscrowsFromIndexerByRole with correct params', () async {
      final mock = MockClient((req) async {
        expect(req.url.path, '/helper/get-escrows-by-role');
        expect(req.url.queryParameters['role'], 'approver');
        expect(req.url.queryParameters['roleAddress'], 'GAAA');
        return http.Response(
          jsonEncode([fakeIndexerRow(contractId: 'CROLE')]),
          200,
        );
      });

      final container = ProviderContainer(
        overrides: [
          trustlessWorkClientProvider.overrideWithValue(buildClient(mock)),
        ],
      );
      addTearDown(container.dispose);

      final response = await container.read(
        escrowsByRoleProvider(
          (role: IndexerRole.approver, user: 'GAAA'),
        ).future,
      );

      expect(response.escrows, hasLength(1));
      expect(response.escrows.single.contractId, 'CROLE');
    });
  });

  group('escrowsBySignerProvider', () {
    test('calls getEscrowsFromIndexerBySigner with signer param', () async {
      final mock = MockClient((req) async {
        expect(req.url.path, '/helper/get-escrows-by-signer');
        expect(req.url.queryParameters['signer'], 'GSIGNER');
        return http.Response(
          jsonEncode([fakeIndexerRow(signer: 'GSIGNER')]),
          200,
        );
      });

      final container = ProviderContainer(
        overrides: [
          trustlessWorkClientProvider.overrideWithValue(buildClient(mock)),
        ],
      );
      addTearDown(container.dispose);

      final response = await container.read(
        escrowsBySignerProvider('GSIGNER').future,
      );

      expect(response.escrows, hasLength(1));
      expect(response.escrows.single.signer, 'GSIGNER');
    });
  });

  group('escrowsByContractIdsProvider', () {
    test('calls getEscrowFromIndexerByContractIds with params', () async {
      final mock = MockClient((req) async {
        expect(req.url.path, '/helper/get-escrow-by-contract-ids');
        expect(
          req.url.queryParameters['contractIds'],
          'CAAA,CBBB',
        );
        expect(req.url.queryParameters['validateOnChain'], 'true');
        return http.Response(
          jsonEncode([
            fakeIndexerRow(contractId: 'CAAA'),
            fakeIndexerRow(contractId: 'CBBB'),
          ]),
          200,
        );
      });

      final container = ProviderContainer(
        overrides: [
          trustlessWorkClientProvider.overrideWithValue(buildClient(mock)),
        ],
      );
      addTearDown(container.dispose);

      final response = await container.read(
        escrowsByContractIdsProvider(
          (contractIds: ['CAAA', 'CBBB'], validateOnChain: true),
        ).future,
      );

      expect(response.escrows, hasLength(2));
      expect(response.escrows[0].contractId, 'CAAA');
      expect(response.escrows[1].contractId, 'CBBB');
    });
  });

  group('escrowBalancesProvider', () {
    test('calls getMultipleEscrowBalances with address list', () async {
      final mock = MockClient((req) async {
        expect(req.url.path, '/helper/get-multiple-escrow-balance');
        // Addresses are sent as repeat-params. The mock client encodes them.
        return http.Response(
          jsonEncode([
            {'address': 'CAAA', 'balance': 100.5},
            {'address': 'CBBB', 'balance': 200.0},
          ]),
          200,
        );
      });

      final container = ProviderContainer(
        overrides: [
          trustlessWorkClientProvider.overrideWithValue(buildClient(mock)),
        ],
      );
      addTearDown(container.dispose);

      final response = await container.read(
        escrowBalancesProvider(['CAAA', 'CBBB']).future,
      );

      expect(response.balances, hasLength(2));
      expect(response.balances[0].address, 'CAAA');
      expect(response.balances[0].balance, 100.5);
      expect(response.balances[1].address, 'CBBB');
      expect(response.balances[1].balance, 200.0);
    });
  });
}
