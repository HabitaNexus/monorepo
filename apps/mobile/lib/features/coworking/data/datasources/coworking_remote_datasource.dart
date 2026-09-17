import 'package:dio/dio.dart';
import '../../domain/entities/coworking_space.dart';

class CoworkingRemoteDataSource {
  final Dio _dio;

  CoworkingRemoteDataSource(this._dio);

  Future<List<CoworkingSpace>> getAll({Map<String, dynamic>? params}) async {
    final response = await _dio.get('/coworkings', queryParameters: params);
    final list = response.data as List<dynamic>;
    return list.map((e) => CoworkingSpace.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<CoworkingSpace> getById(String id) async {
    final response = await _dio.get('/coworkings/$id');
    return CoworkingSpace.fromJson(response.data as Map<String, dynamic>);
  }

  Future<List<CoworkingSpace>> getNearby(
    double latitude,
    double longitude, {
    double radiusKm = 5.0,
    Map<String, dynamic>? extraParams,
  }) async {
    final params = <String, dynamic>{
      'latitude': latitude,
      'longitude': longitude,
      'radius_km': radiusKm,
      ...?extraParams,
    };
    final response = await _dio.get('/coworkings/nearby', queryParameters: params);
    final list = response.data as List<dynamic>;
    return list.map((e) => CoworkingSpace.fromJson(e as Map<String, dynamic>)).toList();
  }
}
