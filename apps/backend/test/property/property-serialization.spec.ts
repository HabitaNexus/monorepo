import {
  HotWaterSystem,
  InternetConnectionType,
  InternetProvider,
  ListingStatus,
  ParkingType,
  PetCatsPolicy,
  PetDogsPolicy,
  PetOtherPolicy,
  PropertyCondition,
  PropertyType,
  RoomSpaceType,
  SecurityFeature,
  ServicePaymentMode,
  VideoTourType,
} from '../../src/modules/property/domain/entities/catalog-types';
import { Listing } from '../../src/modules/property/domain/entities/listing.entity';
import { Property } from '../../src/modules/property/domain/entities/property.entity';
import { RoomSpace } from '../../src/modules/property/domain/entities/room-space';

describe('RoomSpace', () => {
  it('computes area and round-trips snake_case json', () => {
    const space = RoomSpace.create({
      type: RoomSpaceType.Dormitorio,
      label: 'D1',
      lengthM: 3.5,
      widthM: 4,
      capacityNotes: 'cama matrimonial + closet',
    });

    expect(space.areaM2).toBe(14);

    const json = space.toJSON();
    expect(json.length_m).toBe(3.5);
    expect(json.width_m).toBe(4);
    expect(json.area_m2).toBe(14);
    expect(json.capacity_notes).toBe('cama matrimonial + closet');

    expect(RoomSpace.fromJSON(json).equals(space)).toBe(true);
  });
});

describe('Property', () => {
  const minimal = () =>
    Property.create({
      id: 'prop-1',
      ownerId: 'owner-1',
      propertyType: PropertyType.CasaIndependiente,
    });

  it('minimal round-trip', () => {
    expect(Property.fromJSON(minimal().toJSON()).equals(minimal())).toBe(true);
  });

  it('full round-trip with catalog types and spaces', () => {
    const property = Property.create({
      id: 'prop-2',
      ownerId: 'owner-2',
      propertyType: PropertyType.ApartamentoEdificio,
      paintCondition: undefined,
      condition: PropertyCondition.BuenEstado,
      permittedUse: 'Vivienda unica y exclusiva',
      spaces: [
        RoomSpace.create({
          type: RoomSpaceType.Dormitorio,
          label: 'D1',
          lengthM: 3.5,
          widthM: 4,
        }),
        RoomSpace.create({
          type: RoomSpaceType.Bano,
          label: 'B1',
          lengthM: 2,
          widthM: 2.5,
        }),
      ],
      totalAreaM2: 72.5,
      internetConnectionType: InternetConnectionType.FibraOptica,
      internetProvider: InternetProvider.Kolbi,
      internetSpeedMbps: 100,
      internetPayment: ServicePaymentMode.PorCuentaInquilino,
      trashPayment: ServicePaymentMode.IncluidoEnRenta,
      hotWaterSystem: HotWaterSystem.TermoDucha,
      parkingType: ParkingType.TechadoExclusivo,
      securityFeatures: [
        SecurityFeature.PortonElectrico,
        SecurityFeature.Camaras,
      ],
      dogsPolicy: PetDogsPolicy.RazasPequenas,
      catsPolicy: PetCatsPolicy.SoloInterior,
      otherPetsPolicy: PetOtherPolicy.Peces,
      videoTourUrl: 'https://videos.example/tour-1.mp4',
      videoTourType: VideoTourType.Grabado,
      photoUrls: ['https://img.example/1.jpg'],
      province: 'Heredia',
      createdAt: new Date('2026-01-01T00:00:00.000Z'),
      updatedAt: new Date('2026-01-02T00:00:00.000Z'),
    });

    const json = property.toJSON();
    expect(json.owner_id).toBe('owner-2');
    expect(json.property_type).toBe('apartamento_edificio');
    expect(json.hot_water_system).toBe('termo_ducha');
    expect(json.video_tour_url).toContain('tour-1');

    expect(Property.fromJSON(json).equals(property)).toBe(true);
  });

  it('copy creates a modified copy', () => {
    const updated = minimal().copy({
      parkingType: ParkingType.TechadoExclusivo,
      maxOccupants: 4,
    });
    expect(updated.parkingType).toBe(ParkingType.TechadoExclusivo);
    expect(updated.maxOccupants).toBe(4);
    expect(updated.id).toBe('prop-1');
  });

  it('rejects unknown enum values', () => {
    expect(() =>
      Property.fromJSON({
        ...minimal().toJSON(),
        property_type: 'castillo',
      }),
    ).toThrow();
  });
});

describe('Listing', () => {
  it('round-trips ranges, status and timestamps', () => {
    const listing = Listing.create({
      id: 'list-1',
      propertyId: 'prop-1',
      monthlyRent: 280000,
      minRent: 260000,
      depositAmount: 280000,
      minDurationMonths: 12,
      maxDurationMonths: 36,
      nonNegotiableConditions: ['no_subarriendo'],
      status: ListingStatus.Active,
      publishedAt: new Date('2026-02-01T00:00:00.000Z'),
      createdAt: new Date('2026-02-01T00:00:00.000Z'),
      updatedAt: new Date('2026-02-02T00:00:00.000Z'),
    });

    const json = listing.toJSON();
    expect(json.property_id).toBe('prop-1');
    expect(json.monthly_rent).toBe(280000);
    expect(json.min_duration_months).toBe(12);
    expect(json.non_negotiable_conditions).toEqual(['no_subarriendo']);

    expect(Listing.fromJSON(json).equals(listing)).toBe(true);
    expect(listing.copy({ status: ListingStatus.Paused }).status).toBe(
      ListingStatus.Paused,
    );
  });
});
