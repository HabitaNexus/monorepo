import 'dart:io';
import 'package:stellar_flutter_sdk/stellar_flutter_sdk.dart' as stellar;
import 'package:trustless_work_dart/trustless_work_dart.dart';

Future<void> main() async {
  final apiKey = Platform.environment['TW_TESTNET_API_KEY'];
  if (apiKey == null || apiKey.isEmpty) {
    stderr.writeln('Set TW_TESTNET_API_KEY to run this example.');
    exit(64);
  }

  final keypair = stellar.KeyPair.random();
  await stellar.FriendBot.fundTestAccount(keypair.accountId);

  // ignore: unused_local_variable
  final client = TrustlessWorkClient(
    config: TrustlessWorkConfig.testnet(apiKey: apiKey),
    signer: KeyPairSigner(keypair: keypair, network: Network.testnet),
  );

  stdout.writeln('Using account ${keypair.accountId}');
  stdout.writeln('Initializing escrow...');
  // Reuse the exact payload of the integration test — single release
  // with the signer acting all roles to keep the demo self-contained.
  // See test/integration/testnet_e2e_test.dart for the full fixture.
}
