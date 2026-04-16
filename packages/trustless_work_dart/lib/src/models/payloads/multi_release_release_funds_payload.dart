import 'package:freezed_annotation/freezed_annotation.dart';

part 'multi_release_release_funds_payload.freezed.dart';
part 'multi_release_release_funds_payload.g.dart';

/// Request body for `POST /escrow/multi-release/release-milestone-funds`.
///
/// Releases the portion of the escrow balance tied to a single
/// milestone. The target milestone must be marked `Completed` and its
/// `approvedFlag` must be true. `milestoneIndex` is a string to match
/// the TW OpenAPI schema (see component `ReleaseMilestoneFunds`).
@freezed
class MultiReleaseReleaseFundsPayload with _$MultiReleaseReleaseFundsPayload {
  const factory MultiReleaseReleaseFundsPayload({
    required String contractId,
    required String releaseSigner,
    required String milestoneIndex,
  }) = _MultiReleaseReleaseFundsPayload;

  factory MultiReleaseReleaseFundsPayload.fromJson(Map<String, dynamic> json) =>
      _$MultiReleaseReleaseFundsPayloadFromJson(json);
}
