import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/coworking_space.dart';
import '../../domain/entities/coworking_filter.dart';
import '../../domain/repositories/coworking_repository.dart';
import '../datasources/coworking_local_datasource.dart';
import '../repositories/coworking_repository_impl.dart';

final coworkingLocalDataSourceProvider = Provider<CoworkingLocalDataSource>((ref) {
  return CoworkingLocalDataSource();
});

final coworkingRepositoryProvider = Provider<CoworkingRepository>((ref) {
  final localDataSource = ref.watch(coworkingLocalDataSourceProvider);
  return CoworkingRepositoryImpl(localDataSource);
});

final coworkingFilterProvider = StateProvider<CoworkingFilter>((ref) {
  return const CoworkingFilter();
});

final coworkingFilteredProvider = FutureProvider.autoDispose<List<CoworkingSpace>>((ref) async {
  final repository = ref.watch(coworkingRepositoryProvider);
  final filter = ref.watch(coworkingFilterProvider);
  return repository.getAll(filter: filter);
});

final coworkingDetailProvider = FutureProvider.autoDispose.family<CoworkingSpace, String>((ref, id) async {
  final repository = ref.watch(coworkingRepositoryProvider);
  return repository.getById(id);
});

final coworkingNearbyProvider = FutureProvider.autoDispose.family<List<CoworkingSpace>, Map<String, double>>(
  (ref, coords) async {
    final repository = ref.watch(coworkingRepositoryProvider);
    return repository.getNearby(
      coords['lat']!,
      coords['lng']!,
      radiusKm: coords['radiusKm'] ?? 5.0,
    );
  },
);
