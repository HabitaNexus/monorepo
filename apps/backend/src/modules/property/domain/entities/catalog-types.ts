/**
 * Catálogo de opciones de la plataforma (dominio rental-flow).
 *
 * PROPIEDAD DE HAB-14: estos tipos son el espejo TypeScript de
 * `apps/mobile/.../property/domain/entities/catalog_types.dart`.
 * HAB-14 puede moverlos a un módulo compartido siempre que mantenga
 * los valores wire (snake_case).
 *
 * Fuente canónica: docs/site/content/docs/sops/flujo-arrendamiento.md,
 * tabla "Catálogo de opciones de la plataforma" (Fase 4).
 *
 * Reconciliación 27 vs 34: el catálogo real tiene 27 filas; el "34" de
 * openspec/specs/rental-flow/spec.md es una conflación con los términos
 * negociables (que a su vez listan 33 filas reales, no 34).
 * 27 = catálogo (`Property`); 33 = términos negociables (Fase 4).
 *
 * Ley 8968: ningún tipo aquí porta PII; la entidad solo guarda `ownerId`.
 *
 * Los valores de cada enum SON el contrato wire (snake_case) compartido
 * con mobile: `toJSON()` emite el valor tal cual y `fromJSON()` lo valida.
 *
 * Nota de paridad (para HAB-14): mobile hoy serializa enums con Dart
 * `.name` (p. ej. `casaIndependiente`, `pilasLavanderia`), que NO es
 * snake_case en enums multi-palabra. Este backend emite snake_case
 * (`casa_independiente`, `pilas_lavanderia`) según el constraint del
 * ticket. HAB-14 debe normalizar mobile a estos mismos valores wire.
 */

export enum PropertyType {
  CasaIndependiente = 'casa_independiente',
  ApartamentoEdificio = 'apartamento_edificio',
  ApartamentoCondominio = 'apartamento_condominio',
  Townhouse = 'townhouse',
  CasaCondominio = 'casa_condominio',
  Estudio = 'estudio',
  CuartoCasaCompartida = 'cuarto_casa_compartida',
}

export enum FloorType {
  Ceramica = 'ceramica',
  Porcelanato = 'porcelanato',
  Madera = 'madera',
  Laminado = 'laminado',
  ConcretoPulido = 'concreto_pulido',
  Terrazo = 'terrazo',
  Vinilo = 'vinilo',
}

export enum CeilingType {
  Concreto = 'concreto',
  Gypsum = 'gypsum',
  Madera = 'madera',
  Tablilla = 'tablilla',
  Lamina = 'lamina',
  SinCieloRaso = 'sin_cielo_raso',
}

export enum PaintCondition {
  Reciente = 'reciente',
  BuenEstado = 'buen_estado',
  RequiereRetoque = 'requiere_retoque',
  SinPintar = 'sin_pintar',
}

export enum KitchenType {
  SinAmueblar = 'sin_amueblar',
  ConMuebles = 'con_muebles',
  ConMueblesYBasicos = 'con_muebles_y_basicos',
  TotalmenteEquipada = 'totalmente_equipada',
}

export enum WaterProvider {
  Aya = 'aya',
  Asada = 'asada',
  PozoPropio = 'pozo_propio',
  Otro = 'otro',
}

/** Tipo de medidor — aplica a agua y electricidad (2 opciones). */
export enum MeterType {
  Individual = 'individual',
  Compartido = 'compartido',
}

export enum SharedMeterDivisionMethod {
  Equitativa = 'equitativa',
  PorConsumo = 'por_consumo',
  MontoFijo = 'monto_fijo',
  IncluidoEnRenta = 'incluido_en_renta',
}

export enum InternetConnectionType {
  FibraOptica = 'fibra_optica',
  CableCoaxial = 'cable_coaxial',
  Adsl = 'adsl',
  InalambricoFijo = 'inalambrico_fijo',
  Satelital = 'satelital',
  SinCobertura = 'sin_cobertura',
  NoVerificado = 'no_verificado',
}

export enum InternetProvider {
  Kolbi = 'kolbi',
  Tigo = 'tigo',
  Claro = 'claro',
  Liberty = 'liberty',
  Cabletica = 'cabletica',
  Otro = 'otro',
  Ninguno = 'ninguno',
}

/**
 * Pago de un servicio (internet, cable, teléfono, gas, basura).
 * Una fila del catálogo que se expande a 5 campos tipados en `Property`.
 */
export enum ServicePaymentMode {
  IncluidoEnRenta = 'incluido_en_renta',
  PorCuentaInquilino = 'por_cuenta_inquilino',
  NoDeseadoPorInquilino = 'no_deseado_por_inquilino',
  NoAplica = 'no_aplica',
}

