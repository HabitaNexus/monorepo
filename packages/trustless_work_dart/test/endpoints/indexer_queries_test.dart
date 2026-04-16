import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:test/test.dart';
import 'package:trustless_work_dart/src/client/trustless_work_config.dart';
import 'package:trustless_work_dart/src/endpoints/indexer_queries.dart';
import 'package:trustless_work_dart/src/http/http_client.dart';
import 'package:trustless_work_dart/src/models/role.dart';

void main() {
  /// Minimal valid indexer escrow row. Trimmed to required fields so each
  /// test only asserts on what it cares about.
  Map<String, dynamic> fakeIndexerRow({
    String contractId = 'CAAA',
    String signer = 'GAAA',
    String type = 'single-release',
    String engagementId = 'lease-1',
  }) =>
      <String, dynamic>{
        'contractId': contractId,
        'signer': signer,
        'type': type,
        'engagementId': engagementId,
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

  HttpClient buildHttp(MockClient inner) => HttpClient(
        config: TrustlessWorkConfig.testnet(apiKey: 'k'),
        inner: inner,
      );

  group('IndexerQueries.getEscrowsFromIndexerByRole', () {
    test('GETs /helper/get-escrows-by-role with role+roleAddress query',
        () async {
      final mock = MockClient((req) async {
        expect(req.method, 'GET');
        expect(req.url.path, '/helper/get-escrows-by-role');
        expect(req.url.queryParameters['role'], 'approver');
        expect(req.url.queryParameters['roleAddress'], 'GAAA');
        expect(req.headers['x-api-key'], 'k');
        return http.Response(
          jsonEncode([fakeIndexerRow(contractId: 'CROLE')]),
          200,
        );
      });

      final queries = IndexerQueries(http: buildHttp(mock));
      final response = await queries.getEscrowsFromIndexerByRole(
        role: IndexerRole.approver,
        user: 'GAAA',
      );

      expect(response.escrows, hasLength(1));
      expect(response.escrows.single.contractId, 'CROLE');
    });

    test(
      'maps Role enum values to their canonical TW role names',
      () async {
        final seenRoles = <String>[];
        final mock = MockClient((req) async {
          seenRoles.add(req.url.queryParameters['role']!);
          return http.Response(jsonEncode(const <dynamic>[]), 200);
        });

        final queries = IndexerQueries(http: buildHttp(mock));
        for (final role in IndexerRole.values) {
          await queries.getEscrowsFromIndexerByRole(
            role: role,
            user: 'GAAA',
          );
        }

        expect(
          seenRoles,
          // Must match the exact strings the TW contract validates.
          const <String>[
            'approver',
            'serviceProvider',
            'releaseSigner',
            'disputeResolver',
            'platformAddress',
            'receiver',
          ],
        );
      },
    );

    test('decodes an empty indexer array to an empty response', () async {
      final mock = MockClient((_) async => http.Response(
            jsonEncode(const <dynamic>[]),
            200,
          ));

      final queries = IndexerQueries(http: buildHttp(mock));
      final response = await queries.getEscrowsFromIndexerByRole(
        role: IndexerRole.approver,
        user: 'GAAA',
      );
      expect(response.escrows, isEmpty);
    });
  });

  group('IndexerQueries.getEscrowsFromIndexerBySigner', () {
    test('GETs /helper/get-escrows-by-signer with signer query', () async {
      final mock = MockClient((req) async {
        expect(req.method, 'GET');
        expect(req.url.path, '/helper/get-escrows-by-signer');
        expect(req.url.queryParameters['signer'], 'GBBB');
        expect(req.url.queryParameters.containsKey('role'), isFalse);
        return http.Response(
          jsonEncode([fakeIndexerRow(contractId: 'CSGR')]),
          200,
        );
      });

      final queries = IndexerQueries(http: buildHttp(mock));
      final response = await queries.getEscrowsFromIndexerBySigner('GBBB');
      expect(response.escrows.single.contractId, 'CSGR');
    });
  });

  group('IndexerQueries.getEscrowFromIndexerByContractIds', () {
    test(
      'GETs /helper/get-escrow-by-contract-ids with a comma-separated '
      'contractIds query and default validateOnChain=false',
      () async {
        final mock = MockClient((req) async {
          expect(req.method, 'GET');
          expect(req.url.path, '/helper/get-escrow-by-contract-ids');
          // Per the OpenAPI example, contractIds is a single comma-separated
          // query parameter, not repeat-param.
          expect(req.url.queryParameters['contractIds'], 'CAAA,CBBB');
          // Default: caller opted out of on-chain validation.
          expect(req.url.queryParameters.containsKey('validateOnChain'), isFalse);
          return http.Response(
            jsonEncode([
              fakeIndexerRow(contractId: 'CAAA'),
              fakeIndexerRow(contractId: 'CBBB'),
            ]),
            200,
          );
        });

        final queries = IndexerQueries(http: buildHttp(mock));
        final response = await queries.getEscrowFromIndexerByContractIds(
          const ['CAAA', 'CBBB'],
        );
        expect(response.escrows.map((e) => e.contractId), ['CAAA', 'CBBB']);
      },
    );

    test(
      'forwards validateOnChain=true as a string query parameter when requested',
      () async {
        final mock = MockClient((req) async {
          expect(req.url.queryParameters['validateOnChain'], 'true');
          expect(req.url.queryParameters['contractIds'], 'CAAA');
          return http.Response(jsonEncode(const <dynamic>[]), 200);
        });

        final queries = IndexerQueries(http: buildHttp(mock));
        await queries.getEscrowFromIndexerByContractIds(
          const ['CAAA'],
          validateOnChain: true,
        );
      },
    );

    test('throws ArgumentError when the contractIds list is empty', () async {
      final queries = IndexerQueries(
        http: buildHttp(MockClient((_) async => http.Response('', 200))),
      );
      await expectLater(
        queries.getEscrowFromIndexerByContractIds(const <String>[]),
        throwsArgumentError,
      );
    });
  });

  test(
    'Role enum constants are publicly aliased so consumers do not need to '
    'import the internal role.dart file',
    () {
      // Sanity: IndexerRole is exposed from indexer_queries.dart.
      expect(IndexerRole.approver.name, 'approver');
      // And the canonical `Role` model is still available side-by-side.
      expect(
        const Role(name: 'approver', address: 'G').name,
        'approver',
      );
    },
  );
}
