import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import '../endpoints/deployer.dart';
import '../endpoints/helpers.dart';
import '../endpoints/queries.dart';
import '../endpoints/single_release_operations.dart';
import '../events/escrow_event.dart';
import '../events/hybrid_event_stream.dart';
import '../events/stellar_event_sources.dart';
import '../http/http_client.dart';
import '../models/escrow.dart';
import '../models/payloads/approve_milestone_payload.dart';
import '../models/payloads/change_milestone_status_payload.dart';
import '../models/payloads/fund_escrow_payload.dart';
import '../models/payloads/release_funds_payload.dart';
import '../models/payloads/resolve_dispute_payload.dart';
import '../models/payloads/single_release_contract.dart';
import '../models/payloads/start_dispute_payload.dart';
import '../models/payloads/update_escrow_payload.dart';
import '../signer/transaction_signer.dart';
import 'trustless_work_config.dart';

/// Public entry point for consumers of the SDK.
///
/// Every state-changing operation performs the two-step dance:
///   1. Request an unsigned XDR envelope from the corresponding gateway
///      endpoint.
///   2. Sign it via the configured `TransactionSigner` and resubmit to
///      `/helper/send-transaction`, then re-read the current escrow
///      state so callers always receive a coherent `Escrow` snapshot.
class TrustlessWorkClient {
  factory TrustlessWorkClient({
    required TrustlessWorkConfig config,
    required TransactionSigner signer,
    http.Client? httpClient,
  }) {
    final http_ = HttpClient(config: config, inner: httpClient);
    return TrustlessWorkClient._(
      http: http_,
      signer: signer,
      deployer: SingleReleaseDeployer(http: http_),
      operations: SingleReleaseOperations(http: http_),
      helper: TransactionHelper(http: http_, signer: signer),
      queries: EscrowQueries(http: http_),
      config: config,
    );
  }

  @visibleForTesting
  factory TrustlessWorkClient.forTesting({
    required TrustlessWorkConfig config,
    required TransactionSigner signer,
    required http.Client innerHttp,
    SorobanEventSource? sorobanEvents,
    HorizonEffectsSource? horizonEffects,
  }) {
    final http_ = HttpClient(config: config, inner: innerHttp);
    return TrustlessWorkClient._(
      http: http_,
      signer: signer,
      deployer: SingleReleaseDeployer(http: http_),
      operations: SingleReleaseOperations(http: http_),
      helper: TransactionHelper(http: http_, signer: signer),
      queries: EscrowQueries(http: http_),
      config: config,
      sorobanEventsOverride: sorobanEvents,
      horizonEffectsOverride: horizonEffects,
    );
  }

  TrustlessWorkClient._({
    required HttpClient http,
    required TransactionSigner signer,
    required SingleReleaseDeployer deployer,
    required SingleReleaseOperations operations,
    required TransactionHelper helper,
    required EscrowQueries queries,
    required TrustlessWorkConfig config,
    SorobanEventSource? sorobanEventsOverride,
    HorizonEffectsSource? horizonEffectsOverride,
  })  : _deployer = deployer,
        _operations = operations,
        _helper = helper,
        _queries = queries,
        _config = config,
        _sorobanEventsOverride = sorobanEventsOverride,
        _horizonEffectsOverride = horizonEffectsOverride;

  final SingleReleaseDeployer _deployer;
  final SingleReleaseOperations _operations;
  final TransactionHelper _helper;
  final EscrowQueries _queries;
  final TrustlessWorkConfig _config;
  final SorobanEventSource? _sorobanEventsOverride;
  final HorizonEffectsSource? _horizonEffectsOverride;

  Future<Escrow> initializeEscrow(SingleReleaseContract contract) async {
    final xdr = await _deployer.deploy(contract);
    final submitResponse = await _helper.signAndSubmit(xdr);
    final contractId = submitResponse['contractId'];
    if (contractId is! String || contractId.isEmpty) {
      throw StateError('Gateway did not return contractId after deploy.');
    }
    return _queries.getEscrow(contractId);
  }

  Future<Escrow> fundEscrow(FundEscrowPayload payload) async {
    final xdr = await _operations.fund(payload);
    await _helper.signAndSubmit(xdr);
    return _queries.getEscrow(payload.contractId);
  }

  Future<Escrow> releaseFunds(ReleaseFundsPayload payload) async {
    final xdr = await _operations.release(payload);
    await _helper.signAndSubmit(xdr);
    return _queries.getEscrow(payload.contractId);
  }

