/// Datos demo de la negociación HAB-27 (sin backend).
///
/// Réplica textual del diseño `docs/design/hab27/propuesta-contrapropuesta.html`:
/// expediente #NEG-2025-089, ronda 3 de 5, timeline R1/R2/R3 y los 34 textos
/// por lado. Las 8 filas con badge DIFF en el HTML son: 1, 2, 7, 8, 12,
/// 13, 24 y 27 (las métricas se calculan en vivo desde esta tabla).
library;

import '../domain/negotiation.dart';

abstract final class DemoNegotiation {
  static const String id = 'demo-neg-2025-089';
  static const String expediente = '#NEG-2025-089';
  static const String propertyName = 'Altamira Sky 402';
  static const String propertyMeta = 'Rohrmoser, San José • Condominio Vertical';
  static const String tenantLabel = 'Inquilino (Tú)';
  static const String ownerLabel = 'Carlos M. (Propietario)';
  static const String listingId = 'demo-altamira-402';
  static const String tenantId = 'demo-tenant-sofia';
  static const String ownerId = 'demo-owner-carlos';

  /// Deadline demo: 18h 42m desde la carga (se fija al construir el detalle).
  static const Duration demoRemaining = Duration(hours: 18, minutes: 42);

  static const List<RoundEntry> rounds = [
    RoundEntry(
        round: 1,
        authorLabel: 'R1 • Inquilino',
        dateLabel: '14 Oct',
        detailLabel: 'Borrador base'),
    RoundEntry(
        round: 2,
        authorLabel: 'R2 • Carlos M.',
        dateLabel: '15 Oct',
        detailLabel: 'Contraoferta'),
    RoundEntry(
        round: 3,
        authorLabel: 'R3 • Actual',
        dateLabel: 'En revisión',
        detailLabel: 'cambios activos',
        isCurrent: true),
  ];

  /// Valores por key API (lado base = "Tu Propuesta").
  static const Map<String, String> baseTerms = {
    'renta_mensual': '₡480,000',
    'deposito_garantia': '1 mes (₡480,000)',
    'dia_pago': 'Día 1 de cada mes',
    'incremento_anual': 'IPC Oficial BCCR',
    'plazo_meses': '12 meses forzosos',
    'fecha_inicio': '01 Nov 2025',
    'preaviso_dias': '3 días anticipados',
    'mascotas_permitidas': 'Permitido (1 raza mediana)',
    'numero_ocupantes': '2 adultos registrados',
    'visitas_propietario': 'Hasta 15 días continuos',
    'servicios_agua': 'Incluido en canon base',
    'servicios_luz': 'Medidor directo inquilino',
    'servicios_internet': '300 Mbps bonificado',
    'amueblado': 'No requerido',
    'inventario': 'Tanque individual GLP',
    'cuota_mantenimiento': 'Incluida en canon',
    'mantenimiento_menor': 'Permitido (resane final)',
    'estado_pintura': 'Neutral acordado',
    'mejoras': 'Prohibidas',
    'uso_inmueble': 'Sin afluencia pública',
    'mantenimiento_mayor': 'Costo compartido 50% / 50%',
    'seguro_inquilino': 'Certificado en SOP-04',
    'parqueo': 'Permitido a condómino interno',
    'subarriendo': 'Prohibición Absoluta',
    'resolucion_temprana': 'Con aval previo escrito',
    'gastos_notariales': 'Custodia neutral BCCR',
    'arbitraje': 'Cámara de Comercio de Costa Rica',
    'firma_digital': 'Firma avanzada BCCR UTC-6',
    'entrega_llaves': 'Acta fotográfica + inventario',
  };

