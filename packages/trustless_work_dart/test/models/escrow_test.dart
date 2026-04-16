import 'package:test/test.dart';
import 'package:trustless_work_dart/src/models/escrow.dart';

void main() {
  group('Escrow', () {
    test('round-trips through JSON', () {
      const json = <String, dynamic>{
        'contractId': 'CAAA...',
        'engagementId': 'lease-2026-04-15-42',
        'title': 'Alquiler Apto 3B',
        'description': 'Depósito de garantía',
        'amount': 500000,
        'platformFee': 1.5,
        'receiverMemo': 0,
        'roles': <Map<String, dynamic>>[
          {'name': 'approver', 'address': 'GAAA...'},
          {'name': 'receiver', 'address': 'GBBB...'},
        ],
        'milestones': <Map<String, dynamic>>[
          {'description': 'Entrega del inmueble', 'status': 'pending', 'approvedFlag': false},
        ],
        'trustline': <String, dynamic>{
          'address': 'CUSDC...',
          'name': 'USDC',
          'decimals': 7,
        },
        'flags': <String, dynamic>{'approved': false, 'disputed': false, 'released': false},
        'isActive': true,
      };

      final escrow = Escrow.fromJson(json);
      expect(escrow.contractId, 'CAAA...');
      expect(escrow.amount, 500000);
      expect(escrow.roles, hasLength(2));
      expect(escrow.milestones.single.description, 'Entrega del inmueble');
      expect(escrow.trustline.name, 'USDC');

      final again = Escrow.fromJson(escrow.toJson());
      expect(again, escrow);
    });
  });
}
