/// Filtro de búsqueda de propiedades (HAB-18).
///
/// Patrón copyWith + toQueryParams() inspirado en coworking_filter.dart.
/// Filtros tipados desde HAB-14 (catálogo de opciones).
library;

import 'package:flutter/material.dart';

import 'global_countries.dart';
import 'property.dart';

/// Provincias de Costa Rica — deprectado, usar countryCode/region (global).
@Deprecated('Usar GlobalCountry / region (global)')
enum CostaRicaProvince {
  sanJose('San José'),
  alajuela('Alajuela'),
  cartago('Cartago'),
  heredia('Heredia'),
  guanacaste('Guanacaste'),
  puntaarenas('Puntarenas'),
  limon('Limón');
  const CostaRicaProvince(this.label);
  final String label;
}

/// Filtro de búsqueda — global (HAB-18). Precio en USD, ubicación por país/región.
@immutable
class PropertyFilter {
  static const RangeValues kDefaultBudget = RangeValues(500, 3000); // USD global
  static const int kDefaultMaxBedrooms = 8;

  final RangeValues budgetRange; // USD
  final String? countryCode; // ISO2, e.g. US, CR. null = global / cualquiera
  final String? region; // Estado / provincia dentro del país
  final String? city; // Ciudad / distrito / barrio específico
  // Compat CR deprecated
  final CostaRicaProvince? province;
  final String? canton;

  final int minBedrooms;
  final int maxBedrooms; // 1..8 (8 = 8+)
  final int minBathrooms;
  final int parkingSpots;
  final ResidenceType residenceType;
  final PetType petPolicy;
  final String searchQuery;

  const PropertyFilter({
    this.budgetRange = kDefaultBudget,
    this.countryCode,
    this.region,
    this.city,
    this.province,
    this.canton,
    this.minBedrooms = 1,
    this.maxBedrooms = kDefaultMaxBedrooms,
    this.minBathrooms = 1,
    this.parkingSpots = 0,
    this.residenceType = ResidenceType.any,
    this.petPolicy = PetType.none,
    this.searchQuery = '',
  });

  GlobalCountry? get country => countryCode == null ? null : countryByCode(countryCode!);
  String get locationLabel {
    if (countryCode == null) return 'Cualquier lugar';
    final c = countryByCode(countryCode!);
    if (city != null) return '${c.flag} $city, $region, ${c.name}';
    if (region == null) return '${c.flag} ${c.name}';
    return '${c.flag} $region, ${c.name}';
  }
  String get cityLabel => city ?? 'Cualquier ciudad';

  PropertyFilter copyWith({
    RangeValues? budgetRange,
    String? countryCode,
    String? region,
    String? city,
    CostaRicaProvince? province,
    String? canton,
    int? minBedrooms,
    int? maxBedrooms,
    int? minBathrooms,
    int? parkingSpots,
    ResidenceType? residenceType,
    PetType? petPolicy,
    String? searchQuery,
    bool clearCountry = false,
    bool clearRegion = false,
    bool clearCity = false,
    bool clearProvince = false,
    bool clearCanton = false,
  }) {
    return PropertyFilter(
      budgetRange: budgetRange ?? this.budgetRange,
      countryCode: clearCountry ? null : (countryCode ?? this.countryCode),
      region: clearRegion ? null : (region ?? this.region),
      city: clearCity ? null : (city ?? this.city),
      province: clearProvince ? null : (province ?? this.province),
      canton: clearCanton ? null : (canton ?? this.canton),
      minBedrooms: minBedrooms ?? this.minBedrooms,
      maxBedrooms: maxBedrooms ?? this.maxBedrooms,
      minBathrooms: minBathrooms ?? this.minBathrooms,
      parkingSpots: parkingSpots ?? this.parkingSpots,
      residenceType: residenceType ?? this.residenceType,
      petPolicy: petPolicy ?? this.petPolicy,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  Map<String, dynamic> toQueryParams() {
    return {
      'budget_min': budgetRange.start.round(),
      'budget_max': budgetRange.end.round(),
      'currency': 'USD',
      if (countryCode != null) 'country': countryCode,
      if (region != null) 'region': region,
      if (city != null) 'city': city,
      if (province != null) 'province': province!.name,
      if (canton != null) 'canton': canton,
      'bedrooms_min': minBedrooms,
      'bedrooms_max': maxBedrooms,
      'bathrooms_min': minBathrooms,
      if (parkingSpots > 0) 'parking_spots': parkingSpots,
      if (residenceType != ResidenceType.any) 'residence_type': residenceType.name,
      'pet_policy': petPolicy.name,
      if (searchQuery.isNotEmpty) 'q': searchQuery,
    };
  }

  bool get isDefault =>
      budgetRange == kDefaultBudget &&
      countryCode == null &&
      region == null &&
      city == null &&
      province == null &&
      canton == null &&
      minBedrooms == 1 &&
      maxBedrooms == kDefaultMaxBedrooms &&
      minBathrooms == 1 &&
      parkingSpots == 0 &&
      residenceType == ResidenceType.any &&
      petPolicy == PetType.none &&
      searchQuery.isEmpty;

  int get activeFilterCount {
    int count = 0;
    if (budgetRange != kDefaultBudget) count++;
    if (countryCode != null) count++;
    if (region != null) count++;
    if (city != null) count++;
    if (province != null) count++;
    if (canton != null) count++;
    if (minBedrooms != 1 || maxBedrooms != kDefaultMaxBedrooms) count++;
    if (minBathrooms != 1) count++;
    if (parkingSpots != 0) count++;
    if (residenceType != ResidenceType.any) count++;
    if (petPolicy != PetType.none) count++;
    if (searchQuery.isNotEmpty) count++;
    return count;
  }

  String get bathroomsLabel => minBathrooms == 1 ? 'Cualquier' : '$minBathrooms+ baños';
  String get parkingLabel {
    switch (parkingSpots) {
      case 0:
        return 'Cualquier';
      case 1:
        return '1 cochera';
      case 2:
        return '2 cocheras';
      default:
        return '$parkingSpots cocheras';
    }
  }
}
