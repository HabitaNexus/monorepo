// test/errors/trustless_work_error_test.dart
import 'package:test/test.dart';
import 'package:trustless_work_dart/src/errors/trustless_work_error.dart';

void main() {
  group('TrustlessWorkError', () {
    test('BadRequest carries message and status 400', () {
      const err = TrustlessWorkError.badRequest(message: 'missing amount');
      expect(err, isA<BadRequest>());
      expect((err as BadRequest).message, 'missing amount');
      expect(err.statusCode, 400);
    });

    test('ServerError carries possibleCauses', () {
      const err = TrustlessWorkError.serverError(
        message: 'Escrow not found',
        possibleCauses: ['Escrow not found', 'Invalid contract id'],
      );
      expect(err, isA<ServerError>());
      expect((err as ServerError).possibleCauses, hasLength(2));
    });

    test('NetworkError wraps an underlying exception', () {
      final underlying = Exception('DNS failed');
      final err = TrustlessWorkError.network(message: 'connect failed', cause: underlying);
      expect(err, isA<NetworkError>());
      expect((err as NetworkError).cause, underlying);
    });

    test('toString includes class name and message', () {
      const err = TrustlessWorkError.unauthorized(message: 'invalid api key');
      expect(err.toString(), contains('Unauthorized'));
      expect(err.toString(), contains('invalid api key'));
    });
  });
}