export enum ComboPackageOption {
  InquilinoAsumeTodo = 'inquilino_asume_todo',
  InquilinoAsumeParcial = 'inquilino_asume_parcial',
  PropietarioCancela = 'propietario_cancela',
  PropietarioMantieneASuCosto = 'propietario_mantiene_a_su_costo',
}

/** Sistema de agua caliente (8 opciones del catálogo). */
export enum HotWaterSystem {
  SoloAguaFria = 'solo_agua_fria',
  CalentadorElectrico110 = 'calentador_electrico_110v',
  CalentadorElectrico220 = 'calentador_electrico_220v',
  TermoDucha = 'termo_ducha',
  TanqueCentralElectrico = 'tanque_central_electrico',
  TanqueCentralGas = 'tanque_central_gas',
  PanelSolarTermico = 'panel_solar_termico',
  CalderaCentralizada = 'caldera_centralizada',
}

export enum ParkingType {
  TechadoExclusivo = 'techado_exclusivo',
  DescubiertoExclusivo = 'descubierto_exclusivo',
  CompartidoTechado = 'compartido_techado',
  CompartidoDescubierto = 'compartido_descubierto',
  EnCalle = 'en_calle',
  NoDisponible = 'no_disponible',
}

/** Seguridad del inmueble (multi-selección; 7 opciones). */
export enum SecurityFeature {
  VerjasVentanas = 'verjas_ventanas',
  PortonCandado = 'porton_candado',
  PortonElectrico = 'porton_electrico',
  Camaras = 'camaras',
  Alarma = 'alarma',
  Vigilancia24h = 'vigilancia_24h',
  Ninguna = 'ninguna',
}

export enum PetDogsPolicy {
  NoPermitidos = 'no_permitidos',
  RazasPequenas = 'razas_pequenas',
  RazasMedianas = 'razas_medianas',
  CualquierRaza = 'cualquier_raza',
  ConRestricciones = 'con_restricciones',
}

export enum PetCatsPolicy {
  NoPermitidos = 'no_permitidos',
  SoloInterior = 'solo_interior',
  InteriorYExterior = 'interior_y_exterior',
}

export enum PetOtherPolicy {
  NoPermitidas = 'no_permitidas',
  Aves = 'aves',
  Peces = 'peces',
  Reptiles = 'reptiles',
  Roedores = 'roedores',
  Otro = 'otro',
}

export enum GuestPolicy {
  NoPermitidos = 'no_permitidos',
  ConAvisoPrevio = 'con_aviso_previo',
  SinRestriccion = 'sin_restriccion',
  ConDuracionMaxima = 'con_duracion_maxima',
}

export enum NoiseRestriction {
  SoloLimitesLegales = 'solo_limites_legales',
  RestriccionesAdicionales = 'restricciones_adicionales',
}

export enum ModificationPolicy {
  NoPermitidas = 'no_permitidas',
  LevesConAviso = 'leves_con_aviso',
  LevesYModeradasConAutorizacion = 'leves_y_moderadas_con_autorizacion',
  TodasConAutorizacion = 'todas_con_autorizacion',
}

export enum CommercialActivityPolicy {
  NoPermitida = 'no_permitida',
  PermitidaConRestricciones = 'permitida_con_restricciones',
}

export enum GarageSubletPolicy {
  NoPermitido = 'no_permitido',
  ConAutorizacion = 'con_autorizacion',
  Libremente = 'libremente',
}

export enum PartialSubletPolicy {
  NoPermitido = 'no_permitido',
  ConAutorizacionYLimite = 'con_autorizacion_y_limite',
}

export enum FullAssignmentPolicy {
  NoPermitida = 'no_permitida',
  ConAutorizacionEscrita = 'con_autorizacion_escrita',
}

/** Estado físico general del inmueble declarado al publicar. */
export enum PropertyCondition {
  Excelente = 'excelente',
  BuenEstado = 'buen_estado',
  Aceptable = 'aceptable',
  RequiereReparacion = 'requiere_reparacion',
}

/** Tipo de espacio dentro de la distribución desglosada. */
export enum RoomSpaceType {
  Dormitorio = 'dormitorio',
  Bano = 'bano',
  Sala = 'sala',
  Comedor = 'comedor',
  Cocina = 'cocina',
  PilasLavanderia = 'pilas_lavanderia',
  Patio = 'patio',
  Jardin = 'jardin',
  TerrazaBalcon = 'terraza_balcon',
  Cochera = 'cochera',
  Bodega = 'bodega',
  Otro = 'otro',
}

/** Formato del video tour (SOP 3.1: al menos uno es obligatorio). */
export enum VideoTourType {
  Grabado = 'grabado',
  EnVivo = 'en_vivo',
}

/** Estado de publicación del `Listing`. */
export enum ListingStatus {
  Draft = 'draft',
  PendingReview = 'pending_review',
  Active = 'active',
  Paused = 'paused',
  Rented = 'rented',
  Closed = 'closed',
}
