import {
  CeilingType,
  CommercialActivityPolicy,
  ComboPackageOption,
  FloorType,
  FullAssignmentPolicy,
  GarageSubletPolicy,
  GuestPolicy,
  HotWaterSystem,
  InternetConnectionType,
  InternetProvider,
  KitchenType,
  MeterType,
  ModificationPolicy,
  NoiseRestriction,
  PaintCondition,
  ParkingType,
  PartialSubletPolicy,
  PetCatsPolicy,
  PetDogsPolicy,
  PetOtherPolicy,
  PropertyCondition,
  PropertyType,
  SecurityFeature,
  ServicePaymentMode,
  SharedMeterDivisionMethod,
  VideoTourType,
  WaterProvider,
} from './catalog-types';
import { RoomSpace } from './room-space';

function parseEnum<T extends string>(
  values: readonly T[],
  raw: unknown,
  field: string,
): T | null {
  if (raw === null || raw === undefined) return null;
  if ((values as readonly unknown[]).includes(raw)) return raw as T;
  throw new Error(`Unknown ${field}: ${String(raw)}`);
}

function parseEnumList<T extends string>(
  values: readonly T[],
  raw: unknown,
  field: string,
): T[] {
  if (raw === null || raw === undefined) return [];
  if (!Array.isArray(raw)) throw new Error(`Expected array for ${field}`);
  return raw.map((item) => {
    if ((values as readonly unknown[]).includes(item)) return item as T;
    throw new Error(`Unknown ${field} entry: ${String(item)}`);
  });
}

/**
 * Entidad de dominio para un inmueble en arriendo (fase 1: Listado).
 *
 * Espejo TypeScript de `Property` en mobile, con el mismo contrato JSON
 * (claves snake_case). Cubre los datos obligatorios del SOP más las
 * 27 filas del catálogo (Fase 4); cada campo del catálogo usa un tipo
 * de `catalog-types.ts` (propiedad de HAB-14), nunca `string` sueltos.
 *
 * Sin PII del propietario embebida (solo `ownerId`) — Ley 8968.
 * Capa domain: sin dependencias de NestJS ni de infrastructure.
 */
export interface PropertyProps {
  id: string;
  ownerId: string;
  propertyType: PropertyType;
  floorType?: FloorType | null;
  ceilingType?: CeilingType | null;
  paintCondition?: PaintCondition | null;
  kitchenType?: KitchenType | null;
  condition?: PropertyCondition | null;
  permittedUse?: string | null;
  spaces?: RoomSpace[];
  totalAreaM2?: number | null;
  sharedCommonAreas?: string | null;
  waterProvider?: WaterProvider | null;
  waterMeterType?: MeterType | null;
  electricityMeterType?: MeterType | null;
  sharedMeterMethod?: SharedMeterDivisionMethod | null;
  internetConnectionType?: InternetConnectionType | null;
  internetProvider?: InternetProvider | null;
  internetSpeedMbps?: number | null;
  internetPayment?: ServicePaymentMode | null;
  cableTvPayment?: ServicePaymentMode | null;
  phonePayment?: ServicePaymentMode | null;
  gasPayment?: ServicePaymentMode | null;
  trashPayment?: ServicePaymentMode | null;
  comboPackage?: ComboPackageOption | null;
  hotWaterSystem?: HotWaterSystem | null;
  parkingType?: ParkingType | null;
  securityFeatures?: SecurityFeature[];
  dogsPolicy?: PetDogsPolicy | null;
  catsPolicy?: PetCatsPolicy | null;
  otherPetsPolicy?: PetOtherPolicy | null;
  petRestrictions?: string | null;
  maxOccupants?: number | null;
  guestsPolicy?: GuestPolicy | null;
  noiseRestriction?: NoiseRestriction | null;
  modificationPolicy?: ModificationPolicy | null;
  commercialActivity?: CommercialActivityPolicy | null;
  garageSublet?: GarageSubletPolicy | null;
  partialSublet?: PartialSubletPolicy | null;
  fullAssignment?: FullAssignmentPolicy | null;
  videoTourUrl?: string | null;
  videoTourType?: VideoTourType | null;
  photoUrls?: string[];
  province?: string | null;
  canton?: string | null;
  district?: string | null;
  addressLine?: string | null;
  latitude?: number | null;
  longitude?: number | null;
  createdAt?: Date | null;
  updatedAt?: Date | null;
}

