/// Entidad de propiedad para búsqueda (HAB-18).
///
/// Representa una propiedad listada en el marketplace.
library;

import 'package:flutter/material.dart';

/// Tipos de mascotas permitidas
enum PetType {
  none('No permitido'),
  dogs('Permitido'),
  cats('Permitido'),
  smallPets('Mascotas pequeñas'),
  any('Cualquier mascota');

  const PetType(this.label);
  final String label;
}

/// Tipo de residencia — global
enum ResidenceType {
  any('Cualquier', Icons.home_outlined),
  apartment('Apartamento', Icons.apartment),
  house('Casa', Icons.house_outlined),
  cabin('Cabaña', Icons.cabin_outlined),
  loft('Loft', Icons.view_quilt_outlined),
  studio('Estudio', Icons.single_bed_outlined),
  penthouse('Penthouse', Icons.location_city),
  villa('Villa', Icons.villa_outlined),
  condo('Condominio', Icons.domain_outlined),
  room('Habitación', Icons.bed_outlined);

  const ResidenceType(this.label, this.icon);
  final String label;
  final IconData icon;
}

/// Estado de verificación de la propiedad
enum VerificationStatus {
  pending('Pendiente'),
  verified('Verificado'),
  rejected('Rechazado');

  const VerificationStatus(this.label);
  final String label;
}

/// Propiedad para resultados de búsqueda
@immutable
class Property {
  final String id;
  final String title;
  final String address;
  final String province;
  final String canton;
  final String? city; // Ciudad/barrio específico (global)
  final String countryCode; // ISO2 para filtro global
  final double latitude;
  final double longitude;
  final int priceMonthly;
  final int bedrooms;
  final int bathrooms;
  final double areaM2;
  final ResidenceType residenceType;
  final PetType petPolicy;
  final VerificationStatus verificationStatus;
  final DateTime createdAt;
  final String? imageUrl;
  final List<String> imageUrls;
  final Map<String, dynamic> features;

  const Property({
    required this.id,
    required this.title,
    required this.address,
    required this.province,
    required this.canton,
    this.city,
    this.countryCode = 'CR',
    required this.latitude,
    required this.longitude,
    required this.priceMonthly,
    required this.bedrooms,
    required this.bathrooms,
    required this.areaM2,
    this.residenceType = ResidenceType.apartment,
    this.petPolicy = PetType.none,
    this.verificationStatus = VerificationStatus.pending,
    required this.createdAt,
    this.imageUrl,
    this.imageUrls = const [],
    this.features = const {},
  });

  /// Precio formateado — USD global
  String get formattedPrice {
    return '\$${priceMonthly.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        )}';
  }

  String get formattedPriceWithSuffix => '$formattedPrice/mes';

  /// Tiempo relativo de creación
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} mes(es)';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} día(s)';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hora(s)';
    } else {
      return '${difference.inMinutes} min(s)';
    }
  }

  /// Propiedad de ejemplo para demostración
  static Property demo({
    required String id,
    required String title,
    required int price,
    required int bedrooms,
    required double area,
  }) {
    return Property(
      id: id,
      title: title,
      address: 'Dirección de ejemplo',
      province: 'San José',
      canton: 'San José',
      latitude: 9.9281,
      longitude: -84.0907,
      priceMonthly: price,
      bedrooms: bedrooms,
      bathrooms: bedrooms > 2 ? 2 : 1,
      areaM2: area,
      petPolicy: PetType.dogs,
      verificationStatus: VerificationStatus.verified,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      imageUrl: 'https://via.placeholder.com/400x300',
    );
  }
}


