import '../errors/trustless_work_error.dart';
import '../http/http_client.dart';
import '../models/payloads/single_release_contract.dart';

/// Wraps `POST /deployer/single-release`.
///
/// Returns the unsigned transaction XDR that must be signed with the
/// deployer's key and submitted through `TransactionHelper`.
class SingleReleaseDeployer {
  SingleReleaseDeployer({required HttpClient http}) : _http = http;

  final HttpClient _http;

  Future<String> deploy(SingleReleaseContract contract) async {
    final response = await _http.postJson<Map<String, dynamic>>(
      '/deployer/single-release',
      body: contract.toJson(),
    );
    final xdr = response['transactionXdr'];
    if (xdr is! String || xdr.isEmpty) {
      throw const ServerError(
        message: 'Response missing transactionXdr',
      );
    }
    return xdr;
  }
}
