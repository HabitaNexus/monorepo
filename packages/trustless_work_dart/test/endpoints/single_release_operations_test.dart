import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:test/test.dart';
import 'package:trustless_work_dart/src/client/trustless_work_config.dart';
import 'package:trustless_work_dart/src/endpoints/single_release_operations.dart';
import 'package:trustless_work_dart/src/http/http_client.dart';
import 'package:trustless_work_dart/src/models/payloads/approve_milestone_payload.dart';
import 'package:trustless_work_dart/src/models/payloads/change_milestone_status_payload.dart';
import 'package:trustless_work_dart/src/models/payloads/fund_escrow_payload.dart';
import 'package:trustless_work_dart/src/models/payloads/release_funds_payload.dart';
import 'package:trustless_work_dart/src/models/payloads/resolve_dispute_payload.dart';
import 'package:trustless_work_dart/src/models/payloads/start_dispute_payload.dart';
import 'package:trustless_work_dart/src/models/payloads/update_escrow_payload.dart';

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

  test('update PUTs to /escrow/single-release/update-escrow', () async {
    String? method;
    Map<String, dynamic>? body;
    final ops = SingleReleaseOperations(
      http: buildHttp(MockClient((req) async {
        method = req.method;
        expect(req.url.path, '/escrow/single-release/update-escrow');
        body = jsonDecode(req.body) as Map<String, dynamic>;
        return http.Response(jsonEncode({'transactionXdr': 'UPD_XDR'}), 200);
      })),
    );

    final xdr = await ops.update(const UpdateEscrowPayload(
      signer: 'GAPPROVER',
      contractId: 'CAAA',
      escrow: <String, Object?>{'engagementId': 'lease-42'},
    ));

    expect(method, 'PUT');
    expect(xdr, 'UPD_XDR');
    expect(body!['contractId'], 'CAAA');
    expect(body!['escrow'], {'engagementId': 'lease-42'});
  });

  test('changeMilestoneStatus POSTs to change-milestone-status', () async {
    Map<String, dynamic>? body;
    final ops = SingleReleaseOperations(
      http: buildHttp(MockClient((req) async {
        expect(req.url.path, '/escrow/single-release/change-milestone-status');
        body = jsonDecode(req.body) as Map<String, dynamic>;
        return http.Response(jsonEncode({'transactionXdr': 'CMS_XDR'}), 201);
      })),
    );

    final xdr = await ops.changeMilestoneStatus(
      const ChangeMilestoneStatusPayload(
        contractId: 'CAAA',
        milestoneIndex: '1',
        newEvidence: 'ipfs://hash',
        newStatus: 'Completed',
        serviceProvider: 'GSERVICE',
      ),
    );

    expect(xdr, 'CMS_XDR');
    expect(body!['milestoneIndex'], '1');
    expect(body!['newStatus'], 'Completed');
  });

  test('approveMilestone POSTs to approve-milestone', () async {
    Map<String, dynamic>? body;
    final ops = SingleReleaseOperations(
      http: buildHttp(MockClient((req) async {
        expect(req.url.path, '/escrow/single-release/approve-milestone');
        body = jsonDecode(req.body) as Map<String, dynamic>;
        return http.Response(jsonEncode({'transactionXdr': 'APM_XDR'}), 201);
      })),
    );

    final xdr = await ops.approveMilestone(const ApproveMilestonePayload(
      contractId: 'CAAA',
      milestoneIndex: '0',
      approver: 'GAPPROVER',
    ));

    expect(xdr, 'APM_XDR');
    expect(body!['approver'], 'GAPPROVER');
  });

  test('startDispute POSTs to dispute-escrow', () async {
    Map<String, dynamic>? body;
    final ops = SingleReleaseOperations(
      http: buildHttp(MockClient((req) async {
        expect(req.url.path, '/escrow/single-release/dispute-escrow');
        body = jsonDecode(req.body) as Map<String, dynamic>;
        return http.Response(jsonEncode({'transactionXdr': 'DSP_XDR'}), 201);
      })),
    );

    final xdr = await ops.startDispute(const StartDisputePayload(
      contractId: 'CAAA',
      signer: 'GAPPROVER',
    ));

    expect(xdr, 'DSP_XDR');
    expect(body!, {'contractId': 'CAAA', 'signer': 'GAPPROVER'});
  });

  test('resolveDispute POSTs to resolve-dispute', () async {
    Map<String, dynamic>? body;
    final ops = SingleReleaseOperations(
      http: buildHttp(MockClient((req) async {
        expect(req.url.path, '/escrow/single-release/resolve-dispute');
        body = jsonDecode(req.body) as Map<String, dynamic>;
        return http.Response(jsonEncode({'transactionXdr': 'RES_XDR'}), 201);
      })),
    );

    final xdr = await ops.resolveDispute(const ResolveDisputePayload(
      contractId: 'CAAA',
      disputeResolver: 'GRESOLVER',
      distributions: [
        DisputeDistribution(address: 'GAPPROVER', amount: 300),
        DisputeDistribution(address: 'GRECEIVER', amount: 700),
      ],
    ));

    expect(xdr, 'RES_XDR');
    expect(body!['disputeResolver'], 'GRESOLVER');
    final dist = body!['distributions'] as List<Object?>;
    expect(dist, hasLength(2));
    expect((dist[0] as Map<String, Object?>)['amount'], 300);
  });

  test('throws ServerError when response is missing transactionXdr', () async {
    final ops = SingleReleaseOperations(
      http: buildHttp(MockClient((_) async {
        return http.Response(jsonEncode({'status': 'SUCCESS'}), 200);
      })),
    );

    expect(
      () => ops.startDispute(const StartDisputePayload(
        contractId: 'CAAA',
        signer: 'GAPPROVER',
      )),
      throwsA(isA<Exception>()),
    );
  });
}
