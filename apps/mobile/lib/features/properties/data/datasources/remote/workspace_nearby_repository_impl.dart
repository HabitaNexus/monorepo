import 'package:dio/dio.dart';
import '../../../domain/entities/workspace_nearby.dart';
import '../../../domain/repositories/workspace_nearby_repository.dart';
import './google_places_remote_datasource.dart';
import '../workspace_nearby_datasource.dart';

/// Implementación concreta del repositorio de espacios de trabajo cercanos.
///
/// Delega a [WorkspaceNearbyDatasource] para obtener los datos.
/// Por defecto usa la implementación remota (Google Places API).
///
/// Configuración requerida:
/// - [baseUrl]: URL del backend propio
/// - [dio]: Instancia de Dio configurada con el baseUrl
class WorkspaceNearbyRepositoryImpl implements WorkspaceNearbyRepository {
  final WorkspaceNearbyDatasource _datasource;

  WorkspaceNearbyRepositoryImpl(this._datasource);

  @override
  Future<List<WorkspaceNearby>> getNearby({
    required double latitude,
    required double longitude,
    required double radius,
  }) async {
    return _datasource.getNearby(
      latitude: latitude,
      longitude: longitude,
      radius: radius,
    );
  }
}

/// Factory para crear el repositorio con el datasource remoto.
WorkspaceNearbyRepositoryImpl createRemoteWorkspaceNearbyRepository({
  required String baseUrl,
}) {
  final dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));
  return WorkspaceNearbyRepositoryImpl(
    GooglePlacesRemoteDatasource(
      dio: dio,
      baseUrl: baseUrl,
    ),
  );
}