const NULL_DEFAULT: null = null;

export class Property {
  readonly id: string;
  readonly ownerId: string;
  readonly propertyType: PropertyType;
  readonly floorType: FloorType | null;
  readonly ceilingType: CeilingType | null;
  readonly paintCondition: PaintCondition | null;
  readonly kitchenType: KitchenType | null;
  readonly condition: PropertyCondition | null;
  readonly permittedUse: string | null;
  readonly spaces: readonly RoomSpace[];
  readonly totalAreaM2: number | null;
  readonly sharedCommonAreas: string | null;
  readonly waterProvider: WaterProvider | null;
  readonly waterMeterType: MeterType | null;
  readonly electricityMeterType: MeterType | null;
  readonly sharedMeterMethod: SharedMeterDivisionMethod | null;
  readonly internetConnectionType: InternetConnectionType | null;
  readonly internetProvider: InternetProvider | null;
  readonly internetSpeedMbps: number | null;
  readonly internetPayment: ServicePaymentMode | null;
  readonly cableTvPayment: ServicePaymentMode | null;
  readonly phonePayment: ServicePaymentMode | null;
  readonly gasPayment: ServicePaymentMode | null;
  readonly trashPayment: ServicePaymentMode | null;
  readonly comboPackage: ComboPackageOption | null;
  readonly hotWaterSystem: HotWaterSystem | null;
  readonly parkingType: ParkingType | null;
  readonly securityFeatures: readonly SecurityFeature[];
  readonly dogsPolicy: PetDogsPolicy | null;
  readonly catsPolicy: PetCatsPolicy | null;
  readonly otherPetsPolicy: PetOtherPolicy | null;
  readonly petRestrictions: string | null;
  readonly maxOccupants: number | null;
  readonly guestsPolicy: GuestPolicy | null;
  readonly noiseRestriction: NoiseRestriction | null;
  readonly modificationPolicy: ModificationPolicy | null;
  readonly commercialActivity: CommercialActivityPolicy | null;
  readonly garageSublet: GarageSubletPolicy | null;
  readonly partialSublet: PartialSubletPolicy | null;
  readonly fullAssignment: FullAssignmentPolicy | null;
  readonly videoTourUrl: string | null;
  readonly videoTourType: VideoTourType | null;
  readonly photoUrls: readonly string[];
  readonly province: string | null;
  readonly canton: string | null;
  readonly district: string | null;
  readonly addressLine: string | null;
  readonly latitude: number | null;
  readonly longitude: number | null;
  readonly createdAt: Date | null;
  readonly updatedAt: Date | null;

