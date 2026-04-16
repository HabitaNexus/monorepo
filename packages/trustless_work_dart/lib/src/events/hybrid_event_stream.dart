import 'dart:async';

import 'package:stellar_flutter_sdk/stellar_flutter_sdk.dart';

import '../models/escrow.dart';
import 'escrow_event.dart';
import 'soroban_event_decoder.dart';

/// One page of Soroban contract events plus the cursor to resume from.
class SorobanEventPage {
  const SorobanEventPage({required this.events, required this.cursor});
  final List<EventInfo> events;
  final String? cursor;
}

/// Abstracts `SorobanServer.getEvents` so tests can swap a fake in.
///
/// Implementations must be idempotent given the same cursor — if the
/// RPC node returns the same ledger range twice, the hybrid stream's
/// dedupe-by-id keeps the public stream clean.
abstract class SorobanEventSource {
  Future<SorobanEventPage> fetch({
    required String contractId,
    String? cursor,
  });
}

/// Abstracts Horizon's `EffectsRequestBuilder.stream()` so tests can
/// inject a controller-backed stream without touching the network.
abstract class HorizonEffectsSource {
  Stream<EffectResponse> streamForContractAccount(String contractAccount);
}

/// Hybrid Horizon-SSE + Soroban-`getEvents` implementation of the
/// public `Stream<EscrowEvent>` contract, replacing the v0.1
/// `PollingEventStream`.
///
/// Pipeline (all three feeds merged into one broadcast stream):
///   1. Horizon SSE account effects — detects classic-layer credits /
///      debits that touch the escrow account. Primarily useful when
///      callers want a push signal that "money moved" before the
///      Soroban events catch up.
///   2. Soroban `getEvents` with cursor pagination — the source of
///      truth for `tw_*` contract events. Interval adapts between
///      `minPollInterval` (default 2s) and `maxPollInterval` (default
///      30s) depending on recent activity (exponential backoff during
///      quiet periods, reset on any event received).
///   3. `getEscrow` + snapshot diff — fallback used whenever the
///      decoder cannot produce a fully-populated `EscrowEvent`
///      (missing milestone index on `tw_ms_*`, any decode failure, or
///      any error from the Soroban source). This keeps the stream
///      eventually-consistent even if both push sources blow up.
///
/// iOS background handling
/// ------------------------
/// This class lives in the pure-Dart `trustless_work_dart` core and
/// intentionally has no Flutter dependency. Mobile consumers that
/// want to pause/resume the stream across app lifecycle transitions
/// should:
///
/// 1. Subscribe to `WidgetsBindingObserver.didChangeAppLifecycleState`
///    in their Flutter companion layer, and
/// 2. Call `resumeFromBackground()` whenever the app moves back to
///    `AppLifecycleState.resumed`. That forces an immediate
///    reconciliation tick (`getEscrow` + diff) so any events missed
///    while the socket was idle are recovered.
///
/// The stream itself already handles SSE disconnects and RPC errors
/// gracefully — it swallows the exception and falls back to a
/// reconciliation tick. `resumeFromBackground()` is a puntual hint
/// that lets the consumer skip the adaptive delay and reconcile now.
class HybridEventStream {
  HybridEventStream({
    required String contractId,
    required Future<Escrow> Function() fetchEscrow,
    required SorobanEventSource sorobanEvents,
    required HorizonEffectsSource horizonEffects,
    String? contractAccountId,
    SorobanEventDecoder decoder = const SorobanEventDecoder(),
    Duration minPollInterval = const Duration(seconds: 2),
    Duration maxPollInterval = const Duration(seconds: 30),
    DateTime Function()? now,
  })  : _contractId = contractId,
        _fetchEscrow = fetchEscrow,
        _sorobanEvents = sorobanEvents,
        _horizonEffects = horizonEffects,
        _contractAccountId = contractAccountId ?? contractId,
        _decoder = decoder,
        _minPollInterval = minPollInterval,
        _maxPollInterval = maxPollInterval,
        _now = now ?? DateTime.now;

