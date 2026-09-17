import '../../domain/entities/coworking_space.dart';
import '../../domain/entities/coworking_filter.dart';
import '../../domain/repositories/coworking_repository.dart';
import '../datasources/coworking_local_datasource.dart';

class CoworkingRepositoryImpl implements CoworkingRepository {
  final CoworkingLocalDataSource _localDataSource;

  CoworkingRepositoryImpl(this._localDataSource);

  @override
  Future<List<CoworkingSpace>> getAll({CoworkingFilter? filter}) async {
    return _localDataSource.getAll(params: filter?.toQueryParams());
  }

  @override
  Future<CoworkingSpace> getById(String id) async {
    return _localDataSource.getById(id);
  }

  @override
  Future<List<CoworkingSpace>> getNearby(
    double latitude,
    double longitude, {
    double radiusKm = 5.0,
    CoworkingFilter? filter,
  }) async {
    return _localDataSource.getNearby(
      latitude,
      longitude,
      radiusKm: radiusKm,
      extraParams: filter?.toQueryParams(),
    );
  }
}
