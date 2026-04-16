import 'package:trustless_work_dart/trustless_work_dart.dart';

typedef SignerLoader = Future<TransactionSigner> Function();

/// Builds a `TrustlessWorkClient` ready to be injected into the app's
/// dependency graph. In production `signerLoader` is wired to
/// `SecureStorageKeyPairSigner.loadOrCreate`; in tests callers pass a
/// fake.
Future<TrustlessWorkClient> bootstrapTrustlessWorkClient({
  required String apiKey,
  required Network network,
  required SignerLoader signerLoader,
}) async {
  final signer = await signerLoader();
  final config = switch (network) {
    Network.testnet => TrustlessWorkConfig.testnet(apiKey: apiKey),
    Network.mainnet => TrustlessWorkConfig.mainnet(apiKey: apiKey),
  };
  return TrustlessWorkClient(config: config, signer: signer);
}
