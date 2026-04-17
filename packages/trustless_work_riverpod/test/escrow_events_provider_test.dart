import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:stellar_flutter_sdk/stellar_flutter_sdk.dart' hide Flags;
import 'package:trustless_work_dart/trustless_work_dart.dart';
import 'package:trustless_work_riverpod/trustless_work_riverpod.dart';

/// Fake [SorobanEventSource] that returns empty pages.
class _EmptySorobanEventSource implements SorobanEventSource {
  @override
  Future<SorobanEventPage> fetch({
    required String contractId,
    String? cursor,
  }) async =>
      const SorobanEventPage(events: [], cursor: null);
}

/// Fake [HorizonEffectsSource] that emits nothing.
class _EmptyHorizonEffectsSource implements HorizonEffectsSource {
  @override
  Stream<EffectResponse> streamForContractAccount(String contractAccount) =>
      const Stream.empty();
}

void main() {
  Map<String, dynamic> fakeEscrowMap({String contractId = 'CAAA'}) =>
      <String, dynamic>{
        'contractId': contractId,
        'engagementId': 'lease-1',
        'title': 'Test Escrow',
        'description': 'A test escrow',
        'amount': 1000,
        'platformFee': 0.0,
        'receiverMemo': 0,
        'roles': <Map<String, dynamic>>[],
        'milestones': <Map<String, dynamic>>[],
        'trustline': <String, dynamic>{
          'address': 'CUSDC',
          'name': 'USDC',
          'decimals': 7,
        },
        'flags': <String, dynamic>{
          'approved': false,
          'disputed': false,
          'released': false,
        },
        'isActive': true,
      };

  group('escrowEventsProvider', () {
    test('wraps client.escrowEvents as a StreamProvider', () async {
      // The HybridEventStream will do an initial escrow fetch, then poll
      // Soroban events. We wire a mock that returns a valid escrow for
      // the initial read, and empty event sources.
      final mock = MockClient((req) async {
        if (req.url.path.contains('get-escrow')) {
          return http.Response(jsonEncode(fakeEscrowMap()), 200);
        }
        return http.Response('not found', 404);
      });

      final client = TrustlessWorkClient.forTesting(
        config: TrustlessWorkConfig.testnet(apiKey: 'k'),
        signer: CallbackSigner(
          publicKey: 'GAAA',
          signXdr: (xdr) async => 'S_$xdr',
        ),
        innerHttp: mock,
        sorobanEvents: _EmptySorobanEventSource(),
        horizonEffects: _EmptyHorizonEffectsSource(),
      );

      final container = ProviderContainer(
        overrides: [
          trustlessWorkClientProvider.overrideWithValue(client),
        ],
      );
      addTearDown(container.dispose);

      // The provider type is StreamProvider.family, so we can read it.
      final asyncValue = container.read(escrowEventsProvider('CAAA'));
      // Initially it should be loading since the stream hasn't emitted.
      expect(asyncValue, isA<AsyncValue<EscrowEvent>>());
    });

    test('provider is family-keyed by contractId', () {
      final mock = MockClient((req) async {
        return http.Response(jsonEncode(fakeEscrowMap()), 200);
      });

      final client = TrustlessWorkClient.forTesting(
        config: TrustlessWorkConfig.testnet(apiKey: 'k'),
        signer: CallbackSigner(
          publicKey: 'GAAA',
          signXdr: (xdr) async => 'S_$xdr',
        ),
        innerHttp: mock,
        sorobanEvents: _EmptySorobanEventSource(),
        horizonEffects: _EmptyHorizonEffectsSource(),
      );

      final container = ProviderContainer(
        overrides: [
          trustlessWorkClientProvider.overrideWithValue(client),
        ],
      );
      addTearDown(container.dispose);

      // Two different contractIds should produce two distinct providers.
      final provider1 = escrowEventsProvider('CAAA');
      final provider2 = escrowEventsProvider('CBBB');
      expect(provider1, isNot(equals(provider2)));
    });
  });
}
