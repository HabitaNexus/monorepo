import 'package:stellar_flutter_sdk/stellar_flutter_sdk.dart';
import 'package:test/test.dart';
import 'package:trustless_work_dart/src/events/escrow_event.dart';
import 'package:trustless_work_dart/src/events/soroban_event_decoder.dart';

EventInfo _event({
  required List<String> topic,
  required String valueB64,
  String? ledgerCloseAt,
  String txHash = 'tx',
  String id = '0',
}) =>
    EventInfo(
      'contract',
      1,
      ledgerCloseAt ?? '2026-04-15T12:00:00Z',
      'CAAA',
      id,
      topic,
      valueB64,
      true,
      txHash,
      id,
    );

String _sym(String s) => XdrSCVal.forSymbol(s).toBase64EncodedXdrString();
String _void() {
  final v = XdrSCVal(XdrSCValType.SCV_VOID);
  return v.toBase64EncodedXdrString();
}

void main() {
  group('SorobanEventDecoder', () {
    const contractId = 'CAAA';
    late SorobanEventDecoder decoder;

    setUp(() {
      decoder = const SorobanEventDecoder();
    });

    test('decodes tw_init → Initialized', () {
      final event = _event(
        topic: [_sym('tw_init')],
        valueB64: _void(),
      );
      final decoded = decoder.decode(event: event, contractId: contractId);
      expect(decoded, isA<Initialized>());
      expect(decoded!.contractId, contractId);
      expect(decoded.observedAt, DateTime.parse('2026-04-15T12:00:00Z'));
    });

    test('decodes tw_fund → Funded with amount from vec data', () {
      final signerAddress = XdrSCVal.forAccountAddress(
        'GA7QYNF7SOWQ3GLR2BGMZEHXAVIRZA4KVWLTJJFC7MGXUA74P7UJVSGZ',
      );
      final amount =
          XdrSCVal.forI128(XdrInt128Parts.forHiLo(0, 5000000000));
      final data =
          XdrSCVal.forVec([signerAddress, amount]).toBase64EncodedXdrString();
      final event = _event(topic: [_sym('tw_fund')], valueB64: data);

      final decoded = decoder.decode(event: event, contractId: contractId);
      expect(decoded, isA<Funded>());
      expect((decoded! as Funded).amount, '5000000000');
    });

    test('decodes tw_release → Released', () {
      final signerAddress = XdrSCVal.forAccountAddress(
        'GA7QYNF7SOWQ3GLR2BGMZEHXAVIRZA4KVWLTJJFC7MGXUA74P7UJVSGZ',
      );
      final event = _event(
        topic: [_sym('tw_release')],
        valueB64: signerAddress.toBase64EncodedXdrString(),
      );
      final decoded = decoder.decode(event: event, contractId: contractId);
      expect(decoded, isA<Released>());
    });

    test('decodes tw_dispute → DisputeStarted', () {
      final event = _event(
        topic: [_sym('tw_dispute')],
        valueB64: _void(),
      );
      final decoded = decoder.decode(event: event, contractId: contractId);
      expect(decoded, isA<DisputeStarted>());
    });

    test('decodes tw_disp_resolve → DisputeResolved (approverSplit '
        'placeholder)', () {
      final event = _event(
        topic: [_sym('tw_disp_resolve')],
        valueB64: _void(),
      );
      final decoded = decoder.decode(event: event, contractId: contractId);
      expect(decoded, isA<DisputeResolved>());
      // v0.2 cannot extract the split from the on-chain event (the
      // Escrow struct does not carry the distribution map). The decoder
      // emits a sentinel value; consumers wishing exact splits must
      // correlate with the resolve-dispute tx args out-of-band.
      expect((decoded! as DisputeResolved).approverSplit, isNaN);
    });

    test('decodes tw_ms_change → null (caller must diff to get index)', () {
      final event = _event(
        topic: [_sym('tw_ms_change')],
        valueB64: _void(),
      );
      final decoded = decoder.decode(event: event, contractId: contractId);
      // The on-chain event carries the full Escrow, not the changed
      // index — decoder signals "needs diff" by returning null so the
      // HybridEventStream drops to its re-fetch + diff path.
      expect(decoded, isNull);
    });

    test('decodes tw_ms_approve → null (caller must diff)', () {
      final event = _event(
        topic: [_sym('tw_ms_approve')],
        valueB64: _void(),
      );
      final decoded = decoder.decode(event: event, contractId: contractId);
      expect(decoded, isNull);
    });

    test('unknown topic returns null', () {
      final event = _event(
        topic: [_sym('tw_unknown_made_up')],
        valueB64: _void(),
      );
      final decoded = decoder.decode(event: event, contractId: contractId);
      expect(decoded, isNull);
    });

    test('topic without a symbol segment returns null', () {
      final event = _event(topic: [], valueB64: _void());
      expect(
        decoder.decode(event: event, contractId: contractId),
        isNull,
      );
    });

    test('tw_fund with malformed payload falls back to null '
        '(decode-failure sentinel)', () {
      // A topic we know, but payload is not the expected vec[addr, i128].
      final event = _event(
        topic: [_sym('tw_fund')],
        valueB64: _sym('oops'), // wrong shape
      );
      final decoded = decoder.decode(event: event, contractId: contractId);
      expect(decoded, isNull);
    });
  });
}
