import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import '../endpoints/deployer.dart';
import '../endpoints/helpers.dart';
import '../endpoints/queries.dart';
import '../endpoints/single_release_operations.dart';
import '../http/http_client.dart';
import '../models/escrow.dart';
import '../models/payloads/fund_escrow_payload.dart';
import '../models/payloads/release_funds_payload.dart';
import '../models/payloads/single_release_contract.dart';
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
    );
  }

  @visibleForTesting
  factory TrustlessWorkClient.forTesting({
    required TrustlessWorkConfig config,
    required TransactionSigner signer,
    required http.Client innerHttp,
  }) {
    final http_ = HttpClient(config: config, inner: innerHttp);
    return TrustlessWorkClient._(
      http: http_,
      signer: signer,
      deployer: SingleReleaseDeployer(http: http_),
      operations: SingleReleaseOperations(http: http_),
      helper: TransactionHelper(http: http_, signer: signer),
      queries: EscrowQueries(http: http_),
    );
  }

  TrustlessWorkClient._({
    required HttpClient http,
    required TransactionSigner signer,
    required SingleReleaseDeployer deployer,
    required SingleReleaseOperations operations,
    required TransactionHelper helper,
    required EscrowQueries queries,
  })  : _deployer = deployer,
        _operations = operations,
        _helper = helper,
        _queries = queries;

  final SingleReleaseDeployer _deployer;
  final SingleReleaseOperations _operations;
  final TransactionHelper _helper;
  final EscrowQueries _queries;

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

  Future<Escrow> getEscrow(String contractId) => _queries.getEscrow(contractId);
}
