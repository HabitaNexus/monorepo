/// Implementación del repositorio de búsqueda (HAB-18).
///
/// Conecta datasource abstraído con el dominio.
library;

import '../domain/property.dart';
import '../domain/property_filter.dart';
import '../domain/property_search_repository.dart';
import 'local_property_datasource.dart';

class PropertySearchRepositoryImpl implements PropertySearchRepository {
  final LocalPropertyDatasource _datasource;

  PropertySearchRepositoryImpl({LocalPropertyDatasource? datasource})
      : _datasource = datasource ?? LocalPropertyDatasource();

  @override
  Future<List<Property>> searchProperties(PropertyFilter filter) async {
    return _datasource.search(filter);
  }

  @override
  Future<Property?> getPropertyById(String id) async {
    return _datasource.getById(id);
  }

  @override
  Future<List<Property>> getFavorites() async {
    return _datasource.getFavorites();
  }

  @override
  Future<void> addToFavorites(String propertyId) async {
    await _datasource.addToFavorites(propertyId);
  }

  @override
  Future<void> removeFromFavorites(String propertyId) async {
    await _datasource.removeFromFavorites(propertyId);
  }

  @override
  Future<bool> isFavorite(String propertyId) async {
    return _datasource.isFavorite(propertyId);
  }

  @override
  Future<List<Property>> compareProperties(List<String> propertyIds) async {
    final properties = <Property>[];
    for (final id in propertyIds.take(3)) {
      final property = await getPropertyById(id);
      if (property != null) {
        properties.add(property);
      }
    }
    return properties;
  }
}
