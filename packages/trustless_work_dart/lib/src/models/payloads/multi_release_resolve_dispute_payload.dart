import 'package:freezed_annotation/freezed_annotation.dart';

import 'resolve_dispute_payload.dart' show DisputeDistribution;

part 'multi_release_resolve_dispute_payload.freezed.dart';
part 'multi_release_resolve_dispute_payload.g.dart';

/// Request body for `POST /escrow/multi-release/resolve-milestone-dispute`.
///
/// Executes the USDC split for a single milestone after an external
/// arbiter has decided how that milestone's portion should be
/// distributed. Other milestones remain untouched.
///
/// Reuses [DisputeDistribution] from the single-release payload because
/// the per-entry shape (`address`, `amount`) is identical across
/// flavors. [distributions] must sum to the remaining milestone balance
/// after platform fees.
///
/// IMPORTANT — architectural boundary: the SDK does NOT decide the
/// split. The `distributions` list must come from an off-chain arbiter
/// in the HabitaNexus backend `contract-core` module (see
/// `business/spikes/06-contract-core-megaprompt.md` §7 and §12). The SDK
/// submits whatever split the `disputeResolver` key signs.
@freezed
class MultiReleaseResolveDisputePayload
    with _$MultiReleaseResolveDisputePayload {
  const factory MultiReleaseResolveDisputePayload({
    required String contractId,
    required String disputeResolver,
    required String milestoneIndex,
    required List<DisputeDistribution> distributions,
  }) = _MultiReleaseResolveDisputePayload;

  factory MultiReleaseResolveDisputePayload.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$MultiReleaseResolveDisputePayloadFromJson(json);
}
