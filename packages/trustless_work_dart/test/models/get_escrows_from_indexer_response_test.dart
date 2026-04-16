import 'package:test/test.dart';
import 'package:trustless_work_dart/src/models/get_escrows_from_indexer_response.dart';

void main() {
  group('GetEscrowsFromIndexerResponse', () {
    test('round-trips an array of indexer escrows through JSON', () {
      // Shape taken from the TW OpenAPI
      // (`GET /helper/get-escrows-by-signer` response).
      final raw = <Map<String, dynamic>>[
        {
          'contractId': 'CB25FW...',
          'signer': 'GBPUA...',
          'type': 'single-release',
          'engagementId': 'ENG-003',
          'title': 'Alquiler Apto 3B',
          'description': 'Depósito de garantía',
          'milestones': <Map<String, dynamic>>[
            {
              'description': 'Entrega del inmueble',
              'amount': 500,
              'status': 'pending',
              'flags': <String, dynamic>{
                'disputed': false,
                'released': false,
                'resolved': false,
                'approved': false,
              },
              'evidence': null,
            },
          ],
          'platformFee': 1.5,
          'receiverMemo': 0,
          'roles': <String, dynamic>{
            'approver': 'GBPUACN...',
            'serviceProvider': 'GA2RRI...',
            'platformAddress': 'GBPA2LO...',
            'releaseSigner': 'GCPZUO...',
            'disputeResolver': 'GDBMRV...',
            'receiver': 'GA2RRI...',
            'issuer': 'GBPUAC...',
          },
          'trustline': <String, dynamic>{
            'address': 'CBIELT...',
            'name': 'USDC',
          },
          'isActive': true,
          'updatedAt': <String, dynamic>{
            '_seconds': 1750698602,
            '_nanoseconds': 356000000,
          },
          'createdAt': <String, dynamic>{
            '_seconds': 1750698602,
            '_nanoseconds': 356000000,
          },
          'balance': 0,
          'flags': <String, dynamic>{
            'disputed': false,
            'released': false,
            'resolved': false,
          },
        },
      ];

      final response = GetEscrowsFromIndexerResponse.fromList(raw);
      expect(response.escrows, hasLength(1));

      final escrow = response.escrows.single;
      expect(escrow.contractId, 'CB25FW...');
      expect(escrow.signer, 'GBPUA...');
      expect(escrow.type, 'single-release');
      expect(escrow.engagementId, 'ENG-003');
      expect(escrow.roles.approver, 'GBPUACN...');
      expect(escrow.roles.serviceProvider, 'GA2RRI...');
      expect(escrow.milestones, hasLength(1));
      expect(escrow.milestones.single.amount, 500);
      expect(escrow.milestones.single.flags.approved, isFalse);
      expect(escrow.trustline.name, 'USDC');
      expect(escrow.balance, 0);
      expect(escrow.createdAt?.seconds, 1750698602);
      expect(escrow.updatedAt?.nanoseconds, 356000000);
      expect(escrow.flags.disputed, isFalse);
      expect(escrow.flags.resolved, isFalse);

      // Round-trip: decoding → encoding → decoding yields the same object.
      final encoded = response.toList();
      final again = GetEscrowsFromIndexerResponse.fromList(encoded);
      expect(again, response);
    });

    test(
      'tolerates optional indexer-only metadata '
      '(fundedBy, approverFunds, receiverFunds, user, disputeStartedBy) '
      'when surfaced by the API',
      () {
        final raw = <Map<String, dynamic>>[
          {
            'contractId': 'CAAA',
            'signer': 'GAAA',
            'type': 'multi-release',
            'engagementId': 'ENG-001',
            'title': 't',
            'description': 'd',
            'milestones': <Map<String, dynamic>>[],
            'platformFee': 0,
            'receiverMemo': 0,
            'roles': <String, dynamic>{},
            'trustline': <String, dynamic>{'address': 'C', 'name': 'USDC'},
            'isActive': true,
            'flags': <String, dynamic>{
              'disputed': false,
              'released': false,
              'resolved': false,
            },
            // Not documented in OpenAPI but mentioned in HAB-61 spec — kept as
            // optional pass-through metadata.
            'fundedBy': 'GFFF',
            'approverFunds': 1000,
            'receiverFunds': 1000,
            'user': 'GUUU',
            'disputeStartedBy': 'GDDD',
          },
        ];

        final response = GetEscrowsFromIndexerResponse.fromList(raw);
        final escrow = response.escrows.single;
        expect(escrow.fundedBy, 'GFFF');
        expect(escrow.approverFunds, 1000);
        expect(escrow.receiverFunds, 1000);
        expect(escrow.user, 'GUUU');
        expect(escrow.disputeStartedBy, 'GDDD');
      },
    );

    test('handles an empty indexer response', () {
      final response = GetEscrowsFromIndexerResponse.fromList(
        const <Map<String, dynamic>>[],
      );
      expect(response.escrows, isEmpty);
    });
  });
}
