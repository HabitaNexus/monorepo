import 'package:freezed_annotation/freezed_annotation.dart';
import 'flags.dart';
import 'milestone.dart';
import 'role.dart';
import 'trustline.dart';

part 'escrow.freezed.dart';
part 'escrow.g.dart';

/// The canonical Trustless Work escrow entity, as returned by the API
/// gateway.
///
/// Mirrors the fields documented at
/// https://docs.trustlesswork.com/trustless-work/api-reference. Amount is
/// an int because Trustless Work tracks amounts as integer units of the
/// trustline's smallest denomination (e.g. 1e7 per USDC).
@freezed
class Escrow with _$Escrow {
  const factory Escrow({
    required String contractId,
    required String engagementId,
    required String title,
    required String description,
    required int amount,
    required double platformFee,
    required int receiverMemo,
    required List<Role> roles,
    required List<Milestone> milestones,
    required Trustline trustline,
    required Flags flags,
    required bool isActive,
  }) = _Escrow;

  factory Escrow.fromJson(Map<String, dynamic> json) => _$EscrowFromJson(json);
}
