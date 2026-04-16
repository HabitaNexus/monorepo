import 'package:test/test.dart';
import 'package:trustless_work_dart/src/models/payloads/fund_escrow_payload.dart';
import 'package:trustless_work_dart/src/models/payloads/release_funds_payload.dart';
import 'package:trustless_work_dart/src/models/payloads/single_release_contract.dart';
import 'package:trustless_work_dart/src/models/payloads/approve_milestone_payload.dart';
import 'package:trustless_work_dart/src/models/payloads/change_milestone_status_payload.dart';
import 'package:trustless_work_dart/src/models/payloads/resolve_dispute_payload.dart';
import 'package:trustless_work_dart/src/models/payloads/start_dispute_payload.dart';
import 'package:trustless_work_dart/src/models/payloads/update_escrow_payload.dart';

void main() {
  test('SingleReleaseContract serializes required fields', () {
    const contract = SingleReleaseContract(
      signer: 'GAAA...',
      engagementId: 'lease-42',
      title: 'Alquiler',
      description: 'Depósito',
      amount: 1000,
      platformFee: 2.5,
      roles: <Map<String, Object?>>[],
      milestones: <Map<String, Object?>>[],
      trustline: <Map<String, Object?>>[],
    );
    final json = contract.toJson();
    expect(json['signer'], 'GAAA...');
    expect(json['engagementId'], 'lease-42');
    expect(json['amount'], 1000);
  });

  test('FundEscrowPayload requires contractId, signer, amount', () {
    const payload = FundEscrowPayload(
      contractId: 'CAAA',
      signer: 'GAAA',
      amount: '500',
    );
    expect(payload.toJson(), {
      'contractId': 'CAAA',
      'signer': 'GAAA',
      'amount': '500',
    });
  });

  test('ReleaseFundsPayload requires contractId + releaseSigner', () {
    const payload = ReleaseFundsPayload(
      contractId: 'CAAA',
      releaseSigner: 'GRELEASE',
    );
    expect(payload.toJson(), {
      'contractId': 'CAAA',
      'releaseSigner': 'GRELEASE',
    });
  });

  test('UpdateEscrowPayload round-trips through JSON', () {
    const payload = UpdateEscrowPayload(
      signer: 'GAPPROVER',
      contractId: 'CAAA',
      escrow: <String, Object?>{
        'engagementId': 'lease-42',
        'title': 'Alquiler actualizado',
        'description': 'Nuevo monto',
        'roles': <Map<String, Object?>>[],
        'amount': 1500,
        'platformFee': 2.5,
        'milestones': <Map<String, Object?>>[],
        'flags': <Map<String, Object?>>[],
        'isActive': true,
        'receiverMemo': 0,
        'trustline': <Map<String, Object?>>[],
      },
      isActive: true,
    );
    final json = payload.toJson();
    expect(json['signer'], 'GAPPROVER');
    expect(json['contractId'], 'CAAA');
    expect(json['isActive'], true);
    final nested = json['escrow'] as Map<String, Object?>;
    expect(nested['engagementId'], 'lease-42');
    expect(nested['amount'], 1500);

    final roundTripped = UpdateEscrowPayload.fromJson(json);
    expect(roundTripped, payload);
  });

  test('ChangeMilestoneStatusPayload round-trips through JSON', () {
    const payload = ChangeMilestoneStatusPayload(
      contractId: 'CAAA',
      milestoneIndex: '1',
      newEvidence: 'ipfs://bafy.../evidence.pdf',
      newStatus: 'Completed',
      serviceProvider: 'GSERVICE',
    );
    expect(payload.toJson(), {
      'contractId': 'CAAA',
      'milestoneIndex': '1',
      'newEvidence': 'ipfs://bafy.../evidence.pdf',
      'newStatus': 'Completed',
      'serviceProvider': 'GSERVICE',
    });
    expect(
      ChangeMilestoneStatusPayload.fromJson(payload.toJson()),
      payload,
    );
  });

  test('ApproveMilestonePayload round-trips through JSON', () {
    const payload = ApproveMilestonePayload(
      contractId: 'CAAA',
      milestoneIndex: '0',
      approver: 'GAPPROVER',
    );
    expect(payload.toJson(), {
      'contractId': 'CAAA',
      'milestoneIndex': '0',
      'approver': 'GAPPROVER',
    });
    expect(ApproveMilestonePayload.fromJson(payload.toJson()), payload);
  });

  test('StartDisputePayload round-trips through JSON', () {
    const payload = StartDisputePayload(
      contractId: 'CAAA',
      signer: 'GAPPROVER',
    );
    expect(payload.toJson(), {
      'contractId': 'CAAA',
      'signer': 'GAPPROVER',
    });
    expect(StartDisputePayload.fromJson(payload.toJson()), payload);
  });

  test('ResolveDisputePayload round-trips with int distributions', () {
    const payload = ResolveDisputePayload(
      contractId: 'CAAA',
      disputeResolver: 'GRESOLVER',
      distributions: [
        DisputeDistribution(address: 'GAPPROVER', amount: 300),
        DisputeDistribution(address: 'GRECEIVER', amount: 700),
      ],
    );
    final json = payload.toJson();
    expect(json['contractId'], 'CAAA');
    expect(json['disputeResolver'], 'GRESOLVER');
    final dist = json['distributions'] as List<Object?>;
    expect(dist, hasLength(2));
    expect(dist[0], {'address': 'GAPPROVER', 'amount': 300});
    expect(ResolveDisputePayload.fromJson(json), payload);
  });

  test('ResolveDisputePayload accepts double amounts', () {
    const payload = ResolveDisputePayload(
      contractId: 'CAAA',
      disputeResolver: 'GRESOLVER',
      distributions: [
        DisputeDistribution(address: 'GAPPROVER', amount: 123.45),
      ],
    );
    final json = payload.toJson();
    final dist = (json['distributions'] as List<Object?>)[0]
        as Map<String, Object?>;
    expect(dist['amount'], 123.45);
  });

  test('UpdateEscrowPayload omits isActive when null', () {
    const payload = UpdateEscrowPayload(
      signer: 'GAPPROVER',
      contractId: 'CAAA',
      escrow: <String, Object?>{'engagementId': 'x'},
    );
    final json = payload.toJson();
    expect(json.containsKey('isActive'), isFalse);
  });
}