  /// Modifies an existing escrow. Legal only before any milestone is
  /// approved — the gateway returns 500 if called after approval.
  Future<Escrow> updateEscrow(UpdateEscrowPayload payload) async {
    final xdr = await _operations.update(payload);
    await _helper.signAndSubmit(xdr);
    return _queries.getEscrow(payload.contractId);
  }

  /// Reports a milestone status change on behalf of the service
  /// provider. Typical use: flipping a milestone to `Completed` with
  /// evidence once deliverables are ready for approval.
  Future<Escrow> changeMilestoneStatus(
    ChangeMilestoneStatusPayload payload,
  ) async {
    final xdr = await _operations.changeMilestoneStatus(payload);
    await _helper.signAndSubmit(xdr);
    return _queries.getEscrow(payload.contractId);
  }

  /// Approves a milestone on behalf of the approver. Once all
  /// milestones are approved, the contract's `approved` flag flips and
  /// `releaseFunds` becomes callable.
  Future<Escrow> approveMilestone(ApproveMilestonePayload payload) async {
    final xdr = await _operations.approveMilestone(payload);
    await _helper.signAndSubmit(xdr);
    return _queries.getEscrow(payload.contractId);
  }

  /// Flips the contract's `disputed` flag on-chain.
  ///
  /// Architectural boundary: this is the on-chain primitive only. The
  /// SDK does NOT make dispute decisions. The off-chain mediation /
  /// arbitration workflow (MEDIATION 48h -> ARBITRATION 7d ->
  /// JUDICIAL_ESCALATED) lives in the HabitaNexus backend
  /// `contract-core` module — see
  /// `business/spikes/06-contract-core-megaprompt.md` sections 7 and
  /// 12. Callers should only invoke this once an off-chain process
  /// has authorised the escalation.
  Future<Escrow> startDispute(StartDisputePayload payload) async {
    final xdr = await _operations.startDispute(payload);
    await _helper.signAndSubmit(xdr);
    return _queries.getEscrow(payload.contractId);
  }

  /// Executes the on-chain USDC split that resolves a dispute.
  ///
  /// Architectural boundary: the SDK does NOT decide how to split
  /// funds. The `distributions` list must come from an off-chain
  /// arbiter in the HabitaNexus backend `contract-core` module (see
  /// `business/spikes/06-contract-core-megaprompt.md` §7 and §12). The
  /// SDK submits whatever split the `disputeResolver` key signs.
  Future<Escrow> resolveDispute(ResolveDisputePayload payload) async {
    final xdr = await _operations.resolveDispute(payload);
    await _helper.signAndSubmit(xdr);
    return _queries.getEscrow(payload.contractId);
  }

  Future<Escrow> getEscrow(String contractId) => _queries.getEscrow(contractId);

  /// Observable stream of state transitions on an escrow contract.
  ///
  /// v0.2 implementation: hybrid Horizon SSE + Soroban `getEvents`
  /// (see `HybridEventStream`). The legacy `pollInterval` parameter
  /// is accepted for source-compatibility but has no effect — the
  /// hybrid stream manages its own adaptive 2s–30s cadence. It will
  /// be removed in v0.3.
  ///
  /// Mobile consumers that care about iOS/Android background
  /// lifecycle should attach a `WidgetsBindingObserver` to the stream
  /// they subscribe to and call `resumeFromBackground()` on the
  /// underlying `HybridEventStream` via the `escrowEventStream()`
  /// helper if they need that hook. The default `escrowEvents` path
  /// handles disconnects via internal reconciliation so most callers
  /// never have to care.
  Stream<EscrowEvent> escrowEvents(
    String contractId, {
    @Deprecated('No-op in v0.2; HybridEventStream manages its own '
        'adaptive interval. Will be removed in v0.3.')
    Duration pollInterval = const Duration(seconds: 15),
  }) {
    return escrowEventStream(contractId).events;
  }

  /// Lower-level accessor that returns the `HybridEventStream` so
  /// advanced callers (e.g. a Flutter companion) can call
  /// `resumeFromBackground()` directly.
  HybridEventStream escrowEventStream(String contractId) {
    return HybridEventStream(
      contractId: contractId,
      fetchEscrow: () => _queries.getEscrow(contractId),
      sorobanEvents: _sorobanEventsOverride ??
          SorobanRpcEventSource(network: _config.network),
      horizonEffects: _horizonEffectsOverride ??
          HorizonSseEffectsSource(network: _config.network),
    );
  }
}
