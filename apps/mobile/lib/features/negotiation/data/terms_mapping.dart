/// Tabla de mapeo etiqueta UI (español) ↔ key API (HAB-27).
///
/// Fuente UI: `docs/design/hab27/propuesta-contrapropuesta.html` (34 filas
/// numeradas en 7 grupos). Fuente API: catálogo `TERMS_CATALOG` de
/// `apps/backend/src/negotiation/domain/terms.ts` (34 keys snake_case).
///
/// El catálogo API y el diseño no son biyectivos: varias filas UI son
/// facetas de una misma key (p. ej. caninos/felinos/exóticas comparten
/// `mascotas_permitidas`) y otras usan la key más cercana con nota
/// `aprox`. Las keys sin fila propia en esta demo se listan en
/// [kApiKeysWithoutDemoRow] con el motivo.
library;

/// Grupos de términos tal como los presenta el diseño (7 grupos, 34 filas).
enum NegotiationTermGroup {
  economicos,
  plazo,
  mascotas,
  servicios,
  modificaciones,
  usos,
  fijas,
}

/// Metadatos de presentación de cada grupo (el icono lo resuelve la capa
/// de presentación; aquí solo viaja el identificador).
extension NegotiationTermGroupMeta on NegotiationTermGroup {
  String get id => name;

  String get title {
    switch (this) {
      case NegotiationTermGroup.economicos:
        return '1. Económicos & Pagos';
      case NegotiationTermGroup.plazo:
        return '2. Plazo & Fechas';
      case NegotiationTermGroup.mascotas:
        return '3. Mascotas & Cohabitantes';
      case NegotiationTermGroup.servicios:
        return '4. Servicios & Suministros';
      case NegotiationTermGroup.modificaciones:
        return '5. Modificaciones & Convivencia';
      case NegotiationTermGroup.usos:
        return '6. Usos, Subarriendo & Cesión';
      case NegotiationTermGroup.fijas:
        return '7. Cláusulas Fiduciarias Obligatorias';
    }
  }

  /// Número de filas del diseño por grupo: 4 + 3 + 5 + 7 + 6 + 4 + 5 = 34.
  int get expectedTerms {
    switch (this) {
      case NegotiationTermGroup.economicos:
        return 4;
      case NegotiationTermGroup.plazo:
        return 3;
      case NegotiationTermGroup.mascotas:
        return 5;
      case NegotiationTermGroup.servicios:
        return 7;
      case NegotiationTermGroup.modificaciones:
        return 6;
      case NegotiationTermGroup.usos:
        return 4;
      case NegotiationTermGroup.fijas:
        return 5;
    }
  }
}

/// Una fila del comparador: etiqueta UI ↔ key del documento de términos API.
class TermMapping {
  /// Número de fila del diseño (1-34).
  final int number;

  /// Etiqueta en español tal como aparece en el diseño Stitch.
  final String uiLabel;

  /// Key snake_case del catálogo API (`TERMS_CATALOG`).
  final String apiKey;

  final NegotiationTermGroup group;

  /// true para las 5 cláusulas fijas SOP (solo lectura, no negociables).
  final bool isFixed;

  /// Referencia SOP para cláusulas fijas (p. ej. "SOP 4.1").
  final String? sopRef;

  /// Aclaración cuando la key es aproximada o una faceta compartida.
  final String? note;

  const TermMapping({
    required this.number,
    required this.uiLabel,
    required this.apiKey,
    required this.group,
    this.isFixed = false,
    this.sopRef,
    this.note,
  });
}