  private constructor(props: PropertyProps) {
    this.id = props.id;
    this.ownerId = props.ownerId;
    this.propertyType = props.propertyType;
    this.floorType = props.floorType ?? NULL_DEFAULT;
    this.ceilingType = props.ceilingType ?? NULL_DEFAULT;
    this.paintCondition = props.paintCondition ?? NULL_DEFAULT;
    this.kitchenType = props.kitchenType ?? NULL_DEFAULT;
    this.condition = props.condition ?? NULL_DEFAULT;
    this.permittedUse = props.permittedUse ?? NULL_DEFAULT;
    this.spaces = Object.freeze([...(props.spaces ?? [])]);
    this.totalAreaM2 = props.totalAreaM2 ?? NULL_DEFAULT;
    this.sharedCommonAreas = props.sharedCommonAreas ?? NULL_DEFAULT;
    this.waterProvider = props.waterProvider ?? NULL_DEFAULT;
    this.waterMeterType = props.waterMeterType ?? NULL_DEFAULT;
    this.electricityMeterType = props.electricityMeterType ?? NULL_DEFAULT;
    this.sharedMeterMethod = props.sharedMeterMethod ?? NULL_DEFAULT;
    this.internetConnectionType = props.internetConnectionType ?? NULL_DEFAULT;
    this.internetProvider = props.internetProvider ?? NULL_DEFAULT;
    this.internetSpeedMbps = props.internetSpeedMbps ?? NULL_DEFAULT;
    this.internetPayment = props.internetPayment ?? NULL_DEFAULT;
    this.cableTvPayment = props.cableTvPayment ?? NULL_DEFAULT;
    this.phonePayment = props.phonePayment ?? NULL_DEFAULT;
    this.gasPayment = props.gasPayment ?? NULL_DEFAULT;
    this.trashPayment = props.trashPayment ?? NULL_DEFAULT;
    this.comboPackage = props.comboPackage ?? NULL_DEFAULT;
    this.hotWaterSystem = props.hotWaterSystem ?? NULL_DEFAULT;
    this.parkingType = props.parkingType ?? NULL_DEFAULT;
    this.securityFeatures = Object.freeze([...(props.securityFeatures ?? [])]);
    this.dogsPolicy = props.dogsPolicy ?? NULL_DEFAULT;
    this.catsPolicy = props.catsPolicy ?? NULL_DEFAULT;
    this.otherPetsPolicy = props.otherPetsPolicy ?? NULL_DEFAULT;
    this.petRestrictions = props.petRestrictions ?? NULL_DEFAULT;
    this.maxOccupants = props.maxOccupants ?? NULL_DEFAULT;
    this.guestsPolicy = props.guestsPolicy ?? NULL_DEFAULT;
    this.noiseRestriction = props.noiseRestriction ?? NULL_DEFAULT;
    this.modificationPolicy = props.modificationPolicy ?? NULL_DEFAULT;
    this.commercialActivity = props.commercialActivity ?? NULL_DEFAULT;
    this.garageSublet = props.garageSublet ?? NULL_DEFAULT;
    this.partialSublet = props.partialSublet ?? NULL_DEFAULT;
    this.fullAssignment = props.fullAssignment ?? NULL_DEFAULT;
    this.videoTourUrl = props.videoTourUrl ?? NULL_DEFAULT;
    this.videoTourType = props.videoTourType ?? NULL_DEFAULT;
    this.photoUrls = Object.freeze([...(props.photoUrls ?? [])]);
    this.province = props.province ?? NULL_DEFAULT;
    this.canton = props.canton ?? NULL_DEFAULT;
    this.district = props.district ?? NULL_DEFAULT;
    this.addressLine = props.addressLine ?? NULL_DEFAULT;
    this.latitude = props.latitude ?? NULL_DEFAULT;
    this.longitude = props.longitude ?? NULL_DEFAULT;
    this.createdAt = props.createdAt ?? NULL_DEFAULT;
    this.updatedAt = props.updatedAt ?? NULL_DEFAULT;
    Object.freeze(this);
  }

  static create(props: PropertyProps): Property {
    return new Property(props);
  }

