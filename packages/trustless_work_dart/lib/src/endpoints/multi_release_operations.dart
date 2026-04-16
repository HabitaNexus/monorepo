import '../errors/trustless_work_error.dart';
import '../http/http_client.dart';
import '../models/payloads/approve_milestone_payload.dart';
import '../models/payloads/change_milestone_status_payload.dart';
import '../models/payloads/fund_escrow_payload.dart';
import '../models/payloads/multi_release_release_funds_payload.dart';
import '../models/payloads/multi_release_resolve_dispute_payload.dart';
import '../models/payloads/multi_release_start_dispute_payload.dart';
import '../models/payloads/update_escrow_payload.dart';

/// Wraps the `/escrow/multi-release/*` endpoints.
///
/// Parallel to [SingleReleaseOperations] but for multi-release escrows
/// where each milestone carries its own release amount and can be
/// approved, disputed, and released independently.
///
/// Differences from single-release at the API level (confirmed against
/// the TW OpenAPI spec):
///
/// - Release: `/escrow/multi-release/release-milestone-funds` (not
///   `release-funds`) and requires a `milestoneIndex`.
/// - Dispute: `/escrow/multi-release/dispute-milestone` (not
///   `dispute-escrow`) and requires a `milestoneIndex`.
/// - Resolve: `/escrow/multi-release/resolve-milestone-dispute` (not
///   `resolve-dispute`) and requires a `milestoneIndex`.
/// - Fund, approve-milestone, change-milestone-status, and
///   update-escrow reuse the identical body shape as single-release;
///   only the URL path differs.
///
/// Dispute workflows: same architectural boundary as single-release.
/// The SDK only exposes the on-chain primitives. The off-chain
/// mediation / arbitration state machine lives in the HabitaNexus
/// backend `contract-core` module — see
/// `business/spikes/06-contract-core-megaprompt.md` sections 7 and 12.
class MultiReleaseOperations {
  MultiReleaseOperations({required HttpClient http}) : _http = http;

  final HttpClient _http;

  Future<String> fund(FundEscrowPayload payload) =>
      _postForXdr('/escrow/multi-release/fund-escrow', payload.toJson());

  /// Releases the portion of escrow balance tied to a single milestone.
  /// Fails if the milestone is not `Completed` + approved, or if it is
  /// under dispute.
  Future<String> release(MultiReleaseReleaseFundsPayload payload) =>
      _postForXdr(
        '/escrow/multi-release/release-milestone-funds',
        payload.toJson(),
      );

  Future<String> update(UpdateEscrowPayload payload) =>
      _putForXdr('/escrow/multi-release/update-escrow', payload.toJson());

  Future<String> changeMilestoneStatus(ChangeMilestoneStatusPayload payload) =>
      _postForXdr(
        '/escrow/multi-release/change-milestone-status',
        payload.toJson(),
      );

  /// Approves a specific milestone. In multi-release this flips the
  /// per-milestone `approvedFlag` and makes just that milestone
  /// releasable; other milestones are unaffected.
  Future<String> approveMilestone(ApproveMilestonePayload payload) =>
      _postForXdr(
        '/escrow/multi-release/approve-milestone',
        payload.toJson(),
      );

  /// Starts a dispute on a specific milestone, freezing only that
  /// milestone until a `disputeResolver` calls [resolveDispute]. Other
  /// milestones remain releasable. Thin on-chain primitive — see class
  /// docstring for the architectural boundary.
  Future<String> startDispute(MultiReleaseStartDisputePayload payload) =>
      _postForXdr(
        '/escrow/multi-release/dispute-milestone',
        payload.toJson(),
      );

  /// Executes the USDC split that resolves a milestone's dispute. The
  /// SDK does NOT decide the split — the [distributions] list must
  /// come from an off-chain arbiter in the HabitaNexus backend
  /// `contract-core` module.
  Future<String> resolveDispute(MultiReleaseResolveDisputePayload payload) =>
      _postForXdr(
        '/escrow/multi-release/resolve-milestone-dispute',
        payload.toJson(),
      );

  Future<String> _postForXdr(String path, Map<String, Object?> body) async {
    final response =
        await _http.postJson<Map<String, dynamic>>(path, body: body);
    return _extractXdr(path, response);
  }

  Future<String> _putForXdr(String path, Map<String, Object?> body) async {
    final response =
        await _http.putJson<Map<String, dynamic>>(path, body: body);
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
