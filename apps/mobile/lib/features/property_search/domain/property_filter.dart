/// Filtro de búsqueda de propiedades (HAB-18).
///
/// Patrón copyWith + toQueryParams() inspirado en coworking_filter.dart.
/// Filtros tipados desde HAB-14 (catálogo de opciones).
library;

import 'package:flutter/material.dart';

import 'property.dart';

/// Provincias de Costa Rica
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

/// Filtro de búsqueda de propiedades
@immutable
class PropertyFilter {
  final RangeValues budgetRange;
  final CostaRicaProvince? province;
  final String? canton;
  final int minBedrooms;
  final int maxBedrooms;
  final PetType petPolicy;
  final String searchQuery;

  const PropertyFilter({
    this.budgetRange = const RangeValues(100000, 500000),
    this.province,
    this.canton,
    this.minBedrooms = 1,
    this.maxBedrooms = 5,
    this.petPolicy = PetType.none,
    this.searchQuery = '',
  });

  PropertyFilter copyWith({
    RangeValues? budgetRange,
    CostaRicaProvince? province,
    String? canton,
    int? minBedrooms,
    int? maxBedrooms,
    PetType? petPolicy,
    String? searchQuery,
    bool clearProvince = false,
    bool clearCanton = false,
  }) {
    return PropertyFilter(
      budgetRange: budgetRange ?? this.budgetRange,
      province: clearProvince ? null : (province ?? this.province),
      canton: clearCanton ? null : (canton ?? this.canton),
      minBedrooms: minBedrooms ?? this.minBedrooms,
      maxBedrooms: maxBedrooms ?? this.maxBedrooms,
      petPolicy: petPolicy ?? this.petPolicy,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  /// Convierte el filtro a query params para la API
  Map<String, dynamic> toQueryParams() {
    return {
      'budget_min': budgetRange.start.round(),
      'budget_max': budgetRange.end.round(),
      if (province != null) 'province': province!.name,
      if (canton != null) 'canton': canton,
      'bedrooms_min': minBedrooms,
      'bedrooms_max': maxBedrooms,
      'pet_policy': petPolicy.name,
      if (searchQuery.isNotEmpty) 'q': searchQuery,
    };
  }

  /// Verifica si el filtro tiene valores por defecto
  bool get isDefault =>
      budgetRange == const RangeValues(100000, 500000) &&
      province == null &&
      canton == null &&
      minBedrooms == 1 &&
      maxBedrooms == 5 &&
      petPolicy == PetType.none &&
      searchQuery.isEmpty;

  /// Cuenta cuántos filtros están activos
  int get activeFilterCount {
    int count = 0;
    if (budgetRange != const RangeValues(100000, 500000)) count++;
    if (province != null) count++;
    if (canton != null) count++;
    if (minBedrooms != 1 || maxBedrooms != 5) count++;
    if (petPolicy != PetType.none) count++;
    if (searchQuery.isNotEmpty) count++;
    return count;
  }
}
