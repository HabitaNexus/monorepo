import 'package:freezed_annotation/freezed_annotation.dart';

part 'fund_escrow_payload.freezed.dart';
part 'fund_escrow_payload.g.dart';

/// Request body for `POST /escrow/single-release/fund-escrow`.
///
/// `amount` is intentionally a string because the API accepts arbitrary
/// precision decimals that must not be truncated by IEEE-754.
@freezed
class FundEscrowPayload with _$FundEscrowPayload {
  const factory FundEscrowPayload({
    required String contractId,
    required String signer,
    required String amount,
  }) = _FundEscrowPayload;

  factory FundEscrowPayload.fromJson(Map<String, dynamic> json) =>
      _$FundEscrowPayloadFromJson(json);
}