  final String _contractId;
  final Future<Escrow> Function() _fetchEscrow;
  final SorobanEventSource _sorobanEvents;
  final HorizonEffectsSource _horizonEffects;
  final String _contractAccountId;
  final SorobanEventDecoder _decoder;
  final Duration _minPollInterval;
  final Duration _maxPollInterval;
  final DateTime Function() _now;

  late final StreamController<EscrowEvent> _controller =
      StreamController<EscrowEvent>.broadcast(
    onListen: _start,
    onCancel: _stop,
  );

  /// Dedupe set — ids of Soroban events we have already emitted. The
  /// RPC `getEvents` call is not strictly idempotent across cursor
  /// rewinds, so we keep the last `~256` ids to drop repeats.
  final _seenEventIds = <String>{};
  static const _maxSeenEvents = 256;

  Timer? _sorobanTimer;
  StreamSubscription<EffectResponse>? _horizonSub;
  String? _cursor;
  Escrow? _previous;
  Duration _currentInterval = const Duration(milliseconds: 1);
  bool _running = false;
  bool _initializedEmitted = false;

  /// Public shape — this is what consumers subscribe to. Matches the
  /// v0.1 polling stream so swapping implementations is transparent
  /// to callers.
  Stream<EscrowEvent> get events => _controller.stream;

  /// Puntual hint from a Flutter companion layer that the app just
  /// resumed from background. Forces an immediate `getEscrow`
  /// reconciliation (catching any events missed while the SSE socket
  /// was idle) plus a Soroban poll.
  void resumeFromBackground() {
    if (!_running) return;
    _currentInterval = _minPollInterval;
    unawaited(_reconcile().then((_) {
      if (_running) unawaited(_tickSoroban());
    }));
  }

  void _start() {
    if (_running) return;
    _running = true;
    _currentInterval = _minPollInterval;
    _subscribeHorizon();
    // Establish a baseline snapshot up-front. Subsequent decoder
    // failures will diff against this snapshot to recover missing
    // context (milestone indices, dispute resolution flag flip, etc.).
    unawaited(_reconcile().then((_) {
      if (_running) _scheduleSorobanTick(immediate: true);
    }));
  }

  void _stop() {
    _running = false;
    _sorobanTimer?.cancel();
    _sorobanTimer = null;
    _horizonSub?.cancel();
    _horizonSub = null;
  }

  void _subscribeHorizon() {
    try {
      final s = _horizonEffects.streamForContractAccount(_contractAccountId);
      _horizonSub = s.listen(
        _onEffect,
        onError: (Object _) {
          // Horizon SSE blew up — rely on Soroban + reconciliation.
          unawaited(_reconcile());
        },
        cancelOnError: false,
      );
    } catch (_) {
      // Host environment without SSE support — no-op.
    }
  }

  void _onEffect(EffectResponse effect) {
    // Classic-layer detection is conservative — we only use effects as
    // a wake-up hint. The Soroban decoder is the source of truth for
    // event shapes, so on any classic effect we bump the poll
    // interval down so the next tick fires sooner.
    _currentInterval = _minPollInterval;
  }

  void _scheduleSorobanTick({bool immediate = false}) {
    if (!_running) return;
    _sorobanTimer?.cancel();
    _sorobanTimer = Timer(
      immediate ? const Duration(milliseconds: 1) : _currentInterval,
      () {
        unawaited(_tickSoroban());
      },
    );
  }