  /// Valores por key API (lado actual = "Contrapropuesta").
  static const Map<String, String> currentTerms = {
    'renta_mensual': '₡495,000',
    'deposito_garantia': '1 mes (₡495,000)',
    'dia_pago': 'Día 1 de cada mes',
    'incremento_anual': 'IPC Oficial BCCR',
    'plazo_meses': '12 meses forzosos',
    'fecha_inicio': '01 Nov 2025',
    'preaviso_dias': '2 días anticipados',
    'mascotas_permitidas': 'Permitido (1 raza mediana, máx 15kg)',
    'numero_ocupantes': '2 adultos registrados',
    'visitas_propietario': 'Hasta 10 días continuos',
    'servicios_agua': 'A cargo del inquilino (remarcador)',
    'servicios_luz': 'Medidor directo inquilino',
    'servicios_internet': '300 Mbps bonificado',
    'amueblado': 'No provisto',
    'inventario': 'Tanque individual GLP',
    'cuota_mantenimiento': '₡65,000 (Propietario)',
    'mantenimiento_menor': 'Permitido (resane final)',
    'estado_pintura': 'Blanco humo estándar',
    'mejoras': 'Prohibidas',
    'uso_inmueble': 'Sin afluencia pública',
    'mantenimiento_mayor': '100% Inquilino (anual)',
    'seguro_inquilino': 'Certificado en SOP-04',
    'parqueo': 'Estrictamente Prohibido',
    'subarriendo': 'Prohibición Absoluta',
    'resolucion_temprana': 'Con aval previo escrito',
    'gastos_notariales': 'Custodia neutral BCCR',
    'arbitraje': 'Cámara de Comercio de Costa Rica',
    'firma_digital': 'Firma avanzada BCCR UTC-6',
    'entrega_llaves': 'Acta fotográfica + inventario',
  };

  /// Textos visibles por fila que difieren del valor crudo de la key
  /// (filas faceta). Lado base.
  static const Map<int, String> baseOverrides = {
    9: 'No solicitados',
    10: 'Ninguna',
    18: 'Incluida en canon',
    19: '₡65,000 (Propietario)',
    23: '10:00 PM - 7:00 AM',
    26: 'Sin afluencia pública',
    30: 'Habitacional unifamiliar privado no comercial.',
    31: 'Custodia neutral del depósito bancario en entidad fiduciaria calificada BCCR.',
    32: 'Centro de Conciliación y Arbitraje de la Cámara de Comercio de Costa Rica.',
    33: 'Firma electrónica avanzada BCCR respaldada con estampa de tiempo UTC-6.',
    34: 'El primer desembolso fiduciario exige acta fotográfica y firma de inventario.',
  };

  /// Textos visibles por fila que difieren del valor crudo de la key.
  /// Lado contrapropuesta.
  static const Map<int, String> currentOverrides = {
    9: 'No autorizados',
    10: 'Prohibición expresa',
    18: 'Incluida en canon',
    19: '₡65,000 (Propietario)',
    23: '10:00 PM - 7:00 AM',
    26: 'Sin afluencia pública',
    30: 'Habitacional unifamiliar privado no comercial.',
    31: 'Custodia neutral del depósito bancario en entidad fiduciaria calificada BCCR.',
    32: 'Centro de Conciliación y Arbitraje de la Cámara de Comercio de Costa Rica.',
    33: 'Firma electrónica avanzada BCCR respaldada con estampa de tiempo UTC-6.',
    34: 'El primer desembolso fiduciario exige acta fotográfica y firma de inventario.',
  };

  /// Construye el detalle demo (ronda 3 de 5, turno del inquilino porque el
  /// último documento lo redactó el propietario).
  static NegotiationDetail detail({DateTime? now}) {
    final at = now ?? DateTime.now();
    return NegotiationDetail(
      id: id,
      listingId: listingId,
      tenantId: tenantId,
      ownerId: ownerId,
      state: NegotiationState(
        status: NegotiationStatus.contrapropuesta,
        round: 3,
        deadline: at.add(demoRemaining),
      ),
      baseTerms: Map<String, String>.from(baseTerms),
      currentTerms: Map<String, String>.from(currentTerms),
      baseOverrides: Map<int, String>.from(baseOverrides),
      currentOverrides: Map<int, String>.from(currentOverrides),
      lastAuthor: NegotiationParty.owner,
    );
  }

  /// Filas de redacción complementaria (acuerdo aunque el texto difiera:
  /// 9 "No solicitados"/"No autorizados", 10 "Ninguna"/"Prohibición
  /// expresa", 16 "No requerido"/"No provisto", 21 "Neutral"/"Blanco humo").
  static const Set<int> lenientRows = {9, 10, 16, 21};
}
