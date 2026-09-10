import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/workspace_nearby.dart';
import '../../domain/repositories/workspace_nearby_repository.dart';
import '../../data/datasources/remote/workspace_nearby_repository_impl.dart';
import '../../data/config.dart';

/// Estado del proveedor de espacios de trabajo cercanos.
class WorkspaceNearbyState {
  final List<WorkspaceNearby> spaces;
  final bool isLoading;
  final String? error;

  const WorkspaceNearbyState({
    this.spaces = const [],
    this.isLoading = false,
    this.error,
  });

  WorkspaceNearbyState copyWith({
    List<WorkspaceNearby>? spaces,
    bool? isLoading,
    String? error,
  }) {
    return WorkspaceNearbyState(
      spaces: spaces ?? this.spaces,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Provider del repositorio concreto (implementación remota).
final workspaceNearbyRepositoryProvider =
    Provider<WorkspaceNearbyRepository>((ref) {
  return createRemoteWorkspaceNearbyRepository(
    baseUrl: WorkspaceNearbyConfig.baseUrl,
  );
});

/// Provider para cargar espacios de trabajo cercanos.
/// Usa el repositorio para obtener datos y maneja estados de carga/error.
final coworkingNearbyProvider =
    StateNotifierProvider<CoworkingNearbyNotifier, WorkspaceNearbyState>(
  (ref) => CoworkingNearbyNotifier(
    ref.read(workspaceNearbyRepositoryProvider),
  ),
);

class CoworkingNearbyNotifier
    extends StateNotifier<WorkspaceNearbyState> {
  final WorkspaceNearbyRepository _repository;

  CoworkingNearbyNotifier(this._repository)
      : super(const WorkspaceNearbyState());

  /// Carga los espacios de trabajo cercanos a las coordenadas dadas.
  Future<void> loadNearby({
    required double latitude,
    required double longitude,
    required double radius,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final spaces = await _repository.getNearby(
        latitude: latitude,
        longitude: longitude,
        radius: radius,
      );
      state = state.copyWith(spaces: spaces, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error al cargar espacios de trabajo: $e',
      );
    }
  }
}