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
}
