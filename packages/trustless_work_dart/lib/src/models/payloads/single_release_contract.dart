import 'package:freezed_annotation/freezed_annotation.dart';

part 'single_release_contract.freezed.dart';
part 'single_release_contract.g.dart';

/// Request body for `POST /deployer/single-release`.
///
/// Roles/milestones/trustline are kept as raw JSON maps because their
/// exact shape differs subtly across API versions — pinning stronger
/// types here would invite unnecessary breaking changes. Callers build
/// them from the typed `Role`, `Milestone`, `Trustline` models and pass
/// `.toJson()`.
@freezed
class SingleReleaseContract with _$SingleReleaseContract {
  const factory SingleReleaseContract({
    required String signer,
    required String engagementId,
    required String title,
    required String description,
    required int amount,
    required double platformFee,
    required List<Map<String, Object?>> roles,
    required List<Map<String, Object?>> milestones,
    required List<Map<String, Object?>> trustline,
  }) = _SingleReleaseContract;

  factory SingleReleaseContract.fromJson(Map<String, dynamic> json) =>
      _$SingleReleaseContractFromJson(json);
}
