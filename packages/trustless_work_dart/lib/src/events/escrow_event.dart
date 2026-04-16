/// Events emitted by `TrustlessWorkClient.escrowEvents`.
///
/// The shape is stable across SDK versions; only the implementation
/// strategy changes (polling in v0.1 → Horizon SSE + Soroban events in
/// v0.2).
sealed class EscrowEvent {
  const EscrowEvent({required this.contractId, required this.observedAt});

  final String contractId;
  final DateTime observedAt;

  const factory EscrowEvent.initialized({
    required String contractId,
    required DateTime observedAt,
  }) = Initialized;
  const factory EscrowEvent.funded({
    required String contractId,
    required DateTime observedAt,
    required String amount,
  }) = Funded;
  const factory EscrowEvent.milestoneStatusChanged({
    required String contractId,
    required DateTime observedAt,
    required int index,
    required String status,
  }) = MilestoneStatusChanged;
  const factory EscrowEvent.milestoneApproved({
    required String contractId,
    required DateTime observedAt,
    required int index,
  }) = MilestoneApproved;
  const factory EscrowEvent.released({
    required String contractId,
    required DateTime observedAt,
  }) = Released;
  const factory EscrowEvent.disputeStarted({
    required String contractId,
    required DateTime observedAt,
  }) = DisputeStarted;
  const factory EscrowEvent.disputeResolved({
    required String contractId,
    required DateTime observedAt,
    required double approverSplit,
  }) = DisputeResolved;
}

final class Initialized extends EscrowEvent {
  const Initialized({required super.contractId, required super.observedAt});
}

final class Funded extends EscrowEvent {
  const Funded({
    required super.contractId,
    required super.observedAt,
    required this.amount,
  });
  final String amount;
}

final class MilestoneStatusChanged extends EscrowEvent {
  const MilestoneStatusChanged({
    required super.contractId,
    required super.observedAt,
    required this.index,
    required this.status,
  });
  final int index;
  final String status;
}

final class MilestoneApproved extends EscrowEvent {
  const MilestoneApproved({
    required super.contractId,
    required super.observedAt,
    required this.index,
  });
  final int index;
}

final class Released extends EscrowEvent {
  const Released({required super.contractId, required super.observedAt});
}

final class DisputeStarted extends EscrowEvent {
  const DisputeStarted({required super.contractId, required super.observedAt});
}

final class DisputeResolved extends EscrowEvent {
  const DisputeResolved({
    required super.contractId,
    required super.observedAt,
    required this.approverSplit,
  });
  final double approverSplit;
}
