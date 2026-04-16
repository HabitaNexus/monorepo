import 'package:test/test.dart';
import 'package:trustless_work_dart/src/models/payloads/multi_release_contract.dart';
import 'package:trustless_work_dart/src/models/payloads/multi_release_release_funds_payload.dart';
import 'package:trustless_work_dart/src/models/payloads/multi_release_start_dispute_payload.dart';
import 'package:trustless_work_dart/src/models/payloads/multi_release_resolve_dispute_payload.dart';
import 'package:trustless_work_dart/src/models/payloads/resolve_dispute_payload.dart';

void main() {
  test(
      'MultiReleaseContract serializes required fields and omits top-level amount',
      () {
    const contract = MultiReleaseContract(
      signer: 'GAAA...',
      engagementId: 'lease-42',
      title: 'Alquiler + pagos mensuales',
      description: 'Depósito + 6 pagos',
      platformFee: 2.5,
      roles: <Map<String, Object?>>[],
      milestones: <Map<String, Object?>>[
        {'description': 'Depósito', 'amount': 250000},
        {'description': 'Pago mes 1', 'amount': 500000},
      ],
      trustline: <Map<String, Object?>>[],
    );
    final json = contract.toJson();
    expect(json['signer'], 'GAAA...');
    expect(json['engagementId'], 'lease-42');
    expect(json['platformFee'], 2.5);
    expect(
      json.containsKey('amount'),
      isFalse,
      reason: 'multi-release contracts do not have a top-level amount',
    );
    expect((json['milestones'] as List).length, 2);

    expect(MultiReleaseContract.fromJson(json), contract);
  });

  test(
    'MultiReleaseReleaseFundsPayload requires contractId, releaseSigner, milestoneIndex',
    () {
      const payload = MultiReleaseReleaseFundsPayload(
        contractId: 'CAAA',
        releaseSigner: 'GREL',
        milestoneIndex: '2',
      );
      expect(payload.toJson(), {
        'contractId': 'CAAA',
        'releaseSigner': 'GREL',
        'milestoneIndex': '2',
      });
      expect(
        MultiReleaseReleaseFundsPayload.fromJson(payload.toJson()),
        payload,
      );
    },
  );

  test('MultiReleaseStartDisputePayload round-trips with milestoneIndex', () {
    const payload = MultiReleaseStartDisputePayload(
      contractId: 'CAAA',
      milestoneIndex: '1',
      signer: 'GAPPROVER',
    );
    expect(payload.toJson(), {
      'contractId': 'CAAA',
      'milestoneIndex': '1',
      'signer': 'GAPPROVER',
    });
    expect(
      MultiReleaseStartDisputePayload.fromJson(payload.toJson()),
      payload,
    );
  });

  test('MultiReleaseResolveDisputePayload round-trips with distributions', () {
    const payload = MultiReleaseResolveDisputePayload(
      contractId: 'CAAA',
      disputeResolver: 'GRESOLVER',
      milestoneIndex: '0',
      distributions: [
        DisputeDistribution(address: 'GAPPROVER', amount: 300),
        DisputeDistribution(address: 'GRECEIVER', amount: 700),
      ],
    );
    final json = payload.toJson();
    expect(json['contractId'], 'CAAA');
    expect(json['disputeResolver'], 'GRESOLVER');
    expect(json['milestoneIndex'], '0');
    final dist = json['distributions'] as List<Object?>;
    expect(dist, hasLength(2));
    expect(dist[0], {'address': 'GAPPROVER', 'amount': 300});
    expect(
      MultiReleaseResolveDisputePayload.fromJson(json),
      payload,
    );
  });
}