  Future<void> _tickSoroban() async {
    if (!_running) return;
    var sawActivity = false;
    try {
      final page = await _sorobanEvents.fetch(
        contractId: _contractId,
        cursor: _cursor,
      );
      if (page.cursor != null) _cursor = page.cursor;
      for (final event in page.events) {
        if (!_seenEventIds.add(event.id)) continue;
        _trimSeen();
        sawActivity = true;
        final decoded =
            _decoder.decode(event: event, contractId: _contractId);
        if (decoded != null) {
          if (decoded is Initialized) {
            if (_initializedEmitted) continue;
            _initializedEmitted = true;
          }
          _controller.add(decoded);
        } else {
          // Decoder signalled "need more context" — re-fetch + diff.
          await _reconcile();
        }
      }
    } catch (_) {
      // Soroban source failed (cursor invalid, RPC outage, etc.) —
      // fall back to a reconciliation tick so we never silently drop
      // events.
      await _reconcile();
    } finally {
      if (_running) {
        _currentInterval = sawActivity
            ? _minPollInterval
            : _nextBackoff(_currentInterval);
        _scheduleSorobanTick();
      }
    }
  }

  Duration _nextBackoff(Duration current) {
    final doubled = current * 2;
    if (doubled >= _maxPollInterval) return _maxPollInterval;
    if (doubled < _minPollInterval) return _minPollInterval;
    return doubled;
  }

  /// Fetch the escrow and emit events for every state transition
  /// relative to `_previous`. This is the same algorithm the v0.1
  /// polling stream used; it is invoked here whenever we can't fully
  /// decode a Soroban event or the push source errored.
  Future<void> _reconcile() async {
    try {
      final current = await _fetchEscrow();
      final previous = _previous;
      if (previous == null) {
        if (!_initializedEmitted) {
          _initializedEmitted = true;
          _controller.add(
            EscrowEvent.initialized(
              contractId: _contractId,
              observedAt: _now(),
            ),
          );
        }
      } else {
        _emitDiff(previous: previous, current: current);
      }
      _previous = current;
    } catch (error, stack) {
      _controller.addError(error, stack);
    }
  }

  void _emitDiff({required Escrow previous, required Escrow current}) {
    if (previous.amount != current.amount && current.amount > 0) {
      _controller.add(
        EscrowEvent.funded(
          contractId: _contractId,
          observedAt: _now(),
          amount: current.amount.toString(),
        ),
      );
    }
    if (!previous.flags.released && current.flags.released) {
      _controller.add(
        EscrowEvent.released(
          contractId: _contractId,
          observedAt: _now(),
        ),
      );
    }
    if (!previous.flags.disputed && current.flags.disputed) {
      _controller.add(
        EscrowEvent.disputeStarted(
          contractId: _contractId,
          observedAt: _now(),
        ),
      );
    }
    // Dispute resolution — flag moved from disputed → resolved. We
    // cannot recover approverSplit from escrow state alone, so we
    // emit NaN (same sentinel as the Soroban decoder does for
    // tw_disp_resolve).
    if (previous.flags.disputed && !current.flags.disputed) {
      _controller.add(
        EscrowEvent.disputeResolved(
          contractId: _contractId,
          observedAt: _now(),
          approverSplit: double.nan,
        ),
      );
    }
    for (var i = 0;
        i < current.milestones.length && i < previous.milestones.length;
        i++) {
      final before = previous.milestones[i];
      final after = current.milestones[i];
      if (before.status != after.status) {
        _controller.add(
          EscrowEvent.milestoneStatusChanged(
            contractId: _contractId,
            observedAt: _now(),
            index: i,
            status: after.status,
          ),
        );
      }
      if (!before.approvedFlag && after.approvedFlag) {
        _controller.add(
          EscrowEvent.milestoneApproved(
            contractId: _contractId,
            observedAt: _now(),
            index: i,
          ),
        );
      }
    }
  }

  void _trimSeen() {
    if (_seenEventIds.length <= _maxSeenEvents) return;
    // Drop the oldest half. `_seenEventIds` is a Set so there is no
    // order guarantee, but the goal here is just to cap memory — the
    // dedupe window only needs to outlive the RPC's typical cursor
    // replay window.
    final toDrop = _seenEventIds.length - (_maxSeenEvents ~/ 2);
    final iter = _seenEventIds.iterator;
    for (var i = 0; i < toDrop && iter.moveNext(); i++) {
      _seenEventIds.remove(iter.current);
    }
  }
}
