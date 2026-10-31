import 'package:equatable/equatable.dart';

import 'catalog_types.dart';
import 'room_space.dart';

T? _enumFromName<T extends Enum>(List<T> values, Object? raw) {
  if (raw == null) return null;
  return values.byName(raw as String);
}

/// Entidad de dominio para un inmueble en arriendo (fase 1: Listado).
///
/// Cubre los datos obligatorios del SOP (ubicación, distribución
/// desglosada con dimensiones, estado, servicios, video tour) más las
/// 27 filas del catálogo de opciones (Fase 4). Cada campo del catálogo
/// usa un tipo de [catalog_types.dart] (propiedad de HAB-14), nunca
/// `String` sueltos.
///
/// Reconciliación 27 vs 34: el catálogo canónico tiene 27 filas; el
/// "34" del spec es una conflación con los términos negociables
/// (que a su vez listan 33 filas reales, no 34). Ver `catalog_types.dart`.
///
/// Sin PII del propietario embebida (solo [ownerId]) — Ley 8968.
class Property extends Equatable {
  final String id;
  final String ownerId;

  // Clasificación y acabados (catálogo filas 1-5 + estado).
  final PropertyType propertyType;
  final FloorType? floorType;
  final CeilingType? ceilingType;
  final PaintCondition? paintCondition;
  final KitchenType? kitchenType;
  final PropertyCondition? condition;
  final String? permittedUse;

  // Distribución desglosada y áreas.
  final List<RoomSpace> spaces;
  final double? totalAreaM2;
  final String? sharedCommonAreas;

  // Agua / electricidad (catálogo filas 6-9).
  final WaterProvider? waterProvider;
  final MeterType? waterMeterType;
  final MeterType? electricityMeterType;
  final SharedMeterDivisionMethod? sharedMeterMethod;

  // Internet y servicios (catálogo filas 10-14 → pagos expandidos).
  final InternetConnectionType? internetConnectionType;
  final InternetProvider? internetProvider;
  final int? internetSpeedMbps;
  final ServicePaymentMode? internetPayment;
  final ServicePaymentMode? cableTvPayment;
  final ServicePaymentMode? phonePayment;
  final ServicePaymentMode? gasPayment;
  final ServicePaymentMode? trashPayment;
  final ComboPackageOption? comboPackage;

  // Agua caliente, estacionamiento, seguridad (filas 15-17).
  final HotWaterSystem? hotWaterSystem;
  final ParkingType? parkingType;
  final List<SecurityFeature> securityFeatures;

  // Mascotas y ocupación (filas 18-20 + SOP Fase 1).
  final PetDogsPolicy? dogsPolicy;
  final PetCatsPolicy? catsPolicy;
  final PetOtherPolicy? otherPetsPolicy;
  final String? petRestrictions;
  final int? maxOccupants;

  // Convivencia y cesión (filas 21-27).
  final GuestPolicy? guestsPolicy;
  final NoiseRestriction? noiseRestriction;
  final ModificationPolicy? modificationPolicy;
  final CommercialActivityPolicy? commercialActivity;
  final GarageSubletPolicy? garageSublet;
  final PartialSubletPolicy? partialSublet;
  final FullAssignmentPolicy? fullAssignment;

  // Evidencia y ubicación (SOP Fases 1 y 3.1).
  final String? videoTourUrl;
  final VideoTourType? videoTourType;
  final List<String> photoUrls;
  final String? province;
  final String? canton;
  final String? district;
  final String? addressLine;
  final double? latitude;
  final double? longitude;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Property({
    required this.id,
    required this.ownerId,
    required this.propertyType,
    this.floorType,
    this.ceilingType,
    this.paintCondition,
    this.kitchenType,
    this.condition,
    this.permittedUse,
    this.spaces = const [],
    this.totalAreaM2,
    this.sharedCommonAreas,
    this.waterProvider,
    this.waterMeterType,
    this.electricityMeterType,
    this.sharedMeterMethod,
    this.internetConnectionType,
    this.internetProvider,
    this.internetSpeedMbps,
    this.internetPayment,
    this.cableTvPayment,
    this.phonePayment,
    this.gasPayment,
    this.trashPayment,
    this.comboPackage,
    this.hotWaterSystem,
    this.parkingType,
    this.securityFeatures = const [],
    this.dogsPolicy,
    this.catsPolicy,
    this.otherPetsPolicy,
    this.petRestrictions,
    this.maxOccupants,
    this.guestsPolicy,
    this.noiseRestriction,
    this.modificationPolicy,
    this.commercialActivity,
    this.garageSublet,
    this.partialSublet,
    this.fullAssignment,
    this.videoTourUrl,
    this.videoTourType,
    this.photoUrls = const [],
    this.province,
    this.canton,
    this.district,
    this.addressLine,
    this.latitude,
    this.longitude,
    this.createdAt,
    this.updatedAt,
  });

