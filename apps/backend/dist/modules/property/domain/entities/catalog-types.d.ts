export declare enum PropertyType {
    CasaIndependiente = "casa_independiente",
    ApartamentoEdificio = "apartamento_edificio",
    ApartamentoCondominio = "apartamento_condominio",
    Townhouse = "townhouse",
    CasaCondominio = "casa_condominio",
    Estudio = "estudio",
    CuartoCasaCompartida = "cuarto_casa_compartida"
}
export declare enum FloorType {
    Ceramica = "ceramica",
    Porcelanato = "porcelanato",
    Madera = "madera",
    Laminado = "laminado",
    ConcretoPulido = "concreto_pulido",
    Terrazo = "terrazo",
    Vinilo = "vinilo"
}
export declare enum CeilingType {
    Concreto = "concreto",
    Gypsum = "gypsum",
    Madera = "madera",
    Tablilla = "tablilla",
    Lamina = "lamina",
    SinCieloRaso = "sin_cielo_raso"
}
export declare enum PaintCondition {
    Reciente = "reciente",
    BuenEstado = "buen_estado",
    RequiereRetoque = "requiere_retoque",
    SinPintar = "sin_pintar"
}
export declare enum KitchenType {
    SinAmueblar = "sin_amueblar",
    ConMuebles = "con_muebles",
    ConMueblesYBasicos = "con_muebles_y_basicos",
    TotalmenteEquipada = "totalmente_equipada"
}
export declare enum WaterProvider {
    Aya = "aya",
    Asada = "asada",
    PozoPropio = "pozo_propio",
    Otro = "otro"
}
export declare enum MeterType {
    Individual = "individual",
    Compartido = "compartido"
}
export declare enum SharedMeterDivisionMethod {
    Equitativa = "equitativa",
    PorConsumo = "por_consumo",
    MontoFijo = "monto_fijo",
    IncluidoEnRenta = "incluido_en_renta"
}
export declare enum InternetConnectionType {
    FibraOptica = "fibra_optica",
    CableCoaxial = "cable_coaxial",
    Adsl = "adsl",
    InalambricoFijo = "inalambrico_fijo",
    Satelital = "satelital",
    SinCobertura = "sin_cobertura",
    NoVerificado = "no_verificado"
}
export declare enum InternetProvider {
    Kolbi = "kolbi",
    Tigo = "tigo",
    Claro = "claro",
    Liberty = "liberty",
    Cabletica = "cabletica",
    Otro = "otro",
    Ninguno = "ninguno"
}
export declare enum ServicePaymentMode {
    IncluidoEnRenta = "incluido_en_renta",
    PorCuentaInquilino = "por_cuenta_inquilino",
    NoDeseadoPorInquilino = "no_deseado_por_inquilino",
    NoAplica = "no_aplica"
}
export declare enum ComboPackageOption {
    InquilinoAsumeTodo = "inquilino_asume_todo",
    InquilinoAsumeParcial = "inquilino_asume_parcial",
    PropietarioCancela = "propietario_cancela",
    PropietarioMantieneASuCosto = "propietario_mantiene_a_su_costo"
}
export declare enum HotWaterSystem {
    SoloAguaFria = "solo_agua_fria",
    CalentadorElectrico110 = "calentador_electrico_110v",
    CalentadorElectrico220 = "calentador_electrico_220v",
    TermoDucha = "termo_ducha",
    TanqueCentralElectrico = "tanque_central_electrico",
    TanqueCentralGas = "tanque_central_gas",
    PanelSolarTermico = "panel_solar_termico",
    CalderaCentralizada = "caldera_centralizada"
}
export declare enum ParkingType {
    TechadoExclusivo = "techado_exclusivo",
    DescubiertoExclusivo = "descubierto_exclusivo",
    CompartidoTechado = "compartido_techado",
    CompartidoDescubierto = "compartido_descubierto",
    EnCalle = "en_calle",
    NoDisponible = "no_disponible"
}
export declare enum SecurityFeature {
    VerjasVentanas = "verjas_ventanas",
    PortonCandado = "porton_candado",
    PortonElectrico = "porton_electrico",
    Camaras = "camaras",
    Alarma = "alarma",
    Vigilancia24h = "vigilancia_24h",
    Ninguna = "ninguna"
}
export declare enum PetDogsPolicy {
    NoPermitidos = "no_permitidos",
    RazasPequenas = "razas_pequenas",
    RazasMedianas = "razas_medianas",
    CualquierRaza = "cualquier_raza",
    ConRestricciones = "con_restricciones"
}
export declare enum PetCatsPolicy {
    NoPermitidos = "no_permitidos",
    SoloInterior = "solo_interior",
    InteriorYExterior = "interior_y_exterior"
}
export declare enum PetOtherPolicy {
    NoPermitidas = "no_permitidas",
    Aves = "aves",
    Peces = "peces",
    Reptiles = "reptiles",
    Roedores = "roedores",
    Otro = "otro"
}
export declare enum GuestPolicy {
    NoPermitidos = "no_permitidos",
    ConAvisoPrevio = "con_aviso_previo",
    SinRestriccion = "sin_restriccion",
    ConDuracionMaxima = "con_duracion_maxima"
}
export declare enum NoiseRestriction {
    SoloLimitesLegales = "solo_limites_legales",
    RestriccionesAdicionales = "restricciones_adicionales"
}
export declare enum ModificationPolicy {
    NoPermitidas = "no_permitidas",
    LevesConAviso = "leves_con_aviso",
    LevesYModeradasConAutorizacion = "leves_y_moderadas_con_autorizacion",
    TodasConAutorizacion = "todas_con_autorizacion"
}
export declare enum CommercialActivityPolicy {
    NoPermitida = "no_permitida",
    PermitidaConRestricciones = "permitida_con_restricciones"
}
export declare enum GarageSubletPolicy {
    NoPermitido = "no_permitido",
    ConAutorizacion = "con_autorizacion",
    Libremente = "libremente"
}
export declare enum PartialSubletPolicy {
    NoPermitido = "no_permitido",
    ConAutorizacionYLimite = "con_autorizacion_y_limite"
}
export declare enum FullAssignmentPolicy {
    NoPermitida = "no_permitida",
    ConAutorizacionEscrita = "con_autorizacion_escrita"
}
export declare enum PropertyCondition {
    Excelente = "excelente",
    BuenEstado = "buen_estado",
    Aceptable = "aceptable",
    RequiereReparacion = "requiere_reparacion"
}
export declare enum RoomSpaceType {
    Dormitorio = "dormitorio",
    Bano = "bano",
    Sala = "sala",
    Comedor = "comedor",
    Cocina = "cocina",
    PilasLavanderia = "pilas_lavanderia",
    Patio = "patio",
    Jardin = "jardin",
    TerrazaBalcon = "terraza_balcon",
    Cochera = "cochera",
    Bodega = "bodega",
    Otro = "otro"
}
export declare enum VideoTourType {
    Grabado = "grabado",
    EnVivo = "en_vivo"
}
export declare enum ListingStatus {
    Draft = "draft",
    PendingReview = "pending_review",
    Active = "active",
    Paused = "paused",
    Rented = "rented",
    Closed = "closed"
}
