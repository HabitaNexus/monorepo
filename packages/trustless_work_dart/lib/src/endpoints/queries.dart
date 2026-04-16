import '../http/http_client.dart';
import '../models/escrow.dart';
import '../models/multi_release_escrow.dart';

/// Read-only queries against the Trustless Work API.
///
/// The endpoints used here are provisional — pending confirmation from
/// Trustless Work on the canonical paths for "fetch a single escrow by
/// contractId" (see spec §13.5). The current TW OpenAPI
/// (re-verified against `https://api.trustlesswork.com/docs-json` as
/// part of HAB-61 on 2026-04-15) exposes only
/// `GET /helper/get-escrow-by-contract-ids` (plural) and no
/// single-contract-id path. We keep the working
/// `/escrow/{flavor}/get-escrow` routes that the gateway has historically
/// served. When they change, only this file and its tests need updating;
/// the public `TrustlessWorkClient.getEscrow` /
/// `getMultiReleaseEscrow` signatures are unchanged.
///
/// HAB-61 explored consolidating these two methods onto
/// `/helper/get-escrow-by-contract-ids` (the indexer's batch endpoint,
/// used with a single-element array). That path IS canonical for
/// indexer-backed reads but the response shape genuinely diverges from
/// `Escrow` / `MultiReleaseEscrow` — roles are an object keyed by role
/// name, timestamps are Firestore `{_seconds,_nanoseconds}`, milestones
/// carry their own nested `flags`, and top-level flags include
/// `resolved` but not `approved`. Forcing those payloads through
/// `Escrow.fromJson` would require reshaping the gateway-post-mutation
/// models as well (every state-refresh call after deploy/fund/release
/// reuses this code path). That reshape is out of scope for HAB-61 —
/// the indexer-flavoured reads therefore live in
/// [IndexerQueries] and return
/// `GetEscrowsFromIndexerResponse` instead of `Escrow`.
class EscrowQueries {
  EscrowQueries({required HttpClient http}) : _http = http;

  final HttpClient _http;

  Future<Escrow> getEscrow(String contractId) async {
    final json = await _http.postJson<Map<String, dynamic>>(
      '/escrow/single-release/get-escrow',
      body: {'contractId': contractId},
    );
    return Escrow.fromJson(json);
  }

  Future<MultiReleaseEscrow> getMultiReleaseEscrow(String contractId) async {
    final json = await _http.postJson<Map<String, dynamic>>(
      '/escrow/multi-release/get-escrow',
      body: {'contractId': contractId},
    );
    return MultiReleaseEscrow.fromJson(json);
  }
}
