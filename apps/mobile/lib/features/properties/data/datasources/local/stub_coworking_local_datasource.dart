import '../../../domain/entities/workspace_nearby.dart';
import '../workspace_nearby_datasource.dart';

/// Stub de datasource local para coworkings cercanos.
/// Este debe ser reemplazado por una implementación real.
class StubCoworkingLocalDatasource implements WorkspaceNearbyDatasource {
  @override
  Future<List<WorkspaceNearby>> getNearby({
    required double latitude,
    required double longitude,
    required double radius,
  }) async {
    // Stub vacío - debe ser reemplazado
    return [];
  }
}