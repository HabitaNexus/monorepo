import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import '../../../domain/entities/workspace_nearby.dart';
import '../workspace_nearby_datasource.dart';
import '../../models/workspace_nearby_model.dart';

/// Datasource remoto de espacios de trabajo cercanos.
///
/// Llama al endpoint propio `GET /coworkings/nearby?lat=X&lng=Y&radius=Z`.
/// El backend es quien llama a Google Places API, por lo que
/// la API key de Google nunca se expone en Flutter.
///
/// Usa el patrón de datasource para permitir alternar entre
/// fuente local (cache) y remota.
class GooglePlacesRemoteDatasource implements WorkspaceNearbyDatasource {
  final Dio _dio;
  final String _baseUrl;

  GooglePlacesRemoteDatasource({
    required Dio dio,
    required String baseUrl,
  })  : _dio = dio,
        _baseUrl = baseUrl;

  @override
  Future<List<WorkspaceNearby>> getNearby({
    required double latitude,
    required double longitude,
    required double radius,
  }) async {
    final response = await _dio.get(
      '/coworkings/nearby',
      queryParameters: {
        'lat': latitude,
        'lng': longitude,
        'radius': radius,
      },
    );

    if (response.statusCode != HttpStatus.ok) {
      throw Exception(
        'Failed to fetch nearby workspaces: ${response.statusCode}',
      );
    }

    final data = response.data as Map<String, dynamic>;
    final results = data['results'] as List? ?? [];

    if (results.isEmpty) {
      return [];
    }

    // Normalizar cada resultado de Google Places al modelo interno
    // y convertir a la entidad de dominio.
    final List<WorkspaceNearby> spaces = results
        .map((place) => WorkspaceNearbyModel.fromGooglePlace(
              place: place as Map<String, dynamic>,
              propertyLat: latitude,
              propertyLng: longitude,
            ))
        .map((model) => WorkspaceNearby(
              id: model.id,
              name: model.name,
              category: model.category,
              distanceKm: model.distanceKm,
              hasWifi: model.hasWifi,
            ))
        .toList();

    // Ordenar por distancia (menor a mayor) y limitar a 5 resultados
    spaces.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    return spaces.take(5).toList();
  }
}