import 'package:freezed_annotation/freezed_annotation.dart';

part 'change_milestone_status_payload.freezed.dart';
part 'change_milestone_status_payload.g.dart';

/// Request body for `POST /escrow/single-release/change-milestone-status`.
///
/// Invoked by the service provider to report completion (or any other
/// free-form status change) of a milestone. The TW API treats
/// `milestoneIndex` as a string — matching the OpenAPI schema.
///
/// `newEvidence` is a free-form string describing the off-chain
/// evidence (URL, hash, textual description) the service provider
/// attaches to the status change. It is persisted on-chain by TW.
@freezed
class ChangeMilestoneStatusPayload with _$ChangeMilestoneStatusPayload {
  const factory ChangeMilestoneStatusPayload({
    required String contractId,
    required String milestoneIndex,
    required String newEvidence,
    required String newStatus,
    required String serviceProvider,
  }) = _ChangeMilestoneStatusPayload;

  factory ChangeMilestoneStatusPayload.fromJson(Map<String, dynamic> json) =>
      _$ChangeMilestoneStatusPayloadFromJson(json);
}
