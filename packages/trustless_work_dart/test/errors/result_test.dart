// test/errors/result_test.dart
import 'package:test/test.dart';
import 'package:trustless_work_dart/src/errors/result.dart';

void main() {
  group('Result', () {
    test('Ok carries the value', () {
      const r = Result<int, String>.ok(42);
      expect(r.isOk, isTrue);
      expect(r.isErr, isFalse);
      expect(r.valueOrNull, 42);
      expect(r.errorOrNull, isNull);
    });

    test('Err carries the error', () {
      const r = Result<int, String>.err('boom');
      expect(r.isOk, isFalse);
      expect(r.isErr, isTrue);
      expect(r.valueOrNull, isNull);
      expect(r.errorOrNull, 'boom');
    });

    test('map transforms Ok value', () {
      const r = Result<int, String>.ok(2);
      expect(r.map((v) => v * 3).valueOrNull, 6);
    });

    test('map does not touch Err', () {
      const r = Result<int, String>.err('boom');
      expect(r.map((v) => v * 3).errorOrNull, 'boom');
    });

    test('when is exhaustive', () {
      const ok = Result<int, String>.ok(1);
      const err = Result<int, String>.err('x');
      expect(ok.when(ok: (v) => 'v=$v', err: (e) => 'e=$e'), 'v=1');
      expect(err.when(ok: (v) => 'v=$v', err: (e) => 'e=$e'), 'e=x');
    });
  });
}
