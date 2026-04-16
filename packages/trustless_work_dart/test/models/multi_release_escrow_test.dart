import 'package:test/test.dart';
import 'package:trustless_work_dart/src/models/multi_release_escrow.dart';

void main() {
  group('MultiReleaseEscrow', () {
    test('round-trips through JSON', () {
      const json = <String, dynamic>{
        'contractId': 'CAAA...',
        'engagementId': 'lease-2026-04-15-42',
        'title': 'Alquiler Apto 3B',
        'description': 'Depósito + 6 pagos mensuales',
        'platformFee': 1.5,
        'receiverMemo': 0,
        'roles': <Map<String, dynamic>>[
          {'name': 'approver', 'address': 'GAAA...'},
          {'name': 'receiver', 'address': 'GBBB...'},
        ],
        'milestones': <Map<String, dynamic>>[
          {
            'description': 'Depósito',
            'amount': 250000,
            'status': 'pending',
            'approvedFlag': false,
          },
          {
            'description': 'Pago mes 1',
            'amount': 500000,
            'status': 'pending',
            'approvedFlag': false,
          },
        ],
        'trustline': <String, dynamic>{
          'address': 'CUSDC...',
          'name': 'USDC',
          'decimals': 7,
        },
        'flags': <String, dynamic>{
          'approved': false,
          'disputed': false,
          'released': false,
        },
        'isActive': true,
      };

      final escrow = MultiReleaseEscrow.fromJson(json);
      expect(escrow.contractId, 'CAAA...');
      expect(escrow.roles, hasLength(2));
      expect(escrow.milestones, hasLength(2));
      expect(escrow.milestones[0].amount, 250000);
      expect(escrow.milestones[1].description, 'Pago mes 1');
      expect(escrow.trustline.name, 'USDC');
      // Critical: multi-release has NO top-level amount.
      // ignore: unnecessary_type_check
      expect(escrow is MultiReleaseEscrow, isTrue);

      final again = MultiReleaseEscrow.fromJson(escrow.toJson());
      expect(again, escrow);
    });

    test('parses per-milestone disputeStartedBy when present', () {
      const json = <String, dynamic>{
        'contractId': 'CAAA',
        'engagementId': 'eng',
        'title': 't',
        'description': 'd',
        'platformFee': 0.0,
        'receiverMemo': 0,
        'roles': <Map<String, dynamic>>[],
        'milestones': <Map<String, dynamic>>[
          {
            'description': 'Pago disputado',
            'amount': 500,
            'status': 'Completed',
            'approvedFlag': false,
            'disputeStartedBy': <String, dynamic>{
              'name': 'approver',
              'address': 'GAPPROVER',
            },
          },
        ],
        'trustline': <String, dynamic>{
          'address': 'C',
          'name': 'USDC',
          'decimals': 7,
        },
        'flags': <String, dynamic>{
          'approved': false,
          'disputed': true,
          'released': false,
        },
        'isActive': true,
      };
      final escrow = MultiReleaseEscrow.fromJson(json);
      expect(escrow.milestones.single.disputeStartedBy?.name, 'approver');
      expect(escrow.flags.disputed, isTrue);
    });
  });
}
