import 'package:test/test.dart';
import 'package:trustless_work_dart/src/models/payloads/fund_escrow_payload.dart';
import 'package:trustless_work_dart/src/models/payloads/release_funds_payload.dart';
import 'package:trustless_work_dart/src/models/payloads/single_release_contract.dart';

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
}
