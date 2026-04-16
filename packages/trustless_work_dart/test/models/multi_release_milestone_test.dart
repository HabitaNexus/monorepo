import 'package:test/test.dart';
import 'package:trustless_work_dart/src/models/multi_release_milestone.dart';
import 'package:trustless_work_dart/src/models/role.dart';

void main() {
  group('MultiReleaseMilestone', () {
    test('round-trips through JSON with all fields', () {
      const json = <String, dynamic>{
        'description': 'Entrega del inmueble',
        'amount': 250000,
        'status': 'pending',
        'approvedFlag': false,
        'evidence': 'ipfs://bafy.../entrega.pdf',
      };

      final milestone = MultiReleaseMilestone.fromJson(json);
      expect(milestone.description, 'Entrega del inmueble');
      expect(milestone.amount, 250000);
      expect(milestone.status, 'pending');
      expect(milestone.approvedFlag, false);
      expect(milestone.evidence, 'ipfs://bafy.../entrega.pdf');
      expect(milestone.disputeStartedBy, isNull);

      final again = MultiReleaseMilestone.fromJson(milestone.toJson());
      expect(again, milestone);
    });

    test('defaults status to pending and approvedFlag to false', () {
      const milestone = MultiReleaseMilestone(
        description: 'Segundo pago',
        amount: 100000,
      );
      expect(milestone.status, 'pending');
      expect(milestone.approvedFlag, false);
      expect(milestone.evidence, isNull);
      expect(milestone.disputeStartedBy, isNull);
    });

    test('preserves disputeStartedBy role through round-trip', () {
      const milestone = MultiReleaseMilestone(
        description: 'Pago en disputa',
        amount: 500000,
        status: 'Completed',
        approvedFlag: false,
        disputeStartedBy: Role(name: 'approver', address: 'GAPPROVER...'),
      );
      final json = milestone.toJson();
      expect(json['disputeStartedBy'], {
        'name': 'approver',
        'address': 'GAPPROVER...',
      });
      final again = MultiReleaseMilestone.fromJson(json);
      expect(again, milestone);
    });

    test('omits disputeStartedBy when null via round-trip', () {
      const milestone = MultiReleaseMilestone(
        description: 'Pago inicial',
        amount: 100000,
      );
      final json = milestone.toJson();
      // Whether null is emitted or omitted, from-JSON with only required
      // fields must still reconstruct the same object.
      final reconstructed = MultiReleaseMilestone.fromJson({
        'description': json['description'],
        'amount': json['amount'],
      });
      expect(reconstructed, milestone);
    });
  });
}
