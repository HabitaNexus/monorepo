import 'package:freezed_annotation/freezed_annotation.dart';

part 'approve_milestone_payload.freezed.dart';
part 'approve_milestone_payload.g.dart';

/// Request body for `POST /escrow/single-release/approve-milestone`.
///
/// Invoked by the approver to accept a milestone that the service
/// provider previously marked complete. Once all milestones are
/// approved the contract's `approved` flag flips true and
/// `releaseFunds` becomes callable.
///
/// `milestoneIndex` is a string to match the TW OpenAPI schema.
@freezed
class ApproveMilestonePayload with _$ApproveMilestonePayload {
  const factory ApproveMilestonePayload({
    required String contractId,
    required String milestoneIndex,
    required String approver,
  }) = _ApproveMilestonePayload;

  factory ApproveMilestonePayload.fromJson(Map<String, dynamic> json) =>
      _$ApproveMilestonePayloadFromJson(json);
}
