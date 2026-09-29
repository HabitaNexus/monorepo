/// Contrato del repositorio de negociación (puerto de dominio).
library;

import 'negotiation.dart';

/// Excepción de transporte/repositorio con mensaje apto para UI.
class NegotiationException implements Exception {
  final String message;
  const NegotiationException(this.message);

  @override
  String toString() => 'NegotiationException: $message';
}

abstract class NegotiationRepository {
  /// Carga el detalle desde el servidor (`GET /negotiations/:id`).
  Future<NegotiationDetail> fetch(String id);

  /// Crea una negociación (`POST /negotiations`).
  Future<NegotiationDetail> propose({
    required String listingId,
    required String tenantId,
    required String ownerId,
    required Map<String, Object?> terms,
    required String actor,
  });

  /// Envía contrapropuesta (`POST /negotiations/:id/counter`).
  Future<NegotiationDetail> counter({
    required String id,
    required Map<String, Object?> terms,
    required String actor,
  });

  /// Acepta los términos vigentes (`POST /negotiations/:id/accept`).
  Future<NegotiationDetail> accept({required String id, required String actor});

  /// Desiste con motivo (`POST /negotiations/:id/reject`).
  Future<NegotiationDetail> reject({
    required String id,
    required String reason,
    required String actor,
  });

  /// Confirma el resumen bilateral (`POST /negotiations/:id/confirm-summary`).
  Future<NegotiationDetail> confirmSummary({
    required String id,
    required NegotiationParty party,
    required String actor,
  });
}
