import 'package:freezed_annotation/freezed_annotation.dart';

import 'flags.dart';
import 'multi_release_milestone.dart';
import 'role.dart';
import 'trustline.dart';

part 'multi_release_escrow.freezed.dart';
part 'multi_release_escrow.g.dart';

/// The canonical Trustless Work escrow entity for multi-release
/// contracts, as returned by the API gateway.
///
/// Differs from [Escrow] (single-release) in two ways:
///
/// 1. No top-level `amount` field. The total escrow amount is the sum of
///    `milestones[].amount`.
/// 2. `milestones` are [MultiReleaseMilestone] which track per-milestone
///    `approvedFlag` and `disputeStartedBy`.
///
/// Reuses [Role], [Trustline], and [Flags] which are identical to the
/// single-release shape.
@freezed
class MultiReleaseEscrow with _$MultiReleaseEscrow {
  const factory MultiReleaseEscrow({
    required String contractId,
    required String engagementId,
    required String title,
    required String description,
    required double platformFee,
    required int receiverMemo,
    required List<Role> roles,
    required List<MultiReleaseMilestone> milestones,
    required Trustline trustline,
    required Flags flags,
    required bool isActive,
  }) = _MultiReleaseEscrow;

  factory MultiReleaseEscrow.fromJson(Map<String, dynamic> json) =>
      _$MultiReleaseEscrowFromJson(json);
}
