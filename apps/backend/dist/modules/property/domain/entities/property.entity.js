"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.Property = void 0;
const catalog_types_1 = require("./catalog-types");
const room_space_1 = require("./room-space");
function parseEnum(values, raw, field) {
    if (raw === null || raw === undefined)
        return null;
    if (values.includes(raw))
        return raw;
    throw new Error(`Unknown ${field}: ${String(raw)}`);
}
function parseEnumList(values, raw, field) {
    if (raw === null || raw === undefined)
        return [];
    if (!Array.isArray(raw))
        throw new Error(`Expected array for ${field}`);
    return raw.map((item) => {
        if (values.includes(item))
            return item;
        throw new Error(`Unknown ${field} entry: ${String(item)}`);
    });
}
const NULL_DEFAULT = null;
class Property {
    id;
    ownerId;
    propertyType;
    floorType;
    ceilingType;
    paintCondition;
    kitchenType;
    condition;
    permittedUse;
    spaces;
    totalAreaM2;
    sharedCommonAreas;
    waterProvider;
    waterMeterType;
    electricityMeterType;
    sharedMeterMethod;
    internetConnectionType;
    internetProvider;
    internetSpeedMbps;
    internetPayment;
    cableTvPayment;
    phonePayment;
    gasPayment;
    trashPayment;
    comboPackage;
    hotWaterSystem;
    parkingType;
    securityFeatures;
    dogsPolicy;
    catsPolicy;
    otherPetsPolicy;
    petRestrictions;
    maxOccupants;
    guestsPolicy;
    noiseRestriction;
    modificationPolicy;
    commercialActivity;
    garageSublet;
    partialSublet;
    fullAssignment;
    videoTourUrl;
    videoTourType;
    photoUrls;
    province;
    canton;
    district;
    addressLine;
    latitude;
    longitude;
    createdAt;
    updatedAt;
    constructor(props) {
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
    static create(props) {
        return new Property(props);
    }
    copy(patch) {
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
            electricityMeterType: patch.electricityMeterType ?? this.electricityMeterType,
            sharedMeterMethod: patch.sharedMeterMethod ?? this.sharedMeterMethod,
            internetConnectionType: patch.internetConnectionType ?? this.internetConnectionType,
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
    toJSON() {
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
    static fromJSON(json) {
        const propertyType = parseEnum(Object.values(catalog_types_1.PropertyType), json.property_type, 'property_type');
        if (!propertyType)
            throw new Error('property_type is required');
        const parseDate = (raw) => {
            if (raw === null || raw === undefined)
                return null;
            return new Date(raw);
        };
        const asSpaces = (raw) => {
            if (raw === null || raw === undefined)
                return [];
            return raw.map((s) => room_space_1.RoomSpace.fromJSON(s));
        };
        return Property.create({
            id: json.id,
            ownerId: json.owner_id,
            propertyType,
            floorType: parseEnum(Object.values(catalog_types_1.FloorType), json.floor_type, 'floor_type'),
            ceilingType: parseEnum(Object.values(catalog_types_1.CeilingType), json.ceiling_type, 'ceiling_type'),
            paintCondition: parseEnum(Object.values(catalog_types_1.PaintCondition), json.paint_condition, 'paint_condition'),
            kitchenType: parseEnum(Object.values(catalog_types_1.KitchenType), json.kitchen_type, 'kitchen_type'),
            condition: parseEnum(Object.values(catalog_types_1.PropertyCondition), json.condition, 'condition'),
            permittedUse: json.permitted_use ?? null,
            spaces: asSpaces(json.spaces),
            totalAreaM2: json.total_area_m2 ?? null,
            sharedCommonAreas: json.shared_common_areas ?? null,
            waterProvider: parseEnum(Object.values(catalog_types_1.WaterProvider), json.water_provider, 'water_provider'),
            waterMeterType: parseEnum(Object.values(catalog_types_1.MeterType), json.water_meter_type, 'water_meter_type'),
            electricityMeterType: parseEnum(Object.values(catalog_types_1.MeterType), json.electricity_meter_type, 'electricity_meter_type'),
            sharedMeterMethod: parseEnum(Object.values(catalog_types_1.SharedMeterDivisionMethod), json.shared_meter_method, 'shared_meter_method'),
            internetConnectionType: parseEnum(Object.values(catalog_types_1.InternetConnectionType), json.internet_connection_type, 'internet_connection_type'),
            internetProvider: parseEnum(Object.values(catalog_types_1.InternetProvider), json.internet_provider, 'internet_provider'),
            internetSpeedMbps: json.internet_speed_mbps ?? null,
            internetPayment: parseEnum(Object.values(catalog_types_1.ServicePaymentMode), json.internet_payment, 'internet_payment'),
            cableTvPayment: parseEnum(Object.values(catalog_types_1.ServicePaymentMode), json.cable_tv_payment, 'cable_tv_payment'),
            phonePayment: parseEnum(Object.values(catalog_types_1.ServicePaymentMode), json.phone_payment, 'phone_payment'),
            gasPayment: parseEnum(Object.values(catalog_types_1.ServicePaymentMode), json.gas_payment, 'gas_payment'),
            trashPayment: parseEnum(Object.values(catalog_types_1.ServicePaymentMode), json.trash_payment, 'trash_payment'),
            comboPackage: parseEnum(Object.values(catalog_types_1.ComboPackageOption), json.combo_package, 'combo_package'),
            hotWaterSystem: parseEnum(Object.values(catalog_types_1.HotWaterSystem), json.hot_water_system, 'hot_water_system'),
            parkingType: parseEnum(Object.values(catalog_types_1.ParkingType), json.parking_type, 'parking_type'),
            securityFeatures: parseEnumList(Object.values(catalog_types_1.SecurityFeature), json.security_features, 'security_features'),
            dogsPolicy: parseEnum(Object.values(catalog_types_1.PetDogsPolicy), json.dogs_policy, 'dogs_policy'),
            catsPolicy: parseEnum(Object.values(catalog_types_1.PetCatsPolicy), json.cats_policy, 'cats_policy'),
            otherPetsPolicy: parseEnum(Object.values(catalog_types_1.PetOtherPolicy), json.other_pets_policy, 'other_pets_policy'),
            petRestrictions: json.pet_restrictions ?? null,
            maxOccupants: json.max_occupants ?? null,
            guestsPolicy: parseEnum(Object.values(catalog_types_1.GuestPolicy), json.guests_policy, 'guests_policy'),
            noiseRestriction: parseEnum(Object.values(catalog_types_1.NoiseRestriction), json.noise_restriction, 'noise_restriction'),
            modificationPolicy: parseEnum(Object.values(catalog_types_1.ModificationPolicy), json.modification_policy, 'modification_policy'),
            commercialActivity: parseEnum(Object.values(catalog_types_1.CommercialActivityPolicy), json.commercial_activity, 'commercial_activity'),
            garageSublet: parseEnum(Object.values(catalog_types_1.GarageSubletPolicy), json.garage_sublet, 'garage_sublet'),
            partialSublet: parseEnum(Object.values(catalog_types_1.PartialSubletPolicy), json.partial_sublet, 'partial_sublet'),
            fullAssignment: parseEnum(Object.values(catalog_types_1.FullAssignmentPolicy), json.full_assignment, 'full_assignment'),
            videoTourUrl: json.video_tour_url ?? null,
            videoTourType: parseEnum(Object.values(catalog_types_1.VideoTourType), json.video_tour_type, 'video_tour_type'),
            photoUrls: (json.photo_urls ?? []).slice(),
            province: json.province ?? null,
            canton: json.canton ?? null,
            district: json.district ?? null,
            addressLine: json.address_line ?? null,
            latitude: json.latitude ?? null,
            longitude: json.longitude ?? null,
            createdAt: parseDate(json.created_at),
            updatedAt: parseDate(json.updated_at),
        });
    }
    equals(other) {
        return JSON.stringify(this.toJSON()) === JSON.stringify(other.toJSON());
    }
}
exports.Property = Property;
//# sourceMappingURL=property.entity.js.map