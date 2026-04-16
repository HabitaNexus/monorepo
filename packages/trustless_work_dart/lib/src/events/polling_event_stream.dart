import 'dart:async';
import 'package:meta/meta.dart';
import '../models/escrow.dart';
import 'escrow_event.dart';

/// Polling-based implementation of `Stream<EscrowEvent>` for v0.1.
///
/// Periodically calls `fetch` (wired by the client to `getEscrow`),
/// diffs the snapshot against the previous one, and emits typed events
/// for state transitions (fund amount change, milestone status, dispute
/// flags, release).
///
/// This is a stop-gap. v0.2 will replace the implementation with a
/// hybrid Horizon SSE + Soroban `getEvents` pipeline while keeping the
/// public `Stream<EscrowEvent>` shape identical.
@experimental
class PollingEventStream {
  PollingEventStream({
    required String contractId,
    required Future<Escrow> Function() fetch,
    DateTime Function()? now,
    Duration pollInterval = const Duration(seconds: 15),
  })  : _contractId = contractId,
        _fetch = fetch,
        _now = now ?? DateTime.now,
        _pollInterval = pollInterval;

  final String _contractId;
  final Future<Escrow> Function() _fetch;
  final DateTime Function() _now;
  final Duration _pollInterval;

  late final StreamController<EscrowEvent> _controller =
      StreamController<EscrowEvent>.broadcast(
    onListen: _start,
    onCancel: _stop,
  );

  Timer? _timer;
  Escrow? _previous;

  Stream<EscrowEvent> get events => _controller.stream;

  void _start() {
    _timer ??= Timer.periodic(_pollInterval, (_) => _tick());
    unawaited(_tick());
  }

  void _stop() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _tick() async {
    try {
      final current = await _fetch();
      final previous = _previous;
      if (previous == null) {
        _controller.add(EscrowEvent.initialized(
          contractId: _contractId,
          observedAt: _now(),
        ));
      } else {
        _diffAndEmit(previous: previous, current: current);
      }
      _previous = current;
    } catch (error, stack) {
      _controller.addError(error, stack);
    }
  }

  void _diffAndEmit({required Escrow previous, required Escrow current}) {
    if (previous.amount != current.amount && current.amount > 0) {
      _controller.add(EscrowEvent.funded(
        contractId: _contractId,
        observedAt: _now(),
        amount: current.amount.toString(),
      ));
    }
    if (!previous.flags.released && current.flags.released) {
      _controller.add(EscrowEvent.released(
        contractId: _contractId,
        observedAt: _now(),
      ));
    }
    if (!previous.flags.disputed && current.flags.disputed) {
      _controller.add(EscrowEvent.disputeStarted(
        contractId: _contractId,
        observedAt: _now(),
      ));
    }
    for (var i = 0;
        i < current.milestones.length && i < previous.milestones.length;
        i++) {
      final before = previous.milestones[i];
      final after = current.milestones[i];
      if (before.status != after.status) {
        _controller.add(EscrowEvent.milestoneStatusChanged(
          contractId: _contractId,
          observedAt: _now(),
          index: i,
          status: after.status,
        ));
      }
      if (!before.approvedFlag && after.approvedFlag) {
        _controller.add(EscrowEvent.milestoneApproved(
          contractId: _contractId,
          observedAt: _now(),
          index: i,
        ));
      }
    }
  }
}
