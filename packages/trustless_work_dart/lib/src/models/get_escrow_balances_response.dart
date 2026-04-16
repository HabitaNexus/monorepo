import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_escrow_balances_response.freezed.dart';
part 'get_escrow_balances_response.g.dart';

/// Response wrapper for the batch-balance helper endpoint:
///
///   * `GET /helper/get-multiple-escrow-balance`
///
/// The gateway returns a **raw JSON array** (no top-level envelope) of
/// `{address, balance}` entries — verified against
/// `https://api.trustlesswork.com/docs-json` on 2026-04-15. The wrapper
/// normalises it into a strongly-typed list so callers can pattern-match
/// on `response.balances` uniformly with the rest of the SDK.
///
/// `balance` is modelled as `num` (not `int`) because the OpenAPI schema
/// only pins down `"type": "number"` and the typical unit is USDC in
/// human-readable form — fractional values are expected once the gateway
/// starts returning sub-unit precision.
@freezed
class GetEscrowBalancesResponse with _$GetEscrowBalancesResponse {
  const factory GetEscrowBalancesResponse({
    required List<EscrowBalanceEntry> balances,
  }) = _GetEscrowBalancesResponse;

  factory GetEscrowBalancesResponse.fromJson(Map<String, dynamic> json) =>
      _$GetEscrowBalancesResponseFromJson(json);

  /// Decodes the raw array the helper actually returns into a wrapper.
  factory GetEscrowBalancesResponse.fromList(List<dynamic> raw) {
    return GetEscrowBalancesResponse(
      balances: raw
          .cast<Map<String, dynamic>>()
          .map(EscrowBalanceEntry.fromJson)
          .toList(growable: false),
    );
  }
}

extension GetEscrowBalancesResponseEncoding on GetEscrowBalancesResponse {
  /// Encodes the wrapper back to the raw array shape the helper speaks.
  ///
  /// The freezed-generated `toJson` emits `{"balances": [...]}` which is
  /// handy for logs but does NOT match what the gateway returned.
  /// `toList()` is the lossless inverse of
  /// [GetEscrowBalancesResponse.fromList].
  List<Map<String, dynamic>> toList() =>
      balances.map((e) => e.toJson()).toList(growable: false);
}

/// One row of the batch-balance response: the USDC balance held by a
/// given escrow contract address.
///
/// The OpenAPI description loosely calls the key `address` a "wallet
/// address", but the endpoint is used to query balances of *escrow
/// contracts* (C-addresses), which on Soroban are addressable the same
/// way as G-accounts. The field is kept as a flat `String` to tolerate
/// both forms.
@freezed
class EscrowBalanceEntry with _$EscrowBalanceEntry {
  const factory EscrowBalanceEntry({
    required String address,
    required num balance,
  }) = _EscrowBalanceEntry;

  factory EscrowBalanceEntry.fromJson(Map<String, dynamic> json) =>
      _$EscrowBalanceEntryFromJson(json);
}
