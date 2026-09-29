/// Modelos de transporte del API de negociación (HAB-26).
///
/// Respuesta de `GET /negotiations/:id` y de las mutaciones: el objeto
/// negociación más `terms` (documento vigente) y `summary` (post-accept).
/// Hand-written (sin codegen): el runner del repo (analyzer 7.6.0) no
/// soporta el SDK Dart 3.13 (`visitDotShorthandPropertyAccess`), por lo que
/// `freezed`/`json_serializable` no pueden emitir aquí; migrar a `@freezed`
/// tras el upgrade de dependencias.
class NegotiationDto {
  final String id;
  final String listingId;
  final String tenantId;
  final String ownerId;
  final NegotiationStateDto state;
  final String createdAt;
  final String updatedAt;
  final Map<String, dynamic>? terms;
  final Map<String, dynamic>? summary;

  const NegotiationDto({
    required this.id,
    required this.listingId,
    required this.tenantId,
    required this.ownerId,
    required this.state,
    required this.createdAt,
    required this.updatedAt,
    this.terms,
    this.summary,
  });

  factory NegotiationDto.fromJson(Map<String, dynamic> json) {
    return NegotiationDto(
      id: json['id'] as String? ?? '',
      listingId: json['listingId'] as String? ?? '',
      tenantId: json['tenantId'] as String? ?? '',
      ownerId: json['ownerId'] as String? ?? '',
      state: NegotiationStateDto.fromJson(
          (json['state'] as Map?)?.cast<String, dynamic>() ?? {}),
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
      terms: (json['terms'] as Map?)?.cast<String, dynamic>(),
      summary: (json['summary'] as Map?)?.cast<String, dynamic>(),
    );
  }
}

class NegotiationStateDto {
  final String status;
  final int round;
  final String deadline;
  final bool? tenantConfirmed;
  final bool? ownerConfirmed;
  final String? reason;

  const NegotiationStateDto({
    required this.status,
    required this.round,
    required this.deadline,
    this.tenantConfirmed,
    this.ownerConfirmed,
    this.reason,
  });

  factory NegotiationStateDto.fromJson(Map<String, dynamic> json) {
    return NegotiationStateDto(
      status: json['status'] as String? ?? 'EXPIRADA',
      round: (json['round'] as num?)?.toInt() ?? 1,
      deadline: json['deadline'] as String? ?? '',
      tenantConfirmed: json['tenantConfirmed'] as bool?,
      ownerConfirmed: json['ownerConfirmed'] as bool?,
      reason: json['reason'] as String?,
    );
  }
}

/// Envuelve un mapa de términos en el documento versionado que exige el API
/// (`TermsDocumentDto`: `{version: 1, terms: {...}}`).
Map<String, Object?> termsDocument(Map<String, Object?> terms) {
  return {'version': 1, 'terms': terms};
}
