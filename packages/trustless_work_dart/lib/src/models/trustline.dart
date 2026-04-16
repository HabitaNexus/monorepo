import 'package:freezed_annotation/freezed_annotation.dart';

part 'trustline.freezed.dart';
part 'trustline.g.dart';

/// Stellar trustline describing which asset flows through the escrow.
///
/// `address` is the issuer contract id (Soroban asset) or Stellar asset
/// address. `name` is a human-readable ticker like "USDC".
@freezed
class Trustline with _$Trustline {
  const factory Trustline({
    required String address,
    required String name,
    required int decimals,
  }) = _Trustline;

  factory Trustline.fromJson(Map<String, dynamic> json) =>
      _$TrustlineFromJson(json);
}