  /** Equivalente a `copyWith` en mobile. */
  copy(patch: Partial<PropertyProps>): Property {
    return Property.create({
      id: patch.id ?? this.id,
      ownerId: patch.ownerId ?? this.ownerId,
      propertyType: patch.propertyType ?? this.propertyType,
      floorType: patch.floorType ?? this.floorType,
      ceilingType: patch.ceilingType ?? this.ceilingType,
      paintCondition: patch.paintCondition ?? this.paintCondition,
      kitchenType: patch.kitchenType ?? this.kitchenType,
      condition: patch.condition ?? this.condition,
      permittedUse: patch.permittedUse ?? this.permittedUse,
      spaces: patch.spaces ? [...patch.spaces] : [...this.spaces],
      totalAreaM2: patch.totalAreaM2 ?? this.totalAreaM2,
      sharedCommonAreas: patch.sharedCommonAreas ?? this.sharedCommonAreas,
      waterProvider: patch.waterProvider ?? this.waterProvider,
      waterMeterType: patch.waterMeterType ?? this.waterMeterType,
      electricityMeterType:
        patch.electricityMeterType ?? this.electricityMeterType,
      sharedMeterMethod: patch.sharedMeterMethod ?? this.sharedMeterMethod,
      internetConnectionType:
        patch.internetConnectionType ?? this.internetConnectionType,
      internetProvider: patch.internetProvider ?? this.internetProvider,
      internetSpeedMbps: patch.internetSpeedMbps ?? this.internetSpeedMbps,
      internetPayment: patch.internetPayment ?? this.internetPayment,
      cableTvPayment: patch.cableTvPayment ?? this.cableTvPayment,
      phonePayment: patch.phonePayment ?? this.phonePayment,
      gasPayment: patch.gasPayment ?? this.gasPayment,
      trashPayment: patch.trashPayment ?? this.trashPayment,
      comboPackage: patch.comboPackage ?? this.comboPackage,
      hotWaterSystem: patch.hotWaterSystem ?? this.hotWaterSystem,
      parkingType: patch.parkingType ?? this.parkingType,
      securityFeatures: patch.securityFeatures
        ? [...patch.securityFeatures]
        : [...this.securityFeatures],
      dogsPolicy: patch.dogsPolicy ?? this.dogsPolicy,
      catsPolicy: patch.catsPolicy ?? this.catsPolicy,
      otherPetsPolicy: patch.otherPetsPolicy ?? this.otherPetsPolicy,
      petRestrictions: patch.petRestrictions ?? this.petRestrictions,
      maxOccupants: patch.maxOccupants ?? this.maxOccupants,
      guestsPolicy: patch.guestsPolicy ?? this.guestsPolicy,
      noiseRestriction: patch.noiseRestriction ?? this.noiseRestriction,
      modificationPolicy: patch.modificationPolicy ?? this.modificationPolicy,
      commercialActivity: patch.commercialActivity ?? this.commercialActivity,
      garageSublet: patch.garageSublet ?? this.garageSublet,
      partialSublet: patch.partialSublet ?? this.partialSublet,
      fullAssignment: patch.fullAssignment ?? this.fullAssignment,
      videoTourUrl: patch.videoTourUrl ?? this.videoTourUrl,
      videoTourType: patch.videoTourType ?? this.videoTourType,
      photoUrls: patch.photoUrls ? [...patch.photoUrls] : [...this.photoUrls],
      province: patch.province ?? this.province,
      canton: patch.canton ?? this.canton,
      district: patch.district ?? this.district,
      addressLine: patch.addressLine ?? this.addressLine,
      latitude: patch.latitude ?? this.latitude,
      longitude: patch.longitude ?? this.longitude,
      createdAt: patch.createdAt ?? this.createdAt,
      updatedAt: patch.updatedAt ?? this.updatedAt,
    });
  }

