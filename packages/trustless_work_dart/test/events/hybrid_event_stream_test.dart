import 'dart:async';

import 'package:stellar_flutter_sdk/stellar_flutter_sdk.dart' hide Flags;
import 'package:test/test.dart';
import 'package:trustless_work_dart/src/events/escrow_event.dart';
import 'package:trustless_work_dart/src/events/hybrid_event_stream.dart';
import 'package:trustless_work_dart/src/models/escrow.dart';
import 'package:trustless_work_dart/src/models/flags.dart';
import 'package:trustless_work_dart/src/models/milestone.dart';
import 'package:trustless_work_dart/src/models/trustline.dart';

Escrow _escrow({
  List<Milestone> milestones = const [],
  int amount = 0,
  Flags flags = const Flags(),
}) =>
    Escrow(
      contractId: 'CAAA',
      engagementId: 'e',
      title: 't',
      description: 'd',
      amount: amount,
      platformFee: 0,
      receiverMemo: 0,
      roles: const [],
      milestones: milestones,
      trustline: const Trustline(address: 'C', name: 'USDC', decimals: 7),
      flags: flags,
      isActive: true,
    );

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

String _sym(String s) => XdrSCVal.forSymbol(s).toBase64EncodedXdrString();
String _void() => XdrSCVal(XdrSCValType.SCV_VOID).toBase64EncodedXdrString();

/// Fake that records getEvents cursor progressions and returns
/// pre-seeded batches.
class _FakeSorobanEventSource implements SorobanEventSource {
  _FakeSorobanEventSource(this.batches);

  final List<List<EventInfo>> batches;
  final List<String?> cursorsSeen = [];
  int _idx = 0;

  @override
  Future<SorobanEventPage> fetch({
    required String contractId,
    String? cursor,
  }) async {
    cursorsSeen.add(cursor);
    if (_idx >= batches.length) {
      return const SorobanEventPage(events: [], cursor: null);
    }
    final events = batches[_idx++];
    final next = events.isNotEmpty ? events.last.id : cursor;
    return SorobanEventPage(events: events, cursor: next);
  }
}

/// Fake horizon effects source backed by a StreamController the test
/// owns.
class _FakeHorizonEffectsSource implements HorizonEffectsSource {
  _FakeHorizonEffectsSource(this.controller);

  final StreamController<EffectResponse> controller;

  @override
  Stream<EffectResponse> streamForContractAccount(String contractAccount) =>
      controller.stream;
}

