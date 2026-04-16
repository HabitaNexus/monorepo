import '../http/http_client.dart';
import '../signer/transaction_signer.dart';

/// Handles the second half of every state-changing call: taking the
/// unsigned XDR from a deploy/operation endpoint, delegating signing to
/// the configured `TransactionSigner`, and POSTing the resulting signed
/// envelope to `/helper/send-transaction`.
class TransactionHelper {
  TransactionHelper({
    required HttpClient http,
    required TransactionSigner signer,
  })  : _http = http,
        _signer = signer;

  final HttpClient _http;
  final TransactionSigner _signer;

  Future<Map<String, dynamic>> signAndSubmit(String unsignedXdr) async {
    final signed = await _signer.signXdr(unsignedXdr);
    return _http.postJson<Map<String, dynamic>>(
      '/helper/send-transaction',
      body: {'signedXdr': signed},
    );
  }
}
