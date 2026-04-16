import 'package:freezed_annotation/freezed_annotation.dart';

import 'role.dart';

part 'multi_release_milestone.freezed.dart';
part 'multi_release_milestone.g.dart';

/// A single deliverable inside a multi-release escrow.
///
/// Unlike single-release milestones, each multi-release milestone carries:
///
/// - [amount]: the portion of the escrow balance that will be released
///   when this milestone is approved;
/// - [approvedFlag]: per-milestone approval state (single-release only
///   flips the contract-level `approved` flag once every milestone is
///   approved — multi-release flips this one flag and immediately allows
///   partial release);
/// - [disputeStartedBy]: optional reference to whichever role raised a
///   dispute on this specific milestone. Null while no dispute is open.
///
/// The API does NOT require callers to send `approvedFlag` or `status`
/// when deploying — see the TW `MultiReleaseContract` OpenAPI schema —
/// so the defaults here match the pre-deploy shape.
@freezed
class MultiReleaseMilestone with _$MultiReleaseMilestone {
  const factory MultiReleaseMilestone({
    required String description,
    required int amount,
    @Default('pending') String status,
    @Default(false) bool approvedFlag,
    String? evidence,
    Role? disputeStartedBy,
  }) = _MultiReleaseMilestone;

  factory MultiReleaseMilestone.fromJson(Map<String, dynamic> json) =>
      _$MultiReleaseMilestoneFromJson(json);
}
