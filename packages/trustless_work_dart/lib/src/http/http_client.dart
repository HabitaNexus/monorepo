import 'dart:convert';
import 'package:http/http.dart' as http;
import '../client/trustless_work_config.dart';
import '../errors/trustless_work_error.dart';

/// Thin wrapper over `package:http` that:
/// - injects the `x-api-key` header on every request,
/// - JSON-encodes bodies and JSON-decodes responses,
/// - maps common HTTP failure modes onto `TrustlessWorkError`.
class HttpClient {
  HttpClient({
    required TrustlessWorkConfig config,
    http.Client? inner,
  })  : _config = config,
        _inner = inner ?? http.Client();

  final TrustlessWorkConfig _config;
  final http.Client _inner;

  Future<T> postJson<T>(
    String path, {
    required Map<String, Object?> body,
  }) =>
      _send<T>('POST', path, body: body);

  Future<T> putJson<T>(
    String path, {
    required Map<String, Object?> body,
  }) =>
      _send<T>('PUT', path, body: body);

  /// GETs [path] with an optional query string.
  ///
  /// Values in [queryParameters] may be either a single `String` or an
  /// `Iterable<String>` — the latter is serialised as a repeat-param
  /// (`?k=a&k=b`), which is what `Uri.replace` does natively and what
  /// OpenAPI calls `style: form, explode: true` (the default for array
  /// query parameters). Callers that want CSV serialisation should
  /// pre-join into a single `String` value themselves.
  Future<T> getJson<T>(
    String path, {
    Map<String, dynamic /* String | Iterable<String> */ >? queryParameters,
  }) =>
      _send<T>('GET', path, queryParameters: queryParameters);

  Future<T> _send<T>(
    String method,
    String path, {
    Map<String, Object?>? body,
    Map<String, dynamic /* String | Iterable<String> */ >? queryParameters,
  }) async {
    final uri = _config.baseUrl.replace(
      path: path,
      queryParameters: queryParameters,
    );

    late http.Response response;
    try {
      final request = http.Request(method, uri)
        ..headers['x-api-key'] = _config.apiKey
        ..headers['content-type'] = 'application/json; charset=utf-8';
      if (body != null) {
        request.body = jsonEncode(body);
      }
      final streamed = await _inner.send(request);
      response = await http.Response.fromStream(streamed);
    } on http.ClientException catch (e) {
      throw NetworkError(message: e.message, cause: e);
    } catch (e) {
      throw NetworkError(message: 'HTTP transport failure', cause: e);
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return <String, dynamic>{} as T;
      }
      final decoded = jsonDecode(response.body);
      return decoded as T;
    }

    _throwHttpError(response);
  }

  Never _throwHttpError(http.Response response) {
    final message = _extractMessage(response.body);
    switch (response.statusCode) {
      case 400:
        throw BadRequest(message: message);
      case 401:
        throw Unauthorized(message: message);
      case 429:
        throw TooManyRequests(message: message);
      case 500:
        throw ServerError(message: message);
      default:
        throw NetworkError(
          message: 'Unexpected HTTP ${response.statusCode}: $message',
        );
    }
  }

  String _extractMessage(String body) {
    if (body.isEmpty) return '';
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map && decoded['message'] is String) {
        return decoded['message'] as String;
      }
    } on FormatException {
      // fall through
    }
    return body;
  }

  void close() => _inner.close();
}
