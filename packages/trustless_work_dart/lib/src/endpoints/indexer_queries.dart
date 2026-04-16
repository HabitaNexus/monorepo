import '../http/http_client.dart';
import '../models/get_escrow_balances_response.dart';
import '../models/get_escrows_from_indexer_response.dart';

/// Canonical role names accepted by the TW indexer's `role` query
/// parameter on `GET /helper/get-escrows-by-role`.
///
/// The strings (`approver`, `serviceProvider`, `releaseSigner`,
/// `disputeResolver`, `platformAddress`, `receiver`) are validated
/// server-side — unknown names return 400. Keeping this as an enum
/// rather than a raw `String` parameter makes callers unable to typo
/// the role and keeps the SDK in lockstep with the contract's role
/// vocabulary. The `issuer` role surfaced by some indexer responses
/// is NOT a valid filter value, so it is absent from this enum.
enum IndexerRole {
  approver('approver'),
  serviceProvider('serviceProvider'),
  releaseSigner('releaseSigner'),
  disputeResolver('disputeResolver'),
  platformAddress('platformAddress'),
  receiver('receiver');

  const IndexerRole(this.wireName);

  /// Exact string value the TW API expects on the `role` query.
  final String wireName;
}

/// Read-only batch/filter queries against the Trustless Work indexer
/// plus the batch-balance helper.
///
/// The indexer is a separate Go service behind the same API gateway;
/// its three endpoints all live under `/helper/*` and all speak
/// `GET` with query-string parameters (confirmed against
/// `https://api.trustlesswork.com/docs-json` on 2026-04-15):
///
///   * `GET /helper/get-escrows-by-role`
///   * `GET /helper/get-escrows-by-signer`
///   * `GET /helper/get-escrow-by-contract-ids`
///   * `GET /helper/get-multiple-escrow-balance`  (HAB-62, v0.3)
///
/// All four return a **raw JSON array** (no top-level envelope). The
/// first three share the [IndexerEscrow] row shape and are wrapped into
/// a [GetEscrowsFromIndexerResponse]. The balance endpoint returns a
/// simpler `{address, balance}` row and is wrapped into a
/// [GetEscrowBalancesResponse].
///
/// The balance helper is technically an "escrow balance" query rather
/// than an indexer filter, but it shares the same `/helper/*` namespace,
/// auth header, and raw-array envelope convention, and its primary
/// consumer is the same dashboard code that already calls
/// `getEscrowFromIndexerByContractIds` — so it lives here rather than in
/// a stand-alone `BalanceQueries` class to avoid one-method abstractions.
class IndexerQueries {
  IndexerQueries({required HttpClient http}) : _http = http;

  final HttpClient _http;

  /// Lists escrows where [role] is held by address [user].
  ///
  /// Both parameters are required — the TW indexer enforces that
  /// `role` and `roleAddress` are supplied together (supplying one
  /// without the other returns 400).
  Future<GetEscrowsFromIndexerResponse> getEscrowsFromIndexerByRole({
    required IndexerRole role,
    required String user,
  }) async {
    final raw = await _http.getJson<List<dynamic>>(
      '/helper/get-escrows-by-role',
      queryParameters: <String, String>{
        'role': role.wireName,
        'roleAddress': user,
      },
    );
    return GetEscrowsFromIndexerResponse.fromList(raw);
  }

  /// Lists escrows where [signer] acted as ANY signer on the contract
  /// (deploy / fund / approve / release / dispute).
  Future<GetEscrowsFromIndexerResponse> getEscrowsFromIndexerBySigner(
    String signer,
  ) async {
    final raw = await _http.getJson<List<dynamic>>(
      '/helper/get-escrows-by-signer',
      queryParameters: <String, String>{
        'signer': signer,
      },
    );
    return GetEscrowsFromIndexerResponse.fromList(raw);
  }

  /// Batch-fetch escrows by contract id.
  ///
  /// [contractIds] are serialised as a single comma-separated query
  /// parameter — the form used in the OpenAPI example. If
  /// [validateOnChain] is true, the indexer additionally verifies each
  /// escrow's data against the blockchain (slower, but authoritative).
  ///
  /// Throws [ArgumentError] if [contractIds] is empty — the indexer
  /// returns 400 in that case anyway, but failing fast avoids a
  /// pointless round-trip.
  Future<GetEscrowsFromIndexerResponse> getEscrowFromIndexerByContractIds(
    List<String> contractIds, {
    bool? validateOnChain,
  }) async {
    if (contractIds.isEmpty) {
      throw ArgumentError.value(
        contractIds,
        'contractIds',
        'must contain at least one contract id',
      );
    }
    final query = <String, String>{
      'contractIds': contractIds.join(','),
      if (validateOnChain != null) 'validateOnChain': '$validateOnChain',
    };
    final raw = await _http.getJson<List<dynamic>>(
      '/helper/get-escrow-by-contract-ids',
      queryParameters: query,
    );
    return GetEscrowsFromIndexerResponse.fromList(raw);
  }

  /// Batch-fetch USDC balances for a list of escrow contract addresses.
  ///
  /// [addresses] is serialised as a **repeat-param** query
  /// (`?addresses=CAAA&addresses=CBBB`) — the OpenAPI default
  /// (`style: form, explode: true`) for array query parameters. This
  /// intentionally differs from [getEscrowFromIndexerByContractIds],
  /// which uses CSV: the TW OpenAPI example for that endpoint showed
  /// a comma-joined value, whereas the balance endpoint's schema
  /// omits the explicit style override and therefore inherits the
  /// spec default.
  ///
  /// Throws [ArgumentError] if [addresses] is empty — the gateway
  /// returns 400 in that case, so failing fast avoids a pointless
  /// round-trip.
  Future<GetEscrowBalancesResponse> getMultipleEscrowBalances(
    List<String> addresses,
  ) async {
    if (addresses.isEmpty) {
      throw ArgumentError.value(
        addresses,
        'addresses',
        'must contain at least one address',
      );
    }
    final raw = await _http.getJson<List<dynamic>>(
      '/helper/get-multiple-escrow-balance',
      queryParameters: <String, dynamic>{
        'addresses': addresses,
      },
    );
    return GetEscrowBalancesResponse.fromList(raw);
  }
}
