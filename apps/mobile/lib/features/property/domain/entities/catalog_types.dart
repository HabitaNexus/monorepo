// Catálogo de opciones de la plataforma (tipos del dominio rental-flow).
//
// PROPIEDAD DE HAB-14: este archivo define los tipos referenciados por
// `Property`/`Listing`. Se ubica aquí como placeholder tipado para que
// HAB-13 no bloquee a HAB-14/HAB-15/HAB-18; HAB-14 puede mover/renombrar
// estos tipos siempre que mantenga los nombres de los valores.
//
// Fuente canónica: docs/site/content/docs/sops/flujo-arrendamiento.md,
// tabla "Catálogo de opciones de la plataforma" (Fase 4).
//
// Reconciliación 27 vs 34 (resuelve la duda de HAB-13):
// - El catálogo real tiene 27 filas (campos seleccionables al publicar).
// - El "34" mencionado en openspec/specs/rental-flow/spec.md es un error
//   por conflación: la tabla "Términos negociables" del SOP lista en
//   realidad 33 filas (no 34), y mezcla términos de precio/duración con
//   opciones del catálogo. 27 es la cifra correcta para el catálogo;
//   33 es la cifra correcta para los términos negociables (Fase 4).
// - `Property` cubre las 27 filas del catálogo; `Listing` cubre los
//   rangos de negociación (precio, depósito, duración, no-negociables).
//
// Ley 8968: ningún tipo aquí porta PII; la entidad solo guarda `ownerId`.

/// Tipo de inmueble (7 opciones del catálogo).
enum PropertyType {
  casaIndependiente,
  apartamentoEdificio,
  apartamentoCondominio,
  townhouse,
  casaCondominio,
  estudio,
  cuartoCasaCompartida,
}

/// Tipo de piso (7 opciones).
enum FloorType {
  ceramica,
  porcelanato,
  madera,
  laminado,
  concretoPulido,
  terrazo,
  vinilo,
}

/// Tipo de cielo raso (6 opciones).
enum CeilingType {
  concreto,
  gypsum,
  madera,
  tablilla,
  lamina,
  sinCieloRaso,
}

/// Estado de pintura (4 opciones).
enum PaintCondition {
  reciente,
  buenEstado,
  requiereRetoque,
  sinPintar,
}

/// Tipo de cocina (4 opciones).
enum KitchenType {
  sinAmueblar,
  conMuebles,
  conMueblesYBasicos,
  totalmenteEquipada,
}

/// Proveedor de agua (4 opciones).
enum WaterProvider {
  aya,
  asada,
  pozoPropio,
  otro,
}

/// Tipo de medidor — aplica a agua y electricidad (2 opciones).
enum MeterType {
  individual,
  compartido,
}

/// Método de división de medidor compartido (4 opciones).
enum SharedMeterDivisionMethod {
  equitativa,
  porConsumo,
  montoFijo,
  incluidoEnRenta,
}

/// Tipo de conexión a internet disponible (7 opciones).
enum InternetConnectionType {
  fibraOptica,
  cableCoaxial,
  adsl,
  inalambricoFijo,
  satelital,
  sinCobertura,
  noVerificado,
}

/// Proveedor de internet preinstalado (7 opciones).
enum InternetProvider {
  kolbi,
  tigo,
  claro,
  liberty,
  cabletica,
  otro,
  ninguno,
}

/// Pago de un servicio (internet, cable, teléfono, gas, basura).
/// Una fila del catálogo que se expande a 5 campos tipados en `Property`.
enum ServicePaymentMode {
  incluidoEnRenta,
  porCuentaInquilino,
  noDeseadoPorInquilino,
  noAplica,
}

/// Paquete combinado preinstalado (4 escenarios).
enum ComboPackageOption {
  inquilinoAsumeTodo,
  inquilinoAsumeParcial,
  propietarioCancela,
  propietarioMantieneASuCosto,
}

/// Sistema de agua caliente (8 opciones del catálogo).
enum HotWaterSystem {
  soloAguaFria,
  calentadorElectrico110,
  calentadorElectrico220,
  termoDucha,
  tanqueCentralElectrico,
  tanqueCentralGas,
  panelSolarTermico,
  calderaCentralizada,
}

/// Tipo de estacionamiento (6 opciones).
enum ParkingType {
  techadoExclusivo,
  descubiertoExclusivo,
  compartidoTechado,
  compartidoDescubierto,
  enCalle,
  noDisponible,
}

/// Seguridad del inmueble (multi-selección; 7 opciones).
enum SecurityFeature {
  verjasVentanas,
  portonCandado,
  portonElectrico,
  camaras,
  alarma,
  vigilancia24h,
  ninguna,
}

/// Mascotas: perros (5 opciones).
enum PetDogsPolicy {
  noPermitidos,
  razasPequenas,
  razasMedianas,
  cualquierRaza,
  conRestricciones,
}

/// Mascotas: gatos (3 opciones).
enum PetCatsPolicy {
  noPermitidos,
  soloInterior,
  interiorYExterior,
}

/// Mascotas: otras (6 opciones).
enum PetOtherPolicy {
  noPermitidas,
  aves,
  peces,
  reptiles,
  roedores,
  otro,
}

/// Huéspedes temporales (4 opciones).
enum GuestPolicy {
  noPermitidos,
  conAvisoPrevio,
  sinRestriccion,
  conDuracionMaxima,
}

/// Restricciones de ruido (2 opciones).
enum NoiseRestriction {
  soloLimitesLegales,
  restriccionesAdicionales,
}

/// Modificaciones al inmueble (4 opciones).
enum ModificationPolicy {
  noPermitidas,
  levesConAviso,
  levesYModeradasConAutorizacion,
  todasConAutorizacion,
}

/// Actividad comercial menor (2 opciones).
enum CommercialActivityPolicy {
  noPermitida,
  permitidaConRestricciones,
}

/// Subarriendo de cochera (3 opciones).
enum GarageSubletPolicy {
  noPermitido,
  conAutorizacion,
  libremente,
}

/// Subarriendo parcial de habitaciones (2 opciones).
enum PartialSubletPolicy {
  noPermitido,
  conAutorizacionYLimite,
}

/// Cesión total del contrato (2 opciones).
enum FullAssignmentPolicy {
  noPermitida,
  conAutorizacionEscrita,
}

/// Estado del inmueble (estado físico general declarado al publicar).
enum PropertyCondition {
  excelente,
  buenEstado,
  aceptable,
  requiereReparacion,
}

/// Tipo de espacio dentro de la distribución desglosada.
enum RoomSpaceType {
  dormitorio,
  bano,
  sala,
  comedor,
  cocina,
  pilasLavanderia,
  patio,
  jardin,
  terrazaBalcon,
  cochera,
  bodega,
  otro,
}

/// Formato del video tour (SOP 3.1: al menos uno es obligatorio).
enum VideoTourType {
  grabado,
  enVivo,
}

/// Estado de publicación del [Listing].
enum ListingStatus {
  draft,
  pendingReview,
  active,
  paused,
  rented,
  closed,
}
