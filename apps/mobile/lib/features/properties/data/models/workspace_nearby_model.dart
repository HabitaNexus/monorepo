import 'dart:math';

import 'package:equatable/equatable.dart';

/// Modelo de datos para un espacio de trabajo cercano normalizado.
/// Mapea la respuesta de Google Places Nearby Search al modelo interno.
class WorkspaceNearbyModel extends Equatable {
  final String id;
  final String name;
  final String category; // 'coworking' or 'cafe'
  final double distanceKm;
  final bool hasWifi;

  const WorkspaceNearbyModel({
    required this.id,
    required this.name,
    required this.category,
    required this.distanceKm,
    required this.hasWifi,
  });

  /// Crea desde los datos crudos de Google Places.
  /// [place] es un resultado de Places API.
  /// [propertyLat] y [propertyLng] son las coordenadas de la propiedad para calcular distancia.
  factory WorkspaceNearbyModel.fromGooglePlace({
    required Map<String, dynamic> place,
    required double propertyLat,
    required double propertyLng,
  }) {
    final placeId = place['place_id'] as String? ?? '';
    final name = place['name'] as String? ?? 'Sin nombre';
    final types = place['types'] as List? ?? [];
    final geometry = place['geometry'] as Map?;
    final location = geometry?['location'] as Map?;
    final lat = (location?['lat'] as num?)?.toDouble() ?? 0.0;
    final lng = (location?['lng'] as num?)?.toDouble() ?? 0.0;

    final category = _determineCategory(types);
    final distanceKm = _haversineDistance(
      propertyLat,
      propertyLng,
      lat,
      lng,
    );
    final hasWifi = _checkWifi(types);

    return WorkspaceNearbyModel(
      id: placeId,
      name: name,
      category: category,
      distanceKm: double.parse(distanceKm.toStringAsFixed(2)),
      hasWifi: hasWifi,
    );
  }

  /// Determina la categoría basándose en los tipos de Google Places.
  static String _determineCategory(List<dynamic> types) {
    final typeStrings = types.map((t) => t.toString()).toList();

    if (typeStrings.any((t) =>
        t.contains('coworking') ||
        t.contains('shared_office_space') ||
        t.contains('workplace'))) {
      return 'coworking';
    }
    if (typeStrings.any((t) =>
        t.contains('cafe') || t.contains('coffee_shop'))) {
      return 'cafe';
    }
    return 'other';
  }

  /// Verifica si el lugar tiene WiFi basándose en sus tipos.
  static bool _checkWifi(List<dynamic> types) {
    final typeStrings = types.map((t) => t.toString()).toList();
    return typeStrings.any((t) =>
        t.contains('wifi') ||
        t.contains('cafe') ||
        t.contains('coffee_shop'));
  }

  /// Calcula la distancia Haversine entre dos puntos en coordenadas.
  /// Retorna la distancia en kilómetros.
  static double _haversineDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const earthRadiusKm = 6371.0;
    const dToRad = 0.017453292519943295; // pi / 180

    final dLat = (lat2 - lat1) * dToRad;
    final dLon = (lon2 - lon1) * dToRad;
    final radLat1 = lat1 * dToRad;
    final radLat2 = lat2 * dToRad;

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(radLat1) * cos(radLat2) * sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadiusKm * c;
  }

  @override
  List<Object> get props => [id, name, category, distanceKm, hasWifi];
}