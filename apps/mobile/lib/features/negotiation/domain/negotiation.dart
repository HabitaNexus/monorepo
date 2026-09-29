/// Entidades de dominio de la negociación (HAB-27).
///
/// Puras: sin imports de Flutter, dio ni codegen. La UI nunca decide estado:
/// solo transporta el `state` que entrega el servidor (HAB-26).
library;

/// Parte de la negociación. El backend usa estos literales en
/// `confirm-summary {party}`.
enum NegotiationParty { tenant, owner }

/// Convierte el literal API (`TENANT`/`OWNER`) al enum de dominio.
NegotiationParty negotiationPartyFromApi(String value) {
  switch (value.toUpperCase()) {
    case 'OWNER':
      return NegotiationParty.owner;
    case 'TENANT':
    default:
      return NegotiationParty.tenant;
  }
}

/// Literal API para una parte.
String negotiationPartyToApi(NegotiationParty party) {
  switch (party) {
    case NegotiationParty.tenant:
      return 'TENANT';
    case NegotiationParty.owner:
      return 'OWNER';
  }
}

/// Estados del SOP (espejo de `NegotiationStatus` en `states.ts`).
enum NegotiationStatus {
  propuestaEnviada,
  contrapropuesta,
  acuerdoAlcanzado,
  pendienteFirma,
  rechazada,
  expirada,
}

/// Convierte el literal API al enum de dominio.
NegotiationStatus negotiationStatusFromApi(String value) {
  switch (value) {
    case 'PROPUESTA_ENVIADA':
      return NegotiationStatus.propuestaEnviada;
    case 'CONTRAPROPUESTA':
      return NegotiationStatus.contrapropuesta;
    case 'ACUERDO_ALCANZADO':
      return NegotiationStatus.acuerdoAlcanzado;
    case 'PENDIENTE_FIRMA':
      return NegotiationStatus.pendienteFirma;
    case 'RECHAZADA':
      return NegotiationStatus.rechazada;
    case 'EXPIRADA':
    default:
      return NegotiationStatus.expirada;
  }
}

/// Estado de la negociación tal como lo reporta el servidor.
class NegotiationState {
  final NegotiationStatus status;
  final int round;
  final DateTime deadline;
  final bool tenantConfirmed;
  final bool ownerConfirmed;
  final String? reason;

  const NegotiationState({
    required this.status,
    required this.round,
    required this.deadline,
    this.tenantConfirmed = false,
    this.ownerConfirmed = false,
    this.reason,
  });

  /// Ronda abierta: el servidor aún acepta counter/accept/reject.
  bool get isOpenRound =>
      status == NegotiationStatus.propuestaEnviada ||
      status == NegotiationStatus.contrapropuesta;

  bool get isTerminal =>
      status == NegotiationStatus.pendienteFirma ||
      status == NegotiationStatus.rechazada ||
      status == NegotiationStatus.expirada;
}

/// Agregado de detalle: identidad + estado del servidor + ambos lados
/// de la comparación de términos.
class NegotiationDetail {
  final String id;
  final String listingId;
  final String tenantId;
  final String ownerId;
  final NegotiationState state;

  /// Lado base ("Tu Propuesta"): último documento del otro lado o del
  /// resumen confirmado. En modo demo son los valores del diseño.
  final Map<String, String> baseTerms;

  /// Lado actual ("Contrapropuesta"): último documento del servidor.
  final Map<String, String> currentTerms;

  /// Términos del resumen confirmado (solo post-accept), si existen.
  final Map<String, String>? summaryTerms;

  /// Rol que redactó el último documento, cuando se conoce (demo o
  /// contrapropuesta enviada desde esta UI). El backend HAB-26 no lo
  /// expone, por eso es opcional.
  final NegotiationParty? lastAuthor;

  /// true cuando los datos vienen del backend; false en modo demo local.
  final bool fromBackend;

  /// Texto por fila (número de fila UI → texto) que prevalece sobre el
  /// valor de la key API al mostrar. Necesario porque varias filas son
  /// facetas de una misma key (p. ej. filas 8/9/10 comparten
  /// `mascotas_permitidas`) y cada una muestra un aspecto distinto.
  final Map<int, String> baseOverrides;
  final Map<int, String> currentOverrides;

  const NegotiationDetail({
    required this.id,
    required this.listingId,
    required this.tenantId,
    required this.ownerId,
    required this.state,
    required this.baseTerms,
    required this.currentTerms,
    this.summaryTerms,
    this.lastAuthor,
    this.fromBackend = false,
    this.baseOverrides = const {},
    this.currentOverrides = const {},
  });

  NegotiationDetail copyWith({
    NegotiationState? state,
    Map<String, String>? baseTerms,
    Map<String, String>? currentTerms,
    Map<String, String>? summaryTerms,
    NegotiationParty? lastAuthor,
    bool? fromBackend,
    Map<int, String>? baseOverrides,
    Map<int, String>? currentOverrides,
  }) {
    return NegotiationDetail(
      id: id,
      listingId: listingId,
      tenantId: tenantId,
      ownerId: ownerId,
      state: state ?? this.state,
      baseTerms: baseTerms ?? this.baseTerms,
      currentTerms: currentTerms ?? this.currentTerms,
      summaryTerms: summaryTerms ?? this.summaryTerms,
      lastAuthor: lastAuthor ?? this.lastAuthor,
      fromBackend: fromBackend ?? this.fromBackend,
      baseOverrides: baseOverrides ?? this.baseOverrides,
      currentOverrides: currentOverrides ?? this.currentOverrides,
    );
  }
}

/// Filtro del comparador (pestañas Todos / Solo Diff / Acuerdo).
enum TermFilter { all, diff, agreed }

/// Resultado de comparar una fila UI entre base y contrapropuesta.
class RowComparison {
  final int number;
  final String apiKey;
  final String base;
  final String current;
  final bool isDiff;

  const RowComparison({
    required this.number,
    required this.apiKey,
    required this.base,
    required this.current,
    required this.isDiff,
  });
}

/// Descriptor mínimo de fila para comparar sin acoplar el dominio a la
/// tabla de mapeo UI (que vive en la capa de datos).
class RowSpec {
  final int number;
  final String apiKey;

  /// Fila de redacción complementaria (p. ej. "No requerido" frente a
  /// "No provisto"): hay acuerdo si ambas partes expresaron posición;
  /// solo es DIFF si un lado está vacío.
  final bool lenient;

  const RowSpec({required this.number, required this.apiKey, this.lenient = false});
}

/// Entrada del timeline de rondas (auditable según SOP-04).
class RoundEntry {
  final int round;
  final String authorLabel;
  final String dateLabel;
  final String detailLabel;
  final bool isCurrent;

  const RoundEntry({
    required this.round,
    required this.authorLabel,
    required this.dateLabel,
    required this.detailLabel,
    this.isCurrent = false,
  });
}

/// Desglose del slot calculadora escrow (HAB-28).
class EscrowBreakdown {
  final double canon;
  final double deposito;
  final double comision;
  final double total;

  const EscrowBreakdown({
    required this.canon,
    required this.deposito,
    required this.comision,
    required this.total,
  });
}
