/// Cliente HTTP del API de negociación (HAB-26) sobre dio.
library;

import 'package:dio/dio.dart';

import 'models/negotiation_models.dart';

/// Error de transporte con mensaje apto para UI.
class NegotiationApiException implements Exception {
  final String message;
  final int? statusCode;

  const NegotiationApiException(this.message, {this.statusCode});

  @override
  String toString() => 'NegotiationApiException($statusCode): $message';
}

/// Rutas usadas (ver `negotiation.controller.ts` en el backend):
/// - POST /negotiations
/// - POST /negotiations/:id/counter
/// - POST /negotiations/:id/accept
/// - POST /negotiations/:id/reject
/// - POST /negotiations/:id/confirm-summary {party TENANT|OWNER}
/// - GET  /negotiations/:id
class NegotiationApiClient {
  final Dio _dio;

  NegotiationApiClient({Dio? dio, String? baseUrl})
      : _dio = dio ??
            Dio(BaseOptions(
              baseUrl: baseUrl ?? 'http://localhost:3000',
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
              headers: {'Content-Type': 'application/json'},
            ));

  /// Base URL efectiva (útil para el banner demo/backend).
  String get baseUrl => _dio.options.baseUrl;

  Future<NegotiationDto> fetch(String id) async {
    return _get('/negotiations/$id');
  }

  Future<NegotiationDto> propose({
    required String listingId,
    required String tenantId,
    required String ownerId,
    required Map<String, Object?> terms,
    required String actor,
  }) async {
    return _post('/negotiations', {
      'listingId': listingId,
      'tenantId': tenantId,
      'ownerId': ownerId,
      'terms': termsDocument(terms),
      'actor': actor,
    });
  }

  Future<NegotiationDto> counter({
    required String id,
    required Map<String, Object?> terms,
    required String actor,
  }) async {
    return _post('/negotiations/$id/counter', {
      'terms': termsDocument(terms),
      'actor': actor,
    });
  }

  Future<NegotiationDto> accept({
    required String id,
    required String actor,
  }) async {
    return _post('/negotiations/$id/accept', {'actor': actor});
  }

  Future<NegotiationDto> reject({
    required String id,
    required String reason,
    required String actor,
  }) async {
    return _post('/negotiations/$id/reject', {
      'reason': reason,
      'actor': actor,
    });
  }

  Future<NegotiationDto> confirmSummary({
    required String id,
    required String party,
    required String actor,
  }) async {
    return _post('/negotiations/$id/confirm-summary', {
      'party': party,
      'actor': actor,
    });
  }

  Future<NegotiationDto> _get(String path) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(path);
      return NegotiationDto.fromJson(res.data ?? {});
    } on DioException catch (e) {
      throw _wrap(e);
    }
  }

  Future<NegotiationDto> _post(
      String path, Map<String, Object?> body) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(path, data: body);
      return NegotiationDto.fromJson(res.data ?? {});
    } on DioException catch (e) {
      throw _wrap(e);
    }
  }

  NegotiationApiException _wrap(DioException e) {
    final data = e.response?.data;
    String message = 'Error de red contra $baseUrl';
    if (data is Map && data['message'] != null) {
      final raw = data['message'];
      message = raw is List ? raw.join(', ') : raw.toString();
    } else if (e.message != null && e.message!.isNotEmpty) {
      message = e.message!;
    }
    return NegotiationApiException(message,
        statusCode: e.response?.statusCode);
  }
}
