import 'package:freezed_annotation/freezed_annotation.dart';

part 'resolve_dispute_payload.freezed.dart';
part 'resolve_dispute_payload.g.dart';

/// A single entry in a [ResolveDisputePayload.distributions] list.
///
/// [amount] is a [num] so callers may pass either `int` (stroops /
/// smallest-denomination units) or `double` (platform-fee-adjusted
/// human-readable amount) — the TW OpenAPI declares it as `number`.
/// If precision loss is observed in round-trip tests, callers should
/// switch the `amount` to String via a custom converter; see the
/// discussion in HAB-58.
@freezed
class DisputeDistribution with _$DisputeDistribution {
  const factory DisputeDistribution({
    required String address,
    required num amount,
  }) = _DisputeDistribution;

  factory DisputeDistribution.fromJson(Map<String, dynamic> json) =>
      _$DisputeDistributionFromJson(json);
}

/// Request body for `POST /escrow/single-release/resolve-dispute`.
///
/// Executes the USDC split between parties after an external arbiter
/// has decided the outcome. The [distributions] list must sum to the
/// remaining escrow balance after platform fees.
///
/// IMPORTANT — architectural boundary: the SDK does NOT decide how
/// much each party gets. That decision is made off-chain by the
/// HabitaNexus backend `contract-core` module (MEDIATION -> ARBITRATION
/// -> JUDICIAL_ESCALATED pipeline; see
/// `business/spikes/06-contract-core-megaprompt.md` sections 7 and
/// 12). The SDK simply executes whatever split the arbiter supplied,
/// as signed by the `disputeResolver` key configured on the escrow.
@freezed
class ResolveDisputePayload with _$ResolveDisputePayload {
  const factory ResolveDisputePayload({
    required String contractId,
    required String disputeResolver,
    required List<DisputeDistribution> distributions,
  }) = _ResolveDisputePayload;

  factory ResolveDisputePayload.fromJson(Map<String, dynamic> json) =>
      _$ResolveDisputePayloadFromJson(json);
}