/// Las 34 filas del diseño mapeadas a keys API.
const List<TermMapping> kTermsMapping = [
  // 1. Económicos & Pagos (4)
  TermMapping(
      number: 1,
      uiLabel: 'Precio Mensual del Canon',
      apiKey: 'renta_mensual',
      group: NegotiationTermGroup.economicos),
  TermMapping(
      number: 2,
      uiLabel: 'Depósito en Garantía (Escrow)',
      apiKey: 'deposito_garantia',
      group: NegotiationTermGroup.economicos),
  TermMapping(
      number: 3,
      uiLabel: 'Día de Pago Exigible',
      apiKey: 'dia_pago',
      group: NegotiationTermGroup.economicos),
  TermMapping(
      number: 4,
      uiLabel: 'Reajuste Anual Inflacionario',
      apiKey: 'incremento_anual',
      group: NegotiationTermGroup.economicos),
  // 2. Plazo & Fechas (3)
  TermMapping(
      number: 5,
      uiLabel: 'Duración del Contrato',
      apiKey: 'plazo_meses',
      group: NegotiationTermGroup.plazo,
      note: 'fecha_fin se deriva: fecha_inicio + plazo_meses'),
  TermMapping(
      number: 6,
      uiLabel: 'Fecha de Entrega y Posesión',
      apiKey: 'fecha_inicio',
      group: NegotiationTermGroup.plazo),
  TermMapping(
      number: 7,
      uiLabel: 'Periodo de Gracia para Mudanza',
      apiKey: 'preaviso_dias',
      group: NegotiationTermGroup.plazo,
      note: 'aprox: ambas son conteos de días del cronograma'),
  // 3. Mascotas & Cohabitantes (5)
  TermMapping(
      number: 8,
      uiLabel: 'Tenencia de Caninos',
      apiKey: 'mascotas_permitidas',
      group: NegotiationTermGroup.mascotas),
  TermMapping(
      number: 9,
      uiLabel: 'Felinos / Gatos',
      apiKey: 'mascotas_permitidas',
      group: NegotiationTermGroup.mascotas,
      note: 'faceta de mascotas_permitidas'),
  TermMapping(
      number: 10,
      uiLabel: 'Fauna Exótica u Otras Especies',
      apiKey: 'mascotas_permitidas',
      group: NegotiationTermGroup.mascotas,
      note: 'faceta de mascotas_permitidas'),
  TermMapping(
      number: 11,
      uiLabel: 'Cohabitantes Adultos Permanentes',
      apiKey: 'numero_ocupantes',
      group: NegotiationTermGroup.mascotas),
  TermMapping(
      number: 12,
      uiLabel: 'Límite de Huéspedes Temporales',
      apiKey: 'visitas_propietario',
      group: NegotiationTermGroup.mascotas,
      note: 'aprox: régimen de visitas y estancias temporales'),
  // 4. Servicios & Suministros (7)
  TermMapping(
      number: 13,
      uiLabel: 'Agua Potable (AyA / Medidor)',
      apiKey: 'servicios_agua',
      group: NegotiationTermGroup.servicios),
  TermMapping(
      number: 14,
      uiLabel: 'Electricidad (CNFL)',
      apiKey: 'servicios_luz',
      group: NegotiationTermGroup.servicios),
  TermMapping(
      number: 15,
      uiLabel: 'Internet Fibra Óptica',
      apiKey: 'servicios_internet',
      group: NegotiationTermGroup.servicios),
  TermMapping(
      number: 16,
      uiLabel: 'Televisión por Cable',
      apiKey: 'amueblado',
      group: NegotiationTermGroup.servicios,
      note: 'aprox: equipamiento provisto con el inmueble'),
  TermMapping(
      number: 17,
      uiLabel: 'Suministro de Gas para Cocina',
      apiKey: 'inventario',
      group: NegotiationTermGroup.servicios,
      note: 'aprox: tanque GLP individual registrado en inventario'),
  TermMapping(
      number: 18,
      uiLabel: 'Cuota Municipal de Desechos',
      apiKey: 'cuota_mantenimiento',
      group: NegotiationTermGroup.servicios,
      note: 'faceta de cuota_mantenimiento: cuotas recurrentes'),
  TermMapping(
      number: 19,
      uiLabel: 'Cuota Condominal (HOA)',
      apiKey: 'cuota_mantenimiento',
      group: NegotiationTermGroup.servicios,
      note: 'faceta de cuota_mantenimiento: cuotas recurrentes'),
  // 5. Modificaciones & Convivencia (6)
  TermMapping(
      number: 20,
      uiLabel: 'Fijación de Cuadros y Taladro',
      apiKey: 'mantenimiento_menor',
      group: NegotiationTermGroup.modificaciones,
      note: 'aprox: intervenciones menores con resane final'),
  TermMapping(
      number: 21,
      uiLabel: 'Pintura de Paredes Interiores',
      apiKey: 'estado_pintura',
      group: NegotiationTermGroup.modificaciones),
  TermMapping(
      number: 22,
      uiLabel: 'Modificaciones Estructurales',
      apiKey: 'mejoras',
      group: NegotiationTermGroup.modificaciones,
      note: 'aprox inversa: mejoras prohibidas sin aval'),
  TermMapping(
      number: 23,
      uiLabel: 'Régimen de Silencio Condominal',
      apiKey: 'uso_inmueble',
      group: NegotiationTermGroup.modificaciones,
      note: 'aprox: reglas de convivencia derivadas del uso permitido'),
  TermMapping(
      number: 24,
      uiLabel: 'Mantenimiento Preventivo A/C',
      apiKey: 'mantenimiento_mayor',
      group: NegotiationTermGroup.modificaciones,
      note: 'aprox: mantenimiento de equipos fijos del inmueble'),
  TermMapping(
      number: 25,
      uiLabel: 'Inspección Calentador de Agua',
      apiKey: 'seguro_inquilino',
      group: NegotiationTermGroup.modificaciones,
      note: 'aprox: cobertura y certificación verificadas en SOP-04'),
  // 6. Usos, Subarriendo & Cesión (4)
  TermMapping(
      number: 26,
      uiLabel: 'Teletrabajo y Home Office',
      apiKey: 'uso_inmueble',
      group: NegotiationTermGroup.usos,
      note: 'faceta de uso_inmueble'),
  TermMapping(
      number: 27,
      uiLabel: 'Cesión / Subarriendo de Cochera',
      apiKey: 'parqueo',
      group: NegotiationTermGroup.usos),
  TermMapping(
      number: 28,
      uiLabel: 'Subarriendo Total / Airbnb',
      apiKey: 'subarriendo',
      group: NegotiationTermGroup.usos),
  TermMapping(
      number: 29,
      uiLabel: 'Cesión Contractual de Posición',
      apiKey: 'resolucion_temprana',
      group: NegotiationTermGroup.usos,
      note: 'aprox: mecanismos de salida y traspaso contractual'),
  // 7. Cláusulas Fiduciarias Obligatorias (5, solo lectura)
  TermMapping(
      number: 30,
      uiLabel: 'Destino de Uso Exclusivo',
      apiKey: 'uso_inmueble',
      group: NegotiationTermGroup.fijas,
      isFixed: true,
      sopRef: 'SOP 4.1'),
  TermMapping(
      number: 31,
      uiLabel: 'Fideicomiso Escrow Segregado',
      apiKey: 'gastos_notariales',
      group: NegotiationTermGroup.fijas,
      isFixed: true,
      sopRef: 'SOP 4.2',
      note: 'aprox: costos de cierre y custodia fiduciaria BCCR'),
  TermMapping(
      number: 32,
      uiLabel: 'Cláusula Compromisoria Arbitral',
      apiKey: 'arbitraje',
      group: NegotiationTermGroup.fijas,
      isFixed: true,
      sopRef: 'SOP 4.3'),
  TermMapping(
      number: 33,
      uiLabel: 'Fe de Fechas y Validez Digital',
      apiKey: 'firma_digital',
      group: NegotiationTermGroup.fijas,
      isFixed: true,
      sopRef: 'SOP 4.4'),
  TermMapping(
      number: 34,
      uiLabel: 'Entrega Pericial Condicionante',
      apiKey: 'entrega_llaves',
      group: NegotiationTermGroup.fijas,
      isFixed: true,
      sopRef: 'SOP 4.5'),
];

