import 'package:stellar_flutter_sdk/stellar_flutter_sdk.dart';

import 'escrow_event.dart';

/// Maps a Soroban `EventInfo` emitted by the Trustless Work escrow
/// contract into an `EscrowEvent`.
///
/// Topic catalog — mirrors
/// `contracts/escrow/src/events/handler.rs` at
/// github.com/Trustless-Work/Trustless-Work-Smart-Escrow:
///
/// | Topic              | Data format    | → EscrowEvent              |
/// | ------------------ | -------------- | -------------------------- |
/// | `tw_init`          | vec[Escrow]    | `Initialized`              |
/// | `tw_fund`          | vec[addr,i128] | `Funded(amount)`           |
/// | `tw_release`       | single Address | `Released`                 |
/// | `tw_dispute`       | vec[Escrow]    | `DisputeStarted`           |
/// | `tw_disp_resolve`  | vec[Escrow]    | `DisputeResolved(split)`   |
/// | `tw_ms_change`     | vec[Escrow]    | → null (needs diff)        |
/// | `tw_ms_approve`    | vec[Escrow]    | → null (needs diff)        |
/// | `tw_update`        | vec[...]       | → null (no variant)        |
/// | `tw_ttl_extend`    | vec[...]       | → null (out of scope)      |
///
/// Return semantics:
/// - `EscrowEvent` → caller emits as-is.
/// - `null` → caller must re-fetch the `Escrow` and diff against its
///   previous snapshot to recover the missing detail (the milestone
///   index for `tw_ms_*`, or the split for an unknown topic). This
///   matches the v0.1 polling-diff behaviour and is what the HAB-59
///   spec calls the "decoder-failure fallback".
///
/// The `approverSplit` field on `DisputeResolved` is emitted as
/// `double.nan` because the on-chain event payload is just the Escrow
/// struct (see handler.rs `DisputeResolved { escrow }`) and the
/// distribution Map that determines the split is a transaction
/// argument, not part of the emitted event. Resolving the accurate
/// split would require fetching the transaction envelope and
/// parsing `Map<Address, i128>` out of its invocation args; this
/// remains deferred to a v0.3 tx-args decoder.
class SorobanEventDecoder {
  const SorobanEventDecoder();

  EscrowEvent? decode({
    required EventInfo event,
    required String contractId,
  }) {
    final topic = _firstSymbolTopic(event.topic);
    if (topic == null) return null;

    final observedAt = _parseLedgerCloseAt(event.ledgerCloseAt);

    try {
      switch (topic) {
        case 'tw_init':
          return EscrowEvent.initialized(
            contractId: contractId,
            observedAt: observedAt,
          );
        case 'tw_fund':
          final amount = _fundedAmountFromVec(event.valueXdr);
          if (amount == null) return null;
          return EscrowEvent.funded(
            contractId: contractId,
            observedAt: observedAt,
            amount: amount,
          );
        case 'tw_release':
          return EscrowEvent.released(
            contractId: contractId,
            observedAt: observedAt,
          );
        case 'tw_dispute':
          return EscrowEvent.disputeStarted(
            contractId: contractId,
            observedAt: observedAt,
          );
        case 'tw_disp_resolve':
          return EscrowEvent.disputeResolved(
            contractId: contractId,
            observedAt: observedAt,
            approverSplit: double.nan,
          );
        case 'tw_ms_change':
        case 'tw_ms_approve':
          // Contract event only carries the full Escrow snapshot; the
          // HybridEventStream must re-fetch + diff to find which
          // milestone index changed.
          return null;
        default:
          return null;
      }
    } on FormatException {
      return null;
    } on StateError {
      return null;
    } on ArgumentError {
      return null;
    }
  }

  String? _firstSymbolTopic(List<String> topicSegments) {
    for (final segment in topicSegments) {
      try {
        final scv = XdrSCVal.fromBase64EncodedXdrString(segment);
        final sym = scv.sym;
        if (sym != null) return sym;
      } catch (_) {
        continue;
      }
    }
    return null;
  }

  /// Extracts the `amount: i128` second element of a `tw_fund` event
  /// payload `vec![signer: Address, amount: i128]`. Returns the amount
  /// as its decimal string representation (to match
  /// `Funded.amount: String` from HAB-56) or `null` on any shape
  /// mismatch.
  String? _fundedAmountFromVec(XdrSCVal value) {
    final vec = value.vec;
    if (vec == null || vec.length < 2) return null;
    final amountVal = vec[1];
    final i128 = amountVal.i128;
    if (i128 == null) return null;
    final hi = i128.hi.int64;
    final lo = i128.lo.uint64;
    final combined = (BigInt.from(hi) << 64) | BigInt.from(lo);
    return combined.toString();
  }

  DateTime _parseLedgerCloseAt(String raw) {
    // Soroban RPC returns ISO 8601 UTC strings; DateTime.parse covers
    // the common cases.
    return DateTime.parse(raw);
  }
}
