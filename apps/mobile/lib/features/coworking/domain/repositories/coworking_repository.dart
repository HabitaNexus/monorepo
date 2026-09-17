import '../entities/coworking_space.dart';
import '../entities/coworking_filter.dart';

abstract class CoworkingRepository {
  Future<List<CoworkingSpace>> getAll({CoworkingFilter? filter});
  Future<CoworkingSpace> getById(String id);
  Future<List<CoworkingSpace>> getNearby(
    double latitude,
    double longitude, {
    double radiusKm = 5.0,
    CoworkingFilter? filter,
  });
}
