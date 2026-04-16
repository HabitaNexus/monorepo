import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_escrows_from_indexer_response.freezed.dart';
part 'get_escrows_from_indexer_response.g.dart';

/// Response wrapper for the three indexer query endpoints:
///
/// * `GET /helper/get-escrows-by-role`
/// * `GET /helper/get-escrows-by-signer`
/// * `GET /helper/get-escrow-by-contract-ids`
///
/// The gateway returns a **raw JSON array** (no top-level `status` or
/// `data` envelope). This wrapper normalises it into a strongly-typed
/// list so callers can pattern-match on `response.escrows` uniformly.
///
/// The shape intentionally diverges from [Escrow] / [MultiReleaseEscrow]:
///
/// * `roles` is returned as an **object** keyed by role name (not a
///   `List<Role>` of `{name, address}` pairs).
/// * Timestamps use the Firestore shape
///   `{_seconds: int, _nanoseconds: int}` instead of ISO 8601 strings.
/// * Milestones nest their own `flags` object (`approved`, `disputed`,
///   `released`, `resolved`) — the single-release `Milestone` model has
///   none of these at the milestone level.
/// * Escrow-level `flags` include `resolved` (not in [Flags]).
///
/// Rather than bend the existing gateway-post-mutation models to fit
/// the indexer shape, HAB-61 introduces [IndexerEscrow] et al. as a
/// parallel read-only type tree. See HAB-61 prompt §"Consolidation
/// opportunity" and the decision log in the package's PR description.
@freezed
class GetEscrowsFromIndexerResponse with _$GetEscrowsFromIndexerResponse {
  const factory GetEscrowsFromIndexerResponse({
    required List<IndexerEscrow> escrows,
  }) = _GetEscrowsFromIndexerResponse;

  factory GetEscrowsFromIndexerResponse.fromJson(Map<String, dynamic> json) =>
      _$GetEscrowsFromIndexerResponseFromJson(json);

  /// Decodes the raw array the indexer actually returns into a wrapper.
  factory GetEscrowsFromIndexerResponse.fromList(
    List<dynamic> raw,
  ) {
    return GetEscrowsFromIndexerResponse(
      escrows: raw
          .cast<Map<String, dynamic>>()
          .map(IndexerEscrow.fromJson)
          .toList(growable: false),
    );
  }
}

extension GetEscrowsFromIndexerResponseEncoding
    on GetEscrowsFromIndexerResponse {
  /// Encodes the wrapper back to the raw array shape the indexer speaks.
  ///
  /// The freezed-generated `toJson` emits `{"escrows": [...]}` which is
  /// handy for logs but does NOT match what the gateway returned.
  /// `toList()` is the lossless inverse of [GetEscrowsFromIndexerResponse.fromList].
  List<Map<String, dynamic>> toList() =>
      escrows.map((e) => e.toJson()).toList(growable: false);
}

/// Per-escrow row as returned by the indexer.
///
/// Optional fields (`fundedBy`, `approverFunds`, `receiverFunds`, `user`,
/// `disputeStartedBy`) are not in the published OpenAPI schema but are
/// listed in HAB-61's scope as pass-through metadata. They are modelled
/// as nullable so the decoder tolerates both forms — present or absent.
@freezed
class IndexerEscrow with _$IndexerEscrow {
  const factory IndexerEscrow({
    required String contractId,
    required String engagementId,
    required String title,
    required String description,
    required double platformFee,
    required int receiverMemo,
    required IndexerEscrowRoles roles,
    required List<IndexerMilestone> milestones,
    required IndexerTrustline trustline,
    required IndexerEscrowFlags flags,
    required bool isActive,
    String? signer,
    String? type,
    num? balance,
    IndexerTimestamp? createdAt,
    IndexerTimestamp? updatedAt,
    // Optional indexer-surfaced metadata called out in HAB-61. These are
    // not present in the OpenAPI example but the prompt explicitly lists
    // them, so we model them as nullable pass-through fields.
    String? fundedBy,
    num? approverFunds,
    num? receiverFunds,
    String? user,
    String? disputeStartedBy,
  }) = _IndexerEscrow;

