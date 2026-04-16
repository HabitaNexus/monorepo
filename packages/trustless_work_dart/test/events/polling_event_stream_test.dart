import 'package:test/test.dart';
import 'package:trustless_work_dart/src/events/escrow_event.dart';
import 'package:trustless_work_dart/src/events/polling_event_stream.dart';
import 'package:trustless_work_dart/src/models/escrow.dart';
import 'package:trustless_work_dart/src/models/flags.dart';
import 'package:trustless_work_dart/src/models/trustline.dart';

Escrow _buildEscrow({required Flags flags, required int amount}) => Escrow(
      contractId: 'CAAA',
      engagementId: 'e',
      title: 't',
      description: 'd',
      amount: amount,
      platformFee: 0,
      receiverMemo: 0,
      roles: const [],
      milestones: const [],
      trustline: const Trustline(address: 'C', name: 'USDC', decimals: 7),
      flags: flags,
      isActive: true,
    );

void main() {
  test('emits Funded and Released as state transitions occur', () async {
    final snapshots = [
      _buildEscrow(flags: const Flags(), amount: 0),
      _buildEscrow(flags: const Flags(), amount: 500),
      _buildEscrow(flags: const Flags(released: true), amount: 500),
    ];
    var idx = 0;

    final stream = PollingEventStream(
      contractId: 'CAAA',
      pollInterval: const Duration(milliseconds: 10),
      fetch: () async {
        final i = idx < snapshots.length - 1 ? idx++ : snapshots.length - 1;
        return snapshots[i];
      },
      now: () => DateTime(2026, 4, 15),
    );

    final events = <EscrowEvent>[];
    final sub = stream.events.listen(events.add);
    await Future<void>.delayed(const Duration(milliseconds: 60));
    await sub.cancel();

    expect(events.whereType<Funded>(), isNotEmpty);
    expect(events.whereType<Released>(), isNotEmpty);
  });
}
