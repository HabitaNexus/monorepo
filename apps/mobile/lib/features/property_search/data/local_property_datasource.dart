/// Datasource local de propiedades (HAB-18).
///
/// Datos de demostración para probar sin backend.
/// Patrón inspirado en coworking local_datasource.
library;

import '../domain/property.dart';
import '../domain/property_filter.dart';

/// Datos demo de propiedades
abstract final class DemoProperties {
  static final List<Property> _properties = [
    Property(
      id: 'prop-001',
      title: 'Apartamento Moderno Rohrmoser',
      address: 'Calle 42, Rohrmoser, San José',
      province: 'San José',
      canton: 'San José',
      latitude: 9.9321,
      longitude: -84.0456,
      priceMonthly: 185000,
      bedrooms: 2,
      bathrooms: 2,
      areaM2: 85,
      petPolicy: PetType.dogs,
      verificationStatus: VerificationStatus.verified,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      imageUrl: 'https://via.placeholder.com/400x300/4CAF50/FFFFFF?text=Apartamento+Rohrmoser',
      features: {'parking': true, 'gym': true, 'pool': false},
    ),
    Property(
      id: 'prop-002',
      title: 'Casa Familiar Escazú',
      address: 'Avenida 2, Escazú, San José',
      province: 'San José',
      canton: 'Escazú',
      latitude: 9.9214,
      longitude: -84.1387,
      priceMonthly: 220000,
      bedrooms: 3,
      bathrooms: 2,
      areaM2: 120,
      petPolicy: PetType.any,
      verificationStatus: VerificationStatus.verified,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      imageUrl: 'https://via.placeholder.com/400x300/2196F3/FFFFFF?text=Casa+Escaz%C3%BA',
      features: {'parking': true, 'gym': false, 'pool': true},
    ),
    Property(
      id: 'prop-003',
      title: 'Loft Creativo Santa Ana',
      address: 'Contiguo a Multiplaza, Santa Ana',
      province: 'San José',
      canton: 'Santa Ana',
      latitude: 9.9345,
      longitude: -84.1834,
      priceMonthly: 165000,
      bedrooms: 1,
      bathrooms: 1,
      areaM2: 55,
      petPolicy: PetType.cats,
      verificationStatus: VerificationStatus.verified,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      imageUrl: 'https://via.placeholder.com/400x300/FF9800/FFFFFF?text=Loft+Santa+Ana',
      features: {'parking': false, 'gym': false, 'pool': false},
    ),
    Property(
      id: 'prop-004',
      title: 'Condominio Vista Lago',
      address: 'Ruta 27, Torrealba, San José',
      province: 'San José',
      canton: 'San José',
      latitude: 9.9156,
      longitude: -84.0823,
      priceMonthly: 280000,
      bedrooms: 3,
      bathrooms: 3,
      areaM2: 150,
      petPolicy: PetType.any,
      verificationStatus: VerificationStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(hours: 12)),
      imageUrl: 'https://via.placeholder.com/400x300/9C27B0/FFFFFF?text=Condominio+Vista+Lago',
      features: {'parking': true, 'gym': true, 'pool': true},
    ),
    Property(
      id: 'prop-005',
      title: 'Estudio Mini Alajuela',
      address: 'Avenida Central, Alajuela Centro',
      province: 'Alajuela',
      canton: 'Alajuela',
      latitude: 10.0164,
      longitude: -84.2158,
      priceMonthly: 120000,
      bedrooms: 1,
      bathrooms: 1,
      areaM2: 35,
      petPolicy: PetType.none,
      verificationStatus: VerificationStatus.verified,
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      imageUrl: 'https://via.placeholder.com/400x300/E91E63/FFFFFF?text=Estudio+Alajuela',
      features: {'parking': false, 'gym': false, 'pool': false},
    ),
    Property(
      id: 'prop-006',
      title: 'Casa con Jardín Cartago',
      address: 'Barrio Ayarco, Cartago',
      province: 'Cartago',
      canton: 'Cartago',
      latitude: 9.8649,
      longitude: -83.9188,
      priceMonthly: 175000,
      bedrooms: 2,
      bathrooms: 2,
      areaM2: 95,
      petPolicy: PetType.dogs,
      verificationStatus: VerificationStatus.verified,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      imageUrl: 'https://via.placeholder.com/400x300/00BCD4/FFFFFF?text=Casa+Cartago',
      features: {'parking': true, 'gym': false, 'pool': false},
    ),
  ];

  static List<Property> get all => List.unmodifiable(_properties);
}

/// Datasource local de propiedades
class LocalPropertyDatasource {
  final List<Property> _properties = DemoProperties.all;
  final Set<String> _favorites = {};

  /// Busca propiedades con filtros
  Future<List<Property>> search(PropertyFilter filter) async {
    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 500));

    return _properties.where((property) {
      // Filtro de búsqueda por texto
      if (filter.searchQuery.isNotEmpty) {
        final query = filter.searchQuery.toLowerCase();
        if (!property.title.toLowerCase().contains(query) &&
            !property.address.toLowerCase().contains(query)) {
          return false;
        }
      }

      // Filtro de presupuesto
      if (property.priceMonthly < filter.budgetRange.start ||
          property.priceMonthly > filter.budgetRange.end) {
        return false;
      }

      // Filtro de provincia
      if (filter.province != null &&
          property.province != filter.province!.label) {
        return false;
      }

      // Filtro de cantón
      if (filter.canton != null && property.canton != filter.canton) {
        return false;
      }

      // Filtro de habitaciones
      if (property.bedrooms < filter.minBedrooms ||
          property.bedrooms > filter.maxBedrooms) {
        return false;
      }

      // Filtro de baños
      if (property.bathrooms < filter.minBathrooms) return false;

      // Filtro de cochera (parkingSpots: 0=cualquiera, 1/2 = requiere)
      if (filter.parkingSpots > 0) {
        final hasParking = property.features['parking'] == true;
        if (!hasParking) return false;
        // Demo: 2 cocheras solo si área >100m2 o precio alto (proxy)
        if (filter.parkingSpots == 2 && property.areaM2 < 100) return false;
      }

      // Filtro de mascotas
      if (filter.petPolicy != PetType.none &&
          property.petPolicy == PetType.none) {
        return false;
      }

      return true;
    }).toList();
  }

  /// Obtiene todas las propiedades
  Future<List<Property>> getAll() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_properties);
  }

  /// Obtiene una propiedad por ID
  Future<Property?> getById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _properties.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Obtiene favoritos
  Future<List<Property>> getFavorites() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _properties.where((p) => _favorites.contains(p.id)).toList();
  }

  /// Agrega a favoritos
  Future<void> addToFavorites(String propertyId) async {
    _favorites.add(propertyId);
  }

  /// Elimina de favoritos
  Future<void> removeFromFavorites(String propertyId) async {
    _favorites.remove(propertyId);
  }

  /// Verifica si es favorito
  Future<bool> isFavorite(String propertyId) async {
    return _favorites.contains(propertyId);
  }
}
