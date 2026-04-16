import 'package:freezed_annotation/freezed_annotation.dart';

part 'start_dispute_payload.freezed.dart';
part 'start_dispute_payload.g.dart';

/// Request body for `POST /escrow/single-release/dispute-escrow`.
///
/// Flips the contract's `disputed` flag, which locks the contract
/// until a `disputeResolver` invokes `resolveDispute` to split the
/// USDC between parties.
///
/// IMPORTANT — architectural boundary: this SDK exposes only the
/// on-chain primitive. The SDK does NOT make dispute decisions, nor
/// does it know about the off-chain mediation/arbitration workflow
/// (MEDIATION 48h -> ARBITRATION 7d -> JUDICIAL_ESCALATED). That
/// workflow lives in the HabitaNexus backend `contract-core` module.
/// See `business/spikes/06-contract-core-megaprompt.md` sections 7
/// and 12 for the off-chain state machine.
@freezed
class StartDisputePayload with _$StartDisputePayload {
  const factory StartDisputePayload({
    required String contractId,
    required String signer,
  }) = _StartDisputePayload;

  factory StartDisputePayload.fromJson(Map<String, dynamic> json) =>
      _$StartDisputePayloadFromJson(json);
}
