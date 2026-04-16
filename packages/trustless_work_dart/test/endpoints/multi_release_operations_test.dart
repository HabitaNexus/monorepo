import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:test/test.dart';
import 'package:trustless_work_dart/src/client/trustless_work_config.dart';
import 'package:trustless_work_dart/src/endpoints/multi_release_operations.dart';
import 'package:trustless_work_dart/src/http/http_client.dart';
import 'package:trustless_work_dart/src/models/payloads/approve_milestone_payload.dart';
import 'package:trustless_work_dart/src/models/payloads/change_milestone_status_payload.dart';
import 'package:trustless_work_dart/src/models/payloads/fund_escrow_payload.dart';
import 'package:trustless_work_dart/src/models/payloads/multi_release_release_funds_payload.dart';
import 'package:trustless_work_dart/src/models/payloads/multi_release_resolve_dispute_payload.dart';
import 'package:trustless_work_dart/src/models/payloads/multi_release_start_dispute_payload.dart';
import 'package:trustless_work_dart/src/models/payloads/resolve_dispute_payload.dart';
import 'package:trustless_work_dart/src/models/payloads/update_escrow_payload.dart';

void main() {
  HttpClient buildHttp(MockClient mock) =>
      HttpClient(config: TrustlessWorkConfig.testnet(apiKey: 'k'), inner: mock);

  test('fund POSTs to /escrow/multi-release/fund-escrow', () async {
    Map<String, dynamic>? body;
    final ops = MultiReleaseOperations(
      http: buildHttp(MockClient((req) async {
        expect(req.method, 'POST');
        expect(req.url.path, '/escrow/multi-release/fund-escrow');
        body = jsonDecode(req.body) as Map<String, dynamic>;
        return http.Response(
          jsonEncode({'transactionXdr': 'MR_FUND_XDR'}),
          201,
        );
      })),
    );

    final xdr = await ops.fund(const FundEscrowPayload(
      contractId: 'CAAA',
      signer: 'GAAA',
      amount: '750000',
    ));
    expect(xdr, 'MR_FUND_XDR');
    expect(body!['amount'], '750000');
  });

  test(
    'release POSTs to /escrow/multi-release/release-milestone-funds with milestoneIndex',
    () async {
      Map<String, dynamic>? body;
      final ops = MultiReleaseOperations(
        http: buildHttp(MockClient((req) async {
          expect(req.method, 'POST');
          expect(req.url.path, '/escrow/multi-release/release-milestone-funds');
          body = jsonDecode(req.body) as Map<String, dynamic>;
          return http.Response(
            jsonEncode({'transactionXdr': 'MR_REL_XDR'}),
            201,
          );
        })),
      );

      final xdr = await ops.release(
        const MultiReleaseReleaseFundsPayload(
          contractId: 'CAAA',
          releaseSigner: 'GREL',
          milestoneIndex: '2',
        ),
      );
      expect(xdr, 'MR_REL_XDR');
      expect(body!, {
        'contractId': 'CAAA',
        'releaseSigner': 'GREL',
        'milestoneIndex': '2',
      });
    },
  );

  test('update PUTs to /escrow/multi-release/update-escrow', () async {
    String? method;
    Map<String, dynamic>? body;
    final ops = MultiReleaseOperations(
      http: buildHttp(MockClient((req) async {
        method = req.method;
        expect(req.url.path, '/escrow/multi-release/update-escrow');
        body = jsonDecode(req.body) as Map<String, dynamic>;
        return http.Response(
          jsonEncode({'transactionXdr': 'MR_UPD_XDR'}),
          200,
        );
      })),
    );

    final xdr = await ops.update(const UpdateEscrowPayload(
      signer: 'GPLATFORM',
      contractId: 'CAAA',
      escrow: <String, Object?>{'engagementId': 'lease-42'},
    ));

    expect(method, 'PUT');
    expect(xdr, 'MR_UPD_XDR');
    expect(body!['contractId'], 'CAAA');
  });

  test(
    'changeMilestoneStatus POSTs to /escrow/multi-release/change-milestone-status',
    () async {
      Map<String, dynamic>? body;
      final ops = MultiReleaseOperations(
        http: buildHttp(MockClient((req) async {
          expect(req.url.path, '/escrow/multi-release/change-milestone-status');
          body = jsonDecode(req.body) as Map<String, dynamic>;
          return http.Response(
            jsonEncode({'transactionXdr': 'MR_CMS_XDR'}),
            201,
          );
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
      expect(xdr, 'MR_CMS_XDR');
      expect(body!['milestoneIndex'], '1');
    },
  );

  test(
    'approveMilestone POSTs to /escrow/multi-release/approve-milestone',
    () async {
      Map<String, dynamic>? body;
      final ops = MultiReleaseOperations(
        http: buildHttp(MockClient((req) async {
          expect(req.url.path, '/escrow/multi-release/approve-milestone');
          body = jsonDecode(req.body) as Map<String, dynamic>;
          return http.Response(
            jsonEncode({'transactionXdr': 'MR_APM_XDR'}),
            201,
          );
        })),
      );
      final xdr = await ops.approveMilestone(
        const ApproveMilestonePayload(
          contractId: 'CAAA',
          milestoneIndex: '0',
          approver: 'GAPPROVER',
        ),
      );
      expect(xdr, 'MR_APM_XDR');
      expect(body!['approver'], 'GAPPROVER');
    },
  );

  test(
    'startDispute POSTs to /escrow/multi-release/dispute-milestone',
    () async {
      Map<String, dynamic>? body;
      final ops = MultiReleaseOperations(
        http: buildHttp(MockClient((req) async {
          expect(req.url.path, '/escrow/multi-release/dispute-milestone');
          body = jsonDecode(req.body) as Map<String, dynamic>;
          return http.Response(
            jsonEncode({'transactionXdr': 'MR_DSP_XDR'}),
            201,
          );
        })),
      );
      final xdr = await ops.startDispute(
        const MultiReleaseStartDisputePayload(
          contractId: 'CAAA',
          milestoneIndex: '1',
          signer: 'GAPPROVER',
        ),
      );
      expect(xdr, 'MR_DSP_XDR');
      expect(body!, {
        'contractId': 'CAAA',
        'milestoneIndex': '1',
        'signer': 'GAPPROVER',
      });
    },
  );

  test(
    'resolveDispute POSTs to /escrow/multi-release/resolve-milestone-dispute',
    () async {
      Map<String, dynamic>? body;
      final ops = MultiReleaseOperations(
        http: buildHttp(MockClient((req) async {
          expect(
            req.url.path,
            '/escrow/multi-release/resolve-milestone-dispute',
          );
          body = jsonDecode(req.body) as Map<String, dynamic>;
          return http.Response(
            jsonEncode({'transactionXdr': 'MR_RES_XDR'}),
            201,
          );
        })),
      );
      final xdr = await ops.resolveDispute(
        const MultiReleaseResolveDisputePayload(
          contractId: 'CAAA',
          disputeResolver: 'GRESOLVER',
          milestoneIndex: '0',
          distributions: [
            DisputeDistribution(address: 'GAPPROVER', amount: 300),
            DisputeDistribution(address: 'GRECEIVER', amount: 700),
          ],
        ),
      );
      expect(xdr, 'MR_RES_XDR');
      expect(body!['milestoneIndex'], '0');
      expect((body!['distributions'] as List).length, 2);
    },
  );

  test('throws ServerError when response is missing transactionXdr', () async {
    final ops = MultiReleaseOperations(
      http: buildHttp(MockClient((_) async {
        return http.Response(jsonEncode({'status': 'SUCCESS'}), 200);
      })),
    );
    expect(
      () => ops.startDispute(
        const MultiReleaseStartDisputePayload(
          contractId: 'CAAA',
          milestoneIndex: '0',
          signer: 'GAPPROVER',
        ),
      ),
      throwsA(isA<Exception>()),
    );
  });
}
