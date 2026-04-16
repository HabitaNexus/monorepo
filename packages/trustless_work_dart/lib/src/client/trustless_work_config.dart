import '../models/network.dart';

/// Immutable configuration for `TrustlessWorkClient`.
///
/// Prefer the `testnet`/`mainnet` factories over the generic constructor
/// to avoid URL typos.
class TrustlessWorkConfig {
  TrustlessWorkConfig({
    required this.baseUrl,
    required this.apiKey,
    required this.network,
  }) {
    if (apiKey.isEmpty) {
      throw ArgumentError.value(apiKey, 'apiKey', 'must not be empty');
    }
  }

  const TrustlessWorkConfig._const({
    required this.baseUrl,
    required this.apiKey,
    required this.network,
  });

  factory TrustlessWorkConfig.testnet({required String apiKey}) {
    if (apiKey.isEmpty) {
      throw ArgumentError.value(apiKey, 'apiKey', 'must not be empty');
    }
    return TrustlessWorkConfig._const(
      baseUrl: Uri.parse('https://dev.api.trustlesswork.com'),
      apiKey: apiKey,
      network: Network.testnet,
    );
  }

  factory TrustlessWorkConfig.mainnet({required String apiKey}) {
    if (apiKey.isEmpty) {
      throw ArgumentError.value(apiKey, 'apiKey', 'must not be empty');
    }
    return TrustlessWorkConfig._const(
      baseUrl: Uri.parse('https://api.trustlesswork.com'),
      apiKey: apiKey,
      network: Network.mainnet,
    );
  }

  final Uri baseUrl;
  final String apiKey;
  final Network network;
}
