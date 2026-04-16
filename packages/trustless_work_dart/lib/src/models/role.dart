import 'package:freezed_annotation/freezed_annotation.dart';

part 'role.freezed.dart';
part 'role.g.dart';

/// A named party in the escrow and its Stellar public key.
///
/// The Trustless Work contract defines fixed role names: `approver`,
/// `serviceProvider`, `releaseSigner`, `disputeResolver`, `platformAddress`,
/// `receiver`. Unknown names are rejected by the API.
@freezed
class Role with _$Role {
  const factory Role({
    required String name,
    required String address,
  }) = _Role;

  factory Role.fromJson(Map<String, dynamic> json) => _$RoleFromJson(json);
}
