import '../errors/trustless_work_error.dart';
import '../http/http_client.dart';
import '../models/payloads/approve_milestone_payload.dart';
import '../models/payloads/change_milestone_status_payload.dart';
import '../models/payloads/fund_escrow_payload.dart';
import '../models/payloads/release_funds_payload.dart';
import '../models/payloads/resolve_dispute_payload.dart';
import '../models/payloads/start_dispute_payload.dart';
import '../models/payloads/update_escrow_payload.dart';

/// Wraps the `/escrow/single-release/*` endpoints.
///
/// Covers the full single-release mutation surface: funding, releasing,
/// updating the escrow pre-approval, reporting milestone status,
/// approving milestones, starting a dispute, and resolving a dispute.
///
/// Dispute workflows: the SDK only exposes the on-chain primitives
/// (`startDispute` and `resolveDispute`). The off-chain mediation /
/// arbitration state machine (MEDIATION 48h -> ARBITRATION 7d ->
/// JUDICIAL_ESCALATED) lives in the HabitaNexus backend `contract-core`
/// module — see `business/spikes/06-contract-core-megaprompt.md`
/// sections 7 and 12.
class SingleReleaseOperations {
  SingleReleaseOperations({required HttpClient http}) : _http = http;

  final HttpClient _http;

  Future<String> fund(FundEscrowPayload payload) =>
      _postForXdr('/escrow/single-release/fund-escrow', payload.toJson());

  Future<String> release(ReleaseFundsPayload payload) =>
      _postForXdr('/escrow/single-release/release-funds', payload.toJson());

  Future<String> update(UpdateEscrowPayload payload) =>
      _putForXdr('/escrow/single-release/update-escrow', payload.toJson());

  Future<String> changeMilestoneStatus(ChangeMilestoneStatusPayload payload) =>
      _postForXdr(
        '/escrow/single-release/change-milestone-status',
        payload.toJson(),
      );

  Future<String> approveMilestone(ApproveMilestonePayload payload) =>
      _postForXdr(
        '/escrow/single-release/approve-milestone',
        payload.toJson(),
      );

  /// Flips the contract's `disputed` flag on-chain.
  ///
  /// This is the thin on-chain primitive. The SDK does NOT make the
  /// decision to dispute — that decision is surfaced by the HabitaNexus
  /// backend `contract-core` module, which also tracks the off-chain
  /// MEDIATION -> ARBITRATION -> JUDICIAL_ESCALATED lifecycle. SDK
  /// consumers should invoke this only when an off-chain arbiter (or
  /// party entitled to escalate) has produced the signed authorisation.
  Future<String> startDispute(StartDisputePayload payload) =>
      _postForXdr('/escrow/single-release/dispute-escrow', payload.toJson());

  /// Executes the on-chain USDC split that resolves a dispute.
  ///
  /// The SDK does NOT decide the split. The `distributions` list must
  /// come from an off-chain arbiter in the HabitaNexus backend
  /// `contract-core` module (see
  /// `business/spikes/06-contract-core-megaprompt.md` §7 and §12). The
  /// SDK simply submits whatever split the arbiter signed.
  Future<String> resolveDispute(ResolveDisputePayload payload) =>
      _postForXdr('/escrow/single-release/resolve-dispute', payload.toJson());

  Future<String> _postForXdr(String path, Map<String, Object?> body) async {
    final response = await _http.postJson<Map<String, dynamic>>(path, body: body);
    return _extractXdr(path, response);
  }

  Future<String> _putForXdr(String path, Map<String, Object?> body) async {
    final response = await _http.putJson<Map<String, dynamic>>(path, body: body);
    return _extractXdr(path, response);
  }

  String _extractXdr(String path, Map<String, dynamic> response) {
    final xdr = response['transactionXdr'];
    if (xdr is! String || xdr.isEmpty) {
      throw ServerError(message: 'Response from $path missing transactionXdr');
    }
    return xdr;
  }
}
