import 'package:freezed_annotation/freezed_annotation.dart';

part 'multi_release_contract.freezed.dart';
part 'multi_release_contract.g.dart';

/// Request body for `POST /deployer/multi-release`.
///
/// Key difference with `SingleReleaseContract`: there is NO top-level
/// `amount`. The total escrow amount is implicit — it is the sum of
/// `milestones[].amount` that callers send in.
///
/// Roles/milestones/trustline are kept as raw JSON maps for the same
/// reason as in `SingleReleaseContract`: their exact shape differs
/// subtly across API versions, and pinning stronger types here would
/// invite unnecessary breaking changes. Callers typically build
/// milestones from [MultiReleaseMilestone] and pass `.toJson()`.
///
/// Per the TW OpenAPI description, the pre-deploy milestone shape does
/// NOT require `approvedFlag` / `status` — only `description` and
/// `amount` (plus optionally `evidence`, `receiver`). Sending the full
/// `MultiReleaseMilestone.toJson()` is accepted, but the extras are
/// ignored at deploy time.
@freezed
class MultiReleaseContract with _$MultiReleaseContract {
  const factory MultiReleaseContract({
    required String signer,
    required String engagementId,
    required String title,
    required String description,
    required double platformFee,
    required List<Map<String, Object?>> roles,
    required List<Map<String, Object?>> milestones,
    required List<Map<String, Object?>> trustline,
  }) = _MultiReleaseContract;

  factory MultiReleaseContract.fromJson(Map<String, dynamic> json) =>
      _$MultiReleaseContractFromJson(json);
}
