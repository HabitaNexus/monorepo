"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ListingStatus = exports.VideoTourType = exports.RoomSpaceType = exports.PropertyCondition = exports.FullAssignmentPolicy = exports.PartialSubletPolicy = exports.GarageSubletPolicy = exports.CommercialActivityPolicy = exports.ModificationPolicy = exports.NoiseRestriction = exports.GuestPolicy = exports.PetOtherPolicy = exports.PetCatsPolicy = exports.PetDogsPolicy = exports.SecurityFeature = exports.ParkingType = exports.HotWaterSystem = exports.ComboPackageOption = exports.ServicePaymentMode = exports.InternetProvider = exports.InternetConnectionType = exports.SharedMeterDivisionMethod = exports.MeterType = exports.WaterProvider = exports.KitchenType = exports.PaintCondition = exports.CeilingType = exports.FloorType = exports.PropertyType = void 0;
var PropertyType;
(function (PropertyType) {
    PropertyType["CasaIndependiente"] = "casa_independiente";
    PropertyType["ApartamentoEdificio"] = "apartamento_edificio";
    PropertyType["ApartamentoCondominio"] = "apartamento_condominio";
    PropertyType["Townhouse"] = "townhouse";
    PropertyType["CasaCondominio"] = "casa_condominio";
    PropertyType["Estudio"] = "estudio";
    PropertyType["CuartoCasaCompartida"] = "cuarto_casa_compartida";
})(PropertyType || (exports.PropertyType = PropertyType = {}));
var FloorType;
(function (FloorType) {
    FloorType["Ceramica"] = "ceramica";
    FloorType["Porcelanato"] = "porcelanato";
    FloorType["Madera"] = "madera";
    FloorType["Laminado"] = "laminado";
    FloorType["ConcretoPulido"] = "concreto_pulido";
    FloorType["Terrazo"] = "terrazo";
    FloorType["Vinilo"] = "vinilo";
})(FloorType || (exports.FloorType = FloorType = {}));
var CeilingType;
(function (CeilingType) {
    CeilingType["Concreto"] = "concreto";
    CeilingType["Gypsum"] = "gypsum";
    CeilingType["Madera"] = "madera";
    CeilingType["Tablilla"] = "tablilla";
    CeilingType["Lamina"] = "lamina";
    CeilingType["SinCieloRaso"] = "sin_cielo_raso";
})(CeilingType || (exports.CeilingType = CeilingType = {}));
var PaintCondition;
(function (PaintCondition) {
    PaintCondition["Reciente"] = "reciente";
    PaintCondition["BuenEstado"] = "buen_estado";
    PaintCondition["RequiereRetoque"] = "requiere_retoque";
    PaintCondition["SinPintar"] = "sin_pintar";
})(PaintCondition || (exports.PaintCondition = PaintCondition = {}));
var KitchenType;
(function (KitchenType) {
    KitchenType["SinAmueblar"] = "sin_amueblar";
    KitchenType["ConMuebles"] = "con_muebles";
    KitchenType["ConMueblesYBasicos"] = "con_muebles_y_basicos";
    KitchenType["TotalmenteEquipada"] = "totalmente_equipada";
})(KitchenType || (exports.KitchenType = KitchenType = {}));
var WaterProvider;
(function (WaterProvider) {
    WaterProvider["Aya"] = "aya";
    WaterProvider["Asada"] = "asada";
    WaterProvider["PozoPropio"] = "pozo_propio";
    WaterProvider["Otro"] = "otro";
})(WaterProvider || (exports.WaterProvider = WaterProvider = {}));
var MeterType;
(function (MeterType) {
    MeterType["Individual"] = "individual";
    MeterType["Compartido"] = "compartido";
})(MeterType || (exports.MeterType = MeterType = {}));
var SharedMeterDivisionMethod;
(function (SharedMeterDivisionMethod) {
    SharedMeterDivisionMethod["Equitativa"] = "equitativa";
    SharedMeterDivisionMethod["PorConsumo"] = "por_consumo";
    SharedMeterDivisionMethod["MontoFijo"] = "monto_fijo";
    SharedMeterDivisionMethod["IncluidoEnRenta"] = "incluido_en_renta";
})(SharedMeterDivisionMethod || (exports.SharedMeterDivisionMethod = SharedMeterDivisionMethod = {}));
var InternetConnectionType;
(function (InternetConnectionType) {
    InternetConnectionType["FibraOptica"] = "fibra_optica";
    InternetConnectionType["CableCoaxial"] = "cable_coaxial";
    InternetConnectionType["Adsl"] = "adsl";
    InternetConnectionType["InalambricoFijo"] = "inalambrico_fijo";
    InternetConnectionType["Satelital"] = "satelital";
    InternetConnectionType["SinCobertura"] = "sin_cobertura";
    InternetConnectionType["NoVerificado"] = "no_verificado";
})(InternetConnectionType || (exports.InternetConnectionType = InternetConnectionType = {}));
var InternetProvider;
(function (InternetProvider) {
    InternetProvider["Kolbi"] = "kolbi";
    InternetProvider["Tigo"] = "tigo";
    InternetProvider["Claro"] = "claro";
    InternetProvider["Liberty"] = "liberty";
    InternetProvider["Cabletica"] = "cabletica";
    InternetProvider["Otro"] = "otro";
    InternetProvider["Ninguno"] = "ninguno";
})(InternetProvider || (exports.InternetProvider = InternetProvider = {}));
var ServicePaymentMode;
(function (ServicePaymentMode) {
    ServicePaymentMode["IncluidoEnRenta"] = "incluido_en_renta";
    ServicePaymentMode["PorCuentaInquilino"] = "por_cuenta_inquilino";
    ServicePaymentMode["NoDeseadoPorInquilino"] = "no_deseado_por_inquilino";
    ServicePaymentMode["NoAplica"] = "no_aplica";
})(ServicePaymentMode || (exports.ServicePaymentMode = ServicePaymentMode = {}));
var ComboPackageOption;
(function (ComboPackageOption) {
    ComboPackageOption["InquilinoAsumeTodo"] = "inquilino_asume_todo";
    ComboPackageOption["InquilinoAsumeParcial"] = "inquilino_asume_parcial";
    ComboPackageOption["PropietarioCancela"] = "propietario_cancela";
    ComboPackageOption["PropietarioMantieneASuCosto"] = "propietario_mantiene_a_su_costo";
})(ComboPackageOption || (exports.ComboPackageOption = ComboPackageOption = {}));
var HotWaterSystem;
(function (HotWaterSystem) {
    HotWaterSystem["SoloAguaFria"] = "solo_agua_fria";
    HotWaterSystem["CalentadorElectrico110"] = "calentador_electrico_110v";
    HotWaterSystem["CalentadorElectrico220"] = "calentador_electrico_220v";
    HotWaterSystem["TermoDucha"] = "termo_ducha";
    HotWaterSystem["TanqueCentralElectrico"] = "tanque_central_electrico";
    HotWaterSystem["TanqueCentralGas"] = "tanque_central_gas";
    HotWaterSystem["PanelSolarTermico"] = "panel_solar_termico";
    HotWaterSystem["CalderaCentralizada"] = "caldera_centralizada";
})(HotWaterSystem || (exports.HotWaterSystem = HotWaterSystem = {}));
var ParkingType;
(function (ParkingType) {
    ParkingType["TechadoExclusivo"] = "techado_exclusivo";
    ParkingType["DescubiertoExclusivo"] = "descubierto_exclusivo";
    ParkingType["CompartidoTechado"] = "compartido_techado";
    ParkingType["CompartidoDescubierto"] = "compartido_descubierto";
    ParkingType["EnCalle"] = "en_calle";
    ParkingType["NoDisponible"] = "no_disponible";
})(ParkingType || (exports.ParkingType = ParkingType = {}));
var SecurityFeature;
(function (SecurityFeature) {
    SecurityFeature["VerjasVentanas"] = "verjas_ventanas";
    SecurityFeature["PortonCandado"] = "porton_candado";
    SecurityFeature["PortonElectrico"] = "porton_electrico";
    SecurityFeature["Camaras"] = "camaras";
    SecurityFeature["Alarma"] = "alarma";
    SecurityFeature["Vigilancia24h"] = "vigilancia_24h";
    SecurityFeature["Ninguna"] = "ninguna";
})(SecurityFeature || (exports.SecurityFeature = SecurityFeature = {}));
var PetDogsPolicy;
(function (PetDogsPolicy) {
    PetDogsPolicy["NoPermitidos"] = "no_permitidos";
    PetDogsPolicy["RazasPequenas"] = "razas_pequenas";
    PetDogsPolicy["RazasMedianas"] = "razas_medianas";
    PetDogsPolicy["CualquierRaza"] = "cualquier_raza";
    PetDogsPolicy["ConRestricciones"] = "con_restricciones";
})(PetDogsPolicy || (exports.PetDogsPolicy = PetDogsPolicy = {}));
var PetCatsPolicy;
(function (PetCatsPolicy) {
    PetCatsPolicy["NoPermitidos"] = "no_permitidos";
    PetCatsPolicy["SoloInterior"] = "solo_interior";
    PetCatsPolicy["InteriorYExterior"] = "interior_y_exterior";
})(PetCatsPolicy || (exports.PetCatsPolicy = PetCatsPolicy = {}));
var PetOtherPolicy;
(function (PetOtherPolicy) {
    PetOtherPolicy["NoPermitidas"] = "no_permitidas";
    PetOtherPolicy["Aves"] = "aves";
    PetOtherPolicy["Peces"] = "peces";
    PetOtherPolicy["Reptiles"] = "reptiles";
    PetOtherPolicy["Roedores"] = "roedores";
    PetOtherPolicy["Otro"] = "otro";
})(PetOtherPolicy || (exports.PetOtherPolicy = PetOtherPolicy = {}));
var GuestPolicy;
(function (GuestPolicy) {
    GuestPolicy["NoPermitidos"] = "no_permitidos";
    GuestPolicy["ConAvisoPrevio"] = "con_aviso_previo";
    GuestPolicy["SinRestriccion"] = "sin_restriccion";
    GuestPolicy["ConDuracionMaxima"] = "con_duracion_maxima";
})(GuestPolicy || (exports.GuestPolicy = GuestPolicy = {}));
var NoiseRestriction;
(function (NoiseRestriction) {
    NoiseRestriction["SoloLimitesLegales"] = "solo_limites_legales";
    NoiseRestriction["RestriccionesAdicionales"] = "restricciones_adicionales";
})(NoiseRestriction || (exports.NoiseRestriction = NoiseRestriction = {}));
var ModificationPolicy;
(function (ModificationPolicy) {
    ModificationPolicy["NoPermitidas"] = "no_permitidas";
    ModificationPolicy["LevesConAviso"] = "leves_con_aviso";
    ModificationPolicy["LevesYModeradasConAutorizacion"] = "leves_y_moderadas_con_autorizacion";
    ModificationPolicy["TodasConAutorizacion"] = "todas_con_autorizacion";
})(ModificationPolicy || (exports.ModificationPolicy = ModificationPolicy = {}));
var CommercialActivityPolicy;
(function (CommercialActivityPolicy) {
    CommercialActivityPolicy["NoPermitida"] = "no_permitida";
    CommercialActivityPolicy["PermitidaConRestricciones"] = "permitida_con_restricciones";
})(CommercialActivityPolicy || (exports.CommercialActivityPolicy = CommercialActivityPolicy = {}));
var GarageSubletPolicy;
(function (GarageSubletPolicy) {
    GarageSubletPolicy["NoPermitido"] = "no_permitido";
    GarageSubletPolicy["ConAutorizacion"] = "con_autorizacion";
    GarageSubletPolicy["Libremente"] = "libremente";
})(GarageSubletPolicy || (exports.GarageSubletPolicy = GarageSubletPolicy = {}));
var PartialSubletPolicy;
(function (PartialSubletPolicy) {
    PartialSubletPolicy["NoPermitido"] = "no_permitido";
    PartialSubletPolicy["ConAutorizacionYLimite"] = "con_autorizacion_y_limite";
})(PartialSubletPolicy || (exports.PartialSubletPolicy = PartialSubletPolicy = {}));
var FullAssignmentPolicy;
(function (FullAssignmentPolicy) {
    FullAssignmentPolicy["NoPermitida"] = "no_permitida";
    FullAssignmentPolicy["ConAutorizacionEscrita"] = "con_autorizacion_escrita";
})(FullAssignmentPolicy || (exports.FullAssignmentPolicy = FullAssignmentPolicy = {}));
var PropertyCondition;
(function (PropertyCondition) {
    PropertyCondition["Excelente"] = "excelente";
    PropertyCondition["BuenEstado"] = "buen_estado";
    PropertyCondition["Aceptable"] = "aceptable";
    PropertyCondition["RequiereReparacion"] = "requiere_reparacion";
})(PropertyCondition || (exports.PropertyCondition = PropertyCondition = {}));
var RoomSpaceType;
(function (RoomSpaceType) {
    RoomSpaceType["Dormitorio"] = "dormitorio";
    RoomSpaceType["Bano"] = "bano";
    RoomSpaceType["Sala"] = "sala";
    RoomSpaceType["Comedor"] = "comedor";
    RoomSpaceType["Cocina"] = "cocina";
    RoomSpaceType["PilasLavanderia"] = "pilas_lavanderia";
    RoomSpaceType["Patio"] = "patio";
    RoomSpaceType["Jardin"] = "jardin";
    RoomSpaceType["TerrazaBalcon"] = "terraza_balcon";
    RoomSpaceType["Cochera"] = "cochera";
    RoomSpaceType["Bodega"] = "bodega";
    RoomSpaceType["Otro"] = "otro";
})(RoomSpaceType || (exports.RoomSpaceType = RoomSpaceType = {}));
var VideoTourType;
(function (VideoTourType) {
    VideoTourType["Grabado"] = "grabado";
    VideoTourType["EnVivo"] = "en_vivo";
})(VideoTourType || (exports.VideoTourType = VideoTourType = {}));
var ListingStatus;
(function (ListingStatus) {
    ListingStatus["Draft"] = "draft";
    ListingStatus["PendingReview"] = "pending_review";
    ListingStatus["Active"] = "active";
    ListingStatus["Paused"] = "paused";
    ListingStatus["Rented"] = "rented";
    ListingStatus["Closed"] = "closed";
})(ListingStatus || (exports.ListingStatus = ListingStatus = {}));
//# sourceMappingURL=catalog-types.js.map