  Property copyWith({
    String? id,
    String? ownerId,
    PropertyType? propertyType,
    FloorType? floorType,
    CeilingType? ceilingType,
    PaintCondition? paintCondition,
    KitchenType? kitchenType,
    PropertyCondition? condition,
    String? permittedUse,
    List<RoomSpace>? spaces,
    double? totalAreaM2,
    String? sharedCommonAreas,
    WaterProvider? waterProvider,
    MeterType? waterMeterType,
    MeterType? electricityMeterType,
    SharedMeterDivisionMethod? sharedMeterMethod,
    InternetConnectionType? internetConnectionType,
    InternetProvider? internetProvider,
    int? internetSpeedMbps,
    ServicePaymentMode? internetPayment,
    ServicePaymentMode? cableTvPayment,
    ServicePaymentMode? phonePayment,
    ServicePaymentMode? gasPayment,
    ServicePaymentMode? trashPayment,
    ComboPackageOption? comboPackage,
    HotWaterSystem? hotWaterSystem,
    ParkingType? parkingType,
    List<SecurityFeature>? securityFeatures,
    PetDogsPolicy? dogsPolicy,
    PetCatsPolicy? catsPolicy,
    PetOtherPolicy? otherPetsPolicy,
    String? petRestrictions,
    int? maxOccupants,
    GuestPolicy? guestsPolicy,
    NoiseRestriction? noiseRestriction,
    ModificationPolicy? modificationPolicy,
    CommercialActivityPolicy? commercialActivity,
    GarageSubletPolicy? garageSublet,
    PartialSubletPolicy? partialSublet,
    FullAssignmentPolicy? fullAssignment,
    String? videoTourUrl,
    VideoTourType? videoTourType,
    List<String>? photoUrls,
    String? province,
    String? canton,
    String? district,
    String? addressLine,
    double? latitude,
    double? longitude,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Property(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      propertyType: propertyType ?? this.propertyType,
      floorType: floorType ?? this.floorType,
      ceilingType: ceilingType ?? this.ceilingType,
      paintCondition: paintCondition ?? this.paintCondition,
      kitchenType: kitchenType ?? this.kitchenType,
      condition: condition ?? this.condition,
      permittedUse: permittedUse ?? this.permittedUse,
      spaces: spaces ?? this.spaces,
      totalAreaM2: totalAreaM2 ?? this.totalAreaM2,
      sharedCommonAreas: sharedCommonAreas ?? this.sharedCommonAreas,
      waterProvider: waterProvider ?? this.waterProvider,
      waterMeterType: waterMeterType ?? this.waterMeterType,
      electricityMeterType: electricityMeterType ?? this.electricityMeterType,
      sharedMeterMethod: sharedMeterMethod ?? this.sharedMeterMethod,
      internetConnectionType:
          internetConnectionType ?? this.internetConnectionType,
      internetProvider: internetProvider ?? this.internetProvider,
      internetSpeedMbps: internetSpeedMbps ?? this.internetSpeedMbps,
      internetPayment: internetPayment ?? this.internetPayment,
      cableTvPayment: cableTvPayment ?? this.cableTvPayment,
      phonePayment: phonePayment ?? this.phonePayment,
      gasPayment: gasPayment ?? this.gasPayment,
      trashPayment: trashPayment ?? this.trashPayment,
      comboPackage: comboPackage ?? this.comboPackage,
      hotWaterSystem: hotWaterSystem ?? this.hotWaterSystem,
      parkingType: parkingType ?? this.parkingType,
      securityFeatures: securityFeatures ?? this.securityFeatures,
      dogsPolicy: dogsPolicy ?? this.dogsPolicy,
      catsPolicy: catsPolicy ?? this.catsPolicy,
      otherPetsPolicy: otherPetsPolicy ?? this.otherPetsPolicy,
      petRestrictions: petRestrictions ?? this.petRestrictions,
      maxOccupants: maxOccupants ?? this.maxOccupants,
      guestsPolicy: guestsPolicy ?? this.guestsPolicy,
      noiseRestriction: noiseRestriction ?? this.noiseRestriction,
      modificationPolicy: modificationPolicy ?? this.modificationPolicy,
      commercialActivity: commercialActivity ?? this.commercialActivity,
      garageSublet: garageSublet ?? this.garageSublet,
      partialSublet: partialSublet ?? this.partialSublet,
      fullAssignment: fullAssignment ?? this.fullAssignment,
      videoTourUrl: videoTourUrl ?? this.videoTourUrl,
      videoTourType: videoTourType ?? this.videoTourType,
      photoUrls: photoUrls ?? this.photoUrls,
      province: province ?? this.province,
      canton: canton ?? this.canton,
      district: district ?? this.district,
      addressLine: addressLine ?? this.addressLine,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'owner_id': ownerId,
      'property_type': propertyType.name,
      'floor_type': floorType?.name,
      'ceiling_type': ceilingType?.name,
      'paint_condition': paintCondition?.name,
      'kitchen_type': kitchenType?.name,
      'condition': condition?.name,
      'permitted_use': permittedUse,
      'spaces': spaces.map((s) => s.toJson()).toList(),
      'total_area_m2': totalAreaM2,
      'shared_common_areas': sharedCommonAreas,
      'water_provider': waterProvider?.name,
      'water_meter_type': waterMeterType?.name,
      'electricity_meter_type': electricityMeterType?.name,
      'shared_meter_method': sharedMeterMethod?.name,
      'internet_connection_type': internetConnectionType?.name,
      'internet_provider': internetProvider?.name,
      'internet_speed_mbps': internetSpeedMbps,
      'internet_payment': internetPayment?.name,
      'cable_tv_payment': cableTvPayment?.name,
      'phone_payment': phonePayment?.name,
      'gas_payment': gasPayment?.name,
      'trash_payment': trashPayment?.name,
      'combo_package': comboPackage?.name,
      'hot_water_system': hotWaterSystem?.name,
      'parking_type': parkingType?.name,
      'security_features': securityFeatures.map((e) => e.name).toList(),
      'dogs_policy': dogsPolicy?.name,
      'cats_policy': catsPolicy?.name,
      'other_pets_policy': otherPetsPolicy?.name,
      'pet_restrictions': petRestrictions,
      'max_occupants': maxOccupants,
      'guests_policy': guestsPolicy?.name,
      'noise_restriction': noiseRestriction?.name,
      'modification_policy': modificationPolicy?.name,
      'commercial_activity': commercialActivity?.name,
      'garage_sublet': garageSublet?.name,
      'partial_sublet': partialSublet?.name,
      'full_assignment': fullAssignment?.name,
      'video_tour_url': videoTourUrl,
      'video_tour_type': videoTourType?.name,
      'photo_urls': photoUrls,
      'province': province,
      'canton': canton,
      'district': district,
      'address_line': addressLine,
      'latitude': latitude,
      'longitude': longitude,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory Property.fromJson(Map<String, dynamic> json) {
    List<RoomSpace> parseSpaces(Object? raw) {
      if (raw == null) return const [];
      return (raw as List)
          .map((e) => RoomSpace.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    }

    List<SecurityFeature> parseSecurity(Object? raw) {
      if (raw == null) return const [];
      return (raw as List)
          .map((e) => SecurityFeature.values.byName(e as String))
          .toList();
    }

    DateTime? parseDate(Object? raw) {
      if (raw == null) return null;
      return DateTime.parse(raw as String);
    }

    return Property(
      id: json['id'] as String,
      ownerId: json['owner_id'] as String,
      propertyType:
          PropertyType.values.byName(json['property_type'] as String),
      floorType: _enumFromName(FloorType.values, json['floor_type']),
      ceilingType: _enumFromName(CeilingType.values, json['ceiling_type']),
      paintCondition:
          _enumFromName(PaintCondition.values, json['paint_condition']),
      kitchenType: _enumFromName(KitchenType.values, json['kitchen_type']),
      condition: _enumFromName(PropertyCondition.values, json['condition']),
      permittedUse: json['permitted_use'] as String?,
      spaces: parseSpaces(json['spaces']),
      totalAreaM2: (json['total_area_m2'] as num?)?.toDouble(),
      sharedCommonAreas: json['shared_common_areas'] as String?,
      waterProvider:
          _enumFromName(WaterProvider.values, json['water_provider']),
      waterMeterType:
          _enumFromName(MeterType.values, json['water_meter_type']),
      electricityMeterType:
          _enumFromName(MeterType.values, json['electricity_meter_type']),
      sharedMeterMethod: _enumFromName(
          SharedMeterDivisionMethod.values, json['shared_meter_method']),
      internetConnectionType: _enumFromName(
          InternetConnectionType.values, json['internet_connection_type']),
      internetProvider:
          _enumFromName(InternetProvider.values, json['internet_provider']),
      internetSpeedMbps: (json['internet_speed_mbps'] as num?)?.toInt(),
      internetPayment: _enumFromName(
          ServicePaymentMode.values, json['internet_payment']),
      cableTvPayment: _enumFromName(
          ServicePaymentMode.values, json['cable_tv_payment']),
      phonePayment:
          _enumFromName(ServicePaymentMode.values, json['phone_payment']),
      gasPayment:
          _enumFromName(ServicePaymentMode.values, json['gas_payment']),
      trashPayment:
          _enumFromName(ServicePaymentMode.values, json['trash_payment']),
      comboPackage:
          _enumFromName(ComboPackageOption.values, json['combo_package']),
      hotWaterSystem:
          _enumFromName(HotWaterSystem.values, json['hot_water_system']),
      parkingType: _enumFromName(ParkingType.values, json['parking_type']),
      securityFeatures: parseSecurity(json['security_features']),
      dogsPolicy: _enumFromName(PetDogsPolicy.values, json['dogs_policy']),
      catsPolicy: _enumFromName(PetCatsPolicy.values, json['cats_policy']),
      otherPetsPolicy:
          _enumFromName(PetOtherPolicy.values, json['other_pets_policy']),
      petRestrictions: json['pet_restrictions'] as String?,
      maxOccupants: (json['max_occupants'] as num?)?.toInt(),
      guestsPolicy: _enumFromName(GuestPolicy.values, json['guests_policy']),
      noiseRestriction:
          _enumFromName(NoiseRestriction.values, json['noise_restriction']),
      modificationPolicy: _enumFromName(
          ModificationPolicy.values, json['modification_policy']),
      commercialActivity: _enumFromName(
          CommercialActivityPolicy.values, json['commercial_activity']),
      garageSublet:
          _enumFromName(GarageSubletPolicy.values, json['garage_sublet']),
      partialSublet:
          _enumFromName(PartialSubletPolicy.values, json['partial_sublet']),
      fullAssignment:
          _enumFromName(FullAssignmentPolicy.values, json['full_assignment']),
      videoTourUrl: json['video_tour_url'] as String?,
      videoTourType:
          _enumFromName(VideoTourType.values, json['video_tour_type']),
      photoUrls: (json['photo_urls'] as List?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      province: json['province'] as String?,
      canton: json['canton'] as String?,
      district: json['district'] as String?,
      addressLine: json['address_line'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      createdAt: parseDate(json['created_at']),
      updatedAt: parseDate(json['updated_at']),
    );
  }

  @override
  List<Object?> get props => [
        id,
        ownerId,
        propertyType,
        floorType,
        ceilingType,
        paintCondition,
        kitchenType,
        condition,
        permittedUse,
        spaces,
        totalAreaM2,
        sharedCommonAreas,
        waterProvider,
        waterMeterType,
        electricityMeterType,
        sharedMeterMethod,
        internetConnectionType,
        internetProvider,
        internetSpeedMbps,
        internetPayment,
        cableTvPayment,
        phonePayment,
        gasPayment,
        trashPayment,
        comboPackage,
        hotWaterSystem,
        parkingType,
        securityFeatures,
        dogsPolicy,
        catsPolicy,
        otherPetsPolicy,
        petRestrictions,
        maxOccupants,
        guestsPolicy,
        noiseRestriction,
        modificationPolicy,
        commercialActivity,
        garageSublet,
        partialSublet,
        fullAssignment,
        videoTourUrl,
        videoTourType,
        photoUrls,
        province,
        canton,
        district,
        addressLine,
        latitude,
        longitude,
        createdAt,
        updatedAt,
      ];
}
