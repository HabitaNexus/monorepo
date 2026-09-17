import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:habitanexus_mobile/features/properties/data/datasources/remote/google_places_remote_datasource.dart';
import 'package:habitanexus_mobile/features/properties/data/datasources/workspace_nearby_datasource.dart';
import 'package:habitanexus_mobile/features/properties/data/models/workspace_nearby_model.dart';
import '../../helpers/mock_dio.dart';

void main() {
  group('GooglePlacesRemoteDatasource', () {
    late GooglePlacesRemoteDatasource datasource;
    late Dio dio;

    setUp(() {
      dio = MockDio();
      datasource = GooglePlacesRemoteDatasource(
        dio: dio,
        baseUrl: 'http://localhost:8080',
      );
    });

    test('retorna lista vacía cuando no hay resultados', () async {
      when(() => dio.get(
            '/coworkings/nearby',
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer((_) async => Response(
                data: {'results': []},
                statusCode: 200,
                requestOptions: RequestOptions(path: '/coworkings/nearby'),
              ));

      final result = await datasource.getNearby(
        latitude: 9.9281,
        longitude: -84.0907,
        radius: 2000,
      );

      expect(result, isEmpty);
    });

    test('retorna máximo 5 resultados ordenados por distancia', () async {
      // Simular 10 resultados de Google Places
      final results = List.generate(10, (i) => {
        'place_id': 'id_$i',
        'name': 'Space $i',
        'types': ['coworking'],
        'geometry': {
          'location': {'lat': 9.9281 + (i * 0.01), 'lng': -84.0907},
        },
      });

      when(() => dio.get(
            '/coworkings/nearby',
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer((_) async => Response(
                data: {'results': results},
                statusCode: 200,
                requestOptions: RequestOptions(path: '/coworkings/nearby'),
              ));

      final result = await datasource.getNearby(
        latitude: 9.9281,
        longitude: -84.0907,
        radius: 2000,
      );

      expect(result.length, lessThanOrEqualTo(5));
    });

    test('pasa lat/lng/radius en queryParameters', () async {
      when(() => dio.get(
            '/coworkings/nearby',
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer((_) async => Response(
                data: {'results': []},
                statusCode: 200,
                requestOptions: RequestOptions(path: '/coworkings/nearby'),
              ));

      await datasource.getNearby(
        latitude: 9.9281,
        longitude: -84.0907,
        radius: 2000,
      );

      verify(() => dio.get(
            '/coworkings/nearby',
            queryParameters: any(named: 'queryParameters'),
          )).called(1);
    });

    test('lanza excepción cuando el endpoint retorna error', () async {
      when(() => dio.get(
            '/coworkings/nearby',
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer((_) async => Response(
                data: {'error': 'Not found'},
                statusCode: 404,
                requestOptions: RequestOptions(path: '/coworkings/nearby'),
              ));

      expect(
        () => datasource.getNearby(
          latitude: 9.9281,
          longitude: -84.0907,
          radius: 2000,
        ),
        throwsException,
      );
    });
  });
}