/// Keys del catálogo API sin fila propia en la UI demo y el motivo.
const Map<String, String> kApiKeysWithoutDemoRow = {
  'moneda': 'fija en ₡ (colón costarricense) en esta demo',
  'penalidad_mora': 'cubierta por defecto en SOP-04, sin fila en el diseño',
  'renovacion_automatica': 'suplida por la cláusula de prórroga expresa (HAB-29)',
  'fecha_fin': 'derivada: fecha_inicio + plazo_meses (ver fila 5)',
  'jardineria': 'sin fila en el diseño; se rige por reglamento condominial',
};

/// Catálogo API completo (espejo de `TERMS_CATALOG` en el backend).
const Set<String> kApiTermsCatalog = {
  'renta_mensual',
  'deposito_garantia',
  'plazo_meses',
  'fecha_inicio',
  'fecha_fin',
  'dia_pago',
  'moneda',
  'incremento_anual',
  'mascotas_permitidas',
  'numero_ocupantes',
  'uso_inmueble',
  'mantenimiento_menor',
  'mantenimiento_mayor',
  'servicios_agua',
  'servicios_luz',
  'servicios_internet',
  'cuota_mantenimiento',
  'parqueo',
  'amueblado',
  'inventario',
  'penalidad_mora',
  'preaviso_dias',
  'renovacion_automatica',
  'subarriendo',
  'mejoras',
  'visitas_propietario',
  'seguro_inquilino',
  'gastos_notariales',
  'firma_digital',
  'entrega_llaves',
  'estado_pintura',
  'jardineria',
  'arbitraje',
  'resolucion_temprana',
};