  toJSON(): Record<string, unknown> {
    return {
      id: this.id,
      owner_id: this.ownerId,
      property_type: this.propertyType,
      floor_type: this.floorType,
      ceiling_type: this.ceilingType,
      paint_condition: this.paintCondition,
      kitchen_type: this.kitchenType,
      condition: this.condition,
      permitted_use: this.permittedUse,
      spaces: this.spaces.map((s) => s.toJSON()),
      total_area_m2: this.totalAreaM2,
      shared_common_areas: this.sharedCommonAreas,
      water_provider: this.waterProvider,
      water_meter_type: this.waterMeterType,
      electricity_meter_type: this.electricityMeterType,
      shared_meter_method: this.sharedMeterMethod,
      internet_connection_type: this.internetConnectionType,
      internet_provider: this.internetProvider,
      internet_speed_mbps: this.internetSpeedMbps,
      internet_payment: this.internetPayment,
      cable_tv_payment: this.cableTvPayment,
      phone_payment: this.phonePayment,
      gas_payment: this.gasPayment,
      trash_payment: this.trashPayment,
      combo_package: this.comboPackage,
      hot_water_system: this.hotWaterSystem,
      parking_type: this.parkingType,
      security_features: [...this.securityFeatures],
      dogs_policy: this.dogsPolicy,
      cats_policy: this.catsPolicy,
      other_pets_policy: this.otherPetsPolicy,
      pet_restrictions: this.petRestrictions,
      max_occupants: this.maxOccupants,
      guests_policy: this.guestsPolicy,
      noise_restriction: this.noiseRestriction,
      modification_policy: this.modificationPolicy,
      commercial_activity: this.commercialActivity,
      garage_sublet: this.garageSublet,
      partial_sublet: this.partialSublet,
      full_assignment: this.fullAssignment,
      video_tour_url: this.videoTourUrl,
      video_tour_type: this.videoTourType,
      photo_urls: [...this.photoUrls],
      province: this.province,
      canton: this.canton,
      district: this.district,
      address_line: this.addressLine,
      latitude: this.latitude,
      longitude: this.longitude,
      created_at: this.createdAt ? this.createdAt.toISOString() : null,
      updated_at: this.updatedAt ? this.updatedAt.toISOString() : null,
    };
  }

