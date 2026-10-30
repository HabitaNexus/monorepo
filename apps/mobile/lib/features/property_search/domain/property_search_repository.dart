/// Repositorio de búsqueda de propiedades (HAB-18).
///
/// Interfaz para datasource abstraído (local/stub ahora, remoto después).
library;

import '../domain/property.dart';
import '../domain/property_filter.dart';

abstract class PropertySearchRepository {
  /// Busca propiedades con los filtros aplicados
  Future<List<Property>> searchProperties(PropertyFilter filter);

  /// Obtiene una propiedad por ID
  Future<Property?> getPropertyById(String id);

  /// Obtiene propiedades favoritas del usuario
  Future<List<Property>> getFavorites();

  /// Agrega una propiedad a favoritos
  Future<void> addToFavorites(String propertyId);

  /// Elimina una propiedad de favoritos
  Future<void> removeFromFavorites(String propertyId);

  /// Verifica si una propiedad es favorita
  Future<bool> isFavorite(String propertyId);

  /// Compara propiedades (máximo 3)
  Future<List<Property>> compareProperties(List<String> propertyIds);
}
