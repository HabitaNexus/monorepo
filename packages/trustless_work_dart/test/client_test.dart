import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:test/test.dart';
import 'package:trustless_work_dart/trustless_work_dart.dart';

void main() {
  MockClient wireMockedGateway(List<http.Response> responses) {
    final iterator = responses.iterator;
    return MockClient((req) async {
      if (!iterator.moveNext()) {
        return http.Response('no more canned responses', 500);
      }
      return iterator.current;
    });
  }

  http.Response fakeEscrowJson() => http.Response(
        jsonEncode({
          'contractId': 'CAAA',
          'engagementId': 'lease-1',
          'title': 'x',
          'description': 'd',
          'amount': 1,
          'platformFee': 0.0,
          'receiverMemo': 0,
          'roles': <Map<String, Object?>>[],
          'milestones': <Map<String, Object?>>[],
          'trustline': <String, Object?>{
            'address': 'C',
            'name': 'USDC',
            'decimals': 7,
          },
          'flags': <String, Object?>{
            'approved': false,
            'disputed': false,
            'released': false,
          },
          'isActive': true,
        }),
        200,
      );

  TrustlessWorkClient buildClient(MockClient mock) =>
      TrustlessWorkClient.forTesting(
        config: TrustlessWorkConfig.testnet(apiKey: 'k'),
        signer: CallbackSigner(
          publicKey: 'GAAA',
          signXdr: (xdr) async => 'S_$xdr',
        ),
        innerHttp: mock,
      );

  test('initializeEscrow signs XDR and returns resolved Escrow', () async {
    // Sequence: (1) /deployer/single-release → transactionXdr,
    //           (2) /helper/send-transaction → { contractId: 'CAAA' },
    //           (3) /escrow/single-release/get-escrow → Escrow json
    final mock = wireMockedGateway([
      http.Response(jsonEncode({'transactionXdr': 'UXDR_INIT'}), 201),
      http.Response(jsonEncode({'contractId': 'CAAA'}), 200),
      http.Response(
        jsonEncode({
          'contractId': 'CAAA',
          'engagementId': 'lease-1',
          'title': 'x',
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
      ),
    ]);

    // ignore: unused_local_variable
    final client = TrustlessWorkClient(
      config: TrustlessWorkConfig.testnet(apiKey: 'k'),
      signer: CallbackSigner(
        publicKey: 'GAAA',
        signXdr: (xdr) async => 'S_$xdr',
      ),
      httpClient: http.Client(),  // ignored; overridden below via factory
    );

    // For the test we swap the HTTP client via a re-binding.
    final clientForTest = TrustlessWorkClient.forTesting(
      config: TrustlessWorkConfig.testnet(apiKey: 'k'),
      signer: CallbackSigner(
        publicKey: 'GAAA',
        signXdr: (xdr) async => 'S_$xdr',
      ),
      innerHttp: mock,
    );

    final escrow = await clientForTest.initializeEscrow(
      const SingleReleaseContract(
        signer: 'GAAA',
        engagementId: 'lease-1',
        title: 'x',
        description: 'd',
        amount: 1,
        platformFee: 0,
        roles: [],
        milestones: [],
        trustline: [],
      ),
    );
    expect(escrow.contractId, 'CAAA');
  });

  test('updateEscrow signs XDR and returns refreshed Escrow', () async {
    final mock = wireMockedGateway([
      http.Response(jsonEncode({'transactionXdr': 'UPD_XDR'}), 200),
      http.Response(jsonEncode({'status': 'SUCCESS'}), 200),
      fakeEscrowJson(),
    ]);
    final client = buildClient(mock);
    final escrow = await client.updateEscrow(
      const UpdateEscrowPayload(
        signer: 'GAPPROVER',
        contractId: 'CAAA',
        escrow: <String, Object?>{'engagementId': 'lease-1'},
      ),
    );
    expect(escrow.contractId, 'CAAA');
  });

  test('changeMilestoneStatus signs XDR and returns refreshed Escrow',
      () async {
    final mock = wireMockedGateway([
      http.Response(jsonEncode({'transactionXdr': 'CMS_XDR'}), 201),
      http.Response(jsonEncode({'status': 'SUCCESS'}), 200),
      fakeEscrowJson(),
    ]);
    final client = buildClient(mock);
    final escrow = await client.changeMilestoneStatus(
      const ChangeMilestoneStatusPayload(
        contractId: 'CAAA',
        milestoneIndex: '0',
        newEvidence: 'ipfs://hash',
        newStatus: 'Completed',
        serviceProvider: 'GSERVICE',
      ),
    );
    expect(escrow.contractId, 'CAAA');
  });

  test('approveMilestone signs XDR and returns refreshed Escrow', () async {
    final mock = wireMockedGateway([
      http.Response(jsonEncode({'transactionXdr': 'APM_XDR'}), 201),
      http.Response(jsonEncode({'status': 'SUCCESS'}), 200),
      fakeEscrowJson(),
    ]);
    final client = buildClient(mock);
    final escrow = await client.approveMilestone(
      const ApproveMilestonePayload(
        contractId: 'CAAA',
        milestoneIndex: '0',
        approver: 'GAPPROVER',
      ),
    );
    expect(escrow.contractId, 'CAAA');
  });

  test('startDispute signs XDR and returns refreshed Escrow', () async {
    final mock = wireMockedGateway([
      http.Response(jsonEncode({'transactionXdr': 'DSP_XDR'}), 201),
      http.Response(jsonEncode({'status': 'SUCCESS'}), 200),
      fakeEscrowJson(),
    ]);
    final client = buildClient(mock);
    final escrow = await client.startDispute(
      const StartDisputePayload(
        contractId: 'CAAA',
        signer: 'GAPPROVER',
      ),
    );
    expect(escrow.contractId, 'CAAA');
  });

  test('resolveDispute signs XDR and returns refreshed Escrow', () async {
    final mock = wireMockedGateway([
      http.Response(jsonEncode({'transactionXdr': 'RES_XDR'}), 201),
      http.Response(jsonEncode({'status': 'SUCCESS'}), 200),
      fakeEscrowJson(),
    ]);
    final client = buildClient(mock);
    final escrow = await client.resolveDispute(
      const ResolveDisputePayload(
        contractId: 'CAAA',
        disputeResolver: 'GRESOLVER',
        distributions: [
          DisputeDistribution(address: 'GAPPROVER', amount: 300),
          DisputeDistribution(address: 'GRECEIVER', amount: 700),
        ],
      ),
    );
    expect(escrow.contractId, 'CAAA');
  });

  // ===================================================================
  // Multi-release client surface.
  // ===================================================================

  http.Response fakeMultiReleaseEscrowJson() => http.Response(
        jsonEncode({
          'contractId': 'CAAA',
          'engagementId': 'lease-mr',
          'title': 'x',
          'description': 'd',
          'platformFee': 0.0,
          'receiverMemo': 0,
          'roles': <Map<String, Object?>>[],
          'milestones': <Map<String, Object?>>[
            {
              'description': 'Pago 1',
              'amount': 500,
              'status': 'pending',
              'approvedFlag': false,
            },
          ],
          'trustline': <String, Object?>{
            'address': 'C',
            'name': 'USDC',
            'decimals': 7,
          },
          'flags': <String, Object?>{
            'approved': false,
            'disputed': false,
            'released': false,
          },
          'isActive': true,
        }),
        200,
      );

  test(
    'initializeMultiReleaseEscrow signs XDR and returns resolved MultiReleaseEscrow',
    () async {
      // Sequence: (1) /deployer/multi-release → transactionXdr,
      //           (2) /helper/send-transaction → { contractId: 'CAAA' },
      //           (3) /escrow/multi-release/get-escrow → MultiReleaseEscrow json
      final mock = wireMockedGateway([
        http.Response(jsonEncode({'transactionXdr': 'MR_INIT_XDR'}), 201),
        http.Response(jsonEncode({'contractId': 'CAAA'}), 200),
        fakeMultiReleaseEscrowJson(),
      ]);
      final client = buildClient(mock);
      final escrow = await client.initializeMultiReleaseEscrow(
        const MultiReleaseContract(
          signer: 'GAAA',
          engagementId: 'lease-mr',
          title: 'x',
          description: 'd',
          platformFee: 0,
          roles: [],
          milestones: [
            {'description': 'Pago 1', 'amount': 500},
          ],
          trustline: [],
        ),
      );
      expect(escrow.contractId, 'CAAA');
      expect(escrow.milestones.single.amount, 500);
    },
  );

  test('fundMultiReleaseEscrow returns refreshed MultiReleaseEscrow', () async {
    final mock = wireMockedGateway([
      http.Response(jsonEncode({'transactionXdr': 'MR_FUND_XDR'}), 201),
      http.Response(jsonEncode({'status': 'SUCCESS'}), 200),
      fakeMultiReleaseEscrowJson(),
    ]);
    final client = buildClient(mock);
    final escrow = await client.fundMultiReleaseEscrow(
      const FundEscrowPayload(
        contractId: 'CAAA',
        signer: 'GAAA',
        amount: '500',
      ),
    );
    expect(escrow.contractId, 'CAAA');
  });

  test(
    'releaseMultiReleaseMilestone returns refreshed MultiReleaseEscrow',
    () async {
      final mock = wireMockedGateway([
        http.Response(jsonEncode({'transactionXdr': 'MR_REL_XDR'}), 201),
        http.Response(jsonEncode({'status': 'SUCCESS'}), 200),
        fakeMultiReleaseEscrowJson(),
      ]);
      final client = buildClient(mock);
      final escrow = await client.releaseMultiReleaseMilestone(
        const MultiReleaseReleaseFundsPayload(
          contractId: 'CAAA',
          releaseSigner: 'GREL',
          milestoneIndex: '0',
        ),
      );
      expect(escrow.contractId, 'CAAA');
    },
  );

  test(
    'updateMultiReleaseEscrow returns refreshed MultiReleaseEscrow',
    () async {
      final mock = wireMockedGateway([
        http.Response(jsonEncode({'transactionXdr': 'MR_UPD_XDR'}), 200),
        http.Response(jsonEncode({'status': 'SUCCESS'}), 200),
        fakeMultiReleaseEscrowJson(),
      ]);
      final client = buildClient(mock);
      final escrow = await client.updateMultiReleaseEscrow(
        const UpdateEscrowPayload(
          signer: 'GPLATFORM',
          contractId: 'CAAA',
          escrow: <String, Object?>{'engagementId': 'lease-mr'},
        ),
      );
      expect(escrow.contractId, 'CAAA');
    },
  );

  test(
    'changeMultiReleaseMilestoneStatus returns refreshed MultiReleaseEscrow',
    () async {
      final mock = wireMockedGateway([
        http.Response(jsonEncode({'transactionXdr': 'MR_CMS_XDR'}), 201),
        http.Response(jsonEncode({'status': 'SUCCESS'}), 200),
        fakeMultiReleaseEscrowJson(),
      ]);
      final client = buildClient(mock);
      final escrow = await client.changeMultiReleaseMilestoneStatus(
        const ChangeMilestoneStatusPayload(
          contractId: 'CAAA',
          milestoneIndex: '0',
          newEvidence: 'ipfs://hash',
          newStatus: 'Completed',
          serviceProvider: 'GSERVICE',
        ),
      );
      expect(escrow.contractId, 'CAAA');
    },
  );

  test(
    'approveMultiReleaseMilestone returns refreshed MultiReleaseEscrow',
    () async {
      final mock = wireMockedGateway([
        http.Response(jsonEncode({'transactionXdr': 'MR_APM_XDR'}), 201),
        http.Response(jsonEncode({'status': 'SUCCESS'}), 200),
        fakeMultiReleaseEscrowJson(),
      ]);
      final client = buildClient(mock);
      final escrow = await client.approveMultiReleaseMilestone(
        const ApproveMilestonePayload(
          contractId: 'CAAA',
          milestoneIndex: '0',
          approver: 'GAPPROVER',
        ),
      );
      expect(escrow.contractId, 'CAAA');
    },
  );

  test(
    'startMultiReleaseDispute returns refreshed MultiReleaseEscrow',
    () async {
      final mock = wireMockedGateway([
        http.Response(jsonEncode({'transactionXdr': 'MR_DSP_XDR'}), 201),
        http.Response(jsonEncode({'status': 'SUCCESS'}), 200),
        fakeMultiReleaseEscrowJson(),
      ]);
      final client = buildClient(mock);
      final escrow = await client.startMultiReleaseDispute(
        const MultiReleaseStartDisputePayload(
          contractId: 'CAAA',
          milestoneIndex: '0',
          signer: 'GAPPROVER',
        ),
      );
      expect(escrow.contractId, 'CAAA');
    },
  );

  test(
    'resolveMultiReleaseDispute returns refreshed MultiReleaseEscrow',
    () async {
      final mock = wireMockedGateway([
        http.Response(jsonEncode({'transactionXdr': 'MR_RES_XDR'}), 201),
        http.Response(jsonEncode({'status': 'SUCCESS'}), 200),
        fakeMultiReleaseEscrowJson(),
      ]);
      final client = buildClient(mock);
      final escrow = await client.resolveMultiReleaseDispute(
        const MultiReleaseResolveDisputePayload(
          contractId: 'CAAA',
          disputeResolver: 'GRESOLVER',
          milestoneIndex: '0',
          distributions: [
            DisputeDistribution(address: 'GAPPROVER', amount: 300),
            DisputeDistribution(address: 'GRECEIVER', amount: 200),
          ],
        ),
      );
      expect(escrow.contractId, 'CAAA');
    },
  );

  test('getMultiReleaseEscrow returns decoded MultiReleaseEscrow', () async {
    final mock = wireMockedGateway([fakeMultiReleaseEscrowJson()]);
    final client = buildClient(mock);
    final escrow = await client.getMultiReleaseEscrow('CAAA');
    expect(escrow.contractId, 'CAAA');
    expect(escrow.milestones.single.amount, 500);
  });
}
