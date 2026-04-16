import 'package:freezed_annotation/freezed_annotation.dart';

part 'multi_release_start_dispute_payload.freezed.dart';
part 'multi_release_start_dispute_payload.g.dart';

/// Request body for `POST /escrow/multi-release/dispute-milestone`.
///
/// Flips the per-milestone `disputeStartedBy` field on-chain, freezing
/// just that milestone's portion of the escrow balance until a
/// `disputeResolver` calls `/escrow/multi-release/resolve-milestone-dispute`.
/// Other milestones remain releasable.
///
/// IMPORTANT — architectural boundary: this SDK exposes only the on-chain
/// primitive. The off-chain MEDIATION -> ARBITRATION -> JUDICIAL_ESCALATED
/// workflow lives in the HabitaNexus backend `contract-core` module —
/// see `business/spikes/06-contract-core-megaprompt.md` sections 7 and 12.
@freezed
class MultiReleaseStartDisputePayload with _$MultiReleaseStartDisputePayload {
  const factory MultiReleaseStartDisputePayload({
    required String contractId,
    required String milestoneIndex,
    required String signer,
  }) = _MultiReleaseStartDisputePayload;

  factory MultiReleaseStartDisputePayload.fromJson(Map<String, dynamic> json) =>
      _$MultiReleaseStartDisputePayloadFromJson(json);
}
