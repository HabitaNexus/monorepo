@Tags(['integration'])
library;

import 'dart:io';
import 'package:stellar_flutter_sdk/stellar_flutter_sdk.dart' as stellar;
import 'package:test/test.dart';
import 'package:trustless_work_dart/trustless_work_dart.dart';

void main() {
  group('testnet end-to-end', () {
    final apiKey = Platform.environment['TW_TESTNET_API_KEY'];

    test('initialize → fund → release on dev.api.trustlesswork.com',
        () async {
      if (apiKey == null || apiKey.isEmpty) {
        fail('Set TW_TESTNET_API_KEY before running --tags=integration');
      }

      // 1. Mint a funded testnet key via Friendbot.
      final keypair = stellar.KeyPair.random();
      await stellar.FriendBot.fundTestAccount(keypair.accountId);

      final client = TrustlessWorkClient(
        config: TrustlessWorkConfig.testnet(apiKey: apiKey),
        signer: KeyPairSigner(keypair: keypair, network: Network.testnet),
      );

      // 2. Initialize an escrow. Adjust fixture fields once Alberto
      //    confirms the minimal test vector that actually boots against
      //    dev. Keep it under 5 minutes of runtime.
      final escrow = await client.initializeEscrow(
        SingleReleaseContract(
          signer: keypair.accountId,
          engagementId: 'integration-${DateTime.now().millisecondsSinceEpoch}',
          title: 'Integration test',
          description: 'Spike validation',
          amount: 1,
          platformFee: 0,
          roles: [
            {'name': 'approver', 'address': keypair.accountId},
            {'name': 'receiver', 'address': keypair.accountId},
            {'name': 'releaseSigner', 'address': keypair.accountId},
            {'name': 'platformAddress', 'address': keypair.accountId},
            {'name': 'serviceProvider', 'address': keypair.accountId},
            {'name': 'disputeResolver', 'address': keypair.accountId},
          ],
          milestones: [
            {'description': 'Integration milestone'},
          ],
          trustline: [
            {
              'address':
                  'CBIELTK6YBZJU5UP2WWQEUCYKLPU6AUNZ2BQ4WWFEIE3USCIHMXQDAMA',
              'name': 'USDC',
              'decimals': 7,
            },
          ],
        ),
      );

      expect(escrow.contractId, isNotEmpty);

      // 3. Fund
      final funded = await client.fundEscrow(FundEscrowPayload(
        contractId: escrow.contractId,
        signer: keypair.accountId,
        amount: '1',
      ));
      expect(funded.flags.released, isFalse);

      // 4. Release
      final released = await client.releaseFunds(ReleaseFundsPayload(
        contractId: escrow.contractId,
        releaseSigner: keypair.accountId,
      ));
      expect(released.flags.released, isTrue);
    }, timeout: const Timeout(Duration(minutes: 5)));
  });
}
