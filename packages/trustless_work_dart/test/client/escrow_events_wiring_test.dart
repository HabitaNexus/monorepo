import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:stellar_flutter_sdk/stellar_flutter_sdk.dart' hide Flags;
import 'package:test/test.dart';
import 'package:trustless_work_dart/trustless_work_dart.dart';

class _FakeSorobanEventSource implements SorobanEventSource {
  _FakeSorobanEventSource(this.pages);
  final List<List<EventInfo>> pages;
  int _idx = 0;

  @override
  Future<SorobanEventPage> fetch({
    required String contractId,
    String? cursor,
  }) async {
    if (_idx >= pages.length) {
      return const SorobanEventPage(events: [], cursor: null);
    }
    final page = pages[_idx++];
    return SorobanEventPage(
      events: page,
      cursor: page.isNotEmpty ? page.last.id : cursor,
    );
  }
}

class _FakeHorizonEffectsSource implements HorizonEffectsSource {
  @override
  Stream<EffectResponse> streamForContractAccount(String contractAccount) =>
      const Stream.empty();
}

String _escrowJson() => jsonEncode({
      'contractId': 'CAAA',
      'engagementId': 'e',
      'title': 't',
      'description': 'd',
      'amount': 0,
      'platformFee': 0.0,
      'receiverMemo': 0,
      'roles': <Map<String, Object?>>[],
      'milestones': <Map<String, Object?>>[],
      'trustline': <String, Object?>{
        'address': 'C',
        'name': 'USDC',
        'decimals': 7,
      },
      'flags': <String, Object?>{
        'approved': false,
        'disputed': false,
        'released': false,
      },
      'isActive': true,
    });

void main() {
  test('TrustlessWorkClient.escrowEvents returns a Stream<EscrowEvent> '
      'backed by HybridEventStream (no @experimental)', () async {
    final mock = MockClient((req) async => http.Response(_escrowJson(), 200));
    final twInit = _event(
      topic: [XdrSCVal.forSymbol('tw_init').toBase64EncodedXdrString()],
      valueB64: XdrSCVal(XdrSCValType.SCV_VOID).toBase64EncodedXdrString(),
    );
    final client = TrustlessWorkClient.forTesting(
      config: TrustlessWorkConfig.testnet(apiKey: 'k'),
      signer: CallbackSigner(
        publicKey: 'GAAA',
        signXdr: (xdr) async => 'S_$xdr',
      ),
      innerHttp: mock,
      sorobanEvents: _FakeSorobanEventSource([
        [twInit],
      ]),
      horizonEffects: _FakeHorizonEffectsSource(),
    );

    final events = <EscrowEvent>[];
    final sub = client.escrowEvents('CAAA').listen(events.add);
    await Future<void>.delayed(const Duration(milliseconds: 60));
    await sub.cancel();

    expect(events.whereType<Initialized>(), isNotEmpty);
  });
}

EventInfo _event({
  required List<String> topic,
  required String valueB64,
  String id = '0',
}) =>
    EventInfo(
      'contract',
      1,
      '2026-04-15T12:00:00Z',
      'CAAA',
      id,
      topic,
      valueB64,
      true,
      'tx',
      id,
    );
