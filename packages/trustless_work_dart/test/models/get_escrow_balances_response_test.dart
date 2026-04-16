import 'package:test/test.dart';
import 'package:trustless_work_dart/src/models/get_escrow_balances_response.dart';

void main() {
  group('GetEscrowBalancesResponse', () {
    test('decodes the raw array returned by /helper/get-multiple-escrow-balance',
        () {
      // Shape taken verbatim from the TW OpenAPI example on 2026-04-15
      // (`GET /helper/get-multiple-escrow-balance`).
      final raw = <Map<String, dynamic>>[
        {'address': 'GAWVVSA..', 'balance': 30},
        {'address': 'GAWVCG3..', 'balance': 10},
      ];

      final response = GetEscrowBalancesResponse.fromList(raw);
      expect(response.balances, hasLength(2));
      expect(response.balances[0].address, 'GAWVVSA..');
      expect(response.balances[0].balance, 30);
      expect(response.balances[1].address, 'GAWVCG3..');
      expect(response.balances[1].balance, 10);
    });

    test('round-trips an array of entries through toList/fromList', () {
      final raw = <Map<String, dynamic>>[
        {'address': 'GAAA', 'balance': 100},
        {'address': 'GBBB', 'balance': 0},
      ];

      final response = GetEscrowBalancesResponse.fromList(raw);
      final encoded = response.toList();
      final again = GetEscrowBalancesResponse.fromList(encoded);
      expect(again, response);
    });

    test('accepts fractional / decimal balances (`num`, not `int`)', () {
      final raw = <Map<String, dynamic>>[
        {'address': 'GAAA', 'balance': 12.5},
      ];
      final response = GetEscrowBalancesResponse.fromList(raw);
      expect(response.balances.single.balance, 12.5);
    });

    test('handles an empty response', () {
      final response = GetEscrowBalancesResponse.fromList(
        const <Map<String, dynamic>>[],
      );
      expect(response.balances, isEmpty);
    });
  });
}
