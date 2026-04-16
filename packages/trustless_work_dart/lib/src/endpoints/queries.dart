import '../http/http_client.dart';
import '../models/escrow.dart';

/// Read-only queries against the Trustless Work API.
///
/// The endpoint used here is provisional — pending confirmation from
/// Trustless Work on the canonical path for "fetch a single escrow by
/// contractId" (see spec §13.5). When it changes, only this file and
/// its test need updating; the public `TrustlessWorkClient.getEscrow`
/// signature is unchanged.
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
}