void main() {
  test('emits Initialized from Soroban tw_init decoded event', () async {
    final source = _FakeSorobanEventSource([
      [_event(topic: [_sym('tw_init')], valueB64: _void())],
    ]);
    final escrows = [_escrow()];
    final stream = HybridEventStream(
      contractId: 'CAAA',
      fetchEscrow: () async => escrows.first,
      sorobanEvents: source,
      horizonEffects: _FakeHorizonEffectsSource(
        StreamController<EffectResponse>.broadcast(),
      ),
      minPollInterval: const Duration(milliseconds: 10),
      maxPollInterval: const Duration(milliseconds: 30),
      now: () => DateTime(2026, 4, 15),
    );

    final events = <EscrowEvent>[];
    final sub = stream.events.listen(events.add);
    await Future<void>.delayed(const Duration(milliseconds: 40));
    await sub.cancel();

    expect(events.whereType<Initialized>(), isNotEmpty);
  });

  test('decoder-failure topic (tw_ms_approve) triggers re-fetch + diff '
      'and emits MilestoneApproved', () async {
    final source = _FakeSorobanEventSource([
      // First tick emits initial state (no diff yet)
      [],
      // Second tick: tw_ms_approve comes in → decoder returns null →
      // HybridEventStream re-fetches and diffs
      [_event(topic: [_sym('tw_ms_approve')], valueB64: _void())],
    ]);
    var fetchCall = 0;
    final before = _escrow(
      milestones: const [Milestone(description: 'm0', approvedFlag: false)],
    );
    final after = _escrow(
      milestones: const [Milestone(description: 'm0', approvedFlag: true)],
    );
    Future<Escrow> fetchEscrow() async {
      fetchCall++;
      return fetchCall == 1 ? before : after;
    }

    final stream = HybridEventStream(
      contractId: 'CAAA',
      fetchEscrow: fetchEscrow,
      sorobanEvents: source,
      horizonEffects: _FakeHorizonEffectsSource(
        StreamController<EffectResponse>.broadcast(),
      ),
      minPollInterval: const Duration(milliseconds: 10),
      maxPollInterval: const Duration(milliseconds: 30),
      now: () => DateTime(2026, 4, 15),
    );

    final events = <EscrowEvent>[];
    final sub = stream.events.listen(events.add);
    await Future<void>.delayed(const Duration(milliseconds: 60));
    await sub.cancel();

    final approved = events.whereType<MilestoneApproved>();
    expect(approved, isNotEmpty);
    expect(approved.first.index, 0);
  });

  test('Soroban source error surfaces via escrow re-fetch + diff '
      '(reconciliation after SSE disconnect)', () async {
    // This source always throws — simulates an RPC outage or bad cursor.
    final brokenSource = _FailingSorobanSource();
    var fetchCall = 0;
    final before = _escrow();
    final after = _escrow(amount: 1000);
    Future<Escrow> fetchEscrow() async {
      fetchCall++;
      return fetchCall == 1 ? before : after;
    }

    final stream = HybridEventStream(
      contractId: 'CAAA',
      fetchEscrow: fetchEscrow,
      sorobanEvents: brokenSource,
      horizonEffects: _FakeHorizonEffectsSource(
        StreamController<EffectResponse>.broadcast(),
      ),
      minPollInterval: const Duration(milliseconds: 10),
      maxPollInterval: const Duration(milliseconds: 30),
      now: () => DateTime(2026, 4, 15),
    );

    final events = <EscrowEvent>[];
    final errors = <Object>[];
    final sub = stream.events.listen(
      events.add,
      onError: errors.add,
    );
    await Future<void>.delayed(const Duration(milliseconds: 60));
    await sub.cancel();

    // Errors must not kill the stream; diff fallback still emits Funded.
    expect(events.whereType<Funded>(), isNotEmpty);
  });

  test('resumeFromBackground forces an immediate reconciliation tick',
      () async {
    var fetchCall = 0;
    final before = _escrow();
    final after = _escrow(flags: const Flags(released: true));
    Future<Escrow> fetchEscrow() async {
      fetchCall++;
      return fetchCall == 1 ? before : after;
    }

    final source = _FakeSorobanEventSource([]);
    final stream = HybridEventStream(
      contractId: 'CAAA',
      fetchEscrow: fetchEscrow,
      sorobanEvents: source,
      horizonEffects: _FakeHorizonEffectsSource(
        StreamController<EffectResponse>.broadcast(),
      ),
      minPollInterval: const Duration(seconds: 60),
      maxPollInterval: const Duration(seconds: 60),
      now: () => DateTime(2026, 4, 15),
    );

    final events = <EscrowEvent>[];
    final sub = stream.events.listen(events.add);
    // Wait for initial snapshot tick.
    await Future<void>.delayed(const Duration(milliseconds: 30));
    // Now simulate app resume — should trigger an immediate poll.
    stream.resumeFromBackground();
    await Future<void>.delayed(const Duration(milliseconds: 30));
    await sub.cancel();

    expect(events.whereType<Released>(), isNotEmpty);
  });

  test('Initialized is emitted at most once even when both baseline '
      'reconcile and tw_init decoder fire', () async {
    final source = _FakeSorobanEventSource([
      [_event(topic: [_sym('tw_init')], valueB64: _void())],
    ]);
    final stream = HybridEventStream(
      contractId: 'CAAA',
      fetchEscrow: () async => _escrow(),
      sorobanEvents: source,
      horizonEffects: _FakeHorizonEffectsSource(
        StreamController<EffectResponse>.broadcast(),
      ),
      minPollInterval: const Duration(milliseconds: 10),
      maxPollInterval: const Duration(milliseconds: 30),
      now: () => DateTime(2026, 4, 15),
    );

    final events = <EscrowEvent>[];
    final sub = stream.events.listen(events.add);
    await Future<void>.delayed(const Duration(milliseconds: 50));
    await sub.cancel();

    expect(events.whereType<Initialized>().length, 1);
  });

  test('Horizon SSE errors are handled gracefully (reconciliation '
      'kicks in, stream stays alive)', () async {
    final controller = StreamController<EffectResponse>.broadcast();
    final source = _FakeSorobanEventSource([]);
    var fetchCall = 0;
    final before = _escrow();
    final after = _escrow(amount: 500);
    Future<Escrow> fetchEscrow() async {
      fetchCall++;
      return fetchCall == 1 ? before : after;
    }

    final stream = HybridEventStream(
      contractId: 'CAAA',
      fetchEscrow: fetchEscrow,
      sorobanEvents: source,
      horizonEffects: _FakeHorizonEffectsSource(controller),
      minPollInterval: const Duration(milliseconds: 10),
      maxPollInterval: const Duration(milliseconds: 30),
      now: () => DateTime(2026, 4, 15),
    );

    final events = <EscrowEvent>[];
    final sub = stream.events.listen(events.add);
    await Future<void>.delayed(const Duration(milliseconds: 30));
    // Inject an SSE-style error on the effects stream.
    controller.addError(StateError('sse dropped'));
    await Future<void>.delayed(const Duration(milliseconds: 50));
    await sub.cancel();

    // After the SSE error the stream keeps emitting via reconciliation
    // (Funded detected from getEscrow diff).
    expect(events.whereType<Funded>(), isNotEmpty);
  });

  test('HybridEventStream public contract exposes Stream<EscrowEvent>',
      () {
    final stream = HybridEventStream(
      contractId: 'CAAA',
      fetchEscrow: () async => _escrow(),
      sorobanEvents: _FakeSorobanEventSource(const []),
      horizonEffects: _FakeHorizonEffectsSource(
        StreamController<EffectResponse>.broadcast(),
      ),
    );
    expect(stream.events, isA<Stream<EscrowEvent>>());
  });
}

class _FailingSorobanSource implements SorobanEventSource {
  @override
  Future<SorobanEventPage> fetch({
    required String contractId,
    String? cursor,
  }) async {
    throw StateError('rpc outage');
  }
}
