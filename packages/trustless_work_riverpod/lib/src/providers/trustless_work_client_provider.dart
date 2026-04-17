import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trustless_work_dart/trustless_work_dart.dart';

/// The root provider that supplies a configured [TrustlessWorkClient].
///
/// **Must be overridden** in a `ProviderScope`:
///
/// ```dart
/// ProviderScope(
///   overrides: [
///     trustlessWorkClientProvider.overrideWithValue(myClient),
///   ],
///   child: const MyApp(),
/// )
/// ```
///
/// Throws [UnimplementedError] if read without an override, making it
/// impossible to accidentally use a misconfigured client.
final trustlessWorkClientProvider = Provider<TrustlessWorkClient>(
  (ref) => throw UnimplementedError(
    'trustlessWorkClientProvider must be overridden with a configured '
    'TrustlessWorkClient via ProviderScope(overrides: '
    '[trustlessWorkClientProvider.overrideWithValue(myClient)]).',
  ),
);
