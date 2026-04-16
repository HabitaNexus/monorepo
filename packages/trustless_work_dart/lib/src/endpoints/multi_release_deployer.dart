import '../errors/trustless_work_error.dart';
import '../http/http_client.dart';
import '../models/payloads/multi_release_contract.dart';

/// Wraps `POST /deployer/multi-release`.
///
/// Returns the unsigned transaction XDR that must be signed with the
/// deployer's key and submitted through `TransactionHelper`. Parallel
/// to `SingleReleaseDeployer` but for multi-release contracts, which
/// encode per-milestone release amounts.
class MultiReleaseDeployer {
  MultiReleaseDeployer({required HttpClient http}) : _http = http;

  final HttpClient _http;

  Future<String> deploy(MultiReleaseContract contract) async {
    final response = await _http.postJson<Map<String, dynamic>>(
      '/deployer/multi-release',
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