  static fromJSON(json: Record<string, unknown>): Property {
    const propertyType = parseEnum(
      Object.values(PropertyType),
      json.property_type,
      'property_type',
    );
    if (!propertyType) throw new Error('property_type is required');
    const parseDate = (raw: unknown): Date | null => {
      if (raw === null || raw === undefined) return null;
      return new Date(raw as string);
    };
    const asSpaces = (raw: unknown): RoomSpace[] => {
      if (raw === null || raw === undefined) return [];
      return (raw as Record<string, unknown>[]).map((s) =>
        RoomSpace.fromJSON(s),
      );
    };
    return Property.create({
      id: json.id as string,
      ownerId: json.owner_id as string,
      propertyType,
      floorType: parseEnum(
        Object.values(FloorType),
        json.floor_type,
        'floor_type',
      ),
      ceilingType: parseEnum(
        Object.values(CeilingType),
        json.ceiling_type,
        'ceiling_type',
      ),
      paintCondition: parseEnum(
        Object.values(PaintCondition),
        json.paint_condition,
        'paint_condition',
      ),
      kitchenType: parseEnum(
        Object.values(KitchenType),
        json.kitchen_type,
        'kitchen_type',
      ),
      condition: parseEnum(
        Object.values(PropertyCondition),
        json.condition,
        'condition',
      ),
      permittedUse: (json.permitted_use as string | null) ?? null,
      spaces: asSpaces(json.spaces),
      totalAreaM2: (json.total_area_m2 as number | null) ?? null,
      sharedCommonAreas: (json.shared_common_areas as string | null) ?? null,
      waterProvider: parseEnum(
        Object.values(WaterProvider),
        json.water_provider,
        'water_provider',
      ),
      waterMeterType: parseEnum(
        Object.values(MeterType),
        json.water_meter_type,
        'water_meter_type',
      ),
      electricityMeterType: parseEnum(
        Object.values(MeterType),
        json.electricity_meter_type,
        'electricity_meter_type',
      ),
      sharedMeterMethod: parseEnum(
        Object.values(SharedMeterDivisionMethod),
        json.shared_meter_method,
        'shared_meter_method',
      ),
      internetConnectionType: parseEnum(
        Object.values(InternetConnectionType),
        json.internet_connection_type,
        'internet_connection_type',
      ),
      internetProvider: parseEnum(
        Object.values(InternetProvider),
        json.internet_provider,
        'internet_provider',
      ),
      internetSpeedMbps: (json.internet_speed_mbps as number | null) ?? null,
      internetPayment: parseEnum(
        Object.values(ServicePaymentMode),
        json.internet_payment,
        'internet_payment',
      ),
      cableTvPayment: parseEnum(
        Object.values(ServicePaymentMode),
        json.cable_tv_payment,
        'cable_tv_payment',
      ),
      phonePayment: parseEnum(
        Object.values(ServicePaymentMode),
        json.phone_payment,
        'phone_payment',
      ),
      gasPayment: parseEnum(
        Object.values(ServicePaymentMode),
        json.gas_payment,
        'gas_payment',
      ),
      trashPayment: parseEnum(
        Object.values(ServicePaymentMode),
        json.trash_payment,
        'trash_payment',
      ),
      comboPackage: parseEnum(
        Object.values(ComboPackageOption),
        json.combo_package,
        'combo_package',
      ),
      hotWaterSystem: parseEnum(
        Object.values(HotWaterSystem),
        json.hot_water_system,
        'hot_water_system',
      ),
      parkingType: parseEnum(
        Object.values(ParkingType),
        json.parking_type,
        'parking_type',
      ),
      securityFeatures: parseEnumList(
        Object.values(SecurityFeature),
        json.security_features,
        'security_features',
      ),
      dogsPolicy: parseEnum(
        Object.values(PetDogsPolicy),
        json.dogs_policy,
        'dogs_policy',
      ),
      catsPolicy: parseEnum(
        Object.values(PetCatsPolicy),
        json.cats_policy,
        'cats_policy',
      ),
      otherPetsPolicy: parseEnum(
        Object.values(PetOtherPolicy),
        json.other_pets_policy,
        'other_pets_policy',
      ),
      petRestrictions: (json.pet_restrictions as string | null) ?? null,
      maxOccupants: (json.max_occupants as number | null) ?? null,
      guestsPolicy: parseEnum(
        Object.values(GuestPolicy),
        json.guests_policy,
        'guests_policy',
      ),
      noiseRestriction: parseEnum(
        Object.values(NoiseRestriction),
        json.noise_restriction,
        'noise_restriction',
      ),
      modificationPolicy: parseEnum(
        Object.values(ModificationPolicy),
        json.modification_policy,
        'modification_policy',
      ),
      commercialActivity: parseEnum(
        Object.values(CommercialActivityPolicy),
        json.commercial_activity,
        'commercial_activity',
      ),
      garageSublet: parseEnum(
        Object.values(GarageSubletPolicy),
        json.garage_sublet,
        'garage_sublet',
      ),
      partialSublet: parseEnum(
        Object.values(PartialSubletPolicy),
        json.partial_sublet,
        'partial_sublet',
      ),
      fullAssignment: parseEnum(
        Object.values(FullAssignmentPolicy),
        json.full_assignment,
        'full_assignment',
      ),
      videoTourUrl: (json.video_tour_url as string | null) ?? null,
      videoTourType: parseEnum(
        Object.values(VideoTourType),
        json.video_tour_type,
        'video_tour_type',
      ),
      photoUrls: ((json.photo_urls as string[] | null) ?? []).slice(),
      province: (json.province as string | null) ?? null,
      canton: (json.canton as string | null) ?? null,
      district: (json.district as string | null) ?? null,
      addressLine: (json.address_line as string | null) ?? null,
      latitude: (json.latitude as number | null) ?? null,
      longitude: (json.longitude as number | null) ?? null,
      createdAt: parseDate(json.created_at),
      updatedAt: parseDate(json.updated_at),
    });
  }

  equals(other: Property): boolean {
    return JSON.stringify(this.toJSON()) === JSON.stringify(other.toJSON());
  }
}