  factory IndexerEscrow.fromJson(Map<String, dynamic> json) =>
      _$IndexerEscrowFromJson(json);
}

/// Indexer roles are returned as an object keyed by role name (unlike
/// [Role] which is a `{name, address}` pair inside a `List<Role>`).
///
/// All fields are optional because not every escrow surfaces every
/// role (e.g. some contracts don't name an `issuer` explicitly).
@freezed
class IndexerEscrowRoles with _$IndexerEscrowRoles {
  const factory IndexerEscrowRoles({
    String? approver,
    String? serviceProvider,
    String? platformAddress,
    String? releaseSigner,
    String? disputeResolver,
    String? receiver,
    String? issuer,
  }) = _IndexerEscrowRoles;

  factory IndexerEscrowRoles.fromJson(Map<String, dynamic> json) =>
      _$IndexerEscrowRolesFromJson(json);
}

/// Milestone shape as returned by the indexer.
///
/// Carries its own nested [IndexerMilestoneFlags] object — the local
/// `Milestone` and `MultiReleaseMilestone` models flatten approval into
/// a single `approvedFlag` boolean, which is NOT what the indexer
/// returns.
@freezed
class IndexerMilestone with _$IndexerMilestone {
  const factory IndexerMilestone({
    required String description,
    @Default('pending') String status,
    required IndexerMilestoneFlags flags,
    num? amount,
    String? evidence,
    String? receiver,
  }) = _IndexerMilestone;

  factory IndexerMilestone.fromJson(Map<String, dynamic> json) =>
      _$IndexerMilestoneFromJson(json);
}

@freezed
class IndexerMilestoneFlags with _$IndexerMilestoneFlags {
  const factory IndexerMilestoneFlags({
    @Default(false) bool approved,
    @Default(false) bool disputed,
    @Default(false) bool released,
    @Default(false) bool resolved,
  }) = _IndexerMilestoneFlags;

  factory IndexerMilestoneFlags.fromJson(Map<String, dynamic> json) =>
      _$IndexerMilestoneFlagsFromJson(json);
}

/// Top-level escrow flags as returned by the indexer.
///
/// Note the extra `resolved` field vs [Flags]. `approved` is NOT part
/// of the indexer's top-level flags — approval in multi-release lives
/// per-milestone; in single-release the indexer collapses it into the
/// milestone flags instead.
@freezed
class IndexerEscrowFlags with _$IndexerEscrowFlags {
  const factory IndexerEscrowFlags({
    @Default(false) bool disputed,
    @Default(false) bool released,
    @Default(false) bool resolved,
  }) = _IndexerEscrowFlags;

  factory IndexerEscrowFlags.fromJson(Map<String, dynamic> json) =>
      _$IndexerEscrowFlagsFromJson(json);
}

@freezed
class IndexerTrustline with _$IndexerTrustline {
  const factory IndexerTrustline({
    required String address,
    required String name,
  }) = _IndexerTrustline;

  factory IndexerTrustline.fromJson(Map<String, dynamic> json) =>
      _$IndexerTrustlineFromJson(json);
}

/// Firestore timestamp shape `{_seconds, _nanoseconds}`.
///
/// Property name prefix (`_seconds`) is preserved via [JsonKey] so the
/// decoder accepts the raw payload without a pre-processing step.
@freezed
class IndexerTimestamp with _$IndexerTimestamp {
  const factory IndexerTimestamp({
    @JsonKey(name: '_seconds') required int seconds,
    @JsonKey(name: '_nanoseconds') required int nanoseconds,
  }) = _IndexerTimestamp;

  factory IndexerTimestamp.fromJson(Map<String, dynamic> json) =>
      _$IndexerTimestampFromJson(json);
}
