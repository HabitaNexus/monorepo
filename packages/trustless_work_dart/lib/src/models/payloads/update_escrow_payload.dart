import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_escrow_payload.freezed.dart';
part 'update_escrow_payload.g.dart';

/// Request body for `PUT /escrow/single-release/update-escrow`.
///
/// Modifies an existing escrow before any of its milestones are approved.
/// The nested `escrow` payload is kept as a raw map (matching the pattern
/// used by [SingleReleaseContract]) because the TW `EscrowData` schema
/// includes several arrays (`roles`, `milestones`, `flags`, `trustline`)
/// whose shape differs subtly across API versions — pinning stronger
/// types here would invite unnecessary breaking changes. Callers build
/// the `escrow` map from the typed `Role`, `Milestone`, `Trustline`
/// models and pass `.toJson()`.
///
/// The optional top-level `isActive` flag, when present, overrides the
/// `isActive` nested inside `escrow`. See the TW OpenAPI spec for the
/// full `EscrowData` shape.
@Freezed(toJson: true)
class UpdateEscrowPayload with _$UpdateEscrowPayload {
  @JsonSerializable(includeIfNull: false)
  const factory UpdateEscrowPayload({
    required String signer,
    required String contractId,
    required Map<String, Object?> escrow,
    bool? isActive,
  }) = _UpdateEscrowPayload;

  factory UpdateEscrowPayload.fromJson(Map<String, dynamic> json) =>
      _$UpdateEscrowPayloadFromJson(json);
}
