import '../http/http_client.dart';
import '../models/escrow.dart';
import '../models/multi_release_escrow.dart';

/// Read-only queries against the Trustless Work API.
///
/// The endpoints used here are provisional — pending confirmation from
/// Trustless Work on the canonical paths for "fetch a single escrow by
/// contractId" (see spec §13.5). The current TW OpenAPI (as of HAB-60)
/// exposes `/helper/get-escrow-by-contract-ids` (plural) and no
/// single-contract-id path, so we keep the working
/// `/escrow/{flavor}/get-escrow` routes that the gateway has historically
/// served. When they change, only this file and its tests need updating;
/// the public `TrustlessWorkClient.getEscrow` /
/// `getMultiReleaseEscrow` signatures are unchanged.
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
