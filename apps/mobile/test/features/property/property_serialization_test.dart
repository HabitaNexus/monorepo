import 'package:flutter_test/flutter_test.dart';
import 'package:habitanexus_mobile/features/property/domain/entities/catalog_types.dart';
import 'package:habitanexus_mobile/features/property/domain/entities/listing.dart';
import 'package:habitanexus_mobile/features/property/domain/entities/property.dart';
import 'package:habitanexus_mobile/features/property/domain/entities/room_space.dart';

void main() {
  group('RoomSpace', () {
    test('computes area and round-trips snake_case json', () {
      const space = RoomSpace(
        type: RoomSpaceType.dormitorio,
        label: 'D1',
        lengthM: 3.5,
        widthM: 4,
        capacityNotes: 'cama matrimonial + closet',
      );

      expect(space.areaM2, 14.0);

      final json = space.toJson();
      expect(json['length_m'], 3.5);
      expect(json['width_m'], 4);
      expect(json['area_m2'], 14.0);
      expect(json['capacity_notes'], 'cama matrimonial + closet');

      final restored = RoomSpace.fromJson(json);
      expect(restored, space);
    });
  });

  group('Property', () {
    Property minimal() => const Property(
          id: 'prop-1',
          ownerId: 'owner-1',
          propertyType: PropertyType.casaIndependiente,
        );

    test('minimal round-trip', () {
      final restored = Property.fromJson(minimal().toJson());
      expect(restored, minimal());
    });

    test('full round-trip with catalog types and spaces', () {
      final property = Property(
        id: 'prop-2',
        ownerId: 'owner-2',
        propertyType: PropertyType.apartamentoEdificio,
        floorType: FloorType.ceramica,
        ceilingType: CeilingType.gypsum,
        paintCondition: PaintCondition.buenEstado,
        kitchenType: KitchenType.conMueblesYBasicos,
        condition: PropertyCondition.buenEstado,
        permittedUse: 'Vivienda unica y exclusiva',
        spaces: const [
          RoomSpace(
            type: RoomSpaceType.dormitorio,
            label: 'D1',
            lengthM: 3.5,
            widthM: 4,
          ),
          RoomSpace(
            type: RoomSpaceType.bano,
            label: 'B1',
            lengthM: 2,
            widthM: 2.5,
          ),
        ],
        totalAreaM2: 72.5,
        waterProvider: WaterProvider.aya,
        waterMeterType: MeterType.individual,
        electricityMeterType: MeterType.compartido,
        sharedMeterMethod: SharedMeterDivisionMethod.equitativa,
        internetConnectionType: InternetConnectionType.fibraOptica,
        internetProvider: InternetProvider.kolbi,
        internetSpeedMbps: 100,
        internetPayment: ServicePaymentMode.porCuentaInquilino,
        trashPayment: ServicePaymentMode.incluidoEnRenta,
        hotWaterSystem: HotWaterSystem.termoDucha,
        parkingType: ParkingType.techadoExclusivo,
        securityFeatures: const [
          SecurityFeature.portonElectrico,
          SecurityFeature.camaras,
        ],
        dogsPolicy: PetDogsPolicy.razasPequenas,
        catsPolicy: PetCatsPolicy.soloInterior,
        otherPetsPolicy: PetOtherPolicy.peces,
        guestsPolicy: GuestPolicy.conAvisoPrevio,
        noiseRestriction: NoiseRestriction.soloLimitesLegales,
        modificationPolicy: ModificationPolicy.levesConAviso,
        commercialActivity: CommercialActivityPolicy.noPermitida,
        garageSublet: GarageSubletPolicy.noPermitido,
        partialSublet: PartialSubletPolicy.noPermitido,
        fullAssignment: FullAssignmentPolicy.noPermitida,
        videoTourUrl: 'https://videos.example/tour-1.mp4',
        videoTourType: VideoTourType.grabado,
        photoUrls: const ['https://img.example/1.jpg'],
        province: 'Heredia',
        createdAt: DateTime.utc(2026, 1, 1),
        updatedAt: DateTime.utc(2026, 1, 2),
      );

      final json = property.toJson();
      // snake_case contract spot-checks
      expect(json['owner_id'], 'owner-2');
      expect(json['property_type'], 'apartamentoEdificio');
      expect(json['hot_water_system'], 'termoDucha');
      expect(json['video_tour_url'], contains('tour-1'));

      final restored = Property.fromJson(json);
      expect(restored, property);
    });

    test('copyWith creates modified copy', () {
      final updated = minimal().copyWith(
        parkingType: ParkingType.techadoExclusivo,
        maxOccupants: 4,
      );
      expect(updated.parkingType, ParkingType.techadoExclusivo);
      expect(updated.maxOccupants, 4);
      expect(updated.id, 'prop-1');
    });
  });

  group('Listing', () {
    test('round-trips ranges, status and timestamps', () {
      final listing = Listing(
        id: 'list-1',
        propertyId: 'prop-1',
        monthlyRent: 280000,
        minRent: 260000,
        depositAmount: 280000,
        minDurationMonths: 12,
        maxDurationMonths: 36,
        nonNegotiableConditions: const ['no_subarriendo'],
        status: ListingStatus.active,
        publishedAt: DateTime.utc(2026, 2, 1),
        createdAt: DateTime.utc(2026, 2, 1),
        updatedAt: DateTime.utc(2026, 2, 2),
      );

      final json = listing.toJson();
      expect(json['property_id'], 'prop-1');
      expect(json['monthly_rent'], 280000);
      expect(json['min_duration_months'], 12);
      expect(json['non_negotiable_conditions'], ['no_subarriendo']);

      expect(Listing.fromJson(json), listing);
      expect(listing.copyWith(status: ListingStatus.paused).status,
          ListingStatus.paused);
    });
  });
}
