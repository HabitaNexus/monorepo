import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:test/test.dart';
import 'package:trustless_work_dart/src/client/trustless_work_config.dart';
import 'package:trustless_work_dart/src/endpoints/single_release_operations.dart';
import 'package:trustless_work_dart/src/http/http_client.dart';
import 'package:trustless_work_dart/src/models/payloads/fund_escrow_payload.dart';
import 'package:trustless_work_dart/src/models/payloads/release_funds_payload.dart';

void main() {
  HttpClient buildHttp(MockClient mock) =>
      HttpClient(config: TrustlessWorkConfig.testnet(apiKey: 'k'), inner: mock);

  test('fund POSTs to /escrow/single-release/fund-escrow', () async {
    Map<String, dynamic>? body;
    final ops = SingleReleaseOperations(
      http: buildHttp(MockClient((req) async {
        expect(req.url.path, '/escrow/single-release/fund-escrow');
        body = jsonDecode(req.body) as Map<String, dynamic>;
        return http.Response(jsonEncode({'transactionXdr': 'FUND_XDR'}), 201);
      })),
    );

    final xdr = await ops.fund(const FundEscrowPayload(
      contractId: 'CAAA',
      signer: 'GAAA',
      amount: '100',
    ));

    expect(xdr, 'FUND_XDR');
    expect(body!['amount'], '100');
  });

  test('release POSTs to /escrow/single-release/release-funds', () async {
    final ops = SingleReleaseOperations(
      http: buildHttp(MockClient((req) async {
        expect(req.url.path, '/escrow/single-release/release-funds');
        return http.Response(jsonEncode({'transactionXdr': 'REL_XDR'}), 201);
      })),
    );

    final xdr = await ops.release(const ReleaseFundsPayload(
      contractId: 'CAAA',
      releaseSigner: 'GREL',
    ));

    expect(xdr, 'REL_XDR');
  });
}
