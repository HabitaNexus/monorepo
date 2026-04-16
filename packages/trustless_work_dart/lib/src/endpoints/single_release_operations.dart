import '../errors/trustless_work_error.dart';
import '../http/http_client.dart';
import '../models/payloads/fund_escrow_payload.dart';
import '../models/payloads/release_funds_payload.dart';

/// Wraps the `/escrow/single-release/*` endpoints for the v0.1 alcance.
class SingleReleaseOperations {
  SingleReleaseOperations({required HttpClient http}) : _http = http;

  final HttpClient _http;

  Future<String> fund(FundEscrowPayload payload) =>
      _postForXdr('/escrow/single-release/fund-escrow', payload.toJson());

  Future<String> release(ReleaseFundsPayload payload) =>
      _postForXdr('/escrow/single-release/release-funds', payload.toJson());

  Future<String> _postForXdr(String path, Map<String, Object?> body) async {
    final response = await _http.postJson<Map<String, dynamic>>(path, body: body);
    final xdr = response['transactionXdr'];
    if (xdr is! String || xdr.isEmpty) {
      throw ServerError(message: 'Response from $path missing transactionXdr');
    }
    return xdr;
  }
}
