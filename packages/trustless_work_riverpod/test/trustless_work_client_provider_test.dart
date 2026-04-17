import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trustless_work_riverpod/trustless_work_riverpod.dart';

void main() {
  group('trustlessWorkClientProvider', () {
    test('throws UnimplementedError when not overridden', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(
        () => container.read(trustlessWorkClientProvider),
        throwsA(isA<UnimplementedError>()),
      );
    });
  });
}
