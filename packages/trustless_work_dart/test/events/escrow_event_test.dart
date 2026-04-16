import 'package:test/test.dart';
import 'package:trustless_work_dart/src/events/escrow_event.dart';

void main() {
  test('exhaustive switch covers all 7 variants', () {
    final all = <EscrowEvent>[
      EscrowEvent.initialized(contractId: 'c', observedAt: DateTime(2026)),
      EscrowEvent.funded(contractId: 'c', observedAt: DateTime(2026), amount: '100'),
      EscrowEvent.milestoneStatusChanged(
        contractId: 'c',
        observedAt: DateTime(2026),
        index: 0,
        status: 'delivered',
      ),
      EscrowEvent.milestoneApproved(
        contractId: 'c',
        observedAt: DateTime(2026),
        index: 0,
      ),
      EscrowEvent.released(contractId: 'c', observedAt: DateTime(2026)),
      EscrowEvent.disputeStarted(contractId: 'c', observedAt: DateTime(2026)),
      EscrowEvent.disputeResolved(
        contractId: 'c',
        observedAt: DateTime(2026),
        approverSplit: 0.7,
      ),
    ];

    for (final ev in all) {
      final label = switch (ev) {
        Initialized() => 'initialized',
        Funded() => 'funded',
        MilestoneStatusChanged() => 'milestoneStatusChanged',
        MilestoneApproved() => 'milestoneApproved',
        Released() => 'released',
        DisputeStarted() => 'disputeStarted',
        DisputeResolved() => 'disputeResolved',
      };
      expect(label, isNotEmpty);
    }
  });
}
