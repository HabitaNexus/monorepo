import 'package:freezed_annotation/freezed_annotation.dart';

part 'release_funds_payload.freezed.dart';
part 'release_funds_payload.g.dart';

/// Request body for `POST /escrow/single-release/release-funds`.
@freezed
class ReleaseFundsPayload with _$ReleaseFundsPayload {
  const factory ReleaseFundsPayload({
    required String contractId,
    required String releaseSigner,
  }) = _ReleaseFundsPayload;

  factory ReleaseFundsPayload.fromJson(Map<String, dynamic> json) =>
      _$ReleaseFundsPayloadFromJson(json);
}
